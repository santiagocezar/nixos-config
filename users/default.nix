{ config, lib, pkgs, modulesPath, ... }@extraSpecialArgs:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.santi = {
    isNormalUser = true;
    description = "Santi";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  home-manager = {
    # Optionally, use home-manager.extraSpecialArgs to pass
    # arguments to home.nix
    inherit extraSpecialArgs;
    useGlobalPkgs = true;
    useUserPackages = true;
    users.santi = import ./santi;
  };
}
