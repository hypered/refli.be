#!/usr/bin/env bats

# This checks the simple Publicodes compensation rules against known values.

@test "simple case 1800 EUR" {
  run ./run-publicodes.sh
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "revenu brut mensuel: 1 800 EUR." ]
  [ "${lines[1]}" = "cotisations sociales personnelles: 235,26 EUR." ]
  [ "${lines[2]}" = "bonus à l'emploi pour les bas salaires: 178,11 EUR." ]
  [ "${lines[3]}" = "revenu brut imposable: 1 742,85 EUR." ]
  [ "${lines[4]}" = "précompte professionnel: 191,25 EUR." ]
  [ "${lines[5]}" = "réduction du précompte professionnel pour bas salaires: 59,03 EUR." ]
  [ "${lines[6]}" = "cotisation spéciale pour la sécurité sociale: 0 EUR." ]
  [ "${lines[7]}" = "revenu net: 1 610,63 EUR." ]
}

@test "simple case 3600 EUR" {
  run ./run-publicodes.sh \
    --set "revenu brut mensuel" 3600
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "revenu brut mensuel: 3 600 EUR." ]
  [ "${lines[1]}" = "cotisations sociales personnelles: 470,52 EUR." ]
  [ "${lines[2]}" = "bonus à l'emploi pour les bas salaires: 0 EUR." ]
  [ "${lines[3]}" = "revenu brut imposable: 3 129,48 EUR." ]
  [ "${lines[4]}" = "précompte professionnel: 837,4 EUR." ]
  [ "${lines[5]}" = "réduction du précompte professionnel pour bas salaires: 0 EUR." ]
  [ "${lines[6]}" = "cotisation spéciale pour la sécurité sociale: 34,11 EUR." ]
  [ "${lines[7]}" = "revenu net: 2 257,97 EUR." ]
}
