{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, autoconf
, automake

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
  version = "1.25.0+git+465207b7";

  src = fetchFromGitHub {
    owner = "crosstool-ng";
    repo = "crosstool-ng";
    rev = "465207b7a21f00b94b934151c0667275d342cb56";
    sha256 = "sha256-bkw8w+oAGaHo3hwb3mWe3tpjrJ3HtT4rLhwXy5WpQcQ=";
  };

  nativeBuildInputs = [
    makeWrapper
    autoconf
    automake

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

  buildPhase = ''
    bash ./bootstrap
    ./configure --prefix=$out
    make
    make DESTDIR=$out install
  '';

  postInstall = ''
    # add runtime dependencies to build toolchain
    wrapProgram $out/bin/ct-ng \
      --prefix PATH : ${lib.makeBinPath [
          autoconf
          automake
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
