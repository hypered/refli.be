#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nodejs

# This runs the simple compensation formulas written in publicodes.

node publicodes/script.mjs "publicodes/compensation.yaml" "$@"
