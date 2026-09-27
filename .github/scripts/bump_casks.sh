#!/usr/bin/env bash

declare -A version
declare -A version_arm
declare -A version_intel

package=
skip=0
multi=0

brew_output=$(brew bump --tap leeronr/dedeprecated)

while IFS= read -r line; do
    if [[ $line == '==> '* ]]; then
        printf 'PACKAGE MATCH: <%s>\n' "$line"
    elif [[ $line == 'Latest livecheck version: arm:'* ]]; then
        printf 'ARM MATCH: <%s>\n' "$line"
    elif [[ $line == *'intel:'* ]]; then
        printf 'INTEL MATCH: <%s>\n' "$line"
    elif [[ $line == 'Latest livecheck version:'* ]]; then
        printf 'SINGLE MATCH: <%s>\n' "$line"
    fi
done <<< "$brew_output"

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