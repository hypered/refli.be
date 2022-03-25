#!/usr/bin/env bash

set -e

echo Employee, single
bats tests/publicodes-single.bats

echo Employee, married, one income
bats tests/publicodes-one-income.bats

echo Employee, married, two income
bats tests/publicodes-two-income.bats

echo Employee, single, disabled
bats tests/publicodes-single-disabled.bats

echo Employee, single, part-time
bats tests/publicodes-single-part-time.bats
