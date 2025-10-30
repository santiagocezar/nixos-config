{
  _srv.nixos = { config, pkgs, ... }: 
    let 
      gitDir = "/etc/nixos";
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
              command = "/run/current-system/sw/bin/systemctl start ${config.systemd.services.nixos-config-sync.name}";
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
            ExecStart = pkgs.writeShellScript "nixos-config-sync.sh" ''
              #!/bin/sh
              export GIT_SSH_COMMAND='${pkgs.openssh}/bin/ssh -i ${config.sops.secrets.ms-token.path}'
              ${pkgs.git}/bin/git --git-dir ${repoPath} push --mirror mirror
            '';
          };
        };
      };
}
