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


