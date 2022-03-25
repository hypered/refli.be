// Read a Publicodes file (i.e. some YAML) and evaluate some rules from
// compensation.yaml.
// Input variables can be set using `--set "rule name" "value"`.

import Engine, { formatValue } from 'publicodes';
import * as fs from 'fs';

// The filename to parse.
const source_file = process.argv[2];

// Read the file.
var rules;
try {
  rules = fs.readFileSync(source_file, 'utf8');
} catch (err) {
  console.error(err);
  process.exit(1);
}

// Initialize Publicodes.
const engine = new Engine(rules);

// Set the inputs.
var inputs = {};
for (let i = 3; i < process.argv.length; i+=3) {
  if (process.argv[i] != "--set") {
    console.error("ERROR: Expected --set");
    process.exit(1);
  }
  inputs[process.argv[i+1]] = process.argv[i+2];
}
engine.setSituation(inputs);

// Evaluate the Publicodes rules.
var rule_names = [
  "revenu brut mensuel",
  "cotisations sociales personnelles",
  "bonus à l'emploi pour les bas salaires",
  "revenu brut imposable",
  "précompte professionnel",
  "réduction du précompte professionnel pour bas salaires",
  "cotisation spéciale pour la sécurité sociale",
  "revenu net",
];

rule_names.forEach(function(rule_name) {
  const result = engine.evaluate(rule_name);
  console.log(`${rule_name}: ${formatValue(result)}.`);
});
