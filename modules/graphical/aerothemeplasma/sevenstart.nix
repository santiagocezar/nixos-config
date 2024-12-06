{
  src,
  stdenv,
  qt6,
  cmake,
  pkg-config,
  kdePackages,
  extra-cmake-modules,
}:

stdenv.mkDerivation (final: {
  pname = "sevenstart";
  version = "0.0.0";
  inherit src;

  # awful hack
  postUnpack = ''
    cd ${final.src.name}
    patch -p1 < ${./sevenstart.patch}
    rm -r plasma/plasmoids/src/sevenstart_src/src/package
    mv plasma/plasmoids/io.gitgud.wackyideas.SevenStart plasma/plasmoids/src/sevenstart_src/src/package
    cat ./plasma/plasmoids/src/sevenstart_src/src/CMakeLists.txt
    sourceRoot=./plasma/plasmoids/src/sevenstart_src
  '';

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
  ];
  buildInputs = [
    kdePackages.libplasma
  ];

})
