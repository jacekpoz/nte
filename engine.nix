pkgs: src: {extraArgs, entries, templates}: let
  inherit (pkgs) lib;

  inherit (builtins) abort dirOf toString;
  inherit (lib.attrsets) hasAttr;
  inherit (lib.lists) forEach findFirst;
  inherit (lib.path) removePrefix;
  inherit (lib.strings) concatMapStrings concatStrings escapeShellArg hasSuffix isString removeSuffix;
  inherit (lib.trivial) functionArgs;

  args = {inherit pkgs getEntry;}
    // (import ./stdlib.nix pkgs)
    // extraArgs;

  isBaseTemplate = template:
    isString template.output;

  findTemplateFile = entry: let
    _template = findFirst (templateFile: let
      templateFn = import templateFile;
      template = templateFn (functionArgs templateFn);
    in
      template.name == entry.template)
    null
    templates;
  in
    if _template == null then
      abort "unknown template `${entry.template}`"
    else
      _template;

  applyTemplate = entry: templateFile: let
    templateFn = import templateFile;
    template = templateFn (args // entry);
  in
    if isBaseTemplate template then {
      inherit (entry) file;
      inherit (template) output;
    }
    else let
      newEntry = template.output // {inherit (entry) file;};
      foundTemplateFile = findTemplateFile newEntry;
    in
      applyTemplate newEntry foundTemplateFile;

  replaceSuffix = from: to: string:
    if !(hasSuffix from string) then
      abort "invalid suffix `${from}` for string `${string}`"
    else
      concatStrings [ (removeSuffix from string) to ];

  getTemplateFormat = entry: templateFile: let
    templateFn = import templateFile;
    # getEntry needs to go down to the base template for the format
    # but any template through the way can ask for a file
    # so we just give it a placeholder - an empty string here
    # since the output of this thing doesn't matter
    template = templateFn (args // entry // { file = ""; });
  in
    if isBaseTemplate template then
      template.format
    else let
      newEntry = template.output;
      foundTemplateFile = findTemplateFile newEntry;
    in
      getTemplateFormat newEntry foundTemplateFile;

  getEntry = entryFile: let
    sourceFile = toString (removePrefix src entryFile);
    entry = (import entryFile) args;
    foundTemplateFile = findTemplateFile entry;
    entryFormat = getTemplateFormat entry foundTemplateFile;
  in
    if !(hasAttr "file" entry) then
      entry // {
        file = replaceSuffix ".nix" ".${entryFormat}" sourceFile;
      }
    else
      entry;

  processEntryFile = entryFile: let
    entry = getEntry entryFile;
    foundTemplateFile = findTemplateFile entry;
  in
    applyTemplate entry foundTemplateFile;

in /*sh*/''
  ${concatMapStrings
    (result: /*sh*/''
      mkdir -p $out/${dirOf result.file}
      echo ${escapeShellArg result.output} > $out/${result.file}
    '')
    (forEach entries processEntryFile)
  }
''
