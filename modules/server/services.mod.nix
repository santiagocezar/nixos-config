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
        hostname = [ "e123.cez.ar" ];
        proxied = true;
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
