test -w /nix/var/nix || sudo sh -c 'mkdir -pv -m 1735 /nix/var/nix && chown -Rv '"$(id -nu)":"$(id -gn)"' /nix'

ARCH=$(uname -m)

case "$ARCH" in
    x86_64)
        BUILD_ID="313290523"
        EXPECTED_SHA256SUM=e95f16f84987096586abe959c80bb910d26a7fa7707c42802400be999b6ad5ab
        HM_ATTR=pedro-pedro-G3
        ;;
    aarch64)
        BUILD_ID="312837149"
        EXPECTED_SHA256SUM=8fda1192c5f93415206b7028c4afe694611d1a5525bfcb5f3f2d57cc87df0d56
        HM_ATTR=bob
        ;;
    *)
        echo "Error: Unsupported architecture 'ARCH'" >&2
        exit 1
        ;;
esac

(test -f nix || curl -L https://hydra.nixos.org/build/"$BUILD_ID"/download-by-type/file/binary-dist > nix) \
&& echo "$EXPECTED_SHA256SUM"'  'nix \
| sha256sum -c \
&& chmod +x nix \
&& ./nix --version

echo "Start kvm stuff..." \
&& (getent group kvm || sudo groupadd kvm) \
&& sudo usermod --append --groups kvm "$USER" \
&& echo "End kvm stuff!" \
&& (test -w /dev/kvm || sudo chown -v "$(id -u)":"$(id -g)" /dev/kvm) 

# TODO: may it be with exec?
echo '"$HOME"/.nix-profile/bin/zsh --login' >> "$HOME"/.bashrc

./nix --version \
&& ./nix \
--extra-experimental-features nix-command \
--extra-experimental-features flakes \
--extra-experimental-features auto-allocate-uids \
--option auto-allocate-uids false \
shell \
--ignore-environment \
--keep HOME \
--keep SHELL \
--keep USER \
--override-flake \
nixpkgs \
github:NixOS/nixpkgs/c97c47f2bac4fa59e2cbdeba289686ae615f8ed4 \
nixpkgs#bashInteractive \
nixpkgs#coreutils \
nixpkgs#file \
nixpkgs#gnused \
nixpkgs#nix \
nixpkgs#gitMinimal \
nixpkgs#home-manager \
--command \
bash \
<<'COMMANDS'
# set -x

OLD_PWD=$(pwd)

# ! test -z "$USER" || exit 1
# id "$USER" &>/dev/null || exit 1

mkdir -pv /home/"$USER"/.config/home-manager && cd $_

cat << 'EOF' > flake.nix
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
      userName = "vagrant";
      homeDirectory = "/home/${userName}";

      # system = "x86_64-linux";
      # system = "aarch64-linux";

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
          # TODO: how find all passed things?? It was missing the config one.
          ({ config, pkgs, ... }:
            {
              home.stateVersion = "25.11";
              home.username = "${userName}";
              home.homeDirectory = "${homeDirectory}";

              programs.home-manager.enable = true;

              home.packages = with pkgs; [
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
              ];

              nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
                "example-unfree-package"
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
            }
          )
        ];
        extraSpecialArgs = { nixpkgs = nixpkgs; };
      };
    };
}
EOF

test -f /home/"$USER"/.config/home-manager/flake.nix || echo 'not found flake.nix'

(git config init.defaultBranch \
|| git config --global init.defaultBranch main) \
&& (git config --global user.email || git config --global user.email "you@example.com") \
&& (git config --global user.name || git config --global user.name "Your Name") \
&& git init \
&& git add . \
&& git commit -m 'First commit'

# git diff --patch

cat > system-aarch64.patch <<-'EOF'
diff --git a/flake.nix b/flake.nix
index 67b0f05..57fdd66 100644
--- a/flake.nix
+++ b/flake.nix
@@ -15,7 +15,7 @@
       homeDirectory = "/home/${userName}";
 
       # system = "x86_64-linux";
-      # system = "aarch64-linux";
+      system = "aarch64-linux";

       # pkgs = nixpkgs.legacyPackages.${system};

EOF

cat > system-x86_64.patch <<-'EOF'
diff --git a/flake.nix b/flake.nix
index 67b0f05..33ddac4 100644
--- a/flake.nix
+++ b/flake.nix
@@ -14,7 +14,7 @@
       userName = "vagrant";
       homeDirectory = "/home/${userName}";
 
-      # system = "x86_64-linux";
+      system = "x86_64-linux";
       # system = "aarch64-linux";

       # pkgs = nixpkgs.legacyPackages.${system};

EOF

ARCH=$(uname -m)
[ "$ARCH" == "aarch64" ] && (git apply --verbose system-aarch64.patch || exit 1)
[ "$ARCH" == "x86_64" ] && (git apply --verbose system-x86_64.patch || exit 1)
rm -v system-aarch64.patch system-x86_64.patch

sed -i 's/.*userName = ".*";/userName = "'"$USER"'";/' /home/"$USER"/.config/home-manager/flake.nix

"$OLD_PWD"/nix \
--extra-experimental-features nix-command \
--extra-experimental-features flakes \
--extra-experimental-features auto-allocate-uids \
--option auto-allocate-uids false \
--option warn-dirty false \
flake \
lock \
--override-input nixpkgs github:NixOS/nixpkgs/c97c47f2bac4fa59e2cbdeba289686ae615f8ed4 \
--override-input home-manager github:nix-community/home-manager/f63d0fe9d81d36e5fc95497217a72e02b8b7bcab

# Even removing all packages it still making home-manager break, why?
"$OLD_PWD"/nix \
--extra-experimental-features nix-command \
--extra-experimental-features flakes \
--extra-experimental-features auto-allocate-uids \
--option auto-allocate-uids false \
--option warn-dirty false \
profile \
remove \
'.*'

# It looks like the symbolic link breaks home-manager, why?
ls -ahl "$HOME"/.local/state/nix/profiles/profile || true
file "$HOME"/.local/state/nix/profiles || true
test -d "$HOME"/.local/state/nix/profiles && rm -frv "$HOME"/.local/state/nix/profiles

export NIX_CONFIG="extra-experimental-features = nix-command flakes"

home-manager \
switch \
-b backup \
--print-build-logs \
--option warn-dirty false

/home/"$USER"/.nix-profile/bin/zsh \
-lc 'nix flake --version' \
|| echo 'The instalation may have failed!'

test -L /home/"$USER"/.nix-profile/bin/zsh \
&& "$OLD_PWD"/nix \
store \
gc \
--option keep-build-log false \
--option keep-derivations false \
--option keep-env-derivations false \
--option keep-failed false \
--option keep-going false \
--option keep-outputs true \
&& "$OLD_PWD"/nix \
store \
optimise

# test -L /home/"$USER"/.nix-profile/bin/zsh \
# && test -f "$OLD_PWD"/nix && rm -v "$OLD_PWD"/nix

# For some reason in the first execution it fails
# needing re loging, but this workaround allows a
# way better first developer experience.
/home/"$USER"/.nix-profile/bin/zsh \
-lc 'home-manager switch 1> /dev/null 2> /dev/null' 2> /dev/null || true
COMMANDS

./nix \
--extra-experimental-features nix-command \
--extra-experimental-features flakes \
--no-use-registries \
shell \
github:NixOS/nixpkgs/c97c47f2bac4fa59e2cbdeba289686ae615f8ed4#bashInteractive \
github:NixOS/nixpkgs/c97c47f2bac4fa59e2cbdeba289686ae615f8ed4#home-manager \
--command \
bash \
-c \
'
/home/"$USER"/.nix-profile/bin/zsh \
-cl \
"
nix --version \
&& nix flake --version \
&& home-manager --version \
&& hello \
&& home-manager switch
"
'

exec /home/"$USER"/.nix-profile/bin/zsh --login
