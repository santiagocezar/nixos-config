{
  _pc.nixos = [
    ({ config, pkgs, ... }: {
      services.flatpak.enable = true;

      # quote https://github.com/NixOS/nixpkgs/issues/119433#issuecomment-1767513263
      system.fsPackages = [ pkgs.bindfs ];
      fileSystems = let
        mkRoSymBind = path: {
          device = path;
          fsType = "fuse.bindfs";
          options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
        };
        aggregatedIcons = pkgs.buildEnv {
          name = "system-icons";
          paths = with pkgs; [
            libsForQt5.breeze-qt5  # for plasma
            gnome.gnome-themes-extra
          ];
          pathsToLink = [ "/share/icons" ];
        };
        aggregatedFonts = pkgs.buildEnv {
          name = "system-fonts";
          paths = config.fonts.packages;
          pathsToLink = [ "/share/fonts" ];
        };
      in {
        "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
        "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
      };

      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;

      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    })
  ];
}
