curl -L https://releases.nixos.org/nix/nix-2.32.4/install | sh -s -- --no-channel-add --daemon --yes \
&& (test -d /etc/nix || sudo mkdir -pv /etc/nix) \
&& echo 'experimental-features = nix-command flakes' | sudo tee -a /etc/nix/nix.conf \
&& (test -d ~/.config/nix/ || mkdir -pv ~/.config/nix/) \
&& echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf \
&& . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' \
&& sudo launchctl list | grep org.nixos.nix-daemon || echo "nix-daemon not running" \
&& pgrep -x "nix-daemon" || echo "nix-daemon process not running" \
&& sudo -i nix registry pin nixpkgs github:NixOS/nixpkgs/c97c47f2bac4fa59e2cbdeba289686ae615f8ed4 \
&& nix registry pin nixpkgs github:NixOS/nixpkgs/c97c47f2bac4fa59e2cbdeba289686ae615f8ed4 \
&& sudo -i nix run nixpkgs#hello \
&& nix run nixpkgs#hello \
&& (test -d ~/.config/nix-darwin || mkdir -p ~/.config/nix-darwin) \
&& cd ~/.config/nix-darwin \
&& nix flake init --template github:nix-darwin/nix-darwin/e95de00a471d07435e0527ff4db092c84998698e \
&& nix \
     flake \
     lock \
     --override-input nixpkgs 'github:NixOS/nixpkgs/c97c47f2bac4fa59e2cbdeba289686ae615f8ed4' \
     --override-input nix-darwin 'github:nix-darwin/nix-darwin/e95de00a471d07435e0527ff4db092c84998698e' \
&& nix flake metadata . \
&& sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix \
&& sed -i '' "s/pkgs.vim/pkgs.vim pkgs.git/" flake.nix \
&& sudo rm -fv /etc/nix/nix.conf /etc/bashrc /etc/zshrc \
&& sudo -i nix --extra-experimental-features nix-command --extra-experimental-features flakes \
           run github:nix-darwin/nix-darwin/e95de00a471d07435e0527ff4db092c84998698e -- \
           switch --flake ~/.config/nix-darwin \
&& sudo -i /run/current-system/sw/bin/darwin-rebuild switch --flake ~/.config/nix-darwin \
&& echo 'sudo -i darwin-rebuild switch --flake ~/.config/nix-darwin' >> ~/.zsh_history \
&& exec "$SHELL" --login

