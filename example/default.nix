{
  lib,
  mkNteDerivation,
  ...
}: let
  inherit (lib.attrsets) listToAttrs;
  inherit (lib.lists) map;
  inherit (lib.strings) replaceStrings toLower;

  extraArgs' = {
    h = n: content: let
      id = replaceStrings [" " ";"] ["-" "-"] (toLower content);
    in /*html*/''
      <h${toString n} id="${id}"><a href="#${id}">#</a> ${content}</h${toString n}>
    '';
  };
in mkNteDerivation {
  name = "nte-example";
  version = "0.1.0";
  src = ./.;

  extraArgs = extraArgs'
    // listToAttrs (map (n: {
        name = "h${toString n}";
        value = text: extraArgs'.h n text;
      }) [ 1 2 3 4 5 6 ]
    );

  entries = [
    ./index.nix
    ./posts/index.nix
    ./posts/test.nix
  ];

  templates = [
    ./templates/base.nix
    ./templates/post.nix
  ];

  extraFiles = [
    { source = "./*.css"; destination = "/"; }
    { source = "./posts/*.css"; destination = "/posts"; }
  ];
}
