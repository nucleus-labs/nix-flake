{
  lib,
  fetchFromGitHub,
  buildGoModule,
  rootlesskit,
  makeWrapper,
}:

buildGoModule rec {
  pname = "buildg";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ktock";
    repo = "buildg";
    rev = "v${version}";
    hash = "sha256-eP26cb/USYoi0S9MhRp0twjmokz1ZCQkJ6kTGJPopxA=";
  };

  vendorSha256 = "sha256-cSVub/7AVuzn6O93GzSiBjzRTewjyw3WrzLnWvYEF0E=";

  extraPath = lib.makeBinPath [
    rootlesskit
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  doCheck = false;

  fixupPhase = ''
    wrapProgram $out/bin/buildg \
      --prefix PATH : ${extraPath}
  '';

  meta = with lib; {
    description = "A build tool for Docker";
    homepage = "https://github.com/ktock/buildg";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rummik ];
  };
}
