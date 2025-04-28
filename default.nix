let
  sources = import ./nix/sources.nix;
  overlays = import ./nix/overlays.nix;
  nixpkgs = import sources.nixpkgs { inherit overlays; };
in
{
  # Build with nix-build -A <attr>
  # This has links with no extensions.
  site = (import ./site).content;
  # This has .html links.
  public = (import ./site).html.all-with-static;
  static = (import ./site).static;
  static-joined = (import ./site).static-joined;
  favicon = (import ./site).favicon;

  # This is actually a library for now.
  binaries = nixpkgs.haskellPackages.refli-be;

  # Export some functions.
  inherit (import ./site) dirsToMds mdsToHtml;
}
