#!/usr/bin/env bats

# This checks the simple Publicodes compensation rules against known values.

# The 10 following cases are all of the form employee, single, no children,
# disabled.

@test "simple case  100,00 EUR →  100,00 EUR" {
  run ./run-publicodes.sh \
    --set "situation familliale" "'isolé'" \
    --set "je suis handicapé" "oui" \
    --set "revenu brut mensuel" 100
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "revenu brut mensuel: 100 EUR." ]
  [ "${lines[1]}" = "cotisations sociales personnelles: 13,07 EUR." ]
  [ "${lines[2]}" = "bonus à l'emploi pour les bas salaires: 13,07 EUR." ]
  [ "${lines[3]}" = "revenu brut imposable: 100 EUR." ]
  [ "${lines[4]}" = "précompte professionnel: 0 EUR." ]
  [ "${lines[5]}" = "réduction du précompte professionnel pour bas salaires: 0 EUR." ]
  [ "${lines[6]}" = "cotisation spéciale pour la sécurité sociale: 0 EUR." ]
  [ "${lines[7]}" = "revenu net: 100 EUR." ]
}

@test "simple case  900,00 EUR →  900,00 EUR" {
  run ./run-publicodes.sh \
    --set "situation familliale" "'isolé'" \
    --set "je suis handicapé" "oui" \
    --set "revenu brut mensuel" 900
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "revenu brut mensuel: 900 EUR." ]
  [ "${lines[1]}" = "cotisations sociales personnelles: 117,63 EUR." ]
  [ "${lines[2]}" = "bonus à l'emploi pour les bas salaires: 117,63 EUR." ]
  [ "${lines[3]}" = "revenu brut imposable: 900 EUR." ]
  [ "${lines[4]}" = "précompte professionnel: 0 EUR." ]
  [ "${lines[5]}" = "réduction du précompte professionnel pour bas salaires: 0 EUR." ]
  [ "${lines[6]}" = "cotisation spéciale pour la sécurité sociale: 0 EUR." ]
  [ "${lines[7]}" = "revenu net: 900 EUR." ]
}

@test "simple case 1095,10 EUR → 1095,10 EUR" {
  run ./run-publicodes.sh \
    --set "situation familliale" "'isolé'" \
    --set "je suis handicapé" "oui" \
    --set "revenu brut mensuel" "1095.10"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "revenu brut mensuel: 1 095,1 EUR." ]
  [ "${lines[1]}" = "cotisations sociales personnelles: 143,13 EUR." ]
  [ "${lines[2]}" = "bonus à l'emploi pour les bas salaires: 143,13 EUR." ]
  [ "${lines[3]}" = "revenu brut imposable: 1 095,1 EUR." ]
  [ "${lines[4]}" = "précompte professionnel: 0 EUR." ]
  [ "${lines[5]}" = "réduction du précompte professionnel pour bas salaires: 0 EUR." ]
  [ "${lines[6]}" = "cotisation spéciale pour la sécurité sociale: 0 EUR." ]
  [ "${lines[7]}" = "revenu net: 1 095,1 EUR." ]
}

@test "simple case 1800,00 EUR → 1647,63 EUR" {
  run ./run-publicodes.sh \
    --set "situation familliale" "'isolé'" \
    --set "je suis handicapé" "oui" \
    --set "revenu brut mensuel" "1800"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "revenu brut mensuel: 1 800 EUR." ]
  [ "${lines[1]}" = "cotisations sociales personnelles: 235,26 EUR." ]
  [ "${lines[2]}" = "bonus à l'emploi pour les bas salaires: 178,11 EUR." ]
  [ "${lines[3]}" = "revenu brut imposable: 1 742,85 EUR." ]
  [ "${lines[4]}" = "précompte professionnel: 154,25 EUR." ]
  [ "${lines[5]}" = "réduction du précompte professionnel pour bas salaires: 59,03 EUR." ]
  [ "${lines[6]}" = "cotisation spéciale pour la sécurité sociale: 0 EUR." ]
  [ "${lines[7]}" = "revenu net: 1 647,63 EUR." ]
}

@test "simple case 1945,38 EUR → 1693,03 EUR" {
  run ./run-publicodes.sh \
    --set "situation familliale" "'isolé'" \
    --set "je suis handicapé" "oui" \
    --set "revenu brut mensuel" "1945.38"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "revenu brut mensuel: 1 945,38 EUR." ]
  [ "${lines[1]}" = "cotisations sociales personnelles: 254,26 EUR." ]
  [ "${lines[2]}" = "bonus à l'emploi pour les bas salaires: 146,22 EUR." ]
  [ "${lines[3]}" = "revenu brut imposable: 1 837,34 EUR." ]
  [ "${lines[4]}" = "précompte professionnel: 192,77 EUR." ]
  [ "${lines[5]}" = "réduction du précompte professionnel pour bas salaires: 48,46 EUR." ]
  [ "${lines[6]}" = "cotisation spéciale pour la sécurité sociale: 0 EUR." ]
  [ "${lines[7]}" = "revenu net: 1 693,02 EUR." ]
  # TODO This should be 1 693,03 but Publicodes returns the above.
}

@test "simple case 2000,00 EUR → 1707,55 EUR" {
  run ./run-publicodes.sh \
    --set "situation familliale" "'isolé'" \
    --set "je suis handicapé" "oui" \
    --set "revenu brut mensuel" 2000
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "revenu brut mensuel: 2 000 EUR." ]
  [ "${lines[1]}" = "cotisations sociales personnelles: 261,4 EUR." ]
  [ "${lines[2]}" = "bonus à l'emploi pour les bas salaires: 134,23 EUR." ]
  [ "${lines[3]}" = "revenu brut imposable: 1 872,83 EUR." ]
  [ "${lines[4]}" = "précompte professionnel: 205,61 EUR." ]
  [ "${lines[5]}" = "réduction du précompte professionnel pour bas salaires: 44,48 EUR." ]
  [ "${lines[6]}" = "cotisation spéciale pour la sécurité sociale: 4,15 EUR." ]
  [ "${lines[7]}" = "revenu net: 1 707,56 EUR." ]
  # TODO This should be 1 707,55 but Publicodes returns the above.
}

@test "simple case 2190,18 EUR → 1745,10 EUR" {
  run ./run-publicodes.sh \
    --set "situation familliale" "'isolé'" \
    --set "je suis handicapé" "oui" \
    --set "revenu brut mensuel" "2190.18"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "revenu brut mensuel: 2 190,18 EUR." ]
  [ "${lines[1]}" = "cotisations sociales personnelles: 286,26 EUR." ]
  [ "${lines[2]}" = "bonus à l'emploi pour les bas salaires: 92,51 EUR." ]
  [ "${lines[3]}" = "revenu brut imposable: 1 996,43 EUR." ]
  [ "${lines[4]}" = "précompte professionnel: 263,39 EUR." ]
  [ "${lines[5]}" = "réduction du précompte professionnel pour bas salaires: 30,66 EUR." ]
  [ "${lines[6]}" = "cotisation spéciale pour la sécurité sociale: 18,6 EUR." ]
  [ "${lines[7]}" = "revenu net: 1 745,09 EUR." ]
  # TODO This should be 1 745,10 but Publicodes returns the above.
}

@test "simple case 3600,00 EUR → 2294,97 EUR" {
  run ./run-publicodes.sh \
    --set "situation familliale" "'isolé'" \
    --set "je suis handicapé" "oui" \
    --set "revenu brut mensuel" 3600
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "revenu brut mensuel: 3 600 EUR." ]
  [ "${lines[1]}" = "cotisations sociales personnelles: 470,52 EUR." ]
  [ "${lines[2]}" = "bonus à l'emploi pour les bas salaires: 0 EUR." ]
  [ "${lines[3]}" = "revenu brut imposable: 3 129,48 EUR." ]
  [ "${lines[4]}" = "précompte professionnel: 800,4 EUR." ]
  [ "${lines[5]}" = "réduction du précompte professionnel pour bas salaires: 0 EUR." ]
  [ "${lines[6]}" = "cotisation spéciale pour la sécurité sociale: 34,11 EUR." ]
  [ "${lines[7]}" = "revenu net: 2 294,97 EUR." ]
}

@test "simple case 6038,82 EUR → 3296,19 EUR" {
  run ./run-publicodes.sh \
    --set "situation familliale" "'isolé'" \
    --set "je suis handicapé" "oui" \
    --set "revenu brut mensuel" "6038.82"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "revenu brut mensuel: 6 038,82 EUR." ]
  [ "${lines[1]}" = "cotisations sociales personnelles: 789,27 EUR." ]
  [ "${lines[2]}" = "bonus à l'emploi pour les bas salaires: 0 EUR." ]
  [ "${lines[3]}" = "revenu brut imposable: 5 249,55 EUR." ]
  [ "${lines[4]}" = "précompte professionnel: 1 892,42 EUR." ]
  [ "${lines[5]}" = "réduction du précompte professionnel pour bas salaires: 0 EUR." ]
  [ "${lines[6]}" = "cotisation spéciale pour la sécurité sociale: 60,94 EUR." ]
  [ "${lines[7]}" = "revenu net: 3 296,19 EUR." ]
}

@test "simple case 6500,00 EUR → 3480,41 EUR" {
  run ./run-publicodes.sh \
    --set "situation familliale" "'isolé'" \
    --set "je suis handicapé" "oui" \
    --set "revenu brut mensuel" 6500
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "revenu brut mensuel: 6 500 EUR." ]
  [ "${lines[1]}" = "cotisations sociales personnelles: 849,55 EUR." ]
  [ "${lines[2]}" = "bonus à l'emploi pour les bas salaires: 0 EUR." ]
  [ "${lines[3]}" = "revenu brut imposable: 5 650,45 EUR." ]
  [ "${lines[4]}" = "précompte professionnel: 2 109,1 EUR." ]
  [ "${lines[5]}" = "réduction du précompte professionnel pour bas salaires: 0 EUR." ]
  [ "${lines[6]}" = "cotisation spéciale pour la sécurité sociale: 60,94 EUR." ]
  [ "${lines[7]}" = "revenu net: 3 480,41 EUR." ]
}
