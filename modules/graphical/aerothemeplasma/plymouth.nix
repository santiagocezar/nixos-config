{ src, stdenv, cmake, pkg-config, plymouth }:

stdenv.mkDerivation (final: {
  pname = "plymouth-theme-smod";
  version = "0.0.0";
  src = "${src}/misc/plymouth/plymouth-theme-smod";

  postUnpack = ''
    rm -rf plymouth-theme-smod/build
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    plymouth
  ];
})
