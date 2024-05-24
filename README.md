<div align="center">
    <img src="logo/nte.svg" width="200" />
    <br />
    <h1>nte</h1>
</div>

nix template engine - takes some templates, entries and applies the templates to the entries

# examples

check `example/` for a static website written in nte

build and run it using `nix shell nixpkgs#darkhttpd --command sh -c "nix build -L .#examples.x86_64-linux.default && darkhttpd ./result"`; the site will be available at http://localhost:8080

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

- `extraArgs` - an attrset of additional arguments passed to all entries and templates
- `entries` - a list of all entry files to be processed
- `templates` - a list of all template files to be applied

and returns a string containing a shell script that applies the templates to the entries

here's an example usage inside of another derivation:
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

nte offers a standard library that contains `nixpkgs` and utility functions found in [stdlib.nix](./stdlib.nix)

## templates

a template can take an arbitrary number of arguments and returns `{ name, output }`

example template:
```nix
{
  name,
  location,
  info,
  ...
}: {
  name = "greeting";
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
} @ extraArgs : let
  inherit (extraArgs) file;
in {
  name = "greeting-with-date";
  output = {
    template = "greeting";
    inherit file;

    inherit name location;

    info = ''
      You're visiting ${location} on ${date} at ${time}!
    '';
  };
}
```

## entries

an entry can take an arbitrary number of arguments and returns `{ template, file, ... }`, the `...` being the desired template's arguments (sans `extraArgs`, those are passed either way)

example entries (using the previous example templates):
```nix
_: {
  template = "greeting";
  file = "wroclaw/welcome-jacek.txt";

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
  file = "osieck/welcome-rafal.txt";
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

# license
MIT
