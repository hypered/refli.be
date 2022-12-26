let
  sources = import ./nix/sources.nix;
  overlays = import ./nix/overlays.nix;
  nixpkgs = import sources.nixpkgs { inherit overlays; };
in
{
  # Build with nix-build -A <attr>
  site = (import ./site).html.all;
}
