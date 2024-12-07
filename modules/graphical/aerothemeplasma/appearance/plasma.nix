{
  stdenvNoCC,
  src
}:

stdenvNoCC.mkDerivation {
  pname = "AeroThemePlasma";
  version = "0.0.0";

  src = "${src}/plasma";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/look-and-feel
    mkdir -p $out/share/plasma/desktoptheme
    mkdir -p $out/share/color-schemes
    
    cp -ar look-and-feel/authui7 $out/share/plasma/look-and-feel/
    cp -ar desktoptheme/Seven-Black $out/share/plasma/desktoptheme/
    cp -a color_scheme/AeroColorScheme1.colors $out/share/color-schemes/
    
    runHook postInstall
  '';
}
