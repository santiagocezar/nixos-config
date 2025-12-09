{
  _pc.home =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        dejavu_fonts
        fira-code
        material-symbols
      ];

      fonts.fontconfig.enable = true;
    };
}
