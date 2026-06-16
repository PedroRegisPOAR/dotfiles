{

  /*
    nix \
    flake \
    lock \
    --override-input nixpkgs 'github:NixOS/nixpkgs/b77b3de8775677f84492abe84635f87b0e153f0f'
  */
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
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

        e2eTests = final.writeShellApplication {
          name = "e2e-tests";
          runtimeInputs = [ final.python3 ];
          excludeShellChecks = [ "SC2015" ];
          text = ''
            PASS=0
            FAIL=0
            ok()   { echo "✓ $*"; PASS=$((PASS+1)); }
            fail() { echo "✗ $*"; FAIL=$((FAIL+1)); }

            if test -f "$HOME/.claude/settings.json"; then
              ok "settings.json exists"
            else
              fail "settings.json missing"
            fi

            python3 - "$HOME/.claude/settings.json" <<'PYEOF'
import json, sys
s = json.load(open(sys.argv[1]))
h = s.get('hooks', {})
errors = []
ptu = h.get('PreToolUse', [])
ss  = h.get('SessionStart', [])
pou = h.get('PostToolUse', [])
cmds = lambda lst: [hh.get('command',"") for g in lst for hh in g.get('hooks',[])]
if not any('rtk hook claude' in c for c in cmds(ptu)):
  errors.append('rtk PreToolUse hook missing')
if not any('caveman-activate' in c for c in cmds(ss)):
  errors.append('caveman SessionStart hook missing')
if not any('worker-service' in c for c in cmds(pou)):
  errors.append('worker-service PostToolUse hook missing')
if 'aws-api' not in s.get('mcpServers', {}):
  errors.append('aws-api MCP missing')
for e in errors: print(f'X {e}')
if not errors: print('OK hooks and MCP servers configured')
sys.exit(len(errors))
PYEOF

            test -L "$HOME/.claude/hooks/caveman-activate.js" \
              && ok "caveman-activate.js symlink" \
              || fail "caveman-activate.js missing"
            test -L "$HOME/.claude/hooks/caveman-mode-tracker.js" \
              && ok "caveman-mode-tracker.js symlink" \
              || fail "caveman-mode-tracker.js missing"
            test -d "$HOME/.claude/commands" \
              && ok "commands directory" \
              || fail "commands directory missing"
            test -f "$HOME/.claude/RTK.md" \
              && ok "RTK.md exists" \
              || fail "RTK.md missing"

            for tool in rtk caveman claude-mem starship direnv fzf nvim; do
              command -v "$tool" &>/dev/null \
                && ok "$tool in PATH" \
                || fail "$tool not found"
            done

            if test -f "$HOME/.config/direnv/direnv.toml" \
              && grep -q 'log_filter' "$HOME/.config/direnv/direnv.toml"; then
              ok "direnv.toml configured"
            else
              fail "direnv.toml missing or unconfigured"
            fi

            echo ""
            if [ "$FAIL" -eq 0 ]; then
              echo "All $PASS tests passed"
            else
              echo "$PASS passed, $FAIL FAILED"
              exit 1
            fi
          '';
          meta.mainProgram = "e2e-tests";
        };

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
          inherit (pkgs) allTests e2eTests;
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
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "backup";
                home-manager.users.fog = import ./home.nix;
              }
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
