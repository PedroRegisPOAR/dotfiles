
nix flake clone 'github:ES-Nix/es' --dest es \
&& cd es 1>/dev/null 2>/dev/null \
&& (direnv --version 1>/dev/null 2>/dev/null && direnv allow) \
|| nix develop '.#' --command $SHELL


nix flake clone 'github:PedroRegisPOAR/dotfiles' --dest dotfiles \
&& cd dotfiles

nix \
build \
--no-link \
--print-build-logs \
--print-out-paths \
--override-flake \
nixpkgs \
github:NixOS/nixpkgs/c97c47f2bac4fa59e2cbdeba289686ae615f8ed4 \
'nixpkgs#pkgsCross.armv7l-hf-multiplatform.hello' \
'nixpkgs#pkgsCross.aarch64-multiplatform.hello' \
'nixpkgs#pkgsCross.ppc64.hello' \
'nixpkgs#pkgsCross.s390x.hello' \
'nixpkgs#pkgsCross.riscv64.hello' \
'nixpkgs#pkgsCross.armv7l-hf-multiplatform.pkgsStatic.hello' \
'nixpkgs#pkgsCross.aarch64-multiplatform.pkgsStatic.hello' \
'nixpkgs#pkgsCross.ppc64.pkgsStatic.hello' \
'nixpkgs#pkgsCross.s390x.pkgsStatic.hello' \
'nixpkgs#pkgsCross.riscv64.pkgsStatic.hello' 

# sudo launchctl list | grep org.nixos.nix-daemon || echo "nix-daemon not running"
# sudo launchctl stop org.nixos.nix-daemon
# sudo launchctl bootout system /Library/LaunchDaemons/org.nixos.nix-daemon.plist
# sudo launchctl list | grep org.nixos.nix-daemon

# sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.nix-daemon.plist
# sudo launchctl start org.nixos.nix-daemon
# sudo launchctl list | grep org.nixos.nix-daemon

# sudo launchctl kickstart -k system/org.nixos.nix-daemon
# launchctl print system/org.nixos.nix-daemon


curl -L https://releases.nixos.org/nix/nix-2.32.4/install | sh -s -- --no-channel-add --daemon --yes \
&& (test -d /etc/nix || sudo mkdir -pv /etc/nix) \
&& echo 'experimental-features = nix-command flakes' | sudo tee -a /etc/nix/nix.conf \
&& (test -d ~/.config/nix/ || mkdir -pv ~/.config/nix/) \
&& echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf \
&& . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' \
&& test -S /nix/var/nix/daemon-socket/socket \
&& sudo chown -v root:"$(id -gn)" /nix/var/nix/daemon-socket/socket \
&& test -w /nix/var/nix/daemon-socket/socket \
&& pgrep -x "nix-daemon" \
&& systemctl is-active nix-daemon.socket \
&& systemctl is-active nix-daemon.service \
&& sudo -i nix registry pin nixpkgs github:NixOS/nixpkgs/c97c47f2bac4fa59e2cbdeba289686ae615f8ed4 \
&& nix registry pin nixpkgs github:NixOS/nixpkgs/c97c47f2bac4fa59e2cbdeba289686ae615f8ed4


curl -L https://releases.nixos.org/nix/nix-2.32.4/install | sh -s -- --no-channel-add --no-daemon --yes \
&& (test -d ~/.config/nix/ || mkdir -pv ~/.config/nix/) \
&& echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf \
&& . ~/.nix-profile/etc/profile.d/nix.sh \
&& nix --version \
&& nix registry pin nixpkgs github:NixOS/nixpkgs/c97c47f2bac4fa59e2cbdeba289686ae615f8ed4



BUILD_ID=295965384
curl -L https://hydra.nixos.org/build/"$BUILD_ID"/download-by-type/file/binary-dist > nix \
&& chmod +x nix \
&& ./nix --version \
&& ./nix --extra-experimental-features nix-command --extra-experimental-features flakes --store /tmp/root run nixpkgs#hello \
&& ./nix --extra-experimental-features nix-command --extra-experimental-features flakes run nixpkgs#hello


BUILD_ID=312837149
curl -L https://hydra.nixos.org/build/"$BUILD_ID"/download-by-type/file/binary-dist > nix \
&& chmod +x nix \
&& ./nix --version \
&& ./nix --extra-experimental-features nix-command --extra-experimental-features flakes run nixpkgs#hello

&& ./nix --extra-experimental-features nix-command --extra-experimental-features flakes --store /tmp/root run nixpkgs#hello \

--store /tmp/root

NIX_REMOTE='local?store='"$HOME"'/nix/store&state='"$HOME"'/nix/var/nix&log='"$HOME"'/nix/var/log/nix' \
./nix \
--experimental-features 'nix-command flakes' \
build nixpkgs#hello



cd ~/.config/nix-darwin \
&& (git config init.defaultBranch || git config --global init.defaultBranch main) \
&& (git config --global user.email || git config --global user.email "you@example.com") \
&& (git config --global user.name || git config --global user.name "Your Name") \
&& git init \
&& git add . \
&& git commit -m 'First commit'


nix \
flake \
lock \
--override-input nixpkgs 'github:NixOS/nixpkgs/c97c47f2bac4fa59e2cbdeba289686ae615f8ed4' \
--override-input nix-darwin 'github:nix-darwin/nix-darwin/e95de00a471d07435e0527ff4db092c84998698e' \
--override-input home-manager 'github:nix-community/home-manager/f21d9167782c086a33ad53e2311854a8f13c281e'



        home-manger = {
          useGlobalPkgs = true;
          useUserPkgs = true;
          users."chehabmustafa-hilmy".imports = [
            ({ pkgs, ... }: {

              home.packages = with pkgs; [
                    git
                    nevim
                    fzf
                    grep
                    htop
                    tree
                    wget
                    curl
                    gh
                    starship
                    python3
              ];

              home.sessionVariables = {
                # PAGER = "less";
              };

              programs.zsh = {
                enable = true;
                enableCompletion = true;
                enableAutosuggestions = true;
                enableSyntaxHighlight = true;
              };

              programs.fzf = {
                enable = true;
                enableZshIntegration = true;
              };

              programs.zsh.shellAliases = {
                l = "ls -alh";
              };
            })
          ];
        };


system.configurationRevision = self.rev or self.dirtyRev or null;

programs.zsh.shellInit = ''
# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
'';

environment.shells = with pkgs; [ bashInteractive zsh fish ];


programs.starship.enable = true;
programs.starship.enableZshIntegration = true;


programs.fzf.enable = true;
programs.fzf.enableZshIntegration = true;

programs.zsh.enableFzfCompletion = true;
programs.zsh.enableFzfHistory = true;
programs.direnv.enable = true;

nix.gc.automatic = true;
nix.gc.user = "";
nix.gc.interval = {
  Minute = 15;
};
nix.gc.options =
  let
    gbFree = 50;
  in
    "--max-freed $((${toString gbFree} * 1024**3 - 1024 * $(df -P -k /nix/store | tail -n 1 | awk '{ print $4 }')))";

# If we drop below 20GiB during builds, free 20GiB
nix.extraOptions = ''
  min-free = ${toString (30 * 1024 * 1024 * 1024)}
  max-free = ${toString (50 * 1024 * 1024 * 1024)}
'';
sudo apt install hello:amd64