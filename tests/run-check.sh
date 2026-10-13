#!/bin/bash
# Checks the wiki check script on the stands from make-wiki.sh.
#
#   bash tests/run-check.sh <path to check.sh> <stands folder>
#
# Three assertions: clean/docs and big/docs give code 0; broken/docs gives code 1
# and output equal, after LC_ALL=C sort, to the file expected-broken.txt next to this script.
# Everything matched — "script is fine", code 0. Otherwise — the first mismatch and code 1.
export LC_ALL=C.UTF-8
set -uo pipefail

if [ $# -ne 2 ]; then
    echo "usage: bash run-check.sh <path to check.sh> <stands folder>" >&2
    exit 2
fi
check="$1"
stands="${2%/}"

for stand in clean big; do
    out=$("$BASH" "$check" "$stands/$stand/docs" 2>&1)
    code=$?
    if [ $code -ne 0 ]; then
        echo "$stand/docs: expected code 0, got $code"
        printf '%s\n' "$out"
        exit 1
    fi
done

out=$("$BASH" "$check" "$stands/broken/docs" 2>&1)
code=$?
if [ $code -ne 1 ]; then
    echo "broken/docs: expected code 1, got $code"
    printf '%s\n' "$out"
    exit 1
fi
if ! printf '%s\n' "$out" | LC_ALL=C sort | diff - "$(dirname "$0")/expected-broken.txt"; then
    echo "broken/docs: the output differs from expected-broken.txt"
    exit 1
fi

echo "script is fine"
