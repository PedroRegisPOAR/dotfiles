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

        rtk = final.rustPlatform.buildRustPackage rec {
          pname = "rtk";
          version = "0.42.0";
          src = final.fetchFromGitHub {
            owner = "rtk-ai";
            repo = "rtk";
            rev = "v${version}";
            hash = "sha256-ZCDVS/AFljljMac+cAzQztYPQgvQrcEhKIHHRhkMsv8=";
          };
          cargoHash = "sha256-CFhKBzJc2/+gZDfHq7wxBWEbtHV8EF3OYa+t1b9aL8k=";
          doCheck = false;
          meta = with final.lib; {
            description = "Rust Token Killer - High-performance CLI proxy to minimize LLM token consumption";
            homepage = "https://github.com/rtk-ai/rtk";
            license = licenses.asl20;
            mainProgram = "rtk";
          };
        };

        caveman = final.stdenv.mkDerivation rec {
          pname = "caveman";
          version = "1.8.2";
          src = final.fetchFromGitHub {
            owner = "JuliusBrussee";
            repo = "caveman";
            rev = "v${version}";
            hash = "sha256-Jlfas2MPoQx3pOw+yKCta8kYlOEY27SP5NXJtSL+GGI=";
          };
          nativeBuildInputs = [ final.makeWrapper ];
          installPhase = ''
            mkdir -p $out/lib/caveman $out/bin
            cp -r . $out/lib/caveman/
            makeWrapper ${final.nodejs}/bin/node $out/bin/caveman \
              --add-flags "$out/lib/caveman/bin/install.js"
          '';
          meta = with final.lib; {
            description = "Detects AI coding agents and installs caveman for each one";
            homepage = "https://github.com/JuliusBrussee/caveman";
            license = licenses.mit;
            mainProgram = "caveman";
          };
        };

        claude-mem = final.stdenv.mkDerivation rec {
          pname = "claude-mem";
          version = "13.3.0";
          src = final.fetchurl {
            url = "https://registry.npmjs.org/claude-mem/-/claude-mem-${version}.tgz";
            hash = "sha256-IBNHQ9ZrbDb8bf74WPJtfrlDcIa/auLzJZ5IhtHbNmo=";
          };
          nativeBuildInputs = [ final.makeWrapper ];
          unpackPhase = ''
            tar -xzf $src
            sourceRoot=package
          '';
          installPhase = ''
            mkdir -p $out/lib/claude-mem $out/bin
            cp -r . $out/lib/claude-mem/
            makeWrapper ${final.nodejs}/bin/node $out/bin/claude-mem \
              --add-flags "$out/lib/claude-mem/dist/npx-cli/index.js"
          '';
          meta = with final.lib; {
            description = "Claude memory management tool";
            homepage = "https://github.com/thedotmack/claude-mem";
            license = licenses.asl20;
            mainProgram = "claude-mem";
          };
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

