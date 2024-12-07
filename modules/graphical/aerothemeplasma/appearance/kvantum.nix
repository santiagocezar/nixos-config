{ stdenvNoCC, src }:

stdenvNoCC.mkDerivation {
  pname = "Windows7Kvantum_Aero";
  version = "0.0.0";

  src = "${src}/misc/kvantum/Kvantum/Windows7Kvantum_Aero";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/Kvantum/$pname
    cp -a * $out/share/Kvantum/$pname
    runHook postInstall
  '';
}
