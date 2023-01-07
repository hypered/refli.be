# Refli

→ Exploring how Belgian compensations are computed.

The goal of Refli is to make Belgian employee compensation rules approachable
for everyone, by providing documentation, data, and computation tools. Those
should be relevant for everyone, including professionals and developers.

This project is currently in an early stage.


# Withholding tax

The withholding tax (or "précompte professionnel" in French) is described in
the Belgian official journal. The relevant parts are listed on the [FPS
Finance] website (although only in Dutch and French).

In particular there are three links. The data of the second one, [Barèmes 1er
janvier 2021], are available in source code form in
[`Refli.Data.Scales`](src/Refli/Data/Scales.hs).

[FPS Finance]:
https://finances.belgium.be/fr/entreprises/personnel_et_remuneration/precompte_professionnel/calcul
[Barèmes 1er janvier 2021]:
https://finances.belgium.be/sites/default/files/Bar%C3%A8mes%201er%20janvier%202021%20%28AR%2016%20d%C3%A9cembre%202020%29.pdf


# Publicodes

A simple set of rules written in Publicodes to compute a net revenue given a
gross income is provided in
[`publicodes/compensation.yaml`](publicodes/compensation.yaml).

Provided the `publicodes` NPM package is installed, displaying the result with
intermediate values can be done with the helper script `run-publicodes.sh`.

Some code in `compensation.yaml` is generated with the
`withholding-tax/scales.hs` script. E.g.:

```
$ nix-shell --run 'runghc -isrc/ -XNoImplicitPrelude withholding-tax/scales.hs worker-scale-1'
```


# Existing simulations

- Acerta: [Calculateur
  brut/net](https://www.acerta.be/fr/portail-client/employeurs/votre-guide-acerta/simulations-et-verifications-rapides/calculateur-brut-net)
- Attentia: [Calculez votre
  salaire](https://www.attentia.be/fr/outil/easy-payroll/brut-net-calculateur)
(powered by Jobat)
- Bright Plus: [Calculez votre salaire
  net](https://www.brightplus.be/fr/tools/calculateur-brut-net)
- CSC: [Calculez votre salaire en
  net](https://www.lacsc.be/outil-de-calcul/salaire-brut-net)
- FGTB: [Calculateur de salaire brut -
  net](https://www.fgtb.be/calcul-salaire-brut-net)
- Group S: [Salary Sim](https://online.groups.be/salarysim/ibrunet.aspx?lg=fr)
- HelloSafe: [Calcul salaire brut en
  net](https://hellosafe.be/outils/salaire-brut-en-net) (can be embedded)
- Jobat: [Calculez votre salaire](https://www.jobat.be/fr/art/que-reste-t-il-de-mon-brut)
- Kluwer: [Brut-Net](https://tools.kluwer.be/Brut-Net/)
- Liantis: [Calculateur
  brut/net](https://www.liantis.be/fr/politique-du-personnel/remuneration/calculateur-brut-net)
- Partena Professional: [Simulateur de salaire
  brut-net](https://www.partena-professional.be/fr/knowledge-center/des-simulateurs-et-des-calculateurs/simulateur-de-salaire-brut-net)
- References (Le Soir): [Calculateur
  brut/net](https://references.lesoir.be/article/calculateur-brut-net/)
  (powered by SD Worx)
- SD Worx: [Simulation salariale](https://www.sd.be/loonsimulator/public/?lang=FR)
- Securex: [Brut Net](https://hrcalculations.securex.eu/)
- SSN (Fednot): [Calculateur
  brut-net](https://www.ssn.be/fr/e-tools/calculateur-brut-net) (specific to
  notaries)
- Talent: [Calcul du salaire brut /
  net](https://be.talent.com/fr/tax-calculator?from=month&region=Belgium)

Some data collected manually using those simulations are in
[`tests/examples.hs`](tests/examples.hs).

# Serving refli.be

The `refli.be` website is running some closed source code, but most of its
content is a set of static files defined in this repository. To create a root
directory and serve it locally, use the `scripts/serve.sh` script:

```
$ scripts/serve.sh
/nix/store/bh131nxx7rpgmlsb72l8anlx53kxdc92-all-with-static
You can now visit http://127.0.0.1:9000/.
^C
```

Under NixOS, adding an Nginx virtual host looks like this (where `refli-be` is
this directory, and `static` is provided by
[`hypered/design`](https://github.be/hypered/design)):

```
    virtualHosts."refli.be" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/".alias = (import refli-be {}).site + "/";
        "/static/".alias = static + "/";
      };
    };
```

Note: Some pages use HTML comments triggering the SSI (server-side include)
feature of Nginx. It means they pull some additional content served, normally,
by the closed source backend.

# refli.be

[Refli.be](https://refli.be) is hosted on a droplet at Digital Ocean.
