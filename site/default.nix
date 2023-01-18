let
  sources = import ../nix/sources.nix;
  overlays = import ../nix/overlays.nix;
  nixpkgs = import sources.nixpkgs { inherit overlays; };
  lib = nixpkgs.lib;

  design-system-version = "d2ea2b56df1c4966e50ec2aff6e3d1dafa3415c0";
  design-system = nixpkgs.fetchFromGitHub {
    owner = "hypered";
    repo = "design";
    rev = design-system-version;
    hash = "sha256-AtnLoSa2B+aQKHAGVk0T8qM9L6z6lk8WOSB+/QyRG/4=";
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
    cp ${html.pages.documentation.withholding-tax} $out/documentation/withholding-tax.html
    cp ${html.pages.documentation.contributions} $out/documentation/contributions.html

    ${nixpkgs.bash}/bin/bash ${replace-md-links} $out /pages
  '';

  content = nixpkgs.runCommand "all" {} ''
    mkdir -p $out/documentation

    cp ${html.pages.index}                $out/index.html
    cp ${html.pages.about}                $out/about.html
    cp ${html.pages.changelog}            $out/changelog.html
    cp ${html.pages.contact}              $out/contact.html
    cp ${html.pages.disclaimer}           $out/disclaimer.html
    cp ${html.pages.documentation.index}  $out/documentation.html
    cp ${html.pages.documentation.social} $out/documentation/social.html
    cp ${html.pages.documentation.withholding-tax} $out/documentation/withholding-tax.html
    cp ${html.pages.documentation.contributions} $out/documentation/contributions.html

    ${nixpkgs.bash}/bin/bash ${replace-md-links} $out /pages 1
  '';

  # all + static, to serve locally with serve.sh
  html.all-with-static = nixpkgs.runCommand "all-with-static" {} ''
    mkdir $out
    cp -r ${html.all}/* $out/
    ln -s ${static} $out/static
  '';

  inherit static;
}
