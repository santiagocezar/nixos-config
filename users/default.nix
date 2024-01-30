{ config, lib, pkgs, modulesPath, inputs, ... }@extraSpecialArgs:

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
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.santi = import ./santi;
  };
}
