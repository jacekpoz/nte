pkgs: {extraArgs, entries, templates}: let
  inherit (pkgs) lib;

  inherit (builtins) abort;
  inherit (lib.lists) elemAt forEach findFirst length remove;
  inherit (lib.strings) concatMapStrings concatStrings escapeShellArg isString splitString;
  inherit (lib.trivial) functionArgs;

  args = {inherit pkgs;}
    // (import ./stdlib.nix pkgs)
    // extraArgs;

  getDirectory = file: let
      splitPath = splitString "/" file;
      last = elemAt splitPath ((length splitPath) - 1);
    in
      concatStrings (remove last splitPath);

  findTemplateFile = entry:
    findFirst (templateFile: let
      templateFn = import templateFile;
      template = templateFn (functionArgs templateFn);
    in
      template.name == entry.template)
    null
    templates;

  applyTemplate = entry: templateFile: let
    templateFn = import templateFile;
    template = templateFn (args // entry);
  in
    if (isString template.output)
    then {
      inherit (entry) file;
      inherit (template) output;
    }
    else let
      newEntry = template.output;
      foundTemplateFile = findTemplateFile newEntry;
    in
    if foundTemplateFile == null then
      abort "template `${newEntry.template}` not found"
    else
      applyTemplate newEntry foundTemplateFile;

  processEntryFile = entryFile: let
    entryFn = import entryFile;
    entry = entryFn args;
    foundTemplateFile = findTemplateFile entry;
  in
    if foundTemplateFile == null then
      abort "template ${entry.template} not found"
    else
      applyTemplate entry foundTemplateFile;

in /*sh*/''
  ${concatMapStrings
    (result: /*sh*/''
      mkdir -p $out/${getDirectory result.file}
      echo ${escapeShellArg result.output} > $out/${result.file}
    '')
    (forEach entries processEntryFile)
  }
''
