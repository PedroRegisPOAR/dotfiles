{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # https://github.com/NixOS/nixpkgs/issues/27930#issuecomment-417943781
  boot.kernelModules = [
    # "pci-stub"
    # "kvm-amd"
    # "vfio"
    # "vfio_iommu_type1"
    # "vfio_pci"
    # "vfio_virqfd"
  ];
  # https://nixos.wiki/wiki/Libvirt
  # boot.extraModprobeConfig = "options kvm_amd nested=1";

  /*
    # supported file systems, so we can mount any removable disks with these filesystems
    boot.supportedFilesystems = [
    "ext4"
    "btrfs"
    "xfs"
    #"zfs"
    "ntfs"
    "fat"
    "vfat"
    "exfat"
    ];
  */
  networking.hostName = "n1x0s"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Fortaleza";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # systemd.services."getty@tty1".enable = false;
  services.displayManager.autoLogin.user = "fog";
  # services.xserver.displayManager.gdm.enable = false;
  # services.xserver.displayManager.lightdm.enable = false;
  # Configure keymap in X11
  services.xserver.xkb.layout = "br";
  # services.xserver.xkb.variant = "thinkpad";
  # Configure console keymap
  console.keyMap = "br-abnt2";

  services.spice-vdagentd.enable = true;
  services.xserver.videoDrivers = [ "qxl" ];

  services.xserver.displayManager.sessionCommands = ''
    exo-open \
      --launch TerminalEmulator \
      --zoom=-3 \
      --geometry 154x40
  '';

  # Enable CUPS to print documents.
  services.printing.enable = false;

  security.sudo.wheelNeedsPassword = false; # TODO: hardening
  # https://nixos.wiki/wiki/NixOS:nixos-rebuild_build-vm
  users.extraGroups.fog.gid = 1000;
  # users.groups.fog.gid = 1000;

  users.users.fog = {
    isSystemUser = true;
    # isNormalUser = true;
    password = "1"; # TODO: hardening
    createHome = true;
    home = "/home/fog";
    homeMode = "0700";
    description = "The VM tester Fog user";
    group = "fog";
    extraGroups = [
      "docker"
      "kvm"
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      btop
      direnv
      file
      findutils
      firefox
      fzf
      git
      gnugrep
      hello
      jq
      lsof
      claude-code
      # mcp-nixos
      starship
      sudo
      which
    ];
    shell = pkgs.zsh;
    uid = 1000;
    autoSubUidGidRange = true;
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      powerline
      powerline-fonts
    ];
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
  };

  # https://github.com/NixOS/nixpkgs/blob/3a44e0112836b777b176870bb44155a2c1dbc226/nixos/modules/programs/zsh/oh-my-zsh.nix#L119
  # https://discourse.nixos.org/t/nix-completions-for-zsh/5532
  # https://github.com/NixOS/nixpkgs/blob/09aa1b23bb5f04dfc0ac306a379a464584fc8de7/nixos/modules/programs/zsh/zsh.nix#L230-L231
  programs.zsh = {
    enable = true;
    shellAliases = {
      vim = "nvim";
    };

    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
      export ZSH_THEME="agnoster"
      export ZSH_CUSTOM=${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions
      plugins=(
                colored-man-pages
                docker
                git
                #zsh-autosuggestions # Why this causes an warn?
                #zsh-syntax-highlighting
              )

      # https://nixos.wiki/wiki/Fzf
      source $ZSH/oh-my-zsh.sh

      export DIRENV_LOG_FORMAT=""
      eval "$(direnv hook zsh)"

      eval "$(starship init zsh)"

      export FZF_BASE=$(fzf-share)
      source "$(fzf-share)/completion.zsh"
      source "$(fzf-share)/key-bindings.zsh"
    '';

    ohMyZsh.custom = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
    promptInit = "";
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.extraOptions = "experimental-features = nix-command flakes";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    spice-vdagent
    spice-gtk
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
