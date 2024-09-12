{
  description = "Nix Template Engine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgsForEach = nixpkgs.legacyPackages;
    enginesForEach = import ./engine.nix;
  in {
    functions = forEachSystem (
      system: let
        pkgs = pkgsForEach.${system};
        engine = enginesForEach pkgs;
      in {
        inherit engine;
        mkNteDerivation = import ./nte-drv.nix pkgs engine;
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
          inherit (pkgs) lib stdenv;
          nte = engine ./example;
        };
      }
    );
  };
}
