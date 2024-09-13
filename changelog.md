# 0.1.0
- made this

# 0.2.0
- made `file` in entries optional

# 0.3.0
- set nixpkgs input as unstable by default
- added `github:nix-systems/default` as an input
- moved the following outputs:
    - `engines.${system}.default` -> `functions.${system}.engine`
- introduced `mkNteDerivation` helper function (`functions.${system}.mkNteDerivation`)

# 0.3.1
- improved engine code readability a bit
- exposed `applyTemplate` so that users can do templating inside a single file

# 0.3.2
- allow the use of raw paths alongside attrsets in `extraFiles`
