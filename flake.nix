{
  description = "Home Manager configuration";
  /*
    22.11
    nix \
    flake \
    update \
    --override-input home-manager github:nix-community/home-manager/b372d7f8d5518aaba8a4058a453957460481afbc \
    --override-input nixpkgs github:NixOS/nixpkgs/ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b \
    --override-input flake-utils github:numtide/flake-utils/5aed5285a952e0b949eb3ba02c12fa4fcfef535f

    23.05
    nix \
    flake \
    lock \
    --override-input nixpkgs 'github:NixOS/nixpkgs/70bdadeb94ffc8806c0570eb5c2695ad29f0e421' \
    --override-input home-manager 'github:nix-community/home-manager/fc4492181833eaaa7a26a8081c0615d95792d825' \
    --override-input flake-utils 'github:numtide/flake-utils/b1d9ab70662946ef0850d488da1c9019f3a9752a'

    23.11
    nix \
    flake \
    lock \
    --override-input nixpkgs 'github:NixOS/nixpkgs/205fd4226592cc83fd4c0885a3e4c9c400efabb5' \
    --override-input home-manager 'github:nix-community/home-manager/f2e3c19867262dbe84fdfab42467fc8dd83a2005' \
    --override-input flake-utils 'github:numtide/flake-utils/b1d9ab70662946ef0850d488da1c9019f3a9752a'

    24.05
    nix \
    flake \
    lock \
    --override-input nixpkgs 'github:NixOS/nixpkgs/e8c38b73aeb218e27163376a2d617e61a2ad9b59' \
    --override-input home-manager 'github:nix-community/home-manager/2f23fa308a7c067e52dfcc30a0758f47043ec176' \
    --override-input flake-utils 'github:numtide/flake-utils/b1d9ab70662946ef0850d488da1c9019f3a9752a'

    24.11
    nix \
    flake \
    lock \
    --override-input nixpkgs 'github:NixOS/nixpkgs/057f63b6dc1a2c67301286152eb5af20747a9cb4' \
    --override-input home-manager 'github:nix-community/home-manager/aecd341dfead1c3ef7a3c15468ecd71e8343b7c6' \
    --override-input flake-utils 'github:numtide/flake-utils/b1d9ab70662946ef0850d488da1c9019f3a9752a'

    24.11 newer
    # nix flake metadata github:nix-community/home-manager/release-24.11 --refresh
    # nix flake metadata github:NixOS/nixpkgs/nixos-24.11 --refresh
    # nix flake metadata github:numtide/flake-utils --refresh
    nix \
    flake \
    lock \
    --override-input nixpkgs 'github:NixOS/nixpkgs/cdd2ef009676ac92b715ff26630164bb88fec4e0' \
    --override-input flake-utils 'github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b' \
    --override-input home-manager 'github:nix-community/home-manager/f6af7280a3390e65c2ad8fd059cdc303426cbd59'


    nix \
    flake \
    lock \
    --override-input nixpkgs 'github:NixOS/nixpkgs/fd487183437963a59ba763c0cc4f27e3447dd6dd' \
    --override-input home-manager 'github:nix-community/home-manager/83665c39fa688bd6a1f7c43cf7997a70f6a109f9'
  */
  inputs = {
    # Specify the source of Home Manager and Nixpkgs
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgsPy389.url = "github:NixOS/nixpkgs/b0f0b5c6c021ebafbd322899aa9a54b87d75a313";
    nixpkgsPy3921.url = "github:NixOS/nixpkgs/50ab793786d9de88ee30ec4e4c24fb4236fc2674";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    allAttrs@{ self
    , nixpkgs
    , nixpkgsPy389
    , nixpkgsPy3921
    , home-manager
    , ...
    }:
    let
      # TODO: generalizar a arquitetura
      system = "x86_64-linux";

      pkgsAllowUnfree = import nixpkgs {
        # inherit system;
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
        };
      };

      pkgsPy389 = import nixpkgsPy389 {
        system = "x86_64-linux";
      };

      pkgsPy3921 = import nixpkgsPy3921 {
        system = "x86_64-linux";
      };

      f =
        { system, username }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."${system}";

          modules = [
            {
              home = {
                username = "${username}";
                homeDirectory = "/home/" + "${username}"; # TODO: no Mac o caminho é diferente. Existe como fazer isso de forma idiomática em nix lang.
                stateVersion = "22.11";
                # https://discourse.nixos.org/t/correct-way-to-use-nixpkgs-in-nix-shell-on-flake-based-system-without-channels/19360/3
                sessionVariables.NIX_PATH = "nixpkgs=${nixpkgs.outPath}";

                sessionVariables.DIRENV_LOG_FORMAT = "";

                /*
                      https://github.com/NixOS/nixpkgs/issues/207339#issuecomment-1762960908
                      pointerCursor = {
                        gtk.enable = true;
                        x11.enable = true;
                        package = pkgsAllowUnfree.bibata-cursors;
                        name = "Bibata-Modern-Amber";
                        size = 28;
                      };
                */

              };
              programs.home-manager.enable = true;
            }
            ./home.nix
          ];

          # to pass through arguments to home.nix
          extraSpecialArgs = {
            nixpkgs = nixpkgs;
            pkgsPy389 = pkgsPy389;
            pkgsPy3921 = pkgsPy3921;
          };
        };

      # userAndHostname = {user, hostname, system}: { "${hostname}""${user}" = f { system = $system; username = $username; }; };

      # https://gist.github.com/tpwrules/34db43e0e2e9d0b72d30534ad2cda66d#file-flake-nix-L28
      pleaseKeepMyInputs = pkgsAllowUnfree.writeTextDir "bin/.please-keep-my-inputs" (
        builtins.concatStringsSep " " (builtins.attrValues allAttrs)
      );

    in
    {
      homeConfigurations = {

        # vagrant-alpine316.localdomain = f { system = "x86_64-linux"; username = "vagrant"; };

        # sudo su
        # echo 'ubuntu2204-ec2' > /etc/hostname
        # hostname ubuntu2204-ec2
        ubuntu-ubuntu2204-ec2 = f {
          system = "x86_64-linux";
          username = "ubuntu";
        };

        # GNU/Linux
        pedro-nixos = f {
          system = "x86_64-linux";
          username = "pedro";
        };
        pedro-pedro-G3 = f {
          system = "x86_64-linux";
          username = "pedro";
        };
      };

      # nix fmt
      formatter."x86_64-linux" = pkgsAllowUnfree.nixpkgs-fmt;

      devShells."x86_64-linux".default = pkgsAllowUnfree.mkShell {
        buildInputs = with pkgsAllowUnfree; [
          bashInteractive
          coreutils
          curl
          gnumake
          nixpkgs-fmt
          patchelf
          poetry
          python3Full
          tmate

          (writeScriptBin "first-time-gphms" ''
            #! ${pkgs.runtimeShell} -e

            cd "$HOME/.config/nixpkgs" && git pull \
            && export NIXPKGS_ALLOW_UNFREE=1; \
            && nix flake lock \
                    --override-input nixpkgs github:NixOS/nixpkgs/057f63b6dc1a2c67301286152eb5af20747a9cb4 \
            && home-manager switch --impure --flake "$HOME/.config/nixpkgs"#"$(id -un)"-"$(hostname)"
          '')

          pleaseKeepMyInputs
        ];

        shellHook = ''
          test -d .profiles || mkdir -v .profiles
          test -L .profiles/dev \
          || nix develop .# --profile .profiles/dev --command true
          test -L .profiles/dev-shell-default \
          || nix build $(nix eval --impure --raw .#devShells.x86_64-linux.default.drvPath) --out-link .profiles/dev-shell-default
        '';
      };
    };
}
