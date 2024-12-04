{
  _pc.nixos = { config, pkgs, lib, ... }: {
    services.flatpak.enable = true;
  };
}
