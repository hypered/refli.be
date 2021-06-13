{ nixpkgs ? <nixpkgs>
}:

let
  pkgs = import nixpkgs {};
  lib = pkgs.lib;

  design-system-version = "51694bea56d2e5c9545d88b35f11ccffbc536742";
  design-system = pkgs.fetchFromGitHub {
    owner = "hypered";
    repo = "design-system";
    rev = design-system-version;
    sha256 = "0wxvwwhj2xwhflnv02jffim4h6jgwziybv82z2mifmjczbvxhizn";
  };
  inherit (import design-system {}) lua-filter replace-md-links static;

  # Normally the template comes from design-system, but here we create a
  # custom one (mainly to get a custom footer).
  template = ./default.html;

  to-html-with-metadata = src: metadata:
    pkgs.runCommand "html" {} ''
    ${pkgs.pandoc}/bin/pandoc \
      --from markdown \
      --to html \
      --standalone \
      --template ${template} \
      -M prefix="" \
      -M font="ibm-plex" \
      --lua-filter ${lua-filter} \
      --output $out \
      ${metadata} \
      ${src}
  '';

  to-html = src: to-html-with-metadata src ./metadata.yml;

  dirsToMds = dir:
    lib.mapAttrs'
      (n: v: if v == "regular" || v == "symlink"
             then lib.nameValuePair (lib.removeSuffix ".md" n) (dir + "/${n}")
             else lib.nameValuePair n (dirsToMds (dir + "/${n}")))
      (lib.filterAttrs
        (name: _: lib.hasSuffix ".md" name)
        (builtins.readDir dir));

in rec
{
  # nix-instantiate --eval --strict site/ -A md.pages.index
  md.pages = (dirsToMds ../pages);

  # nix-build site/ -A html.pages.index
  html.pages = builtins.mapAttrs (_: v: to-html v) md.pages;

  html.all = pkgs.runCommand "all" {} ''
    mkdir -p $out/

    cp ${html.pages.index}      $out/index.html
    cp ${html.pages.about}      $out/about.html
    cp ${html.pages.contact}    $out/contact.html
    cp ${html.pages.disclaimer} $out/disclaimer.html

    ${pkgs.bash}/bin/bash ${replace-md-links} $out
  '';

  # all + static, to serve locally with serve.sh
  html.all-with-static = pkgs.runCommand "all-with-static" {} ''
    mkdir $out
    cp -r ${html.all}/* $out/
    ln -s ${static} $out/static
  '';

  inherit static;
}
