{
  description = "virtual environments";

  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  outputs = inputs@{ self, flake-parts, devshell, nixpkgs }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        devshell.flakeModule
      ];

      systems = [
        "riscv64-linux"
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
      ];

      perSystem = { pkgs, ... }: rec {
        devshells = rec {
          default = crosstool-ng;

          crosstool-ng = {
            packages = [ ];

            commands = [
              {
                category = "tools";
                name = "ct-ng";
                package = packages.crosstool-ng;
                # help = packages.crosstool-ng.meta.descripton;
              }
            ];

            env = [
              {
                name = "LD_LIBRARY_PATH";
                unset = true;
              }
            ];
          };
        };

        packages = {
          crosstool-ng = pkgs.callPackage ./packages/crosstool-ng.nix { };
        };
      };
    };
}
