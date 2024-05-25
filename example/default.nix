{
  lib,
  nte,
  stdenv,
  ...
}: let
  inherit (lib.attrsets) listToAttrs;
  inherit (lib.lists) map;
  inherit (lib.strings) replaceStrings toLower;

  _nte = nte {inherit extraArgs entries templates;};

  extraArgs = {
    inherit (_nte) getEntry;
    h = n: content: let
      id = replaceStrings [" " ";"] ["-" "-"] (toLower content);
    in /*html*/''
      <h${toString n} id="${id}"><a href="#${id}">#</a> ${content}</h${toString n}>
    '';
  }
  // listToAttrs (map (n: {
      name = "h${toString n}";
      value = text: extraArgs.h n text;
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
in
  stdenv.mkDerivation {
    name = "nte-example";
    version = "0.1.0";
    src = ./.;

    buildPhase = /*sh*/''
      runHook preBuild

      ${_nte.buildScript}

      runHook postBuild
    '';

    installPhase = /*sh*/''
      runHook preInstall

      mkdir -p $out
      cp -r ./*.css $out
      cp -r ./posts/*.css $out/posts

      runHook postInstall
    '';
  }
