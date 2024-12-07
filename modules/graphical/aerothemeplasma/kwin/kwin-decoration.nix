{ 
  stdenv,
  cmake,
  kdePackages,
  kwin-smod-decoration,
  pkg-config,
  src,
}:

stdenv.mkDerivation {
  pname = "smoddecoration";
  version = "0";

  src = "${src}/kwin/decoration/breeze-v5.93.0";
  
  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kwin
  ];
}
