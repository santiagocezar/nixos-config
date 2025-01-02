{ inputs, ... }: {
  _all.nixos = { pkgs, ... }: {
    users.users.santi = {
      isNormalUser = true;
      description = "Santi";
      extraGroups = [ "networkmanager" "dialout" "wheel" "libvirtd" "media" ];
      initialPassword = "cambiar";
      shell = pkgs.nushell;
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
  };
}
