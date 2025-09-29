
```bash
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
```


Manda apenas "outputs" para o cache:
```bash
export NIXPKGS_ALLOW_UNFREE=1

nix path-info --impure --recursive /home/"$USER"/.config/nixpkgs#homeConfigurations.$(nix eval --impure --raw --expr 'builtins.currentSystem').'"'"$(id -un)-$(hostname)"'"'.activationPackage \
| wc -l 

nix path-info --impure --recursive /home/"$USER"/.config/nixpkgs#homeConfigurations.$(nix eval --impure --raw --expr 'builtins.currentSystem').'"'"$(id -un)-$(hostname)"'"'.activationPackage \
| xargs -I{} nix \
    copy \
    --max-jobs $(nproc) \
    -vvv \
    --no-check-sigs \
    {} \
    --to 's3://playing-bucket-nix-cache-test'
```


2) Criando um PAT, opcional, mas recomendado


Basta a permissão "read:packages" e caso deseje mudar tempo de expiração

:arrow_right: *Clique no link*: https://github.com/settings/tokens/new

<details>
  <summary> Detalhes sobre o github PAT (click aqui para expandir!)</summary>


Caso não se utilize github PAT seria necessário fazer o build local da imagem OCI do backend.
Com o intuito de poupar tempo, internete/ciclos de CPUs/memoria, é recomendado que seja 
feito o uso de github PAT para possibilitar que seja feito o download da imagem OCI 
construida pelo CI.

Refs.:
- https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token#creating-a-token
</details>

3) Comandos para salvar o PAT encodado

:arrow_right: Copie e cole no seu terminal e **edite os valores para os seus dados reais**:
```bash
GITHUB_PAT_TOKEN='ghp_' && GITHUB_USER_NAME='seuGithubUser'
```


4) Copie e cole no mesmo terminal do comando anterior
```bash
ENCODED_BASE64_GITHUB_TOKEN="$(echo ${GITHUB_USER_NAME}:${GITHUB_PAT_TOKEN} | base64 )"

test -d "${HOME}"/.config/containers || mkdir -p -v "${HOME}"/.config/containers

cat << EOF > "${HOME}"/.config/containers/auth.json
{
        "auths": {
                "ghcr.io": {
                        "auth": "${ENCODED_BASE64_GITHUB_TOKEN}"
                }
        }
}
EOF
```

<details>
  <summary> Troubleshooting (em caso de erro)</summary>

Checando os valores:
```bash
echo "$GITHUB_PAT_TOKEN"
echo "$GITHUB_USER_NAME"
```

Removendo o arquivo criado
```bash
rm -fv "${HOME}"/.config/containers/auth.json
```

</details>


### Extras: Como navegar entre commits no nixpkgs


Atualizando para a versão mais recente do nixpkgs existente:
```bash
nix \
flake \
update \
--override-input nixpkgs
```


```bash
nix flake metadata nixpkgs
```

```bash
nix flake metadata github:NixOS/nixpkgs/release-22.05
```


```bash
# nix flake metadata github:NixOS/nixpkgs/nixos-24.11
# 107d5ef05c0b1119749e381451389eded30fb0d5

# nix flake metadata github:nix-community/home-manager/release-24.11 --refresh
# nix flake metadata github:NixOS/nixpkgs/nixos-24.11 --refresh
# nix flake metadata github:numtide/flake-utils --refresh

nix \
flake \
lock \
--override-input nixpkgs 'github:NixOS/nixpkgs/cdd2ef009676ac92b715ff26630164bb88fec4e0' \
--override-input flake-utils 'github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b' \
--override-input home-manager 'github:nix-community/home-manager/f6af7280a3390e65c2ad8fd059cdc303426cbd59'
```


### Proxmox nix builder



No cliente:
```bash
ssh nixuser@localhost -p 27020
```

```bash
tee -a ~/.ssh/config <<EOF
Host proxmox
    HostName foo
    User nixuser
    Port 27020
    PubkeyAcceptedKeyTypes ssh-ed25519
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_ed25519
    LogLevel INFO    
EOF
```

```bash
nix build -L --system aarch64-linux nixpkgs#hello
```


```bash
nix \
build \
--builders-use-substitutes \
--eval-store auto \
--keep-failed \
--max-jobs 0 \
--no-link \
--print-build-logs \
--print-out-paths \
--store ssh-ng://ffooo \
--system aarch64-linux \
github:NixOS/nixpkgs/3954218cf613eba8e0dcefa9abe337d26bc48fd0#hello
```
Refs.:
- https://gist.github.com/danbst/09c3f6cd235ae11ccd03215d4542f7e7?permalink_comment_id=3140653#gistcomment-3140653




```bash
tee -a ~/.ssh/config <<EOF
Host proxmox
    HostName foo
    User nixuser
    Port 27020
    PubkeyAcceptedKeyTypes ssh-ed25519
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_ed25519
    LogLevel INFO
EOF
```
