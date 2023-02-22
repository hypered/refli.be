let
  sources = import ../nix/sources.nix;
  overlays = import ../nix/overlays.nix;
  nixpkgs = import sources.nixpkgs { inherit overlays; };
  lib = nixpkgs.lib;

  inherit (sources) hypered-design;
  inherit (import hypered-design) lua-filter replace-md-links static;

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

  # This has unprocessed links.
  html.unprocessed = nixpkgs.runCommand "all" {} ''
    mkdir -p $out/{documentation,.well-known}

    cp ${html.pages.index}                $out/index.html
    cp ${html.pages.about}                $out/about.html
    cp ${html.pages.changelog}            $out/changelog.html
    cp ${html.pages.contact}              $out/contact.html
    cp ${html.pages.disclaimer}           $out/disclaimer.html
    cp ${html.pages.documentation.index}  $out/documentation.html
    cp ${html.pages.documentation.social} $out/documentation/social.html
    cp ${html.pages.documentation.secretariats} $out/documentation/secretariats.html
    cp ${html.pages.documentation.withholding-tax} $out/documentation/withholding-tax.html
    cp ${html.pages.documentation.contributions} $out/documentation/contributions.html
    cp ${html.pages.documentation.ssi}    $out/documentation/ssi.html

    cp ${../content/robots.txt} $out/robots.txt
    cp ${../content/humans.txt} $out/humans.txt
    cp ${../content/.well-known/security.txt} $out/.well-known/security.txt
    cp ${../content/index.xml} $out/index.xml
    gzip --best --stdout ${../content/sitemap-0.xml} > $out/sitemap-0.xml.gz
  '';

  # This has links with no extensions.
  content = nixpkgs.runCommand "all" {} ''
    mkdir $out
    cp -r --no-preserve=mode ${html.unprocessed}/* $out/

    ${nixpkgs.bash}/bin/bash ${replace-md-links} $out /pages 1
  '';

  # This has .html links.
  html.all = nixpkgs.runCommand "all" {} ''
    mkdir $out
    cp -r --no-preserve=mode ${html.unprocessed}/* $out/

    ${nixpkgs.bash}/bin/bash ${replace-md-links} $out /pages
  '';

  # all + static, to serve locally with scripts/serve.sh
  html.all-with-static = nixpkgs.runCommand "all-with-static" {} ''
    mkdir $out
    cp -r ${html.all}/* $out/
    ln -s ${static} $out/static
    ln -s ${favicon} $out/favicon.ico
  '';

  favicon = ../images/favicon.ico;

  inherit static;
}
