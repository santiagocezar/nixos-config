{
    e102.home = { pkgs, ... }: {
      # qt.enable = true;
      # qt.platformTheme.name = "qtct";

      home.packages = with pkgs; [
        papirus-icon-theme
      ];

      start-with-niri = ["swaybg"];

      systemd.user.services."swaybg" = {
        Unit = {
          Description = "wallpaper thing";
          PartOf = ["graphical-session.target"];
          After = ["graphical-session.target"];
          Requisite = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i /home/santi/Imágenes/Wallpapers/Joypolis.png";
          Restart = "on-failure";
        };
      };
    };
}
