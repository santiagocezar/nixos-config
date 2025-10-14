{
  _srv.nixos = { config, pkgs, ... }: 
    let 
        rcloneCfg = pkgs.writeText "rclone.conf" ''
            [onedrive]
            type = onedrive
            drive_id = CA3E0A9B555EF302
            drive_type = personal
        '';
        syncScript = pkgs.writeShellScript "rclone-to-onedrive.sh" ''
            #!/bin/sh
            ${pkgs.rclone}/bin/rclone \
                --config ${rcloneCfg} \
                --onedrive-token "$(cat ${config.sops.secrets.ms-token.path})" \
                sync \
                    /var/lib/syncthing/utn \
                    /var/lib/syncthing/notas \
                    /var/lib/syncthing/plani \
                onedrive:e123/
        '';
    in
        {
            systemd.services.rclone-to-onedrive =  {
                enabled = true;
                description = "Sync through RClone to OneDrive";
                wants = [ "network-online.target" ];
                serviceConfig = {
                    Type = "oneshot";
                    Restart = "on-failure";
                    User = config.services.syncthing.user;
                    Group = config.services.syncthing.group;
                    ExecStart = "${syncScript}";
                };
            };
        };
    }
