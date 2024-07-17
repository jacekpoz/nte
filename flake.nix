{
  description = "Nix Template Engine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = {nixpkgs, ...}: let
    systems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgsForEach = nixpkgs.legacyPackages;
  in rec {
    engines = forEachSystem (
      system: let
        pkgs = pkgsForEach.${system};
      in {
        default = import ./engine.nix pkgs;
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
          nte = engines.${system}.default ./example;
        };
      }
    );
  };
}
