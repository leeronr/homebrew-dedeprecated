#!/usr/bin/env bash

echo "=== DEBUG ==="
echo "BASH_VERSION=$BASH_VERSION"
echo "BASH=$BASH"
echo "PATH=$PATH"
echo "brew=$(command -v brew)"
echo "brew version:"
brew --version
echo "script=$0"
echo "=== END DEBUG ==="

declare -A version
declare -A version_arm
declare -A version_intel

package=
skip=0
multi=0

echo "=== RAW BREW OUTPUT ==="
brew_output=$(brew bump --tap leeronr/dedeprecated)
printf '%s\n' "$brew_output"
echo "=== END RAW BREW OUTPUT ==="

while IFS= read -r line; do

    # New package
    if [[ $line == '==> '* ]]; then

        # "==> foo is up to date!"
        if [[ $line == *' is up to date!' ]]; then
            package=
            skip=1
            multi=0
            continue
        fi

        package=${line#==> }
        skip=0
        multi=0
        continue
    fi

    (( skip )) && continue

	# Don't try to populate an array with an empty key.
  	[[ -z $package ]] && continue

    # Latest version: ARM/Intel
    if [[ $line == 'Latest livecheck version: arm:'* ]]; then
        multi=1

        value=${line#*arm:}
        value=${value#"${value%%[![:space:]]*}"}

        version_arm["$package"]="$value"
        continue
    fi

    # Intel continuation
    if (( multi )) && [[ $line == *'intel:'* ]]; then

        value=${line#*intel:}
        value=${value#"${value%%[![:space:]]*}"}

        version_intel["$package"]="$value"
        continue
    fi

    # Latest version: single version
    if [[ $line == 'Latest livecheck version:'* ]]; then

        value=${line#Latest livecheck version:}
        value=${value#"${value%%[![:space:]]*}"}

        version["$package"]="$value"
        continue
    fi

done <<< "$brew_output"


for package in "${!version[@]}"; do

    echo "Bumping $package -> ${version[$package]}"

    brew bump-cask-pr \
        --no-fork \
        --version "${version[$package]}" \
        --dry-run \
        "leeronr/dedeprecated/$package"

done


for package in "${!version_arm[@]}"; do

    echo "Bumping $package:"
    echo "  arm:   ${version_arm[$package]}"
    echo "  intel: ${version_intel[$package]}"

    brew bump-cask-pr \
        --no-fork \
        --no-browse \
        --version-arm "${version_arm[$package]}" \
        --version-intel "${version_intel[$package]}" \
        --dry-run \
        "leeronr/dedeprecated/$package"

done