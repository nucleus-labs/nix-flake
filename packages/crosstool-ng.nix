{ lib
, stdenv
, fetchFromGitHub
, makeWrapper

, bc
, binutils
, bison
, cpio
, elfutils
, file
, flex
, flock
, gcc
, gnum4
, gnumake
, help2man
, libtool
, ncurses
, openssl
, perl
, rsync
, texinfo
, unzip
, wget
, which
}:

stdenv.mkDerivation {
  pname = "crosstool-ng";
  version = "1.25.0-dev";

  src = fetchFromGitHub {
    owner = "crosstool-ng";
    repo = "crosstool-ng";
    rev = "465207b7a21f00b94b934151c0667275d342cb56";
    sha256 = "sha256-aBYvNCJDzUGJ7XxfTjuxMCyqPyy7+DMYeb0B/gbGDNM=";
  };

  nativeBuildInputs = [
    makeWrapper

    bc
    binutils
    bison
    cpio
    elfutils.dev
    file
    flex
    flock
    gcc
    gnum4
    gnumake
    help2man
    libtool
    ncurses
    ncurses.dev
    openssl.dev
    perl
    rsync
    texinfo
    unzip
    wget
    which
  ];

  postInstall = ''
    # add runtime dependencies to build toolchain
    wrapProgram $out/bin/ct-ng \
      --prefix PATH : ${lib.makeBinPath [
          bc
          binutils
          bison
          cpio
          elfutils.dev
          file
          flex
          flock
          gcc
          gnum4
          gnumake
          help2man
          libtool
          ncurses
          ncurses.dev
          openssl.dev
          perl
          rsync
          texinfo
          unzip
          wget
          which
        ]}

    ln -sr $out/bin/ct-ng $out/bin/crosstool-ng
  '';

  meta = with lib; {
    description = "A versatile (cross-)toolchain generator.";
    maintainers = with maintainers; [ rummik ];
    platforms = platforms.unix;
  };
}
