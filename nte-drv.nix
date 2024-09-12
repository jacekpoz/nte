pkgs: engine: {
  name,
  version,
  src,
  extraArgs ? {},
  entries ? [],
  templates ? [],
  extraFiles ? []
}: let
  inherit (pkgs) lib;
  inherit (lib.lists) forEach init;
  inherit (lib.strings) concatStrings match normalizePath optionalString splitString;
in pkgs.stdenv.mkDerivation {
  inherit name version src;

  buildPhase = /*sh*/''
    runHook preBuild

    ${engine src {inherit extraArgs entries templates;}}

    runHook postBuild
  '';

  installPhase = optionalString (extraFiles != []) /*sh*/''
    runHook preInstall

    mkdir -p $out

    ${concatStrings (forEach extraFiles
        (extraFile: let
          isInSubdir = (match ".+/.+" extraFile.destination) != null;
          outDir = concatStrings (init (splitString "/" extraFile.destination));
          outPath = normalizePath "$out/${extraFile.destination}";
        in /*sh*/''
          ${optionalString isInSubdir /*sh*/"mkdir -p ${outDir}"}
          cp -r ${extraFile.source} ${outPath}
        ''))
    }

    runHook postInstall
  '';
}
