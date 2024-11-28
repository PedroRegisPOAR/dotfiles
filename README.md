# dotfiles

Note: foi possível preservar todo o conteúdo do `/nix`.

1)
```bash
test -n "${USER+1}" || { echo 'The variable USER is not set!' && return }

rm -frv /home/"$USER"/.config/nixpkgs/

nix \
flake \
clone \
'git+ssh://git@github.com/PedroRegisPOAR/dotfiles' \
--dest /home/"$USER"/.config/nixpkgs \
&& time first-time-gphms
```
Refs.:
- https://unix.stackexchange.com/a/654575


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
