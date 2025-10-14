{
  _all.nixos = { pkgs, ... }: {
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

  _srv.nixos = { config, pkgs, ... }: {
    services.aria2 = {
      enable = true;
      rpcSecretFile = "/run/secrets/aria2-rpc-token.txt";
      serviceUMask = "0002";
      settings.dir = "/var/lib/downloads";
    };
    services.tailscale.enable = true;
    services.inadyn = {
      enable = true;
      settings.provider."cloudflare.com" = {
        username = "cez.ar";
        include = config.sops.secrets.dns-token.path;
        hostname = [ "e123.cez.ar" "public.cez.ar" ];
        # proxied = true;
      };
    };
    services.mosquitto = {
      enable = true;
      listeners = [
        {
          acl = [ "pattern readwrite #" ];
          omitPasswordAuth = true;
          settings.allow_anonymous = true;
        }
        {
          acl = [ "pattern readwrite #" ];
          omitPasswordAuth = true;
          port = 8080;
          settings.allow_anonymous = true;
          settings.protocol = "websockets";
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [ 1883 ];

    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      settings = {
        guiPasswordFile = config.sops.secrets.syncthing-password.path;
        devices = {
          "adachi00" = {
            addresses = [
              "tcp://100.95.116.94"
              "quic://100.95.116.94"
              "tcp://192.168.0.16"
              "quic://192.168.0.16"
              "dynamic"
            ];
            id = "IXMXMSD-FIJB23F-527Z6DA-WSSMA2O-IUP2AXR-M42DSEW-GIXYX35-6QC77QY";
            introducer = true;
          };
          "motobug42" = {
            addresses = [
              "tcp://100.120.237.63"
              "quic://100.120.237.63"
              "tcp://192.168.0.4"
              "quic://192.168.0.4"
              "dynamic"
            ];
            id = "AZGNX5Q-VIBGOFP-GJZFYMA-I7EFT7T-EM7FX4X-OXVXMRW-G4PLZ3Z-SCSSRAS";
            introducer = true;
          };
        };
        folders = {
          "utn" = {
            path = "~/utn";
            devices = [ "adachi00" "motobug42" ];
          };
          "plani" = {
            path = "~/plani";
            devices = [ "adachi00" "motobug42" ];
          };
          "notas" = {
            path = "~/notas";
            devices = [ "adachi00" "motobug42" ];
          };
        };
      };
    };

    # services.jellyfin = {
    #   enable = true;
    #   openFirewall = true;
    # };
    # environment.systemPackages = [
    #   pkgs.jellyfin
    #   pkgs.jellyfin-web
    #   pkgs.jellyfin-ffmpeg
    # ];
  };
}
