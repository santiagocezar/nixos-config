{ 
  stdenv,
  cmake,
  kdePackages,
  kwin-smod-decoration,
  pkg-config,
  src,
}:


stdenv.mkDerivation {
  pname = "kwin-effects-smodglow";
  version = "0";

  src = "${src}/kwin/effects_cpp/smodglow";

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  cmakeFlags = [ "-DBUILD_KF6=ON" ];
  
  buildInputs = [
    kdePackages.kwin
    kdePackages.qtbase
    kwin-smod-decoration
  ];
}
