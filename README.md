# dotfiles


0)
```bash
test -w /nix/var/nix || sudo sh -c 'mkdir -pv -m 1735 /nix/var/nix && chown -Rv '"$(id -nu)":"$(id -gn)"' /nix'

ARCH=$(uname -m)

case "$ARCH" in
    x86_64)
        BUILD_ID="308296217"
        EXPECTED_SHA256SUM=7838348c0e560855921cfa97051161bd63e29ee7ef4111eedc77228e91772958
        HM_ATTR=pedro-pedro-G3
        ;;
    aarch64)
        BUILD_ID="308399262"
        EXPECTED_SHA256SUM=524d6ac5fd5acb6129b948b8409e057daac6cadb0a0433c8ace4de7b61c748a1
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
--keep HM_ATTR \
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
github:NixOS/nixpkgs/fd487183437963a59ba763c0cc4f27e3447dd6dd \
'github:PedroRegisPOAR/dotfiles' \
--dest "$HOME"/.config/nixpkgs

# home-manager switch --option download-buffer-size 671088640 --impure --flake "$HOME/.config/nixpkgs"#"$(id -un)"-"$(hostname)"
home-manager switch --option download-buffer-size 671088640  --impure --flake "$HOME/.config/nixpkgs"#$HM_ATTR
COMMANDS
```
Refs.:
- https://unix.stackexchange.com/a/654575
