pkgs: let
  inherit (pkgs) lib runCommand;
  inherit (lib.strings) readFile;
in {
  run = script: readFile (runCommand "run" {} ''
    echo $(${script}) > $out
  '');
}
