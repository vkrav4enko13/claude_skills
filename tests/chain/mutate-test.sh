#!/bin/bash
# Proves mutate.sh on the references of the trap traversal.
#
#   bash tests/chain/mutate-test.sh
#
# In fresh temporary copies under CB, against project/ as the seeded copy: project/ with good/
# on top (it has tests/test_show.sh) — "mutate good: caught <k>/<n>" with k of 1 or more;
# project/ with bad/ on top — "mutate bad: caught 0/<n> — no tests". Then "mutate test: all ok"
# and code 0; a case that does not hold — "mutate <case>: FAIL <output>" and code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
T="$here/traps/traversal"
CB="$HOME/Documents/my/chain-stand"
mkdir -p "$CB"
tmp=$(mktemp -d "$CB/mutate-test.XXXXXX")
trap 'rm -rf "$tmp"' EXIT

failed=0
for case in good bad; do
    c="$tmp/$case"
    mkdir -p "$c"
    cp -R "$T/project/." "$c/"
    cp -R "$T/$case/." "$c/"
    out=$(bash "$here/mutate.sh" "$T/project" "$c" 2>&1) || true
    case "$case:$out" in
        good:"caught 0/"*) ok=0 ;;
        good:"caught "[0-9]*/[0-9]*) ok=1 ;;
        bad:"caught 0/"[0-9]*" — no tests") ok=1 ;;
        *) ok=0 ;;
    esac
    if [ "$ok" -eq 1 ] && [ "$(printf '%s\n' "$out" | wc -l)" -eq 1 ]; then
        echo "mutate $case: $out"
    else
        echo "mutate $case: FAIL $out"
        failed=1
    fi
done
[ "$failed" -eq 0 ] || exit 1
echo "mutate test: all ok"
