{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      userName = "debian";
      homeDirectory = "/home/${userName}";

      # system = "x86_64-linux";
      system = "aarch64-linux";

      # pkgs = nixpkgs.legacyPackages.${system};

      overlays.default = nixpkgs.lib.composeManyExtensions [
        (final: prev: {
          fooBar = prev.hello;
          hms = final.writeScriptBin "hms" ''
            #! ${final.runtimeShell} -e
              nix \
              build \
              --no-link \
              --print-build-logs \
              --print-out-paths \
              "$HOME"'/.config/home-manager#homeConfigurations.'"$(id -un)".activationPackage

              home-manager switch --flake "$HOME/.config/home-manager"#"$(id -un)"
          '';
          ngc = final.writeScriptBin "ngc" ''
            #! ${final.runtimeShell} -e
              nix \
              store \
              gc \
              --verbose \
              --option keep-build-log false \
              --option keep-derivations false \
              --option keep-env-derivations false \
              --option keep-failed false \
              --option keep-going false \
              --option keep-outputs false \
              && nix-collect-garbage --delete-old \
              && nix store optimise --verbose \
              && du -cksh /nix
          '';

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
        })
      ];
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlays.default ];
      };
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;
      homeConfigurations."${userName}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./claude-settings-hm.nix
          # TODO: how find all passed things?? It was missing the config one.
          ({ config, pkgs, ... }:
            {
              home.stateVersion = "25.11";
              home.username = "${userName}";
              home.homeDirectory = "${homeDirectory}";

              programs.home-manager.enable = true;

              home.packages = with pkgs; [
                claude-code
                git
                nix
                # path # TODO: Why it breaks??
                zsh
                direnv
                starship

                hello
                hello-unfree
                nano
                file
                which
                openssh
                procps

                hms
                fooBar
                ngc

                mcp-nixos
                rtk
                caveman
                claude-mem
                awscli2
                aws-api-mcp-server
                context7-mcp
                superpowers-plugin
              ];

              nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
                "example-unfree-package"
                "claude-code"
              ];

              nix = {
                enable = true;
                package = pkgs.nix;
                # package = pkgs.nixVersions.nix_2_29;
                extraOptions = ''
                  experimental-features = nix-command flakes
                '';
                settings = {
                  bash-prompt-prefix = "(nix develop@$name)\\040";
                  keep-build-log = true;
                  keep-derivations = true;
                  keep-env-derivations = true;
                  keep-failed = true;
                  keep-going = true;
                  keep-outputs = true;
                  nix-path = "nixpkgs=flake:nixpkgs";
                  tarball-ttl = 2419200; # 60 * 60 * 24 * 7 * 4 = one month
                };                
                registry.nixpkgs.flake = nixpkgs;
              };

              programs.zsh = {
                enable = true;
                enableCompletion = true;
                dotDir = "${config.home.homeDirectory}";
                autosuggestion.enable = true;
                syntaxHighlighting.enable = true;
                envExtra = ''
                  if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
                    . ~/.nix-profile/etc/profile.d/nix.sh
                  fi
                '';
                shellAliases = {
                  l = "ls -alh";
                };
                sessionVariables = {
                  # https://discourse.nixos.org/t/what-is-the-correct-way-to-set-nix-path-with-home-manager-on-ubuntu/29736
                  NIX_PATH = "nixpkgs=${pkgs.path}"; # TODO: is this correct??
                  LANG = "en_US.utf8"; # TODO: test it
                };
                oh-my-zsh = {
                  enable = true;
                  plugins = [
                    "colored-man-pages"
                    "colorize"
                    "direnv"
                    "zsh-navigation-tools"
                  ];
                  theme = "robbyrussell";
                };
              };

              programs.direnv = {
                enable = true;
                nix-direnv = {
                  enable = true;
                };
                enableZshIntegration = true;
                silent = true;
              };
            }
          )
        ];
        extraSpecialArgs = { nixpkgs = nixpkgs; };
      };
    };
}
