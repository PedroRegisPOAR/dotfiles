
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
