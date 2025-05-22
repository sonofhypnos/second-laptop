{ stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libtool, autoconf
, automake, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "xtrace";
  version = "unstable-2025-05-22";

  src = fetchFromGitHub {
    owner = "yuq";
    repo = "xtrace";
    rev = "master";
    sha256 = "sha256-7nUiJu0gO9IiA3SZAN2Z91oxNVdCcWAa9dtp/cWlxq0=";
  };

  nativeBuildInputs =
    [ autoreconfHook pkg-config libtool autoconf automake makeWrapper ];

  preConfigure = ''
    ./autogen.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp xtrace $out/bin/xtrace
  '';

  postInstall = ''
    wrapProgram $out/bin/xtrace \
      --set PKGDATADIR $out/share/xtrace
  '';

  meta = {
    description = "A tool for tracing X11 protocol usage";
    homepage = "https://github.com/yuq/xtrace";
    #    license = stdenv.lib.licenses.gpl3Plus;
    #    platforms = stdenv.lib.platforms.linux;
  };
}
