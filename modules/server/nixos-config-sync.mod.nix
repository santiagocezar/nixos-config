{
  _srv.nixos = { config, pkgs, ... }: 
    let 
      gitDir = "/etc/nixos";
      repoRemotePath = "/etc/nixos";
      mirror = pkgs.writeShellScript "mirror-config.sh" ''
        export GIT_SSH_COMMAND='ssh -i ${config.sops.secrets.ssh-key.path}'
        git --git-dir ${gitDir} push --mirror origin
      '';
      syncService = config.systemd.services.nixos-config-sync.name;
      refreshService = config.systemd.services.nixos-config-refresh.name;
    in
      {
        security.sudo.extraRules = [{
          commands = [
            {
              command = "/run/current-system/sw/bin/systemctl start ${syncService}";
              options = [ "NOPASSWD" ];
            }
          ];
          groups = [ "wheel" ];
        }];

        systemd.services.nixos-config-sync =  {
          description = "Sync NixOS config to GitHub";
          wants = [ "network-online.target" ];
          path = with pkgs; [
            gitMinimal
            config.nix.package.out
            config.programs.ssh.package
            config.system.build.nixos-rebuild
          ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "nixos-config-sync.sh" ''
              set -eux

              nixos-rebuild switch --refresh --flake git+file://${gitDir}

              ${mirror}
            '';
          };
        };

        systemd.services.nixos-config-refresh =  {
          description = "Refresh NixOS config and sync to GitHub";
          before = syncService;
          wants = [ "network-online.target" syncService ];
          path = with pkgs; [
            config.nix.package.out
          ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "nixos-config-refresh.sh" ''
              set -eux

              # todo
            '';
          };
        };

        systemd.timers.nixos-config-refresh = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "weekly";
            Persistent = true;
            Unit = refreshService;
          };
        };
      };
}
