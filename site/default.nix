let
  sources = import ../nix/sources.nix;
  overlays = import ../nix/overlays.nix;
  nixpkgs = import sources.nixpkgs { inherit overlays; };
  lib = nixpkgs.lib;

  design-system-version = "51694bea56d2e5c9545d88b35f11ccffbc536742";
  design-system = nixpkgs.fetchFromGitHub {
    owner = "hypered";
    repo = "design-system";
    rev = design-system-version;
    sha256 = "0wxvwwhj2xwhflnv02jffim4h6jgwziybv82z2mifmjczbvxhizn";
  };
  inherit (import design-system {}) lua-filter replace-md-links static;

  # Normally the template comes from design-system, but here we create a
  # custom one (mainly to get a custom footer).
  template = ./default.html;

  to-html-with-metadata = name: src: metadata:
    nixpkgs.runCommand "html" {} ''
    ${nixpkgs.pandoc}/bin/pandoc \
      --from markdown \
      --to html \
      --standalone \
      --template ${template} \
      -M prefix="" \
      -M font="ibm-plex" \
      --variable "this-file:${name}.md" \
      --lua-filter ${lua-filter} \
      --output $out \
      ${metadata} \
      ${src}
  '';

  to-html = name: src: to-html-with-metadata name src ./metadata.yml;

  dirsToMds = dir:
    lib.mapAttrs'
      (name: type: if type == "regular" || type == "symlink"
                   then lib.nameValuePair (lib.removeSuffix ".md" name) (dir + "/${name}")
                   else lib.nameValuePair name (dirsToMds (dir + "/${name}")))
      (lib.filterAttrs
        (name: type: lib.hasSuffix ".md" name || type == "directory")
        (builtins.readDir dir));

  mdsToHtml = dir:
    builtins.mapAttrs
      (name: src: if builtins.typeOf src == "path"
                  then to-html name src
                  else mdsToHtml src)
      dir;

in rec
{
  # nix-instantiate --eval --strict site/ -A md.pages.index
  md.pages = (dirsToMds ../pages);

  # nix-build site/ -A html.pages.index
  html.pages = mdsToHtml md.pages;

  html.all = nixpkgs.runCommand "all" {} ''
    mkdir -p $out/documentation

    cp ${html.pages.index}                $out/index.html
    cp ${html.pages.about}                $out/about.html
    cp ${html.pages.changelog}            $out/changelog.html
    cp ${html.pages.contact}              $out/contact.html
    cp ${html.pages.disclaimer}           $out/disclaimer.html
    cp ${html.pages.documentation.index}  $out/documentation.html
    cp ${html.pages.documentation.social} $out/documentation/social.html

    ${nixpkgs.bash}/bin/bash ${replace-md-links} $out
  '';

  # all + static, to serve locally with serve.sh
  html.all-with-static = nixpkgs.runCommand "all-with-static" {} ''
    mkdir $out
    cp -r ${html.all}/* $out/
    ln -s ${static} $out/static
  '';

  inherit static;
}
