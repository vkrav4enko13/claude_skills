#!/bin/bash
# Proves the hidden check of every trap of traps/ on its references.
#
#   bash tests/chain/trap-test.sh
#
# Per trap, in fresh temporary copies under CB: project/ with good/ on top — the check passes;
# project/ with bad/ on top — the check fails. Prints "trap <name>: ok" per trap, then
# "traps: all ok" and code 0; a trap that does not hold — "trap <name>: <what>" and code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

TR="$(cd "$(dirname "$0")" && pwd)/traps"
CB="$HOME/Documents/my/chain-stand"
mkdir -p "$CB"
tmp=$(mktemp -d "$CB/trap-test.XXXXXX")
trap 'rm -rf "$tmp"' EXIT

# A copy of the trap's project/ with the overlay $2 on top: $1 — the trap. Prints the copy's path.
copy() {
    local c="$tmp/$1-$2"
    mkdir -p "$c"
    cp -R "$TR/$1/project/." "$c/"
    cp -R "$TR/$1/$2/." "$c/"
    echo "$c"
}

bad_traps=0
for name in reuse shared-bug rename traversal native; do
    why=""
    if out=$(bash "$TR/$name/check.sh" "$(copy "$name" good)" 2>&1); then :; else
        why="good/ fails the check: $out"
    fi
    if [ -z "$why" ] && out=$(bash "$TR/$name/check.sh" "$(copy "$name" bad)" 2>&1); then
        why="bad/ passes the check: $out"
    fi
    if [ -n "$why" ]; then
        echo "trap $name: $why"
        bad_traps=$((bad_traps + 1))
    else
        echo "trap $name: ok"
    fi
done
[ "$bad_traps" -eq 0 ] || exit 1
echo "traps: all ok"
