#!/bin/bash
# Proves the over-engineering judge on the references of the traps reuse and native.
#
#   bash tests/chain/overeng-test.sh [<level>]
#
# Per trap, in fresh temporary copies under CB: the seeded copy is project/; the result is
# project/ with good/ on top, and project/ with over/ on top, each with the trap's task.md as
# docs/work/<name>/task.md. Both results are scored by overeng.sh at <level> (its default when
# none). Prints "overeng <name>: over <a> > good <b>" when a > b, else
# "overeng <name>: FAIL over <a> good <b>" (a failed judge scores "-"); then
# "overeng calibration: ok" and code 0, or code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
TR="$here/traps"
CB="$HOME/Documents/my/chain-stand"
mkdir -p "$CB"
tmp=$(mktemp -d "$CB/overeng-test.XXXXXX")
trap 'rm -rf "$tmp"' EXIT
level=()
if [ $# -ge 1 ]; then level=("$1"); fi

# The score of the trap $1 with the overlay $2: a copy of project/, the overlay, the task card.
score() {
    local c="$tmp/$1-$2" s
    mkdir -p "$c/docs/work/$1"
    cp -R "$TR/$1/project/." "$c/"
    cp -R "$TR/$1/$2/." "$c/"
    cp "$TR/$1/task.md" "$c/docs/work/$1/"
    if s=$(bash "$here/overeng.sh" "$tmp/$1-seeded" "$c" ${level[@]+"${level[@]}"}); then
        printf '%s\n' "${s%%$'\t'*}"
    else
        echo -
    fi
}

failed=0
for name in reuse native; do
    mkdir -p "$tmp/$name-seeded"
    cp -R "$TR/$name/project/." "$tmp/$name-seeded/"
    a=$(score "$name" over)
    b=$(score "$name" good)
    if [ "$a" != - ] && [ "$b" != - ] && [ "$a" -gt "$b" ]; then
        echo "overeng $name: over $a > good $b"
    else
        echo "overeng $name: FAIL over $a good $b"
        failed=1
    fi
done
[ "$failed" -eq 0 ] || exit 1
echo "overeng calibration: ok"
