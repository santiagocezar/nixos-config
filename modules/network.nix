{
  _all.nixos = { pkgs, ... }: {
    services.avahi = {
      nssmdns4 = true;
      enable = true;
      ipv4 = true;
      ipv6 = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
        workstation = true;
      };
    };
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
    networking.firewall.enable = true;
    networking.firewall.allowPing = true;

    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
    services.fail2ban = {
      enable = true;
      ignoreIP = [
        "192.168.0.0/16"
      ];
    };
  };

  e1001.nixos = { config, pkgs, ... }: {
    networking.networkmanager.wifi.powersave = false;
    services.aria2 = {
      enable = true;
      rpcSecretFile = "/run/secrets/aria2-rpc-token.txt";
    };
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
    services.inadyn = {
      enable = true;
      settings.provider."cloudflare.com" = {
        username = "cez.ar";
        include = config.sops.secrets.dns-token.path;
        hostname = [ "e123.cez.ar" "e1001.cez.ar" "play.cez.ar" ];
        ttl = 1;
        proxied = false;
      };
    };
    environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];
    services.nginx = {
      enable = true;
      virtualHosts."play.cez.ar" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
        };
      };
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
    networking.firewall.allowedTCPPorts = [
      80 443 # http[s]
    ];
  };

  _pc.nixos = {
    networking.firewall.allowedTCPPorts = [
      8010 # VLC
    ];
  };
}
