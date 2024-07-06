# https://andrewdupont.net/2022/01/27/using-mdns-aliases-within-your-home-network/
{
  _all.nixos = { lib, pkgs, config, ... }:
  with lib;
  let
    cfg = config.services.avahi-aliases;
    avahi-aliases = pkgs.writeShellApplication {
      name = "avahi-aliases";
      runtimeInputs = [ pkgs.avahi pkgs.nettools ];
      text = ''
        host=$(hostname).local
        ip=$(avahi-resolve -4 -n "$host" | cut -f2)

        function _term {
          pkill -P $$
        }

        trap _term SIGTERM

        for name in "$@"; do
          avahi-publish -a "$name.local" -R "$ip" &
        done

        sleep infinity
      '';
    };
  in
    {
      options.services.avahi-aliases = {
        enable = mkEnableOption "Publish local address to mDNS or something like that";
        aliases = mkOption {
          type = types.listOf types.str;
          default = [];
        };
      };
      config = mkIf cfg.enable {
        services.avahi = {
          enable = true;
          publish = {
            enable = true;
            userServices = true;
          };
        };
        systemd.services.avahi-aliases = {
          enable = true;
          after = [ "network.target" "avahi-daemon.service" ];
          wantedBy = [ "multi-user.target" ];
          partOf = [ "avahi-daemon.service" ];
          serviceConfig = {
            ExecStart = "${avahi-aliases}/bin/avahi-aliases ${builtins.concatStringsSep " " cfg.aliases}";
            Restart = "no";
          };
        };
      };
    };
}

