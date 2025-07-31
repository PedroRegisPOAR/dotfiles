{ pkgs, nixpkgs, pkgsPy389, ... }:

{

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "ubuntu";
  # home.homeDirectory = "/home/ubuntu";

  home.packages = with pkgs; [
    # Graphical packages
    # anydesk
    # blender
    # brave
    # discord
    # frida-tools
    # ghidra
    # gimp
    # ida-free
    # inkscape
    # insomnia
    # jadx
    # kwave # TODO: it opens but when saving the audio file it errors
    # libreoffice
    # obsidian
    # rustdesk
    # spotify
    # tdesktop
    # virt-manager
    # vscodium

    dbeaver-bin
    gitkraken
    google-chrome
    jetbrains.pycharm-community
    kdePackages.kolourpaint
    kdePackages.okular
    keepassxc
    peek
    postman
    qbittorrent
    redisinsight
    vlc

    # slack
    # (slack.overrideAttrs (old: {
    # installPhase = old.installPhase + ''
    #   rm $out/bin/slack
    #
    #   makeWrapper $out/lib/slack/slack $out/bin/slack \
    #     --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
    #     --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
    #     --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
    # '';
    # }))
    # xdg-desktop-portal-wlr
    # xdg-desktop-portal-gtk

    xorg.xclock
    xclip
    xsel
    # vncdo

    yt-dlp # yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --restrict-filenames --no-playlist --output "%(title)s.%(ext)s" https://www.youtube.com/watch\?v\=ID

    # sudo $(which lshw) -C display
    # sudo dmesg | grep drm
    # glxgears -info
    # lspci | grep -i vga
    # mesa
    # mesa-demos
    # libglvnd # find / -name 'libGL.so' 2>/dev/null
    # vulkan-loader
    # vulkan-headers
    # mesa_drivers
    # linuxPackages.nvidia_x11
    # cudatoolkit
    # cudatoolkit.lib
    # mpi

    # https://github.com/NixOS/nixpkgs/issues/13134#issuecomment-347643564
    # xdg_utils
    xdg-utils
    shared-mime-info

    # steam-run

    xorg.xclock
    # hello
    sl
    asciiquarium
    figlet
    cowsay
    ponysay
    pfetch
    cmatrix

    # TODO: It can "work" by chance if nix is instaled in an imperative way.
    # Just enabling it is not adding it to "$HOME"/.nix-profile/bin
    # it must exists in  ls -alh "$HOME"/.nix-profile/bin pointing to
    # /nix/store/*-home-manager-path/bin/nix
    nix
    # nixVersions.nix_2_28

    # pciutils # lspci and others
    # coreboot-utils

    # # TODO: testar com o zsh
    ## bashInteractive # https://www.reddit.com/r/NixOS/comments/zx4kmh/alpinewsl_home_manager_bash_issue/
    awscli
    coreutils
    binutils
    utillinux
    xorg.xkill
    glibc.bin
    patchelf
    chrpath
    gparted
    glxinfo
    file
    findutils
    gnugrep
    gnumake
    gnused
    gawk
    hexdump
    which
    xz
    exfat
    procps
    curl
    wget
    lsof
    tree
    killall
    nmap
    netcat
    nettools
    libcgroup
    ripgrep
    tmate
    sqlite
    strace
    ltrace
    # ptrace
    traceroute
    man
    man-db
    # typos # TODO: test it
    (aspellWithDicts (d: with d; [ de en pt_BR ])) # nix repl --expr 'import <nixpkgs> {}' <<<'builtins.attrNames aspellDicts' | tr ' ' '\n'
    simple-scan
    imagemagick
    nix-prefetch-git
    nixfmt-rfc-style # nixfmt
    hydra-check
    nixos-option
    shellcheck
    # qemu
    # qemu-img
    xdotool
    # spice-gtk
    # virt-viewer
    # tts
    # wkhtmltopdf
    # ngrok # mirror problem    
    mypy

    nodejs
    nodePackages."@angular/cli"
    yarn
    bun

    # Legacy python 3.8.9 and pipenv
    pkgsPy389.python3
    pkgsPy389.pipenv
    pkgsPy389.stdenv.cc.cc.lib

    uv

    # microsoft-edge

    # 
    # audio-recorder
    # audacity
    # tenacity # ?

    fontconfig
    # fontforge-gtk # TODO: testar fontes usando esse programa
    # pango

    # arphic-ukai
    # arphic-uming
    # google-fonts
    # hack-font
    # ionicons
    # lineicons
    # mplus-outline-fonts
    # proggyfonts
    # roboto
    # source-sans-pro
    # (nerdfonts.override {fonts = ["Iosevka"];})
    # (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    # (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })

    # anonymousPro
    # aurulent-sans
    # # babelstone-han
    # unicode-emoji
    # icu76
    # unifont_upper
    # cm_unicode
    # hannom
    # clearlyU
    # # unifont
    # unidings
    # mro-unicode
    # ttf-indic
    # gyre-fonts
    # # assyrian # mirror problem
    # joypixels
    # julia-mono
    # emojione
    # noto-fonts-monochrome-emoji
    # # whatsapp-emoji-font
    # xmoji
    # ultimate-oldschool-pc-font-pack
    # openttd-ttf
    # arkpandora_ttf # Font, metrically identical to Arial and Times New Roman
    # bakoma_ttf
    # stix-otf

    # agave
    # meslo-lgs-nf
    # ttf_bitstream_vera
    # dosemu_fonts
    # sarasa-gothic
    # scientifica
    # victor-mono
    # comfortaa

    # stix-two
    # oldstandard
    # fantasque-sans-mono
    # monoid
    # # siji
    # mononoki
    # cm_unicode
    # bakoma_ttf
    # lmmath
    # # etBook
    # # eb-garamond
    # # tamsyn
    # recursive
    # # material-design-icons
    # # material-icons
    # inter
    # atkinson-hyperlegible
    # maple-mono
    # maple-mono.NF # maple-mono-NF
    # cozette
    # meslo-lg
    # meslo-lgs-nf
    # awesome
    # noto-fonts-monochrome-emoji
    # sketchybar-app-font
    # iosevka
    # iosevka-comfy.comfy
    # iosevka-comfy.comfy-wide
    # iosevka-comfy.comfy-motion
    # iosevka-comfy.comfy-wide-motion
    # monaspace
    # # roboto-slab

    # # sf-symbols
    # # sf-mono-liga

    # # line-awesome
    # # open-sans
    # # rubik
    # # lato
    # # spleen

    # cascadia-code

    # xorg.fontbitstream100dpi
    # xorg.fontbitstream75dpi
    # xorg.fontbitstreamtype1

    # cantarell-fonts
    # comic-relief
    # corefonts
    # dejavu_fonts
    # dina-font
    # dosemu_fonts
    # emacs-all-the-icons-fonts
    # emacsPackages.unicode-fonts
    # fira
    # fira-code
    # fira-code-nerdfont
    # fira-code-symbols
    # fira-mono
    # font-awesome
    # font-awesome_4
    # font-awesome_5
    # freefont_ttf
    # gentium
    # gyre-fonts
    # hasklig
    # helvetica-neue-lt-std
    # ibm-plex
    # inconsolata
    # inconsolata-nerdfont
    # iosevka
    # ipaexfont
    # ipafont
    # jetbrains-mono
    # lato
    # liberation_ttf
    # libertine
    # libre-caslon
    # material-design-icons
    # material-icons
    # montserrat
    # mplus-outline-fonts.githubRelease
    # nerdfonts
    # noto-fonts
    # noto-fonts-cjk-sans
    # noto-fonts-color-emoji
    # noto-fonts-emoji
    # noto-fonts-extra
    # noto-fonts-lgc-plus
    # open-fonts
    # openmoji-color
    # openmoji-black
    # oxygenfonts
    # powerline
    # powerline-fonts
    # redhat-official-fonts
    # roboto-mono
    # roboto-slab
    # source-code-pro
    # source-han-mono
    # source-han-sans
    # source-han-serif
    # source-han-sans-japanese
    # source-han-sans-korean
    # source-han-sans-simplified-chinese
    # source-han-sans-traditional-chinese
    # source-sans
    # stix-two
    # sudo-font
    # symbola
    # terminus-nerdfont
    # textfonts
    # twemoji-color-font
    # twitter-color-emoji
    # ubuntu_font_family
    # ultimate-oldschool-pc-font-pack
    # vistafonts
    # wqy_microhei
    # wqy_zenhei
    # xkcd-font

    # # Persian Font
    # vazir-fonts
    # shabnam-fonts
    # vazir-code-font

    # julia-mono
    # fc-cache -rfv && hms && hms && gnome-terminal --zoom=2 --tab -- "$SHELL" -c "cd ~/.config/nixpkgs; exec $SHELL"
    nerd-fonts.fira-code
    meslo-lgs-nf

    # New sorted
    #
    # dina-font
    # efont-unicode
    # envypn-font
    # gohufont
    # google-fonts
    # hack-font
    # profont
    # proggyfonts
    # roboto
    # roboto-mono
    # roboto-slab
    # siji
    # spleen
    # tamsyn
    # tamzen
    # ucs-fonts

    #
    # agave
    # aileron
    # anonymousPro
    # ark-pixel-font
    # arkpandora_ttf # Font, metrically identical to Arial and Times New Roman
    # atkinson-hyperlegible
    # aurulent-sans
    # awesome
    # bakoma_ttf
    # bqn386
    # camingo-code
    # cantarell-fonts
    # cascadia-code
    # clearlyU
    # cm_unicode
    # comfortaa
    # comic-relief
    # corefonts
    # cozette
    # dejavu_fonts
    # dosemu_fonts
    # emacs-all-the-icons-fonts
    # emacsPackages.unicode-fonts
    # emojione
    # fantasque-sans-mono
    ########
    # fira
    # fira-code
    # fira-code-symbols
    # fira-mono
    # font-awesome
    # font-awesome_4
    # font-awesome_5
    # freefont_ttf
    # gentium
    # go-font
    # gyre-fonts
    # hackgen-font
    # hackgen-nf-font
    # hannom
    # hasklig
    # helvetica-neue-lt-std
    # hermit
    # ibm-plex
    # icu76
    # inter
    # iosevka
    # iosevka-comfy.comfy
    # iosevka-comfy.comfy-motion
    # iosevka-comfy.comfy-wide
    # iosevka-comfy.comfy-wide-motion
    # ipaexfont
    # ipafont
    # jetbrains-mono
    # joypixels
    # julia-mono
    # last-resort
    # lato
    # liberation_ttf
    # libertine
    # libre-caslon
    # lmmath
    # lmodern
    # maple-mono.NF
    # maple-mono.NF-CN # Old named as: maple-mono-SC-NF
    # maple-mono.NormalNL-TTF-AutoHint # This maple-mono font package have 44 fonts
    # material-design-icons
    # material-icons
    # meslo-lg
    # meslo-lgs-nf
    # monaspace
    # monoid
    # mononoki
    # montserrat
    # mplus-outline-fonts.githubRelease
    # mro-unicode
    # nerd-fonts.fira-code # Old named as fira-code-nerdfont
    # nerd-fonts.inconsolata # Old named as inconsolata
    # nerd-fonts.terminess-ttf # Old named as terminus-nerdfont
    # noto-fonts
    # noto-fonts-cjk-sans
    # noto-fonts-cjk-serif
    # noto-fonts-color-emoji
    # noto-fonts-emoji
    # noto-fonts-extra
    # noto-fonts-lgc-plus
    # noto-fonts-monochrome-emoji
    # oldstandard
    # open-fonts
    # openmoji-color
    # openttd-ttf
    # oxygenfonts
    # paratype-pt-sans
    # powerline
    # powerline-fonts
    # recursive
    # redhat-official-fonts
    # rounded-mgenplus
    # sarasa-gothic
    # scientifica
    # shabnam-fonts
    # sketchybar-app-font
    # source-code-pro
    # source-han-mono
    # source-han-sans
    # source-han-sans-japanese
    # source-han-sans-korean
    # source-han-sans-simplified-chinese
    # source-han-sans-traditional-chinese
    # source-han-sans-vf-ttf
    # source-han-serif
    # source-han-serif-vf-ttf
    # source-sans
    # stix-otf
    # stix-two
    # sudo-font
    # # symbola
    # terminus_font
    # terminus_font_ttf
    # textfonts
    # ttf_bitstream_vera
    # ttf-indic
    # twemoji-color-font
    # twitter-color-emoji
    # ubuntu_font_family
    # udev-gothic
    # udev-gothic-nf
    # uiua386
    # ultimate-oldschool-pc-font-pack
    # undefined-medium
    # unicode-emoji
    # unidings
    # unifont_upper
    # unscii
    # uw-ttyp0
    # vazir-code-font
    # vazir-fonts
    # victor-mono
    # vistafonts
    # vistafonts-chs
    # wqy_microhei
    # wqy_zenhei
    # xkcd-font
    # xmoji
    # xorg.fontbitstream100dpi
    # xorg.fontbitstream75dpi
    # xorg.fontbitstreamtype1
    # xorg.xbitmaps
    # zpix-pixel-font

    # TODO: how to test it?
    # zsh-nix-shell
    # zsh-powerlevel10k
    # zsh-powerlevel9k
    # zsh-syntax-highlighting

    oh-my-zsh
    # zsh-completions-latest

    gcc
    # gdb
    # clang
    # rustc
    # python3Full
    # julia-bin

    graphviz # dot command comes from here
    jq
    unixtools.xxd

    gzip
    # unrar
    unzip
    gnutar

    btop
    htop
    asciinema
    git
    openssh
    # sshfs # TODO: testar

    # docker
    # podman
    # runc
    # skopeo
    # conmon
    # slirp4netns
    # shadow

    (
      writeScriptBin "ix" ''
        #! ${pkgs.runtimeShell} -e
          "$@" | "curl" -F 'f:1=<-' ix.io
      ''
    )

    (
      writeScriptBin "fix-kvm" ''
        #! ${pkgs.runtimeShell} -e

           echo "Start kvm stuff..." \
           && (getent group kvm || sudo groupadd kvm) \
           && sudo usermod --append --groups kvm "$USER" \
           && echo "End kvm stuff!"

           # sudo chown -v "$(id -u)":"$(id -g)" /dev/kvm
      ''
    )

    (
      writeScriptBin "erw" ''
        #! ${pkgs.runtimeShell} -e
        echo "$(readlink -f "$(which $1)")"
      ''
    )

    (
      writeScriptBin "frw" ''
        #! ${pkgs.runtimeShell} -e
        file "$(readlink -f "$(which $1)")"
      ''
    )

    (
      writeScriptBin "crw" ''
        #! ${pkgs.runtimeShell} -e
        cat "$(readlink -f "$(which $1)")"
      ''
    )

    (
      writeScriptBin "gacp" ''
        #! ${pkgs.runtimeShell} -e
        git status .
        git add . && git commit -m "$1" && git push
      ''
    )


    (
      writeScriptBin "gp" ''
        #! ${pkgs.runtimeShell} -e
        git pull
      ''
    )

    (
      writeScriptBin "myexternalip" ''
        #! ${pkgs.runtimeShell} -e
        # https://askubuntu.com/questions/95910/command-for-determining-my-public-ip#comment1985064_712144

        curl https://checkip.amazonaws.com
      ''
    )

    (
      writeScriptBin "mynatip" ''
        #! ${pkgs.runtimeShell} -e
           # https://unix.stackexchange.com/a/569306
           # https://serverfault.com/a/256506

           NETWORK_INTERFACE_NAME=$(route | awk '
                   BEGIN           { min = -1 }
                   $1 == "default" {
                                       if (min < 0  ||  $5 < min) {
                                           min   = $5
                                           iface = $8
                                       }
                                   }
                   END             {
                                       if (iface == "") {
                                           print "No \"default\" route found!" > "/dev/stderr"
                                           exit 1
                                       } else {
                                           print iface
                                           exit 0
                                       }
                                   }
                   '
           )

           ip addr show dev $NETWORK_INTERFACE_NAME | grep "inet " | awk '{ print $2 }' | cut -d'/' -f1
      ''
    )

    (
      writeScriptBin "generate-new-ed25519-key-pair" ''
        #! ${pkgs.runtimeShell} -e

        ssh-keygen \
        -t ed25519 \
        -C "$(git config user.email)" \
        -f "$HOME"/.ssh/id_ed25519 \
        -N "" \
        && echo \
        && cat "$HOME"/.ssh/id_ed25519.pub \
        && echo
      ''
    )

    (
      writeScriptBin "nfmn" ''
        #! ${pkgs.runtimeShell} -e
        nix flake metadata nixpkgs
      ''
    )

    (
      writeScriptBin "nfm" ''
        #! ${pkgs.runtimeShell} -e
        nix flake metadata $1
      ''
    )

    (
      writeScriptBin "nfs" ''
        #! ${pkgs.runtimeShell} -e
        nix flake show $1
      ''
    )

    (
      writeScriptBin "nfmn-j" ''
        #! ${pkgs.runtimeShell} -e
        nix flake metadata nixpkgs --json | jq -r '.url'
      ''
    )

    (
      writeScriptBin "nfm-j" ''
        #! ${pkgs.runtimeShell} -e
        nix flake metadata $1 --json | jq -r '.url'
      ''
    )

    (
      writeScriptBin "build-pulling-all-from-cache" ''
        #! ${pkgs.runtimeShell} -e

           set -x

           export NIXPKGS_ALLOW_UNFREE=1

           nix \
           --option eval-cache false \
           --option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
           --option extra-substituters https://playing-bucket-nix-cache-test.s3.amazonaws.com \
           build \
           --impure \
           --keep-failed \
           --max-jobs 0 \
           --no-link \
           --print-build-logs \
           --print-out-paths \
           ~/.config/nixpkgs#homeConfigurations."$(id -un)"-"$(hostname)".activationPackage
      ''
    )

    (
      writeScriptBin "build-in-local-remote-builder" ''
        #! ${pkgs.runtimeShell} -e

           set -x

           export NIXPKGS_ALLOW_UNFREE=1

           nix \
           build \
           --impure \
           --eval-store auto \
           --keep-failed \
           --max-jobs 0 \
           --no-link \
           --print-build-logs \
           --print-out-paths \
           --store ssh-ng://builder \
           --substituters "" \
           ~/.config/nixpkgs#homeConfigurations."$(id -un)"-"$(hostname)".activationPackage
      ''
    )

    (
      writeScriptBin "hms" ''
        #! ${pkgs.runtimeShell} -e

        export NIXPKGS_ALLOW_UNFREE=1;

        home-manager switch --impure --flake "$HOME/.config/nixpkgs"#"$(id -un)"-"$(hostname)"
      ''
    )

    (
      writeScriptBin "gphms" ''
        #! ${pkgs.runtimeShell} -e

        echo $(cd "$HOME/.config/nixpkgs" && git pull) \
        && export NIXPKGS_ALLOW_UNFREE=1; \
        home-manager switch --impure --flake "$HOME/.config/nixpkgs"#"$(id -un)"-"$(hostname)"
      ''
    )

    (
      writeScriptBin "gphms-cache" ''
        #! ${pkgs.runtimeShell} -e

        build-pulling-all-from-cache

        echo $(cd "$HOME/.config/nixpkgs" && git pull) \
        && export NIXPKGS_ALLOW_UNFREE=1; \
        home-manager switch --impure --flake "$HOME/.config/nixpkgs"#"$(id -un)"-"$(hostname)"
      ''
    )

    (
      writeScriptBin "nr" ''
        #! ${pkgs.runtimeShell} -e

        nix repl --expr 'import <nixpkgs> {}'
      ''
    )

    (
      writeScriptBin "copy-rsa-keys" ''
        #! ${pkgs.runtimeShell} -e

        echo 'This script copies the pair of keys id_rsa and id_rsa.pub. Hit enter to continue!' \
        && read \
        && xclip -selection clipboard -in < ~/.ssh/id_rsa.pub \
        && echo 'Copied the public key ~/.ssh/id_rsa.pub' \
        && read \
        && xclip -selection clipboard -in < ~/.ssh/id_rsa \
        && echo 'Copied the private key ~/.ssh/id_rsa'
      ''
    )

    (
      writeScriptBin "fix-ubuntu" ''
        #! ${pkgs.runtimeShell} -e

        gsettings range org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type

        sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

        systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target


        gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
        gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
      ''
    )

  ];

  # xdg.enable=true;
  # xdg.mime.enable=true;

  # https://github.com/nix-community/home-manager/blob/782cb855b2f23c485011a196c593e2d7e4fce746/modules/targets/generic-linux.nix
  targets.genericLinux.enable = true;

  nix = {
    enable = true;
    # What about github:NixOS/nix#nix-static can it be injected here? What would break?
    # package = pkgs.pkgsStatic.nixVersions.nix_2_10;
    package = pkgs.nix;
    # Could be useful:
    # export NIX_CONFIG='extra-experimental-features = nix-command flakes'
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    registry.nixpkgs.flake = nixpkgs;

    settings = {
      # use-sandbox = true;
      show-trace = false;
      # system-features = [ "big-parallel" "kvm" "recursive-nix" "nixos-test" ];

      # nix-path = "nixpkgs=flake:nixpkgs";

      keep-derivations = true;
      keep-env-derivations = true;
      keep-failed = true;
      keep-going = true;
      keep-outputs = true;

      # bash-prompt = "(ZZZ)\040";
      # bash-prompt-suffix = "WWW";
      bash-prompt-prefix = "(nix-d3v3l0p:$name)\\040"; # TODO: why double \\? https://crates.io/crates/nix-installer/0.15.1

      tarball-ttl = 60 * 60 * 24 * 7 * 4; # = 2419200 = one month
      # readOnlyStore = true;

      # trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
      # trusted-substituters = "fooooo";
      cores = 4;
    };
  };

  nixpkgs.config = {
    allowBroken = false;
    allowUnfree = true;
    # TODO: test it
    # android_sdk.accept_license = true;

    allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
      "discord"
      "gitkraken"
      "google-chrome"
      "joypixels"
      "slack"
      "vscode"
    ];
    joypixels.acceptLicense = true;
  };

  services.systembus-notify.enable = true;
  services.spotifyd.enable = true;

  fonts = {
    # enableFontDir = true;
    # enableGhostscriptFonts = true;
    # fonts = with pkgs; [
    #   powerline-fonts
    # ];
    fontconfig = {
      enable = true;

      # defaultFonts = {
      #   serif = ["IPAexMincho" "Noto Serif CJK JP" "Noto Serif"];
      #   sansSerif = ["IPAexGothic" "Noto Sans CJK JP" "Noto Sans"];
      #   monospace = ["JetBrains Mono"];
      #   emoji = ["Noto Color Emoji"];
      # }; 

      # defaultFonts = {
      #     monospace = [ "Droid Sans Mono Slashed for Powerline" ];
      # };
    };
  };

  programs.bash = {
    enable = false;
    # bashrcExtra = "echo foo-bar";
    sessionVariables = {
      A_B_C = "a-b-c";
      # FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
      # FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts/";
    };
  };

  # TODO: documentar e testar
  home.extraOutputsToInstall = [
    "/share/zsh"
    "/share/bash"
    "/share/fish"
    "/share/fonts" # fc-cache -frv
    # /etc/fonts
  ];


  # qt.enable = true;
  # qt.platformTheme = "gtk";
  # qt.style.name = "adwaita-dark";
  # qt.style.package = pkgs.adwaita-qt;

  ## https://github.com/jonringer/nixpkgs-config/blob/fe043e6237774f703589ce4734391502b83ff9fd/home.nix#L67
  #  programs.ssh = {
  #    enable = true;
  #    forwardAgent = true;
  #    extraConfig = ''
  #      Include ~/.ssh/config.d/*
  #
  #      Host builder
  #          HostName localhost
  #          User nixuser
  #          Port 2221
  #          PubkeyAcceptedKeyTypes ssh-ed25519
  #          IdentitiesOnly yes
  #          IdentityFile ~/.ssh/id_ed25519
  #          LogLevel INFO
  #
  #      Host proxmox-nested-nixos-builder
  #          User nixuser
  #          HostName localhost
  #          Port 2221
  #          PubkeyAcceptedKeyTypes ssh-ed25519
  #          IdentitiesOnly yes
  #          IdentityFile ~/.ssh/id_ed25519
  #          StrictHostKeyChecking=no
  #          StrictHostKeyChecking=accept-new
  #          LogLevel INFO
  #          ProxyJump proxmox-nixos
  #
  #      Host *
  #        ForwardAgent yes
  #        GSSAPIAuthentication no
  #      '';
  #  };

  # home.language.base = "en-US.UTF-8";

  # https://www.reddit.com/r/NixOS/comments/fenb4u/zsh_with_ohmyzsh_with_powerlevel10k_in_nix/
  programs.zsh = {
    # Your zsh config
    enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    # enableAutosuggestions = true;
    autosuggestion.enable = true;
    # enableSyntaxHighlighting = true;
    syntaxHighlighting.enable = true;
    envExtra = ''
      if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
        . ~/.nix-profile/etc/profile.d/nix.sh
      fi
    '';

    # initContent = "neofetch --ascii_distro NixOS_small --color_blocks off --disable cpu gpu memory term de resolution kernel model";
    initContent = "${pkgs.neofetch}/bin/neofetch"; # TODO: checar se esse pacote é seguro

    # promptInit = ''
    #   export POWERLEVEL9K_MODE=nerdfont-complete
    #   source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme
    # '';

    # initExtraBeforeCompInit = ''eval "$(direnv hook zsh)"'';
    autocd = true;


    shellAliases = {
      l = "ls -al";

      #
      nb = "nix build";
      npi = "nix profile install nixpkgs#";
      ns = "nix shell";
      # nr = "nix repl --expr 'import <nixpkgs> {}'";

      rmall = "rm -frv {*,.*}";
    };

    # > closed and reopened the terminal. Then it worked.
    # https://discourse.nixos.org/t/home-manager-doesnt-seem-to-recognize-sessionvariables/8488/8
    sessionVariables = {
      # EDITOR = "nvim";
      # DEFAULT_USER = "foo-bar";
      # ZSH_AUTOSUGGEST_USE_ASYNC="true";
      # ZSH_AUTOSUGGEST_MANUAL_REBIND="true";
      # PROMPT="|%F{153}%n@%m%f|%F{174}%1~%f> ";

      # LANG = "en_US.utf8";
      # fc-match list
      FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
      FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts/";
    };

    historySubstringSearch.enable = true;

    history = {
      save = 50000;
      size = 50000;
      path = "$HOME/.cache/zsh_history";
      expireDuplicatesFirst = true;
    };

    oh-my-zsh = {
      enable = true;
      # https://github.com/Xychic/NixOSConfig/blob/76b638086dfcde981292831106a43022588dc670/home/home-manager.nix
      plugins = [
        # "autojump"
        ""
        # "cargo"
        "catimg"
        "colored-man-pages"
        "colorize"
        "command-not-found"
        "common-aliases"
        "copyfile"
        "copypath"
        "cp"
        "direnv"
        "docker"
        "docker-compose"
        "emacs"
        "encode64"
        "extract"
        "fancy-ctrl-z"
        "fzf"
        "gcloud"
        "git"
        "git-extras"
        "git-flow-avh"
        "github"
        "gitignore"
        "gradle"
        "history"
        "history-substring-search"
        "kubectl"
        "man"
        "mvn"
        "node"
        "npm"
        "pass"
        "pip"
        "poetry"
        "python"
        # "ripgrep"
        "rsync"
        "rust"
        "scala"
        "ssh-agent"
        "sudo"
        "systemadmin" # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemadmin
        "systemd"
        "terraform"
        # "thefuck"
        "tig"
        "timer"
        # "tmux" # It needs tmux to be installed
        "vagrant"
        "vi-mode"
        "vim-interaction"
        "yarn"
        "z"
        "zsh-navigation-tools"
      ];
      theme = "robbyrussell";
      # theme = "bira";
      # theme = "powerlevel10k";
      # theme = "powerlevel9k/powerlevel9k";
      # theme = "agnoster";
      # theme = "gallois";
      # theme = "gentoo";
      # theme = "af-magic";
      # theme = "half-life";
      # theme = "rgm";
      # theme = "crcandy";
      # theme = "fishy";
    };
  };

  #  programs.starship = {
  #    enable = true;
  #    enableZshIntegration = true;
  #  };

  # Credits:
  # https://gist.github.com/s-a-c/0e44dc7766922308924812d4c019b109
  # https://gist.github.com/search?q=So+either+put+%22Important+Documents%22+before+%22Documents%22+or+use+the+substituted+version%3A%3B&ref=searchresults
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # "$schema" = "https://starship.rs/config-schema.json";
      add_newline = true;
      command_timeout = 500;
      continuation_prompt = "[∙](bright-black) ";
      # format = "[](0x9A348E)$username$hostname$localip$shlvl$singularity$kubernetes[](fg:0x9A348E bg:0xDA627D)$directory$vcsh[](fg:0xDA627D bg:0xFCA17D)$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch[](fg:0x86BBD8 bg:0x06969A)$docker_context$package$buf[](fg:0xFCA17D bg:0x86BBD8)$c$cmake$cobol$container$daml$dart$deno$dotnet$elixir$elm$erlang$golang$haskell$helm$java$julia$kotlin$lua$nim$nodejs$ocaml$perl$php$pulumi$purescript$python$rlang$red$ruby$rust$scala$swift$terraform$vlang$vagrant$zig$nix_shell$conda$spack$memory_usage$aws$gcloud$openstack$azure$env_var$crystal$custom$sudo$cmd_duration$line_break$jobs$battery[](fg:0x06969A bg:0x33658A)$time$status$shell$character";
      right_format = "";
      scan_timeout = 30;
      # aws = {
      #  format = "[$symbol($profile )(($region) )([$duration] )]($style)";
      #  symbol = "🅰 ";
      #  style = "bold yellow";
      #  disabled = false;
      #  expiration_symbol = "X";
      #  force_display = false;
      #};
      aws.region_aliases = { };
      aws.profile_aliases = { };
      azure = {
        format = "[$symbol($subscription)([$duration])]($style) ";
        symbol = "ﴃ ";
        style = "blue bold";
        disabled = true;
      };
      battery = {
        format = "[$symbol$percentage]($style) ";
        charging_symbol = " ";
        discharging_symbol = " ";
        empty_symbol = " ";
        full_symbol = " ";
        unknown_symbol = " ";
        disabled = false;
        display = [
          {
            style = "red bold";
            threshold = 35;
          }
          {
            "style" = "italic dimmed bright-purple";
            "threshold" = 50;
          }
          {
            "style" = "italic dimmed yellow";
            "threshold" = 70;
          }
        ];
      };
      buf = {
        format = "[$symbol ($version)]($style)";
        version_format = "v$raw";
        symbol = "";
        style = "bold blue";
        disabled = false;
        detect_extensions = [ ];
        detect_files = [
          "buf.yaml"
          "buf.gen.yaml"
          "buf.work.yaml"
        ];
        detect_folders = [ ];
      };
      c = {
        format = "[$symbol($version(-$name) )]($style)";
        version_format = "v$raw";
        style = "fg:149 bold bg:0x86BBD8";
        symbol = " ";
        disabled = false;
        detect_extensions = [
          "c"
          "h"
        ];
        detect_files = [ ];
        detect_folders = [ ];
        #          commands = [
        #            [
        #            "cc"
        #            "--version"
        #            ]
        #            [
        #            "gcc"
        #            "--version"
        #            ]
        #            [
        #            "clang"
        #            "--version"
        #            ]
        #          ];
      };
      character = {
        format = "$symbol ";
        vicmd_symbol = "[❮](bold green)";
        disabled = false;
        success_symbol = "[➜](bold green) ";
        error_symbol = "[✗](bold red) ";
      };
      cmake = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "△ ";
        style = "bold blue";
        disabled = false;
        detect_extensions = [ ];
        detect_files = [
          "CMakeLists.txt"
          "CMakeCache.txt"
        ];
        detect_folders = [ ];
      };
      cmd_duration = {
        min_time = 2000;
        format = "⏱ [$duration]($style) ";
        style = "yellow bold";
        show_milliseconds = false;
        disabled = false;
        show_notifications = false;
        min_time_to_notify = 45000;
      };
      cobol = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "⚙️ ";
        style = "bold blue";
        disabled = false;
        detect_extensions = [
          "cbl"
          "cob"
          "CBL"
          "COB"
        ];
        detect_files = [ ];
        detect_folders = [ ];
      };
      conda = {
        truncation_length = 1;
        format = "[$symbol$environment]($style) ";
        symbol = " ";
        style = "green bold";
        ignore_base = true;
        disabled = false;
      };
      container = {
        format = "[$symbol [$name]]($style) ";
        symbol = "⬢";
        style = "red bold dimmed";
        disabled = false;
      };
      crystal = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🔮 ";
        style = "bold red";
        disabled = false;
        detect_extensions = [ "cr" ];
        detect_files = [ "shard.yml" ];
        detect_folders = [ ];
      };
      dart = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🎯 ";
        style = "bold blue";
        disabled = false;
        detect_extensions = [ "dart" ];
        detect_files = [
          "pubspec.yaml"
          "pubspec.yml"
          "pubspec.lock"
        ];
        detect_folders = [ ".dart_tool" ];
      };
      deno = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🦕 ";
        style = "green bold";
        disabled = false;
        detect_extensions = [ ];
        detect_files = [
          "deno.json"
          "deno.jsonc"
          "mod.ts"
          "deps.ts"
          "mod.js"
          "deps.js"
        ];
        detect_folders = [ ];
      };
      directory = {
        disabled = false;
        fish_style_pwd_dir_length = 0;
        format = "[$path]($style)[$read_only]($read_only_style) ";
        home_symbol = "~";
        read_only = " ";
        read_only_style = "red";
        repo_root_format = "[$before_root_path]($style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
        style = "cyan bold bg:0xDA627D";
        truncate_to_repo = true;
        truncation_length = 3;
        truncation_symbol = "…/";
        use_logical_path = true;
        use_os_path_sep = true;
      };
      directory.substitutions = {
        # Here is how you can shorten some long paths by text replacement;
        # similar to mapped_locations in Oh My Posh:;
        "Documents" = " ";
        "Downloads" = " ";
        "Music" = " ";
        "Pictures" = " ";
        # Keep in mind that the order matters. For example:;
        # "Important Documents" = "  ";
        # will not be replaced, because "Documents" was already substituted before.;
        # So either put "Important Documents" before "Documents" or use the substituted version:;
        # "Important  " = "  ";
        "Important " = " ";
      };
      docker_context = {
        format = "[$symbol$context]($style) ";
        style = "blue bold bg:0x06969A";
        symbol = " ";
        only_with_files = true;
        disabled = false;
        detect_extensions = [ ];
        detect_files = [
          "docker-compose.yml"
          "docker-compose.yaml"
          "Dockerfile"
        ];
        detect_folders = [ ];
      };
      dotnet = {
        format = "[$symbol($version )(🎯 $tfm )]($style)";
        version_format = "v$raw";
        symbol = "🥅 ";
        style = "blue bold";
        heuristic = true;
        disabled = false;
        detect_extensions = [
          "csproj"
          "fsproj"
          "xproj"
        ];
        detect_files = [
          "global.json"
          "project.json"
          "Directory.Build.props"
          "Directory.Build.targets"
          "Packages.props"
        ];
        detect_folders = [ ];
      };
      elixir = {
        format = "[$symbol($version (OTP $otp_version) )]($style)";
        version_format = "v$raw";
        style = "bold purple bg:0x86BBD8";
        symbol = " ";
        disabled = false;
        detect_extensions = [ ];
        detect_files = [ "mix.exs" ];
        detect_folders = [ ];
      };
      elm = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        style = "cyan bold bg:0x86BBD8";
        symbol = " ";
        disabled = false;
        detect_extensions = [ "elm" ];
        detect_files = [
          "elm.json"
          "elm-package.json"
          ".elm-version"
        ];
        detect_folders = [ "elm-stuff" ];
      };
      env_var = { };
      env_var.SHELL = {
        format = "[$symbol($env_value )]($style)";
        style = "grey bold italic dimmed";
        symbol = "e:";
        disabled = true;
        variable = "SHELL";
        default = "unknown shell";
      };
      env_var.USER = {
        format = "[$symbol($env_value )]($style)";
        style = "grey bold italic dimmed";
        symbol = "e:";
        disabled = true;
        default = "unknown user";
      };
      erlang = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = " ";
        style = "bold red";
        disabled = false;
        detect_extensions = [ ];
        detect_files = [
          "rebar.config"
          "erlang.mk"
        ];
        detect_folders = [ ];
      };
      fill = {
        style = "bold black";
        symbol = ".";
        disabled = false;
      };
      gcloud = {
        format = "[$symbol$account(@$domain)(($region))(($project))]($style) ";
        symbol = "☁️ ";
        style = "bold blue";
        disabled = false;
      };
      gcloud.project_aliases = { };
      gcloud.region_aliases = { };
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        symbol = " ";
        style = "bold purple bg:0xFCA17D";
        truncation_length = 9223372036854775807;
        truncation_symbol = "…";
        only_attached = false;
        always_show_remote = false;
        ignore_branches = [ ];
        disabled = false;
      };
      git_commit = {
        commit_hash_length = 7;
        format = "[($hash$tag)]($style) ";
        style = "green bold";
        only_detached = true;
        disabled = false;
        tag_symbol = " 🏷  ";
        tag_disabled = true;
      };
      git_metrics = {
        added_style = "bold green";
        deleted_style = "bold red";
        only_nonzero_diffs = true;
        format = "([+$added]($added_style) )([-$deleted]($deleted_style) )";
        disabled = false;
      };
      git_state = {
        am = "AM";
        am_or_rebase = "AM/REBASE";
        bisect = "BISECTING";
        cherry_pick = "🍒PICKING(bold red)";
        disabled = false;
        format = "([$state( $progress_current/$progress_total)]($style)) ";
        merge = "MERGING";
        rebase = "REBASING";
        revert = "REVERTING";
        style = "bold yellow";
      };
      git_status = {
        ahead = "🏎💨$count";
        behind = "😰$count";
        conflicted = "🏳";
        deleted = "🗑";
        disabled = false;
        diverged = "😵";
        # format = "([[$all_status$ahead_behind]]($style) )";
        format = "(($style) )";
        ignore_submodules = false;
        modified = "📝";
        renamed = "👅";
        staged = "[++($count)](green)";
        stashed = "📦";
        style = "red bold bg:0xFCA17D";
        untracked = "🤷";
        up_to_date = "✓";
      };
      golang = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = " ";
        style = "bold cyan bg:0x86BBD8";
        disabled = false;
        detect_extensions = [ "go" ];
        detect_files = [
          "go.mod"
          "go.sum"
          "glide.yaml"
          "Gopkg.yml"
          "Gopkg.lock"
          ".go-version"
        ];
        detect_folders = [ "Godeps" ];
      };
      haskell = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "λ ";
        style = "bold purple bg:0x86BBD8";
        disabled = false;
        detect_extensions = [
          "hs"
          "cabal"
          "hs-boot"
        ];
        detect_files = [
          "stack.yaml"
          "cabal.project"
        ];
        detect_folders = [ ];
      };
      helm = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "⎈ ";
        style = "bold white";
        disabled = false;
        detect_extensions = [ ];
        detect_files = [
          "helmfile.yaml"
          "Chart.yaml"
        ];
        detect_folders = [ ];
      };
      hg_branch = {
        symbol = " ";
        style = "bold purple";
        format = "on [$symbol$branch]($style) ";
        truncation_length = 9223372036854775807;
        truncation_symbol = "…";
        disabled = true;
      };
      hostname = {
        disabled = false;
        format = "[$ssh_symbol](blue dimmed bold)[$hostname]($style) ";
        ssh_only = false;
        style = "green dimmed bold";
        trim_at = ".";
      };
      java = {
        disabled = false;
        format = "[$symbol($version )]($style)";
        style = "red dimmed bg:0x86BBD8";
        symbol = " ";
        version_format = "v$raw";
        detect_extensions = [
          "java"
          "class"
          "jar"
          "gradle"
          "clj"
          "cljc"
        ];
        detect_files = [
          "pom.xml"
          "build.gradle.kts"
          "build.sbt"
          ".java-version"
          "deps.edn"
          "project.clj"
          "build.boot"
        ];
        detect_folders = [ ];
      };
      jobs = {
        threshold = 1;
        symbol_threshold = 0;
        number_threshold = 2;
        format = "[$symbol$number]($style) ";
        symbol = "✦";
        style = "bold blue";
        disabled = false;
      };
      julia = {
        disabled = false;
        format = "[$symbol($version )]($style)";
        style = "bold purple bg:0x86BBD8";
        symbol = " ";
        version_format = "v$raw";
        detect_extensions = [ "jl" ];
        detect_files = [
          "Project.toml"
          "Manifest.toml"
        ];
        detect_folders = [ ];
      };
      kotlin = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🅺 ";
        style = "bold blue";
        kotlin_binary = "kotlin";
        disabled = false;
        detect_extensions = [
          "kt"
          "kts"
        ];
        detect_files = [ ];
        detect_folders = [ ];
      };
      kubernetes = {
        disabled = false;
        format = "[$symbol$context( ($namespace))]($style) in ";
        style = "cyan bold";
        symbol = "⛵ ";
      };
      kubernetes.context_aliases = { };
      line_break = {
        disabled = false;
      };
      localip = {
        disabled = false;
        format = "[@$localipv4]($style) ";
        ssh_only = false;
        style = "yellow bold";
      };
      lua = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🌙 ";
        style = "bold blue";
        lua_binary = "lua";
        disabled = false;
        detect_extensions = [ "lua" ];
        detect_files = [ ".lua-version" ];
        detect_folders = [ "lua" ];
      };
      memory_usage = {
        disabled = false;
        format = "$symbol[$ram( | $swap)]($style) ";
        style = "white bold dimmed";
        symbol = " ";
        # symbol = "\\\uf538 ";
        # symbol = "⚙️ ";
        # threshold = 75;
        threshold = -1;
      };
      nim = {
        format = "[$symbol($version )]($style)";
        style = "yellow bold bg:0x86BBD8";
        symbol = " ";
        version_format = "v$raw";
        disabled = false;
        detect_extensions = [
          "nim"
          "nims"
          "nimble"
        ];
        detect_files = [ "nim.cfg" ];
        detect_folders = [ ];
      };
      /*

        https://discourse.nixos.org/t/in-nix-shell-env-variable-in-nix-shell-versus-nix-shell/15933/4
        https://github.com/starship/starship/pull/4724
        https://spaceship-prompt.sh/sections/nix_shell/#Options
        https://github.com/spaceship-prompt/spaceship-prompt/issues/650#issuecomment-1261169936
        */
      nix_shell = {
        format = "[$symbol$state( ($name))]($style) ";
        disabled = false;
        impure_msg = "[impure](bold red)";
        pure_msg = "[pure](bold green)";
        style = "bold blue";
        symbol = " ";
        # detect_extensions = [ "nix" ];
        # detect_files = [ "flake.nix" "flake.lock" ];
        # detect_folders = [ ];
      };
      nodejs = {
        format = "[$symbol($version )]($style)";
        not_capable_style = "bold red";
        style = "bold green bg:0x86BBD8";
        symbol = " ";
        version_format = "v$raw";
        disabled = false;
        detect_extensions = [
          "js"
          "mjs"
          "cjs"
          "ts"
          "mts"
          "cts"
        ];
        detect_files = [
          "package.json"
          ".node-version"
          ".nvmrc"
        ];
        detect_folders = [ "node_modules" ];
      };
      ocaml = {
        format = "[$symbol($version )(($switch_indicator$switch_name) )]($style)";
        global_switch_indicator = "";
        local_switch_indicator = "*";
        style = "bold yellow";
        symbol = "🐫 ";
        version_format = "v$raw";
        disabled = false;
        detect_extensions = [
          "opam"
          "ml"
          "mli"
          "re"
          "rei"
        ];
        detect_files = [
          "dune"
          "dune-project"
          "jbuild"
          "jbuild-ignore"
          ".merlin"
        ];
        detect_folders = [
          "_opam"
          "esy.lock"
        ];
      };
      openstack = {
        format = "[$symbol$cloud(($project))]($style) ";
        symbol = "☁️  ";
        style = "bold yellow";
        disabled = false;
      };
      package = {
        format = "[$symbol$version]($style) ";
        symbol = "📦 ";
        style = "208 bold";
        display_private = false;
        disabled = false;
        version_format = "v$raw";
      };
      perl = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🐪 ";
        style = "149 bold";
        disabled = false;
        detect_extensions = [
          "pl"
          "pm"
          "pod"
        ];
        detect_files = [
          "Makefile.PL"
          "Build.PL"
          "cpanfile"
          "cpanfile.snapshot"
          "META.json"
          "META.yml"
          ".perl-version"
        ];
        detect_folders = [ ];
      };
      php = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🐘 ";
        style = "147 bold";
        disabled = false;
        detect_extensions = [ "php" ];
        detect_files = [
          "composer.json"
          ".php-version"
        ];
        detect_folders = [ ];
      };
      pulumi = {
        format = "[$symbol($username@)$stack]($style) ";
        version_format = "v$raw";
        symbol = " ";
        style = "bold 5";
        disabled = false;
      };
      purescript = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "<=> ";
        style = "bold white";
        disabled = false;
        detect_extensions = [ "purs" ];
        detect_files = [ "spago.dhall" ];
        detect_folders = [ ];
      };
      python = {
        format = "[$symbol$pyenv_prefix($version )(($virtualenv) )]($style)";
        python_binary = [
          "python"
          "python3"
          "python2"
        ];
        pyenv_prefix = "pyenv ";
        pyenv_version_name = true;
        style = "yellow bold";
        symbol = "🐍 ";
        version_format = "v$raw";
        disabled = false;
        detect_extensions = [ "py" ];
        detect_files = [
          "requirements.txt"
          ".python-version"
          "pyproject.toml"
          "Pipfile"
          "tox.ini"
          "setup.py"
          "__init__.py"
        ];
        detect_folders = [ ];
      };
      red = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🔺 ";
        style = "red bold";
        disabled = false;
        detect_extensions = [
          "red"
          "reds"
        ];
        detect_files = [ ];
        detect_folders = [ ];
      };
      rlang = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        style = "blue bold";
        symbol = "📐 ";
        disabled = false;
        detect_extensions = [
          "R"
          "Rd"
          "Rmd"
          "Rproj"
          "Rsx"
        ];
        detect_files = [ ".Rprofile" ];
        detect_folders = [ ".Rproj.user" ];
      };
      ruby = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "💎 ";
        style = "bold red";
        disabled = false;
        detect_extensions = [ "rb" ];
        detect_files = [
          "Gemfile"
          ".ruby-version"
        ];
        detect_folders = [ ];
        detect_variables = [
          "RUBY_VERSION"
          "RBENV_VERSION"
        ];
      };
      rust = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🦀 ";
        style = "bold red bg:0x86BBD8";
        disabled = false;
        detect_extensions = [ "rs" ];
        detect_files = [ "Cargo.toml" ];
        detect_folders = [ ];
      };
      scala = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        disabled = false;
        style = "red bold";
        symbol = "🆂 ";
        detect_extensions = [
          "sbt"
          "scala"
        ];
        detect_files = [
          ".scalaenv"
          ".sbtenv"
          "build.sbt"
        ];
        detect_folders = [ ".metals" ];
      };
      shell = {
        format = "[$indicator]($style) ";
        bash_indicator = "bsh";
        cmd_indicator = "cmd";
        elvish_indicator = "esh";
        fish_indicator = "";
        ion_indicator = "ion";
        nu_indicator = "nu";
        powershell_indicator = "_";
        style = "white bold";
        tcsh_indicator = "tsh";
        unknown_indicator = "mystery shell";
        xonsh_indicator = "xsh";
        zsh_indicator = "zsh";
        disabled = false;
      };
      shlvl = {
        threshold = 2;
        format = "[$symbol$shlvl]($style) ";
        symbol = "↕️  ";
        repeat = false;
        style = "bold yellow";
        disabled = true;
      };
      singularity = {
        format = "[$symbol[$env]]($style) ";
        style = "blue bold dimmed";
        symbol = "📦 ";
        disabled = false;
      };
      spack = {
        truncation_length = 1;
        format = "[$symbol$environment]($style) ";
        symbol = "🅢 ";
        style = "blue bold";
        disabled = false;
      };
      status = {
        format = "[$symbol$status]($style) ";
        map_symbol = true;
        not_executable_symbol = "🚫";
        not_found_symbol = "🔍";
        pipestatus = false;
        pipestatus_format = "[$pipestatus] => [$symbol$common_meaning$signal_name$maybe_int]($style)";
        pipestatus_separator = "|";
        recognize_signal_code = true;
        signal_symbol = "⚡";
        style = "bold red bg:blue";
        success_symbol = "🟢 SUCCESS";
        symbol = "🔴 ";
        disabled = true;
      };
      sudo = {
        format = "[as $symbol]($style)";
        symbol = "🧙 ";
        style = "bold blue";
        allow_windows = false;
        disabled = true;
      };
      swift = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🐦 ";
        style = "bold 202";
        disabled = false;
        detect_extensions = [ "swift" ];
        detect_files = [ "Package.swift" ];
        detect_folders = [ ];
      };
      terraform = {
        format = "[$symbol$workspace]($style) ";
        version_format = "v$raw";
        symbol = "💠 ";
        style = "bold 105";
        disabled = false;
        detect_extensions = [
          "tf"
          "tfplan"
          "tfstate"
        ];
        detect_files = [ ];
        detect_folders = [ ".terraform" ];
      };
      time = {
        format = "[$symbol $time]($style) ";
        style = "bold yellow bg:0x33658A";
        use_12hr = false;
        disabled = false;
        utc_time_offset = "local";
        # time_format = "%R"; # Hour:Minute Format;
        time_format = "%T"; # Hour:Minute:Seconds Format;
        time_range = "-";
      };
      username = {
        format = "[$user]($style) ";
        show_always = true;
        style_root = "red bold bg:0x9A348E";
        style_user = "yellow bold bg:0x9A348E";
        disabled = false;
      };
      vagrant = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "⍱ ";
        style = "cyan bold";
        disabled = false;
        detect_extensions = [ ];
        detect_files = [ "Vagrantfile" ];
        detect_folders = [ ];
      };
      vcsh = {
        symbol = "";
        style = "bold yellow";
        format = "[$symbol$repo]($style) ";
        disabled = false;
      };
      vlang = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "V ";
        style = "blue bold";
        disabled = false;
        detect_extensions = [ "v" ];
        detect_files = [
          "v.mod"
          "vpkg.json"
          ".vpkg-lock.json"
        ];
        detect_folders = [ ];
      };
      zig = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "↯ ";
        style = "bold yellow";
        disabled = false;
        detect_extensions = [ "zig" ];
        detect_files = [ ];
        detect_folders = [ ];
      };
      custom = { };
    };
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enable
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
    enableZshIntegration = true;
    silent = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    # enableBashIntegration = true;
    # enableFishIntegration = true;
  };

  # This makes it so that if you type the name of a program that
  # isn't installed, it will tell you which package contains it.
  # https://eevie.ro/posts/2022-01-24-how-i-nix.html
  #
  programs.nix-index = {
    enable = true;
    # enableFishIntegration = true;
    # enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # https://nixos.wiki/wiki/VSCodium
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    # package = pkgs.vscodium;
    profiles.default.extensions = (with pkgs.vscode-extensions; [
      /*
      edonet.vscode-command-runner
      ms-python.debugpy
      ms-python.python
      ms-python.vscode-pylance
      charliermarsh.ruff
      jgclark.vscode-todo-highlight # wayou.vscode-todo-highlight
      gruntfuggly.todo-tree
      */

      /*
      arrterian.nix-env-selector
      bbenoist.nix
      brettm12345.nixfmt-vscode
      jnoortheen.nix-ide
      # kamadorueda.alejandra
      mkhl.direnv

      edonet.vscode-command-runner
      ms-python.debugpy
      ms-python.python
      ms-python.vscode-pylance
      charliermarsh.ruff
      jgclark.vscode-todo-highlight # wayou.vscode-todo-highlight
      gruntfuggly.todo-tree

      matangover.mypy
      ms-vscode-remote.remote-containers
      redhat.vscode-yaml
      ms-azuretools.vscode-docker
      ms-vscode.makefile-tools
      yzhang.markdown-all-in-one
      tyriar.sort-lines      
      mechatroner.rainbow-csv
      eamodio.gitlens
      */

      # twxs.cmake
      # ms-vscode.cmake-tools
      # catppuccin.catppuccin-vsc
      # emmanuelbeziat.vscode-great-icons # How to test it?
      # matklad.rust-analyzer
      # streetsidesoftware.code-spell-checker
      # earshinov.sort-lines-by-selection
      # tabnine.tabnine-vscode
      # ms-vscode-remote.remote-ssh
      # esbenp.prettier-vscode

      /*
       ms-vsliveshare.vsliveshare # TODO
      alefragnani.project-manager
      astro-build.astro-vscode
      bradlc.vscode-tailwindcss
      cardinal90.multi-cursor-case-preserve
      christian-kohler.npm-intellisense
      christian-kohler.path-intellisense
      dbaeumer.vscode-eslint
      eamodio.gitlens
      editorconfig.editorconfig
      emeraldwalk.runonsave
      esbenp.prettier-vscode
      formulahendry.auto-complete-tag
      formulahendry.code-runner
      golang.go
      jnoortheen.nix-ide
      meganrogge.template-string-converter
      mikestead.dotenv
      mkhl.direnv
      ms-azuretools.vscode-docker
      naumovs.color-highlight
      oderwat.indent-rainbow
      redhat.vscode-yaml
      renesaarsoo.sql-formatter-vsc
      rust-lang.rust-analyzer
      svelte.svelte-vscode
      tamasfe.even-better-toml
      usernamehw.errorlens
      yzhang.markdown-all-in-one
      */

    ]);
    profiles.default.userSettings =
      let
        # theFont = "'MesloLGS Nerd Font Mono', 'JuliaMono', 'monospace', monospace";
        # theFont = "'FiraCode Nerd Font', 'Noto Sans Mono CJK JP', 'JuliaMono', monospace";
        # theFont = "'Sarasa Term J SemiBold', 'JuliaMono', monospace";
        # theFont = "'CodeNewRoman Nerd Font Mono', 'Droid Sans Mono', 'monospace', monospace";
        # theFont = "'FiraCode Nerd Font'";
        # theFont = ''"Monaspace Krypton", "Font Awesome 6 Free", "Font Awesome 6 Brands", "monospace"'';
        # theFont = "'MesloLGS NF', 'Maple Mono NF', 'Zed Mono', Mensch, Menlo, Consolas, Monaco, 'Courier New',\"FiraCode Nerd Font Mono\", \"Noto Sans Mono CJK JP\", 'JuliaMono', monospace";
        # theFont = "'Monaspace Krypton', 'MesloLGS Nerd Font Mono', 'Maple Mono NF', 'Zed Mono', Mensch, Menlo, Consolas, Monaco, 'Courier New',\"FiraCode Nerd Font Mono\", \"Noto Sans Mono CJK JP\", 'JuliaMono', monospace";
        # theFont = "'MesloLGS Nerd Font', 'JuliaMono', monospace";
        # theFont = "'MesloLGS Nerd Font Mono', 'JuliaMono', monospace";
        # theFont = "'Hack Nerd Font', monospace";
        # theFont = "'MesloLGS Nerd Font Mono', 'Noto Sans Mono CJK JP', 'JuliaMono', monospace";
        # theFont = "'FiraCode Nerd Font Mono', 'Noto Emoji', 'JuliaMono', monospace";
        # theFont = "'FiraCode Nerd Font Mono', 'Twitter Color Emoji', 'JuliaMono', monospace";
        # theFont = "'FiraCode Nerd Font Mono', 'Twemoji Mozilla', 'JuliaMono', monospace";
        # theFont = "'FiraCode Nerd Font Mono', 'EmojiOne Color', 'JuliaMono', monospace";
        # theFont = "'FiraCode Nerd Font Mono', 'Apple Color Emoji', 'JuliaMono', monospace";
        # theFont = "'FiraCode Nerd Font Mono', 'Noto Color Emoji', 'JuliaMono', monospace";
        # theFont = "'CodeNewRoman Nerd Font Mono', 'Noto Color Emoji', 'JuliaMono', monospace";
        # theFont = "'FiraCode Nerd Font Mono', 'Font Awesome 6 Free', 'Noto Color Emoji', 'JuliaMono', monospace";
        # theFont = "'FiraCode Nerd Font Mono', 'MesloLGS NF', 'Apple Color Emoji', 'JuliaMono', monospace";
        # theFont = "'MesloLGS Nerd Font Mono', 'MesloLGS NF', 'Lucida Console', 'JuliaMono', monospace";
        # theFont = "'MesloLGS Nerd Font Mono', 'MesloLGS NF', 'monospace'";
        theFont = "'FiraCode Nerd Font', 'MesloLGS NF'";
        # 'OpenMoji Color',

      in
      {
        # "editor.formatOnSave" = false;

        # Workbench
        # "workbench.colorTheme" = "Monokai Pro";
        # "workbench.iconTheme" = "Monokai Pro Icons";
        # "workbench.colorTheme" = "Gruvbox Dark Hard";
        # "workbench.colorTheme" = "One Dark Pro";      
        "workbench.colorTheme" = "Catppuccin Mocha";

        # Editor
        # "editor.acceptSuggestionOnEnter" = "off";
        "editor.autoClosingBrackets" = "always";
        # "editor.cursorBlinking" = "smooth";
        # "editor.cursorSmoothCaretAnimation" = true;
        # "editor.cursorStyle" = "line";
        "editor.fontFamily" = "${theFont}";

        # "editor.fontFamily" = "'CodeNewRoman Nerd Font Mono', 'Droid Sans Mono', 'monospace', monospace";
        # "editor.fontFamily" = "'FiraCode Nerd Font', monospace";
        # "editor.fontFamily" = "'FiraCode Nerd Font', 'SymbolsNerdFont', 'monospace', monospace";
        # "editor.fontFamily" = "'FiraCode Nerd Font Mono','Droid Sans Mono', 'monospace', monospace";
        # "editor.fontFamily" = "'FiraCode Nerd Font','Menlo', 'DejaVu Sans Mono', 'Consolas', 'Lucida Console', monospace";
        # "terminal.integrated.fontFamily" = "Jetbrains Mono";
        # 
        "editor.fontLigatures" = false;
        "editor.fontSize" = 16;
        # "editor.fontWeight" = "700";
        # "editor.formatOnPaste" = true;
        # "editor.formatOnSave" = true;
        # "editor.formatOnType" = true;
        # "editor.renderFinalNewline" = false;
        # "editor.rulers" = [ 80 ];
        # "editor.smoothScrolling" = true;
        # "editor.stickyTabStops" = true;
        # "editor.suggest.preview" = true;
        # "editor.guides.bracketPairs" = true;

        "terminal.integrated.fontSize" = 16;
        "terminal.integrated.fontFamily" = "${theFont}";
        # "terminal.integrated.sendKeybindingsToShell" = true; # What exactly does it do?

        # Telemetry
        "telemetry.telemetryLevel" = "off";
        "redhat.telemetry.enabled" = false;
        "gitlens.telemetry.enabled" = false;
        "continue.telemetryEnabled" = false;

        # Files
        # "files.autoSave" = "on";
        "files.autoSave" = "afterDelay";
        # "files.eol" = "\n";
        # "files.exclude" = { };
        # "files.insertFinalNewline" = true;
        # "files.trimFinalNewlines" = true;
        # "files.trimTrailingWhitespace" = true;

        "search.exclude" = {
          "**/.direnv" = true;
        };
        "files.exclude" = {
          "**/.direnv" = true;
        };
      };
    profiles.default.enableExtensionUpdateCheck = false;
    profiles.default.enableUpdateCheck = false;
    mutableExtensionsDir = true; # TODO: hardenig
  };

  programs.home-manager = {
    enable = true;
  };
}
