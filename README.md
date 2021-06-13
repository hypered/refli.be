# Refli

Exploring how Belgian compensations are computed.


# Withholding tax

The withholding tax (or "précompte professionnel" in French) is described in
the Belgian official journal. The relevant parts are listed on the [FPS
Finance] website (although only in Dutch and French).

In particular there are three links. The data of the second one, [Barèmes 1er
janvier 2021], are available in source code form in
[`withholding-tax/scales.hs`](withholding-tax/scales.hs).

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


# Existing simulations

- CSC: [Calculez votre salaire en net](https://www.lacsc.be/outil-de-calcul/salaire-brut-net)
- FGTB: [Calculateur de salaire brut - net](https://www.fgtb.be/calcul-salaire-brut-net)
- Jobat: [Calculez votre salaire](https://www.jobat.be/fr/art/que-reste-t-il-de-mon-brut)
- Liantis: [Calculateur brut/net](https://www.liantis.be/fr/politique-du-personnel/remuneration/calculateur-brut-net)
- Partena Professional: [Simulateur de salaire brut-net](https://www.partena-professional.be/fr/knowledge-center/des-simulateurs-et-des-calculateurs/simulateur-de-salaire-brut-net)
- SD Worx: [Simulation salariale](www.sd.be/loonsimulator/public/?lang=FR)
- Securex: [Brut Net](https://hrcalculations.securex.eu/)

Some data collected manually using those simulations are in
[`tests/examples.hs`](tests/examples.hs).


# refli.be

[Refli.be](https://refli.be) is currently configured to serve the content of
the [`docs/`](docs/) directory through GitHub Pages.

This will be replaced by the result of building `site/`. The result can be
served locally with the `serve.sh` script.
