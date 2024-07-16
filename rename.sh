#!/usr/bin/env bash

set -euo pipefail

rename-directories () {
  local pattern=template
  local replacement=$1

  for dir in $(find . -type d -name "*$pattern*"); do
    local dest="${dir//$pattern/$replacement}"

    echo "Moving $dir -> $dest"
    mkdir -p "$(dirname "$dest")"
    mv "$dir" "$dest"
  done
}

rename-files () {
  local pattern=template
  local replacement=$1

  for file in $(find . -type f -name "*$pattern*"); do
    local dest="${file//$pattern/$replacement}"

    echo "Moving $file -> $dest"
    mkdir -p "$(dirname "$dest")"
    mv "$file" "$dest"
  done
}

replace-tokens () {
  local token=$1
  local replacement=$2

  echo "Replacing $token with $replacement"

  files=$(grep -rl "$token" . | grep -v "rename.sh")

  if grep -q "GNU sed" <<<$(sed --version 2>/dev/null); then
    xargs sed -i "s/$token/${replacement//\//\\/}/g" <<<"$files"
  else
    xargs sed -i '' "s/$token/${replacement//\//\\/}/g" <<<"$files"
  fi
}

if [ "$#" -ne 2 ]; then
  echo "Usage: rename.sh <gem-name> <namespace>"
  echo "e.g. rename.sh ws-some_namespace-other_namespace SomeNamespace::OtherNamespace
"
  false
fi

gem_name=$1
repo_name=${gem_name//_/-}
path=${gem_name//-/\/}

namespace=$2

echo
echo "Gem Name: $gem_name"
echo "Repo Name: $repo_name"
echo "Lib Path: lib/$path"
echo "Namespace: $namespace"

confirmation="${CONFIRMATION:-on}"
if [ $confirmation == "on" ]; then
  echo
  echo "If everything is correct, press return (Control+C to abort)"
  read -r
fi

echo
echo "Deleting test-template-setup.sh"
echo "= = ="

rm test-template-setup.sh

echo "Writing $gem_name.gemspec"
echo "= = ="
mv template.gemspec "$gem_name.gemspec"

echo
echo "Renaming directories"
echo "= = ="
rename-directories "$path"

echo
echo "Renaming files"
echo "= = ="
rename-files "$path"

echo
echo "Replacing tokens"
echo "= = ="
replace-tokens "TEMPLATE_GEM_NAME" "$gem_name"
replace-tokens "TEMPLATE_REPO_NAME" "$repo_name"
replace-tokens "TEMPLATE_PATH" "$path"
replace-tokens "TEMPLATE_NAMESPACE" "$namespace"

echo
echo "Writing README"
echo "= = ="

mv TEMPLATE-README.md README.md

echo
echo "Deleting rename.sh"
echo "= = ="

rm rename.sh

echo
echo "- - -"
echo "(done)"
