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
    mkdir -p $out/.well-known
    mkdir -p $out/fr/documentation/computation
    mkdir -p $out/{en,nl}/documentation

    cp ${html.pages.changelog}               $out/changelog.html
    cp ${html.pages.en.about}                $out/en/about.html
    cp ${html.pages.en.contact}              $out/en/contact.html
    cp ${html.pages.en.disclaimer}           $out/en/disclaimer.html
    cp ${html.pages.en.documentation.index}  $out/en/documentation.html

    cp ${html.pages.fr.index}                $out/fr/index.html
    cp ${html.pages.fr.about}                $out/fr/about.html
    cp ${html.pages.fr.contact}              $out/fr/contact.html
    cp ${html.pages.fr.disclaimer}           $out/fr/disclaimer.html
    cp ${html.pages.fr.documentation.index}  $out/fr/documentation.html

    cp ${html.pages.nl.about}                $out/nl/about.html
    cp ${html.pages.nl.contact}              $out/nl/contact.html
    cp ${html.pages.nl.disclaimer}           $out/nl/disclaimer.html
    cp ${html.pages.nl.documentation.index}  $out/nl/documentation.html

    cp ${html.pages.fr.documentation.computation.index} \
      $out/fr/documentation/computation.html
    cp ${html.pages.fr.documentation.computation.contribution} \
      $out/fr/documentation/computation/contribution.html
    cp ${html.pages.fr.documentation.computation.tax} \
      $out/fr/documentation/computation/tax.html
    cp ${html.pages.fr.documentation.computation.rounding} \
      $out/fr/documentation/computation/rounding.html
    cp ${html.pages.fr.documentation.social} $out/fr/documentation/social.html
    cp ${html.pages.fr.documentation.secretariats} \
      $out/fr/documentation/secretariats.html
    cp ${html.pages.fr.documentation.withholding-tax} \
      $out/fr/documentation/withholding-tax.html
    cp ${html.pages.fr.documentation.contributions} \
      $out/fr/documentation/contributions.html
    cp ${html.pages.fr.documentation.ssi}    $out/fr/documentation/ssi.html

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
