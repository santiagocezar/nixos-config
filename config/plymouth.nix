{ config, pkgs, inputs, ... }:

{
  boot = {
    plymouth.enable = true;
    plymouth.theme = "bgrt";
    initrd.systemd.enable = true;
    kernelParams = [
      "amdgpu.seamless=1"
      "splash"
      "quiet"
    ];
  };
}
