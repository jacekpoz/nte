{
  description = "Nix Template Engine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = { nixpkgs, systems, ... }: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsForEach = nixpkgs.legacyPackages;
    enginesForEach = import ./engine.nix;
    mkNteDerivationsForEach = import ./nte-drv.nix;
  in {
    functions = forEachSystem (
      system: let
        pkgs = pkgsForEach.${system};
        engine = enginesForEach pkgs;
      in {
        inherit engine;
        mkNteDerivation = mkNteDerivationsForEach pkgs engine;
      }
    );

    libs = forEachSystem (
      system: let
        pkgs = pkgsForEach.${system};
      in {
        default = import ./stdlib.nix pkgs;
      }
    );

    examples = forEachSystem (
      system: let
        pkgs = pkgsForEach.${system};
        engine = enginesForEach pkgs;
      in {
        default = import ./example/default.nix {
          inherit (pkgs) lib;
          mkNteDerivation = mkNteDerivationsForEach pkgs engine;
        };
      }
    );
  };
}
