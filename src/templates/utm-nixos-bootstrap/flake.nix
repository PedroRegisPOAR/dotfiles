{

  /*
    nix \
    flake \
    lock \
    --override-input nixpkgs 'github:NixOS/nixpkgs/d7a713c0b7e47c908258e71cba7a2d77cc8d71d5' 
  */
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "aarch64-linux" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      overlays.default = final: prev: {
        allTests = final.writeShellApplication
          {
            name = "all-tests";
            runtimeInputs = [ ];
            text = ''
              sudo nix fmt . \
              && nix flake show --all-systems '.#' \
              && nix flake metadata '.#' \
              && nix build --no-link --print-build-logs --print-out-paths '.#' \
              && nix build --no-link --print-build-logs --print-out-paths --rebuild '.#' \
              && nix develop '.#' --command sh -c 'true' \
              && nix flake check --all-systems --verbose '.#'
            '';
          } // { meta.mainProgram = "all-tests"; };
      };

      pkgsFor = system: import nixpkgs {
        inherit system;
        overlays = [ overlays.default ];
      };
    in
    {
      inherit overlays;

      formatter = forAllSystems (system: (pkgsFor system).nixpkgs-fmt);

      packages = forAllSystems (system:
        let pkgs = pkgsFor system; in {
          inherit (pkgs) allTests;
          default = pkgs.allTests;
        });

      devShells = forAllSystems (system: {
        default = (pkgsFor system).mkShell { };
      });

      nixosConfigurations =
        let
          mkNixos = system: nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ./configuration.nix
              { nixpkgs.overlays = [ overlays.default ]; }
            ];
          };
        in
        {
          n1x0s = mkNixos "aarch64-linux";
          n1x0s-x86 = mkNixos "x86_64-linux";
        };
    };
}
