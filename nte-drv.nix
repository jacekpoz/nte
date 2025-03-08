pkgs: engine: {
  name,
  version,
  src,
  extraArgs ? {},
  entries ? [],
  templates ? [],
  extraFiles ? [],
  preBuild ? "",
  postBuild ? "",
  preInstall ? "",
  postInstall ? "",
  meta ? {},
}: let
  inherit (pkgs) lib;
  inherit (lib.attrsets) isAttrs;
  inherit (lib.lists) forEach init;
  inherit (lib.strings) concatStrings concatStringsSep match normalizePath optionalString splitString;
in pkgs.stdenv.mkDerivation {
  inherit name version src;

  inherit preBuild;

  buildPhase = /*sh*/''
    runHook preBuild

    ${engine src {inherit extraArgs entries templates;}}

    runHook postBuild
  '';

  inherit postBuild;

  inherit preInstall;

  installPhase = optionalString (extraFiles != []) /*sh*/''
    runHook preInstall

    mkdir -p $out

    ${concatStrings (forEach extraFiles
        (extraFile: let
          fileAttrs = if isAttrs extraFile
            then extraFile
            else { source = extraFile; destination = "/"; };

          isInSubdir = (match ".+/.*" fileAttrs.destination) != null;
          outDir = normalizePath "$out/${concatStringsSep "/" (init (splitString "/" fileAttrs.destination))}";
          outPath = normalizePath "$out/${fileAttrs.destination}";
        in /*sh*/''
          ${optionalString isInSubdir /*sh*/"mkdir -p ${outDir}"}
          cp -r ${fileAttrs.source} ${outPath}
        ''))
    }

    runHook postInstall
  '';

  inherit postInstall;

  inherit meta;
}
