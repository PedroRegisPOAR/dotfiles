# dotfiles

```bash
curl -L https://raw.githubusercontent.com/PedroRegisPOAR/dotfiles/main/apt-fu.sh | "$SHELL"
```

```bash
curl -L https://raw.githubusercontent.com/PedroRegisPOAR/dotfiles/main/bootstrap.sh | sh \
&& exec /home/"$USER"/.nix-profile/bin/zsh --login
```


```bash
curl -L https://raw.githubusercontent.com/PedroRegisPOAR/dotfiles/main/bootstrap-unprivileged.sh | sh \
&& . ~/.profile
```



```bash
sudo rm -frv /etc/nixos/ \
&& sudo mkdir -pv /etc/nixos/ \
&& cd /etc/nixos \
&& sudo \
    nix \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes \
    --refresh \
    flake \
    init \
    --template \
    github:PedroRegisPOAR/dotfiles#UTMNixOSBootstrap \
&& sudo nixos-rebuild switch --flake '/etc/nixos#n1x0s' --option cores 0 --option max-jobs auto
```

```bash
sudo rm -frv /etc/nixos/ \
&& sudo mkdir -pv /etc/nixos/ \
&& cd /etc/nixos \
&& sudo \
    nix \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes \
    --refresh \
    flake \
    init \
    --template \
    github:PedroRegisPOAR/dotfiles#UTMNixOSBootstrap \
&& sudo git init \
&& sudo git add . \
&& sudo nixos-rebuild switch --flake '/etc/nixos#' --option cores 0 --option max-jobs auto
```


```bash
sudo \
nix \
--extra-experimental-features nix-command \
--extra-experimental-features flakes \
flake \
lock \
--override-input nixpkgs github:NixOS/nixpkgs/9a094440e02a699be5c57453a092a8baf569bdad
```

```bash
sudo \
nix \
--extra-experimental-features nix-command \
--extra-experimental-features flakes \
flake \
lock \
--override-input nixpkgs github:NixOS/nixpkgs/f560ccec6b1116b22e6ed15f4c510997d99d5852
```

```bash
sudo \
nix \
--extra-experimental-features nix-command \
--extra-experimental-features flakes \
flake \
lock \
--override-input nixpkgs github:NixOS/nixpkgs/0c88e1f2bdb9
```

0c88e1f2bdb9


0)
```bash
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


./nix \
--extra-experimental-features nix-command \
--extra-experimental-features flakes \
shell \
--ignore-environment \
--keep HOME \
--keep USER \
--keep HM_ATTR \
--override-flake \
nixpkgs \
github:NixOS/nixpkgs/f560ccec6b1116b22e6ed15f4c510997d99d5852 \
nixpkgs#bashInteractive \
nixpkgs#coreutils \
nixpkgs#git \
nixpkgs#home-manager \
nixpkgs#nix \
nixpkgs#nettools \
--command \
bash \
<<'COMMANDS'
export NIXPKGS_ALLOW_UNFREE=1
export NIX_CONFIG="extra-experimental-features = nix-command flakes auto-allocate-uids"

test -d "$HOME"/.config/nixpkgs && rm -frv "$HOME"/.config/nixpkgs/
[ -h "$HOME"/.zshenv ] && [ ! -f "$HOME"/.zshenv ] && [ ! -d "$HOME"/.zshenv ] && rm -fv -- "$HOME"/.zshenv

nix \
flake \
clone \
--override-flake \
nixpkgs \
github:NixOS/nixpkgs/f560ccec6b1116b22e6ed15f4c510997d99d5852 \
'github:PedroRegisPOAR/dotfiles' \
--dest "$HOME"/.config/nixpkgs

# home-manager switch --option download-buffer-size 671088640 --impure --flake "$HOME/.config/nixpkgs"#"$(id -un)"-"$(hostname)"
home-manager switch --option download-buffer-size 671088640  --impure --flake "$HOME/.config/nixpkgs"#$HM_ATTR
COMMANDS
```
Refs.:
- https://unix.stackexchange.com/a/654575
