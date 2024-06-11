{ ags, ... }: {
  e102.home = { config, pkgs, ... }: {
    home.packages = [ ags.packages.${pkgs.system}.default ];

    start-with-niri = ["ags"];

    systemd.user.services."ags" = {
      Unit = {
        Description = "cool panel";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
        Requisite = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${ags.packages.${pkgs.system}.default}/bin/ags";
        Restart = "on-failure";
      };
    };
  };
}
