{

  /*
    nix \
    flake \
    lock \
    --override-input nixpkgs 'github:NixOS/nixpkgs/b77b3de8775677f84492abe84635f87b0e153f0f' 
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
          propagatedBuildInputs = [ final.bun ];
          unpackPhase = ''
            tar -xzf $src
            sourceRoot=package
          '';
          installPhase = ''
            mkdir -p $out/lib/claude-mem $out/bin
            cp -r . $out/lib/claude-mem/
            makeWrapper ${final.nodejs}/bin/node $out/bin/claude-mem \
              --add-flags "$out/lib/claude-mem/dist/npx-cli/index.js" \
              --prefix PATH : ${final.bun}/bin
          '';
          passthru.bunBin = "${final.bun}/bin/bun";
          meta = with final.lib; {
            description = "Claude memory management tool";
            homepage = "https://github.com/thedotmack/claude-mem";
            license = licenses.asl20;
            mainProgram = "claude-mem";
          };
        };

        aws-api-mcp-server = final.writeShellScriptBin "aws-api-mcp-server" ''
          exec ${final.uv}/bin/uvx awslabs.aws-api-mcp-server@latest "$@"
        '';

        context7-mcp = final.writeShellScriptBin "context7-mcp" ''
          export PATH="${final.nodejs}/bin:$PATH"
          exec ${final.nodejs}/bin/npx -y @upstash/context7-mcp@latest "$@"
        '';

        superpowers-plugin = final.stdenv.mkDerivation rec {
          pname = "superpowers-plugin";
          version = "5.1.0";
          src = final.fetchFromGitHub {
            owner = "obra";
            repo = "superpowers";
            rev = "v${version}";
            hash = "sha256-3E3rO6hR87JUfS3XV1Eaoz6SDWOftleWvN9UPNFEMjw=";
          };
          installPhase = ''
            mkdir -p $out/lib/superpowers
            cp -r . $out/lib/superpowers/
          '';
          meta = with final.lib; {
            description = "Superpowers skills framework for Claude Code";
            homepage = "https://github.com/obra/superpowers";
            license = licenses.mit;
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

      checks = forAllSystems (system:
        let pkgs = pkgsFor system; in {
          claude-tools-integration = pkgs.testers.runNixOSTest {
            name = "claude-tools-integration";
            nodes.machine = { config, pkgs, ... }: {
              users.users.fog = {
                isNormalUser = true;
                home = "/home/fog";
                createHome = true;
                group = "fog";
                uid = 1000;
              };
              users.groups.fog.gid = 1000;
              environment.systemPackages = with pkgs; [
                rtk
                caveman
                claude-mem
                nodejs
                python3
                awscli2
                aws-api-mcp-server
              ];
              imports = [ ./claude-settings.nix ];
            };

            testScript = ''
              machine.wait_for_unit("multi-user.target")

              machine.succeed("test -f /home/fog/.claude/settings.json")

              machine.succeed(
                  "python3 -c \"" +
                  "import json; " +
                  "s = json.load(open(\'/home/fog/.claude/settings.json\')); " +
                  "h = s.get(\'hooks\', {}); " +
                  "assert any(any(\'rtk hook claude\' in hh.get(\'command\',\'\') for hh in g.get(\'hooks\',[])) for g in h.get(\'PreToolUse\',[])); " +
                  "assert any(any(\'caveman-activate\' in hh.get(\'command\',\'\') for hh in g.get(\'hooks\',[])) for g in h.get(\'SessionStart\',[])); " +
                  "assert any(any(\'worker-service\' in hh.get(\'command\',\'\') for hh in g.get(\'hooks\',[])) for g in h.get(\'PostToolUse\',[])); " +
                  "assert \'aws-api\' in s.get(\'mcpServers\', {}); " +
                  "print(\'ALL OK\')" +
                  "\"")

              machine.succeed("test -L /home/fog/.claude/hooks/caveman-activate.js")
              machine.succeed("test -L /home/fog/.claude/hooks/caveman-mode-tracker.js")
              machine.succeed("test -x /home/fog/.claude/hooks/caveman-statusline.sh")
              machine.succeed("test -d /home/fog/.claude/commands")
              machine.succeed("test -f /home/fog/.claude/RTK.md")

              machine.succeed("rtk --version")
              machine.succeed("aws --version")
              machine.succeed("which aws-api-mcp-server")
            '';
          };
        });
    };
}

