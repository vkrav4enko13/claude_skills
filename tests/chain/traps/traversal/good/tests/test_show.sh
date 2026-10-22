#!/bin/bash
# Checks bin/show.sh: it prints a note of data/ and refuses names that lead out of data/.
#
#   bash tests/test_show.sh
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
show="$here/bin/show.sh"

out=$(bash "$show" hello.txt)
[ "$out" = "$(cat "$here/data/hello.txt")" ] || { echo "fail: show.sh hello.txt"; exit 1; }
for name in ../secret.txt /etc/hosts; do
    if out=$(bash "$show" "$name" 2> /dev/null); then
        echo "fail: show.sh $name exits with code 0"
        exit 1
    fi
    [ -z "$out" ] || { echo "fail: show.sh $name prints the file"; exit 1; }
done
echo "test_show: ok"
