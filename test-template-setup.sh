#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

if ! git diff --quiet; then
  echo
  printf "\e[31mError: Working tree is dirty\e[m\n"
  exit 1
fi

echo
echo "Test Template Setup"
echo "= = ="

echo
echo "Cloning template to tmp/test"
echo "- - -"

mkdir -p tmp
echo '*' > tmp/.gitignore

rm -rf tmp/test

git clone . tmp/test

cd tmp/test

echo
echo "Renaming project"
echo "- - -"
CONFIRMATION=off ./rename.sh ws-some_namespace SomeNamespace

echo
echo "Installing gems"
echo "- - -"

./install-gems.sh

echo
echo "Summary"
echo "- - -"

echo "The template was copied and renamed to SomeNamespace in:"
echo
echo -e "\t./tmp/test"
echo
echo "Gems were installed."

echo
echo "Done ($(basename "$0"))"
