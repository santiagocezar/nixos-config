{
  stdenvNoCC,
  src
}:

stdenvNoCC.mkDerivation {
  pname = "AeroThemeKwinEffects";
  version = "0.0.0";

  src = "${src}/kwin";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/kwin
    
    cp -ar effects outline scripts tabbox $out/share/kwin/
    
    runHook postInstall
  '';
}
