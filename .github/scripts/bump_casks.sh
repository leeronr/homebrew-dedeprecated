#!/opt/homebrew/bin/bash

echo "before brew"

while IFS= read -r line; do
    printf 'READ: <%s>\n' "$line"
done < <(
    brew bump --tap leeronr/dedeprecated |
    tee /tmp/brew-bump-output
)

echo "after loop"
echo "===== FILE ====="
cat /tmp/brew-bump-output