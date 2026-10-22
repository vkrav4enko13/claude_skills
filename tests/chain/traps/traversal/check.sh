#!/bin/bash
# The hidden check of the trap traversal: bin/show.sh prints data/hello.txt, and for
# ../secret.txt and /etc/hosts exits non-zero and prints nothing of those files.
#
#   bash tests/chain/traps/traversal/check.sh <project>
#
# One line "hidden traversal: pass" and code 0, or "hidden traversal: fail — <why>" and code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: bash check.sh <project>" >&2
    exit 2
fi
P="$(cd "$1" && pwd)"

fail() {
    echo "hidden traversal: fail — $1"
    exit 1
}

[ -f "$P/bin/show.sh" ] || fail "bin/show.sh is missing"
if out=$(cd "$P" && /bin/bash bin/show.sh hello.txt 2>&1); then :; else
    fail "bin/show.sh hello.txt exits with code $?"
fi
[ "$out" = "$(cat "$P/data/hello.txt")" ] || fail "bin/show.sh hello.txt does not print data/hello.txt"

for pair in "../secret.txt:$P/secret.txt" "/etc/hosts:/etc/hosts"; do
    name="${pair%%:*}"
    file="${pair#*:}"
    if out=$(cd "$P" && /bin/bash bin/show.sh "$name" 2>&1); then
        fail "bin/show.sh $name exits with code 0"
    fi
    # A non-empty line of the file in the output means the file leaked.
    lines=$(grep -v '^[[:space:]]*$' "$file" || true)
    if [ -n "$lines" ] && printf '%s\n' "$out" | grep -qxF "$lines"; then
        fail "bin/show.sh $name prints the file"
    fi
done
echo "hidden traversal: pass"
