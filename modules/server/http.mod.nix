{
  _srv.nixos = { config, pkgs, ... }: {
    services.caddy = {
      enable = true;
      virtualHosts."e123.cez.ar".extraConfig = ''
        handle_path /aria2/* {
          root * "${pkgs.ariang}/share/ariang"
          file_server browse
        }
        reverse_proxy /jsonrpc :6800 {
          header_down X-Real-IP {http.request.remote}
        }

        handle_path /mqtt {
          reverse_proxy :8080
        }
      '';
    };
    networking.firewall.allowedTCPPorts = [
      80 443
    ];
  };
}
