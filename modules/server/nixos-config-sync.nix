{
  _srv.nixos = { config, pkgs, ... }: 
    let 
        repoPath = "/etc/nixos";
        repoRemotePath = "/etc/nixos";
    in
        {
            security.sudoextraRules = [{
                commands = [
                    {
                        command = "${pkgs.systemd}/bin/systemctl start ${config.systemd.services.nixos-config-sync.name}";
                        options = [ "NOPASSWD" ];
                    }
                ];
                groups = [ "wheel" ];
            }];

            systemd.services.nixos-config-sync =  {
                description = "Sync NixOS config to GitHub";
                wants = [ "network-online.target" ];
                serviceConfig = {
                    Type = "oneshot";
                    Restart = "on-failure";
                    User = "mirrormirror";
                    WorkingDirectory = repoPath;
                    ExecStart = pkgs.writeShellScript "nixos-config-sync.sh" ''
                        #!/bin/sh
                        export GIT_SSH_COMMAND='ssh -i ${config.sops.secrets.ms-token.path}'
                        git push --mirror mirror
                    '';
                };
            };
        };
    }
