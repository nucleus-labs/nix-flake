{ lib
, stdenv
, fetchurl
, which
, flex
, bison
, texinfo
, unzip
, help2man
, libtool
, ncurses
, wget
, gnum4
, makeWrapper
, perl
}:

stdenv.mkDerivation rec {
  pname = "crosstool-ng";
  version = "1.25.0";

  src = fetchurl {
    url = "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${version}.tar.xz";
    sha256 = "sha256-aBYvNCJDzUGJ7XwfTjuxMCyqPyy7+DMYeb0B/gbGDNM=";
  };

  nativeBuildInputs = [
    which
    flex
    bison
    texinfo
    unzip
    help2man
    libtool
    ncurses
    wget
    makeWrapper
  ];

  postInstall = ''
    # add runtime dependencies to build toolchain
    wrapProgram $out/bin/ct-ng \
      --prefix PATH : ${lib.makeBinPath [ wget gnum4 which perl ]}

    ln -sr $out/bin/ct-ng $out/bin/crosstool-ng
  '';

  meta = with lib; {
    description = "A versatile (cross-)toolchain generator.";
    maintainers = with maintainers; [ rummik ];
    platforms = platforms.unix;
  };
}
