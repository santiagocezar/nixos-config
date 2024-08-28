{
  _all.nixos = { pkgs, ... }: {
    networking.networkmanager.enable = true;
    networking.firewall.enable = true;
    networking.firewall.allowPing = true;

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
  };

  e1001.nixos = { config, pkgs, ... }: {
    networking.networkmanager.wifi.powersave = false;
  };

  _pc.nixos = {
    networking.firewall.allowedTCPPorts = [
      8010 # VLC
    ];
  };
}
