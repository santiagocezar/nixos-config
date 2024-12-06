{ stdenvNoCC
, src
}:

stdenvNoCC.mkDerivation {
  pname = "Windows7AeroSounds";
  version = "0.0.0";

  src = "${src}/misc/sounds/Archive.tar.gz";

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/sounds/
    cp -ar garden $out/share/sounds/
    cp -ar win7-default $out/share/sounds/
    runHook postInstall
  '';
}
