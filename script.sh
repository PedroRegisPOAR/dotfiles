!#/bin/sh

DETERMINATE_SYSTEMS="v3.1.1" \
&& NIX_VERSION="2.30.1" \
&& KERNEL=$(uname) \
&& case "$KERNEL" in \
  Darwin) KERNEL="darwin" ;; \
  Linux) KERNEL="linux" ;; \
  *) echo "Unsupported kernel: $KERNEL" && exit 1 ;; \
  esac \
&& ARCH=$(uname -m) \
&& case "$ARCH" in \
  x86_64) ARCH="x86_64-$KERNEL" ;; \
  arm64) ARCH="aarch64-$KERNEL" ;; \
  *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
  esac \
&& curl \
--proto '=https' \
--tlsv1.2 \
-sSf \
-L \
https://install.determinate.systems/nix/tag/"${DETERMINATE_SYSTEMS}" \
--output nix-installer \
&& chmod -v +x nix-installer \
&& ./nix-installer \
    install linux \
    --no-confirm \
    --logger pretty \
    --diagnostic-endpoint="" \
    --nix-package-url https://releases.nixos.org/nix/nix-"${NIX_VERSION}"/nix-"${NIX_VERSION}"-"${ARCH}".tar.xz \
&& . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
&& nix flake --version \
&& rm -v nix-installer \
&& sudo -i nix registry pin nixpkgs github:NixOS/nixpkgs/fd487183437963a59ba763c0cc4f27e3447dd6dd \
&& sudo -i nix run nixpkgs#nix-info -- --markdown \
&& sudo -i nix flake metadata nixpkgs \
&& sudo -i nix run nixpkgs#hello \
&& sudo -i nix profile install nixpkgs#hello \
&& hello \
&& sudo -i nix build --no-link --print-out-paths nixpkgs#pkgsStatic.hello
