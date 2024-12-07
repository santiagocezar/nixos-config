{
  stdenvNoCC,
  breeze-icons,
  oxygen,
  oxygen-icons5,
  hicolor-icon-theme,
  src
}:

stdenvNoCC.mkDerivation {
  pname = "Windows7AeroIcons";
  version = "0.0.0";

  src = "${src}/misc/icons";
/*
  propagatedBuildInputs = [
    breeze-icons
    oxygen-icons5
    hicolor-icon-theme
  ];*/

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall
    tar xzf 'Windows 7 Aero.tar.gz'
    mkdir -p $out/share/icons
    cp -ar 'Windows 7 Aero' $out/share/icons/$pname
    runHook postInstall
  '';
}
