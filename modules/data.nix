{
  e1001.nixos = { config, pkgs, ... }: {
    user.groups = {
      media.members = [
        "jellyfin" 
        "aria2" 
      ];
    };
    systemd.tmpfiles.rules = [
      "d /var/lib/media      0775 jellyfin media"
      "d /var/lib/downloads  0775 root     media"
    ];
  };
}