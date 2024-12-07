{
  stdenvNoCC,
  kdePackages,
  src
}:

stdenvNoCC.mkDerivation {
  pname = "sddm-theme-mod";
  version = "0.0.0";

  src = "${src}/plasma/sddm";
  
  dontWrapQtApps = true;
  propagatedUserEnvPkgs = with kdePackages; [ qt5compat qtmultimedia ];
  
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/sddm/themes
    
    cp -ar sddm-theme-mod $out/share/sddm/themes/
    
    runHook postInstall
  '';
}
