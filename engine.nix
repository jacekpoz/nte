pkgs: src: {extraArgs, entries, templates}: let
  inherit (pkgs) lib;

  inherit (builtins) abort dirOf toString;
  inherit (lib.attrsets) hasAttr;
  inherit (lib.lists) forEach findFirst;
  inherit (lib.path) removePrefix;
  inherit (lib.strings) concatMapStrings concatStrings escapeShellArg hasSuffix isString removeSuffix;
  inherit (lib.trivial) functionArgs;

  templates' = templates ++ [
    ({ format, output, ... }: {
      name = "passthrough";
      inherit format output;
    })
  ];

  args = {inherit pkgs getEntry applyTemplate;}
    // (import ./stdlib.nix pkgs)
    // extraArgs;

  isBaseTemplate = template:
    isString template.output;

  findTemplateFn = entry: let
    template = findFirst (templateFile: let
        templateFn = import templateFile;
        template' = templateFn (functionArgs templateFn);
      in
        template'.name == entry.template)
      null
      templates';
  in
    if template == null then
      abort "unknown template `${entry.template}`"
    else
      (import template);

  applyTemplate = templateFn: entry: let
    template = templateFn (args // entry);
  in
    if isBaseTemplate template then
      template.output
    else let
      newEntry = template.output;
      foundTemplateFn = findTemplateFn newEntry;
    in
      applyTemplate foundTemplateFn newEntry;

  applyTemplateFile = templateFn: entry: {
    inherit (entry) file;
    output = applyTemplate templateFn entry;
  };

  replaceSuffix = from: to: string:
    if !(hasSuffix from string) then
      abort "invalid suffix `${from}` for string `${string}`"
    else
      concatStrings [ (removeSuffix from string) to ];

  getTemplateFormat = entry: templateFn: let
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
      foundTemplateFn = findTemplateFn newEntry;
    in
      getTemplateFormat newEntry foundTemplateFn;

  getEntry = entryFile: let
    sourceFile = toString (removePrefix src entryFile);
    entry = (import entryFile) args;
    foundTemplateFn = findTemplateFn entry;
    entryFormat = getTemplateFormat entry foundTemplateFn;
  in
    if !(hasAttr "file" entry) then
      entry // {
        file = replaceSuffix ".nix" ".${entryFormat}" sourceFile;
      }
    else
      entry;

  processEntryFile = entryFile: let
    foundTemplateFn = findTemplateFn entry;
    entry = getEntry entryFile;
  in
    applyTemplateFile foundTemplateFn entry;

in /*sh*/''
  ${concatMapStrings
    (result: /*sh*/''
      mkdir -p $out/${dirOf result.file}
      echo ${escapeShellArg result.output} > $out/${result.file}
    '')
    (forEach entries processEntryFile)
  }
''
