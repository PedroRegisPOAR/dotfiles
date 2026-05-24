{

  /*
    nix \
    flake \
    lock \
    --override-input nixpkgs 'github:NixOS/nixpkgs/b77b3de8775677f84492abe84635f87b0e153f0f' 
  */
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgsUnstable, ... }:
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

        rtk = nixpkgsUnstable.legacyPackages.${final.stdenv.hostPlatform.system}.rtk; # TODO: Once 26.05 is out, remove.

        caveman = final.stdenv.mkDerivation {
          pname = "caveman";
          version = "0.1.0";
          src = final.fetchFromGitHub {
            owner = "JuliusBrussee";
            repo = "caveman";
            rev = "655b7d9c5431f822264b7732e9901c5578ac84cf";
            hash = "sha256-BydREt/vai3j7kO5+e1OxsjXf6Vy+jSY1yA/yyxjHbI=";
          };
          nativeBuildInputs = [ final.makeWrapper ];
          dontBuild = true;
          installPhase = ''
            mkdir -p $out/lib/caveman $out/bin
            cp -r . $out/lib/caveman
            makeWrapper ${final.nodejs}/bin/node $out/bin/caveman \
              --add-flags "$out/lib/caveman/bin/install.js"
          '';
          meta.mainProgram = "caveman";
        };

        claude-mem = final.stdenv.mkDerivation rec {
          pname = "claude-mem";
          version = "13.3.0";
          src = final.fetchurl {
            url = "https://registry.npmjs.org/claude-mem/-/claude-mem-${version}.tgz";
            hash = "sha256-IBNHQ9ZrbDb8bf74WPJtfrlDcIa/auLzJZ5IhtHbNmo=";
          };
          sourceRoot = "package";
          nativeBuildInputs = [ final.makeWrapper ];
          dontBuild = true;
          installPhase = ''
            mkdir -p $out/lib/claude-mem $out/bin
            cp -r . $out/lib/claude-mem
            makeWrapper ${final.nodejs}/bin/node $out/bin/claude-mem \
              --add-flags "$out/lib/claude-mem/dist/npx-cli/index.js"
          '';
          meta.mainProgram = "claude-mem";
        };
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
