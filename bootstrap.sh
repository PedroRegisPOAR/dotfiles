test -w /nix/var/nix || sudo sh -c 'mkdir -pv -m 1735 /nix/var/nix && chown -Rv '"$(id -nu)":"$(id -gn)"' /nix'

ARCH=$(uname -m)

case "$ARCH" in
    x86_64)
        BUILD_ID="308296217"
        EXPECTED_SHA256SUM=18710ed342eb80e8417e9bb87ce5b63e54ec4b3daeed6dc068c3c0adb6bebfe5
        HM_ATTR=pedro-pedro-G3
        ;;
    aarch64)
        BUILD_ID="308399262"
        EXPECTED_SHA256SUM=869a20597a27e32fdc2c9b9d7a00e05eb2483c7485dea0f2fe57bffc2c704e06
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
github:NixOS/nixpkgs/fd487183437963a59ba763c0cc4f27e3447dd6dd \
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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      userName = "vagrant";
      homeDirectory = "/home/${userName}";

      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # overlays.default = nixpkgs.lib.composeManyExtensions [
      #   (final: prev: {
      #     fooBar = prev.hello;
      #   })];

      # pkgs = import nixpkgs {
      #           inherit system;
      #           overlays = [ self.overlays.default ];
      #         };            
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;
      homeConfigurations."${userName}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ({ pkgs, ... }:
            {
              home.stateVersion = "25.05";
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
                nano
                file
                which
                (writeScriptBin "hms" ''
                    #! ${pkgs.runtimeShell} -e
                      nix \
                      build \
                      --no-link \
                      --print-build-logs \
                      --print-out-paths \
                      "$HOME"'/.config/home-manager#homeConfigurations.'"$(id -un)".activationPackage

                      home-manager switch --flake "$HOME/.config/home-manager"#"$(id -un)"
                '')
              ];

              nix = {
                enable = true;
                package = pkgs.nix;
                # package = pkgs.nixVersions.nix_2_29;
                extraOptions = ''
                  experimental-features = nix-command flakes
                '';
                settings = {
                  bash-prompt-prefix = "(nix:$name)\\040";
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
                dotDir = ".config/zsh";
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
                  NIX_PATH = "nixpkgs=${pkgs.path}";
                  LANG = "en_US.utf8";
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

sed -i 's/.*userName = ".*";/userName = "'"$USER"'";/' /home/"$USER"/.config/home-manager/flake.nix

(git config init.defaultBranch \
|| git config --global init.defaultBranch main) \
&& (git config --global user.email || git config --global user.email "you@example.com") \
&& (git config --global user.name || git config --global user.name "Your Name") \
&& git init \
&& git add .

"$OLD_PWD"/nix \
--extra-experimental-features nix-command \
--extra-experimental-features flakes \
--extra-experimental-features auto-allocate-uids \
--option auto-allocate-uids false \
--option warn-dirty false \
flake \
lock \
--override-input nixpkgs github:NixOS/nixpkgs/fd487183437963a59ba763c0cc4f27e3447dd6dd \
--override-input home-manager github:nix-community/home-manager/83665c39fa688bd6a1f7c43cf7997a70f6a109f9

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

git add . \
&& git commit -m 'First commit'

cat > system-aarch64.patch <<-'EOF'
diff --git a/flake.nix b/flake.nix
index f461aa4..eea9ce0 100644
--- a/flake.nix
+++ b/flake.nix
@@ -14,7 +14,8 @@
 userName = "bob";
       homeDirectory = "/home/${userName}";
 
-      system = "x86_64-linux";
+      # system = "x86_64-linux";
+      system = "aarch64-linux";
       pkgs = nixpkgs.legacyPackages.${system};
 
       # overlays.default = nixpkgs.lib.composeManyExtensions [
EOF

ARCH=$(uname -m)
[ "$ARCH" == "aarch64" ] && git apply system-aarch64.patch
# [ "$ARCH" == "x86_64" ] && git apply system-x86_64.patch

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
github:NixOS/nixpkgs/fd487183437963a59ba763c0cc4f27e3447dd6dd#bashInteractive \
github:NixOS/nixpkgs/fd487183437963a59ba763c0cc4f27e3447dd6dd#home-manager \
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
