{ home-manager, ... }: {
  # _pc.nixos = { config, pkgs, ... }: {
  #   imports = [ home-manager.nixosModules.home-manager ];
  #   home-manager = {
  #     # extraSpecialArgs = { inherit inputs; };
  #     useGlobalPkgs = true;
  #     useUserPackages = true;
  #     users.santi = {
  #       home.username = "santi";
  #       home.homeDirectory = "/home/santi";
  #
  #       # Backwards compatibility safety!
  #       home.stateVersion = "23.11";
  #       imports = config._module.args.home_modules;
  #     };
  #   };
  # };

  _all.nixos = { pkgs, ... }: {
    users.users.santi = {
      isNormalUser = true;
      description = "Santi";
      extraGroups = [ "networkmanager" "dialout" "wheel" "libvirtd" "media" ];
      initialPassword = "cambiar";
      shell = pkgs.fish;
    };
  };

  e123.nixos = { pkgs, ... }: {
    users.users.flor = {
      isNormalUser = true;
      description = "Flor";
      extraGroups = [ "networkmanager" ];
      shell = pkgs.fish;
    };
  };

  _pc.home = { config, pkgs, ... }: {
    programs.home-manager.enable = true;
    services.syncthing.enable = true;
  };
}
