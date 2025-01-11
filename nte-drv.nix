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
}: let
  inherit (pkgs) lib;
  inherit (lib.attrsets) isAttrs;
  inherit (lib.lists) forEach init;
  inherit (lib.strings) concatStrings concatStringsSep match normalizePath optionalString splitString;
in pkgs.stdenv.mkDerivation {
  inherit name version src;

  inherit preBuild;

  buildPhase = /*sh*/''
    ${engine src {inherit extraArgs entries templates;}}
  '';

  inherit postBuild;

  inherit preInstall;

  installPhase = optionalString (extraFiles != []) /*sh*/''
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
  '';

  inherit postInstall;
}
