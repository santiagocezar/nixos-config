{
  _pc.nixos =
    { config, pkgs, ... }:
    {
      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;

      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
}
