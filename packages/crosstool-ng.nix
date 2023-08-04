{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, autoconf
, automake

, bc
, binutils
, bison
, bzip2
, cpio
, curl
, elfutils
, file
, flex
, flock
, gawk
, gcc
, git
, gnum4
, gnumake
, help2man
, libtool
, ncurses
, openssl
, perl
, python310Full
, rsync
, subversion
, texinfo
, unzip
, wget
, which
}:

stdenv.mkDerivation rec {
  pname = "crosstool-ng";
  version = "1.25.0+git+465207b7";

  src = fetchFromGitHub {
    owner = "crosstool-ng";
    repo = "crosstool-ng";
    rev = "465207b7a21f00b94b934151c0667275d342cb56";
    leaveDotGit = true;
    sha256 = "sha256-vXAPyZCFnyhO0CuV3UwarhEud2NX9tdd4EwD+gLvDsM=";
  };

  docs = fetchFromGitHub {
    owner = "crosstool-ng";
    repo = "crosstool-ng.github.io";
    rev = "cfff4f1a20e347b9dfe6983e00d08020513367ec";
    leaveDotGit = true;
    sha256 = "sha256-DbVw5d4AcZ6cyaPKyHt4QXf4jBGDcULaKJJUBK9n5uI=";
  };

  buildInputs = [
    autoconf
    automake

    binutils
    bison
    elfutils.dev
    gcc
    gnumake
    libtool
    ncurses.dev
    openssl.dev
    python310Full
    texinfo
  ];

  nativeBuildInputs = [
    makeWrapper

    bc
    bzip2
    cpio
    curl
    file
    flex
    flock
    gawk
    git
    gnum4
    help2man
    ncurses
    perl
    rsync
    subversion
    unzip
    wget
    which
  ];

  preConfigure = ''
    echo ${version} > .tarball-version
    bash ./bootstrap
  '';

  fixupPhase = ''
    # add runtime dependencies for the build toolchain
    wrapProgram $out/bin/ct-ng \
      --unset LD_LIBRARY_PATH \
      --unset CC \
      --unset CXX \
      --prefix PATH : ${lib.makeBinPath buildInputs} \
      --prefix PATH : ${lib.makeBinPath nativeBuildInputs} \
      --prefix PYTHONPATH : ${python310Full}/lib/python3.10/site-packages

    ln -sr $out/bin/ct-ng $out/bin/crosstool-ng
  '';

  meta = with lib; {
    description = "A versatile (cross-)toolchain generator.";
    maintainers = with maintainers; [ rummik ];
    platforms = platforms.unix;
  };
}
