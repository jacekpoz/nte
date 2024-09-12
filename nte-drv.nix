pkgs: engine: {
  name,
  version,
  src,
  extraArgs ? {},
  entries ? [],
  templates ? [],
}: pkgs.stdenv.mkDerivation {
  inherit name version src;

  buildPhase = /*sh*/''
    runHook preBuild

    ${engine src {inherit extraArgs entries templates;}}

    runHook postBuild
  '';
}
