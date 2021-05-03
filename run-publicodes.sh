#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nodejs

# This runs the simple compensation formulas written in publicodes.
# Currently the inputs are hard-coded in the publicodes source.

function compute {
  node publicodes/script.mjs "publicodes/compensation.yaml" "$1"
}

compute "revenu brut mensuel"
compute "cotisations sociales personnelles"
compute "bonus à l'emploi pour les bas salaires"
compute "revenu brut imposable"
compute "précompte professionnel"
compute "réduction du précompte professionnel pour bas salaires"
compute "cotisation spéciale pour la sécurité sociale"
compute "revenu net"
