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

  */
  inputs = {
    # Specify the source of Home Manager and Nixpkgs
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = allAttrs@{ self, nixpkgs, home-manager, ... }:
    let
      # TODO: generalizar a arquitetura
      system = "x86_64-linux";

      pkgsAllowUnfree = import nixpkgs {
        # inherit system;
        system = "x86_64-linux";
        config = { allowUnfree = true; };
      };

      f = { system, username }: home-manager.lib.homeManagerConfiguration {
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
        extraSpecialArgs = { nixpkgs = nixpkgs; };
      };

      # userAndHostname = {user, hostname, system}: { "${hostname}""${user}" = f { system = $system; username = $username; }; };

      # https://gist.github.com/tpwrules/34db43e0e2e9d0b72d30534ad2cda66d#file-flake-nix-L28
      pleaseKeepMyInputs = pkgsAllowUnfree.writeTextDir "bin/.please-keep-my-inputs"
        (builtins.concatStringsSep " " (builtins.attrValues allAttrs));

    in
    {
      homeConfigurations = {

        # vagrant-alpine316.localdomain = f { system = "x86_64-linux"; username = "vagrant"; };

        # sudo su
        # echo 'ubuntu2204-ec2' > /etc/hostname
        # hostname ubuntu2204-ec2
        ubuntu-ubuntu2204-ec2 = f { system = "x86_64-linux"; username = "ubuntu"; };

        # GNU/Linux
        pedro-nixos = f { system = "x86_64-linux"; username = "pedro"; };
        pedro-pedro-G3 = f { system = "x86_64-linux"; username = "pedro"; };
      };

      # nix fmt
      formatter."x86_64-linux" = pkgsAllowUnfree.nixfmt-rfc-style;

      devShells."x86_64-linux".default = pkgsAllowUnfree.mkShell {
        buildInputs = with pkgsAllowUnfree; [
          bashInteractive
          coreutils
          curl
          gnumake
          patchelf
          poetry
          python3Full
          tmate

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