{
/*
  e102.home = { pkgs, ... }: {
    # qt.enable = true;
    # qt.platformTheme.name = "qtct";

    home.packages = with pkgs; [
      papirus-icon-theme
    ];

    systemd.user.services."swaybg" = {
      Unit = {
        Description = "wallpaper thing";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
        Requisite = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i /home/santi/Imágenes/Wallpapers/miku-tv-2.jpg";
        Restart = "on-failure";
      };
    };
  };
*/
}
