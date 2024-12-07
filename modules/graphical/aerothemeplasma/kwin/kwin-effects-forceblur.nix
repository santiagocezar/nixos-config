{ 
  lib,
  stdenv,
  cmake,
  kdePackages,
  src,
}:

stdenv.mkDerivation {
  pname = "kwin-effects-forceblur";
  version = "1.2.0";

  src = "${src}/kwin/effects_cpp/kde-effects-aeroglassblur";

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kwin
    kdePackages.qttools
  ];

  meta = with lib; {
    description = "A fork of the KWin Blur effect for KDE Plasma 6 with the ability to blur any window on Wayland and X11";
    license = licenses.gpl3;
    homepage = "https://github.com/taj-ny/kwin-effects-forceblur";
  };
}
