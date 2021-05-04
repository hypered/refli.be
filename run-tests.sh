#!/usr/bin/env bash

echo Employee, single
./run-tests-single.sh

echo Employee, married, one income
./run-tests-one-income.sh

echo Employee, married, two income
./run-tests-two-income.sh

echo Employee, single, disabled
./run-tests-single-disabled.sh
