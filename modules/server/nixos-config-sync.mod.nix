{
  _srv.nixos = { config, pkgs, ... }: 
    let 
      repoPath = "/etc/nixos";
      repoRemotePath = "/etc/nixos";
    in
      {
        users.groups."mirrormirror" = {};
        users.users."mirrormirror" = {
          group = "mirrormirror";
          isSystemUser = true;
        };
        
        security.sudo.extraRules = [{
          commands = [
            {
              command = "systemctl start ${config.systemd.services.nixos-config-sync.name}";
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
              export GIT_SSH_COMMAND='${pkgs.ssh}/bin/ssh -i ${config.sops.secrets.ms-token.path}'
              ${pkgs.git}/bin/git push --mirror mirror
            '';
          };
        };
      };
}
