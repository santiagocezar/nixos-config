{
  _pc.home = { pkgs, ... }: {
    home.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        dejavu_fonts
        fira-code
        material-symbols
    ];

    fonts.fontconfig.enable = true;
  };
}
