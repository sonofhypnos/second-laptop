{ stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libtool, autoconf
, automake }:
stdenv.mkDerivation rec {
  pname = "xtrace";
  version = "unstable-2025-05-22";
  src = fetchFromGitHub {
    owner = "yuq";
    repo = "xtrace";
    rev = "master";
    sha256 =
      "0000000000000000000000000000000000000000000000000000"; # Replace with actual hash
  };
  nativeBuildInputs = [ autoreconfHook pkg-config libtool autoconf automake ];
  configureFlags = [ "--prefix=$out" ];
  meta = {
    description = "A tool for tracing program execution";
    homepage = "https://github.com/yuq/xtrace";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = stdenv.lib.platforms.linux;
  };

}
