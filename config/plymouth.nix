{ config, pkgs, inputs, ... }:

{
  boot = {
    plymouth.enable = true;
    plymouth.theme = "bgrt";
    initrd.systemd.enable = true;
    kernelParams = [
      "splash"
      "quiet"
    ];
  };
}
