<div align="center">
    <img src="branding/nte-colors.svg" width="200" />
    <br />
    <h1>nte</h1>
</div>

nix template engine - takes some templates, entries and applies the templates to the entries

# sites written in nte
https://jacekpoz.pl

if your site (or anything else) is written in nte, let me know and I'll add you to this list

you can also use this button on your site and link to one of the repos

[<img src="branding/powered-by-nte.png">](https://git.jacekpoz.pl/jacekpoz/nte)

# examples

check `example/` for a static website written in nte

build and run it using 
```sh
nix shell nixpkgs#darkhttpd --command sh -c "nix build -L .#examples.x86_64-linux.default && darkhttpd ./result"
```
the site will be available at http://localhost:8080

the example is a cut down version of [my own website](https://jacekpoz.pl) (of course also written in nte)

# usage

first add nte as an input in your project's flake

```nix
nte = {
  url = "git+https://git.jacekpoz.pl/jacekpoz/nte";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

then the engine function will be available under
```nix
inputs.nte.engines.${system}.default
```
it accepts 3 arguments:

- `pkgs` - nixpkgs
- `src` - the directory containing all entries and templates
- an attrset of:
    - `extraArgs` - an attrset of additional arguments passed to all entries and templates
    - `entries` - a list of all entry files to be processed
    - `templates` - a list of all template files to be applied

and returns a string containing a shell script that applies the templates to the entries

the flake gives the engine `pkgs`, so when passing the engine function to a derivation, only provide it with the source directory:
```nix
import ./project/default.nix {
  # ...
  nte = nte.engines.${system}.default ./project;
};
```
then you can use it as in the example derivation below:
```nix
{
  nte,
  stdenv,
  ...
}: let
  extraArgs = {
    foo = 2137;
    bar = "dupa";
    baz = arg1: arg2: ''
      here's arg1: ${arg1}
      and here's arg2: ${arg2}
    '';
  };

  entries = [
    ./entry1.nix
    ./foo/entry2.nix
    ./foo/entry3.nix
    ./bar/entry4.nix
    ./bar/entry5.nix
    ./bar/entry6.nix
  ];

  templates = [
    ./template1.nix
    ./template2.nix
  ];
in
  stdenv.mkDerivation {
    name = "nte-example";
    version = "0.1";
    src = ./.;
  
    buildPhase = ''
      runHook preBuild

      ${nte {inherit extraArgs entries templates;}}
  
      runHook postBuild
    '';
  }
```

nte will handle creating directories if your source file structure isn't flat

nte offers a standard library that contains `nixpkgs`, a `getEntry` function that handles an entry's `file` and utility functions found in [stdlib.nix](./stdlib.nix)

## templates

a template can take an arbitrary number of arguments and returns `{ name, format, output }`:

- `name` - used as a template ID for the entries
- `format` - the extension of the output file (ignored if an entry defines `file`)
- `output` - string if in a base template, entry to another template otherwise

example template:
```nix
{
  name,
  location,
  info,
  ...
}: {
  name = "greeting";
  format = "txt";

  output = ''
    Hello ${name}! Welcome to ${location}.

    Here's some more information:
    ${info}
  '';
}
```

a template's output can also be an entry to another template:
```nix
{
  name,
  location,
  date,
  time,
  ...
}: {
  name = "greeting-with-date";
  output = {
    template = "greeting";

    inherit name location;

    info = ''
      You're visiting ${location} on ${date} at ${time}!
    '';
  };
}
```
a template that's inherited from a different template also inherits its format - no need to define it again

## entries

an entry can take an arbitrary number of arguments and returns `{ template, ... }`, the `...` being the desired template's arguments (sans `extraArgs`, those are passed either way)

example entries (using the previous example templates):
```nix
_: {
  template = "greeting";

  name = "Jacek";
  location = "Wrocław";
  info = ''
    As of 2023, the official population of Wrocław is 674132 making it the third largest city in Poland.
  '';
}
```
an entry using the stdlib:
```nix
{
  run,
  ...
}: {
  template = "greeting-with-date";

  name = "Rafał";
  location = "Osieck";
  date = run "date +%F";
  time = run "date +%T";
}
```
if a binary isn't in `$PATH`, remember that each entry gets `pkgs`:
```nix
{
  pkgs,
  run,
  ...
}: let
  date = "${pkgs.coreutils-full}/bin/date";
in {
  # ...
  date = run "${date} +%F";
  time = run "${date} +%T";
}
```

nte by default will follow your source file structure, if you want to specify the output location yourself use `file`:
```nix
_: {
  # ...
  file = "foo/bar.txt";
}
```
in this example the output of this entry will end up at `$out/foo/bar.txt` instead of the default location - a base template's `format` will also be ignored

# license
MIT
