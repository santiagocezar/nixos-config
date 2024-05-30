{
  _pc.home = { pkgs, ... }: {
    home.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        dejavu_fonts
        fira-code
    ];

    fonts.fontconfig.enable = true;
  };
}
