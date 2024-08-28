{
  _pc.home = { config, ... }: {
    home.sessionVariables = {
      EDITOR = "kwrite";
      PNPM_HOME = "/home/santi/.local/share/pnpm";
      # NIXOS_OZONE_WL = "1";
    };
    home.sessionPath = [
      "$HOME/.local/bin"
      "$PNPM_HOME"
    ];

    home.file = {
      "${config.xdg.configHome}/plasma-workspace/env/hm.sh".text = ''
        source ${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh
      '';
      ".gitignore".text = ''
        .direnv
        .directory
        *.kate-swp
      '';
    };
  };
}
