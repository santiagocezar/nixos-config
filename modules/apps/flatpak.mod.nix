{
  _pc.nixos = { config, pkgs, lib, ... }: {
    services.flatpak.enable = true;
    fonts.fontDir.enable = true;
#     programs.xwayland.defaultFontPath = "/run/current-system/sw/share/X11/fonts";    
  };
}
