{
  _all.nixos = { lib, pkgs, config, ... }:
  with lib;
  let
    cfg = config.services.avahi-aliases;
    avahi-aliases = writeShellApplication {
      name = "avahi-aliases";
      runtimeInputs = [ pkgs.avahi ];
      text = ''
        host=$(hostname)
        ip=$(avahi-resolve -4 -n "$HOST.local" | cut -f2)

        function _term {
          pkill -P $$
        }

        trap _term SIGTERM

        for name in "$@"; do
          /usr/bin/avahi-publish -a "$name" -R "$ip" &
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
        systemd.services.avahi-aliases = {
          after = [ "network.target" "avahi-daemon.service" ];
          partOf = "avahi-daemon.service";
          restart = "no";
          serviceConfig.ExecStart = "${avahi-aliases}/bin/avahi-aliases ${concatStringSep " " cfg.aliases}";
        };
      };
    };
}

