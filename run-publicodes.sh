#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nodejs

# This runs the simple compensation formulas written in publicodes. This
# assumes some node_modules dependencies (see the .github workflow for an
# example setup command).

node publicodes/script.mjs "publicodes/compensation.yaml" "$@"
