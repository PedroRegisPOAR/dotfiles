{
  UTMNixOSBootstrap = {
    description = "Base configuration";
    path = ./utm-nixos-bootstrap;
  };

  UTMNixOS = {
    description = "NixOS configuration with tools";
    path = ./utm-nixos;
  };

  homeManagerWithTools = {
    description = "home-manager with tools";
    path = ./home-manager-with-tools;
  };

  UTMNixOSHomeManager = {
    description = "NixOS configuration with home-manager for user config";
    path = ./utm-nixos-home-manager;
  };
}
