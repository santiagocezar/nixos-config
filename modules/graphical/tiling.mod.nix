{
/*
  e102.nixos = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        slurp
        wl-clipboard
        mako
        lxpanel
        nm-tray
        rofi-wayland
        kdePackages.konsole
    ];

    # Enable the gnome-keyring secrets vault.
    # Will be exposed through DBus to programs willing to store secrets.
    services.gnome.gnome-keyring.enable = true;

    # enable Sway window manager
    programs.sway = {
        enable = true;
#         package = pkgs.swayfx;
        wrapperFeatures.gtk = true;
    };
  };
  _pc.home = {
    wayland.windowManager.sway = {
      enable = true;
      package = null;
      config = rec {
        modifier = "Mod4";
        terminal = "konsole";
        startup = [ ];
      };
    };
  };
*/
}
