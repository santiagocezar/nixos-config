{ stdenvNoCC, src }:

stdenvNoCC.mkDerivation {
  pname = "aero-drop";
  version = "0.0.0";

  src = "${src}/misc/cursors/aero-drop.tar.gz";

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/$pname
    cp -a * $out/share/icons/$pname
    runHook postInstall
  '';
}
