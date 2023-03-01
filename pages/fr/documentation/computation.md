---
title: Le calcul du salaire
---

# Introduction

Cette page documente le calcul de salaire tel qu'il est implémenté par Refli.
En particulier, les exemples repris dans chaque section de cette page
correspondent aux opérations réalisées par Refli.

# Cotisations personnelles

La cotisation personnelle du travailleur se compose de 4 pourcentages à
additionner:

<!--# include virtual="/partials/fr/tables/personal-contributions" -->

Le total vaut
<!--# include virtual="/partials/fr/numbers/personal-contributions-ratio" -->%.
Il est à prélever sur 100% ou 108% du salaire brut suivant que l'on
est employé ou ouvrier.

Examples:

<!--# include virtual="/partials/fr/tables/personal-contributions-examples" -->


Source

:  La cotisation personnelle du travailleur est décrite sur [cette
page](https://www.socialsecurity.be/employer/instructions/dmfa/fr/latest/instructions/socialsecuritycontributions/contributions.html)
   du site portail de la sécurité sociale.

# Bonus à l'emploi

La cotisation personnelle du travailleur telle que calculée ci-dessus peut être
diminuée pour les bas salaires.

Examples:

<!--# include virtual="/partials/fr/tables/employment-bonus-examples" -->

Source

: - Le [bonus à
l'emploi](https://www.socialsecurity.be/employer/instructions/dmfa/fr/latest/instructions/deductions/workers_reductions/workbonus.html)
    sur le site portail de la sécurité sociale.
 - Les plafonds [mis à
   jour](https://www.socialsecurity.be/employer/instructions/dmfa/fr/latest/intermediates#bonus-a-l-emploi-plafonds).

# Cotisation spéciale

La cotisation spéciale pour la sécurité sociale est une retenue supplémentaire.
Elle varie en fonction de la situation familliale du travailleur, démultipliant
dès lors les examples possibles.

Examples pour le cas employé:

<!--# include virtual="/partials/fr/tables/special-contributions-employee-examples" -->

Examples pour le cas ouvrier:

<!--# include virtual="/partials/fr/tables/special-contributions-worker-examples" -->

# Méthode d'arrondi

Durant le calcul du salaire, certaines valeurs intermédiaires sont arrondies à
deux décimales. La "formule clé" produite par le SPF finance indique la méthode
d'arrondi à suivre. Le calcul du bonus à l'emploi semble suivre la même
méthode.

# Arrondi du précompte professionnel

Le précompte professionnel est calculé sur d'une part une base salariale
annuelle (alors que le calcul de salaire est mensuel) et d'autre part des
réductions aussi exprimées de façon annuelle.

Ce n'est qu'en fin de calcul du précompte qu'une division par douze a lieu.

Sur Refli, le détail des réductions accordées est présenté et leur somme peut
sembler ne pas donner le bon résultat.

Considérons un [salaire brut de 2500.00 EUR pour un employé
isolé](/fr/describe/2500.00?details). Après cotisations personnelles, il reste
un brut imposable de 2308.06 EUR. Le précompte, exprimé de façon annuelle, est
composé d'une base, d'une réduction "isolé" et d'une réduction "bas revenu".
Soit:

```
  4487.79   - 144.00   - 536.11
= 3807.68
   317.31 (après division par 12)
```

Si on exprime les montants de façon mensuelle, en divisant par 12 mais en
conservant suffisamment de précision, le précompte devient:

```
   373.9825 -  12.0000 -  44.6758 (division avec 4 chiffres après la virgule)
=  317.3067
   317.31 (après arrondi final)
```

Par contre, si on exprime les montants de façon mensuelle mais en effectuant
déjà un arrondi à deux décimales:

```
   373.98   -  12.00   -  44.68 (division avec 2 chiffres après la virgule)
=  317.30
```

Nous pouvons observer 0.01 EUR de différence et la valeur correcte est bien
317.31 EUR. Eventuellement, nous pourions choisir de les afficher avec une
précision plus élevée dans le futur (comme ci-dessus).
