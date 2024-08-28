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

  e1001.nixos = { config, pkgs, ... }: {
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
  };
}
