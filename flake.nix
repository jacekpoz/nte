{
  description = "Nix Template Engine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    systems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgsForEach = nixpkgs.legacyPackages;
  in rec {
    functions = forEachSystem (
      system: let
        pkgs = pkgsForEach.${system};
      in rec {
        engine = import ./engine.nix pkgs;
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
      in {
        default = import ./example/default.nix {
          inherit (pkgs) lib stdenv;
          nte = functions.${system}.engine ./example;
        };
      }
    );
  };
}
