{
  e1001.nixos = { config, pkgs, ... }: {
    # Share PS2 games with OPL
    services.samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      extraConfig = ''
        workgroup = WORKGROUP
        dns proxy = no
        log file = /var/log/samba/%m.log
        max log size = 1000
        server min protocol = CORE
        client min protocol = CORE
        client max protocol = SMB3

        map to guest = Bad User
        usershare allow guests = yes
        name resolve order = lmhosts bcast host wins
        security = user
        guest account = nobody
      '';
      shares = {
        ps2 = {
          "comment" = "ps2";
          "path" = "/var/lib/shares/PS2";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "public" = "yes";
          "available" = "yes";
        };
      };
    };
  };
}
