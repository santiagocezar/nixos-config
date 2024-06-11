{ stdenv
, fetchurl
, lib
, asar
, makeWrapper
, dpkg
, electron
}:

stdenv.mkDerivation (finalAttrs: {
  version = "6.1.1";
  pname = "staruml";

  src = fetchurl {
      url = "https://files.staruml.io/releases-v6/StarUML_${finalAttrs.version}_amd64.deb";
      sha256 = "sha256-AtWzGEegKUDeNLhklm74JNQQqBzdOE4MUYBFp9ubd2A=";
    };

  nativeBuildInputs = [ asar makeWrapper dpkg ];

  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/share/staruml

    mv usr/share/{applications,icons} $out/share

    asar extract opt/StarUML/resources/app.asar app
    patch -d app/ -p1 < ${./patches/staruml-stupid-evaluation-mode-remover-3000.patch}
    asar pack app $out/share/staruml/app.asar

    substituteInPlace $out/share/applications/staruml.desktop \
      --replace "/opt/StarUML/staruml" "$out/bin/staruml"

    makeWrapper ${electron}/bin/electron $out/bin/staruml \
      --add-flags $out/share/staruml/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Sophisticated software modeler";
    homepage = "https://staruml.io/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ kashw2 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "staruml";
  };
})
