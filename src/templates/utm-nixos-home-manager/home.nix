{ config, pkgs, lib, ... }:
{
  imports = [ ./claude-settings-hm.nix ];

  home.username = "fog";
  home.homeDirectory = "/home/fog";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    neovim
  ];

  programs.zsh = {
    enable = true;
    shellAliases = { vim = "nvim"; };
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "colored-man-pages" "docker" "git" ];
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."direnv/direnv.toml".text = ''
    [global]
    log_filter = "^$"
  '';
}
