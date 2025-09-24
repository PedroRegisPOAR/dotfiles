# dotfiles


0)
```bash
ARCH=$(uname -m)

case "$ARCH" in
    x86_64)
        BUILD_ID="297111184"
        EXPECTED_SHA256SUM=7838348c0e560855921cfa97051161bd63e29ee7ef4111eedc77228e91772958
        ;;
    aarch64)
        BUILD_ID="297111173"
        EXPECTED_SHA256SUM=a559d9c4c144859251ab5441cf285f1c38861e4bb46509e38229474368286467
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
```

1)
```bash
sudo sh -c 'mkdir -pv -m 1735 /nix/var/nix && chown -Rv '"$(id -nu)":"$(id -gn)"' /nix'

./nix \
--extra-experimental-features nix-command \
--extra-experimental-features flakes \
shell \
--ignore-environment \
--keep HOME \
--keep USER \
--override-flake \
nixpkgs \
github:NixOS/nixpkgs/fd487183437963a59ba763c0cc4f27e3447dd6dd \
nixpkgs#bashInteractive \
nixpkgs#coreutils \
nixpkgs#git \
nixpkgs#home-manager \
nixpkgs#nix \
nixpkgs#nettools \
--command \
bash \
-c \
'
export NIXPKGS_ALLOW_UNFREE=1
export NIX_CONFIG="extra-experimental-features = nix-command flakes auto-allocate-uids"

test -d "$HOME"/.config/nixpkgs && rm -frv "$HOME"/.config/nixpkgs/
[ -h "$HOME"/.zshenv ] && [ ! -f "$HOME"/.zshenv ] && [ ! -d "$HOME"/.zshenv ] && rm -fv -- "$HOME"/.zshenv

nix \
flake \
clone \
--override-flake \
nixpkgs \
github:NixOS/nixpkgs/fd487183437963a59ba763c0cc4f27e3447dd6dd \
'github:PedroRegisPOAR/dotfiles' \
--dest "$HOME"/.config/nixpkgs

# home-manager switch --option download-buffer-size 671088640 --impure --flake "$HOME/.config/nixpkgs"#"$(id -un)"-"$(hostname)"
home-manager switch --option download-buffer-size 671088640  --impure --flake "$HOME/.config/nixpkgs"#pedro-pedro-G3
'
```
Refs.:
- https://unix.stackexchange.com/a/654575
