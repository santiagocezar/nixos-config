{
  _all.nixos = { pkgs, ... }: {
    services.avahi.enable = true;
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

    networking.networkmanager.enable = true;
    networking.firewall.enable = false;
    networking.firewall.allowPing = true;

    services.openssh = {
      enable = true;
    };
  };

  e1001.nixos = { pkgs, ... }: {
    services.aria2 = {
      enable = true;
      rpcSecretFile = "/run/secrets/aria2-rpc-token.txt";
    };
    systemd.tmpfiles.rules = [
      "d /var/lib/media 0777 jellyfin jellyfin"
    ];
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
    environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];
    services.nginx = {
      enable = true;
      virtualHosts."e1001.cez.ar" = {
#       virtualHosts."e1001.cez.ar" = {
        locations."/aria2/" = {
          alias = "${pkgs.ariang}/share/ariang/";
        };
        locations."/aria2rpc" = {
          proxyPass = "http://127.0.0.1:6800/jsonrpc";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_redirect   off;
            proxy_set_header X-Real-IP       $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host            $host;
          '';
        };
      };
    };
  };

  _pc.nixos = {
    networking.firewall.allowedTCPPorts = [
      8010 # VLC
    ];
    services.openssh.settings.PasswordAuthentication = false;
  };
}
