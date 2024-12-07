{ 
  stdenv,
  cmake,
  kdePackages,
  src,
}:

stdenv.mkDerivation {
  pname = "kwin-effects-smodsnap";
  version = "2";

  src = "${src}/kwin/effects_cpp/kwin-effect-smodsnap-v2";
  
  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  cmakeFlags = [ "-DBUILD_KF6=ON" ];

  buildInputs = [
    kdePackages.kwin
    kdePackages.qtbase
  ];
}
