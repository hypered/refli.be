// Read a Publicodes file (i.e. some YAML) and evaluate a rule.

import Engine, { formatValue } from 'publicodes';
import * as fs from 'fs';

// The filename to parse, and the rule to evaluate.
const source_file = process.argv[2];
const rule_name = process.argv[3];

// Read the file.
var rules;
try {
  rules = fs.readFileSync(source_file, 'utf8');
} catch (err) {
  console.error(err);
  process.exit(1);
}

// Run the Publicodes rule.
const engine = new Engine(rules);
const result = engine.evaluate(rule_name);
console.log(`${rule_name}: ${formatValue(result)}.`);
