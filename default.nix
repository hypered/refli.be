{ nixpkgs ? <nixpkgs>
}:
let
  pkgs = import nixpkgs {};
in
{
  # Build with nix-build -A <attr>
  site = (import ./site {}).html.all;
}
