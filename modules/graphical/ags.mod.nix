{ inputs, ... }: {
  e102.home = { config, pkgs, ... }: {
    home.packages = [ inputs.ags.packages.${pkgs.system}.default ];

    start-with-niri = ["ags"];

    systemd.user.services."ags" = {
      Unit = {
        Description = "cool panel";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
        Requisite = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${inputs.ags.packages.${pkgs.system}.default}/bin/ags";
        Restart = "on-failure";
      };
    };
  };
}
