{ aerotheme, stdenv, qt6, cmake, pkg-config, kdePackages, extra-cmake-modules }:

stdenv.mkDerivation {
  pname = "sevenstart";
  version = "0.0.0";
  
  patches = [
    ./sevenstart.patch
  ];
  
  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
  ];
  buildInputs = [
    kdePackages.libplasma
  ];
  
  src = "${aerotheme}/plasma/plasmoids/src/sevenstart_src";
}
