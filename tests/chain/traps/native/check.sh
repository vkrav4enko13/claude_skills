#!/bin/bash
# The hidden check of the trap native: bin/top-words.sh prints the exact expected counts of
# words.txt, and on an empty file prints nothing with code 0.
#
#   bash tests/chain/traps/native/check.sh <project>
#
# One line "hidden native: pass" and code 0, or "hidden native: fail — <why>" and code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: bash check.sh <project>" >&2
    exit 2
fi
P="$(cd "$1" && pwd)"

fail() {
    echo "hidden native: fail — $1"
    exit 1
}

# The counts of the words.txt of the trap.
want='3 the
2 a
2 and
2 cat
2 dog
1 end
1 saw'

[ -f "$P/bin/top-words.sh" ] || fail "bin/top-words.sh is missing"
if out=$(cd "$P" && /bin/bash bin/top-words.sh words.txt 2>&1); then :; else
    fail "bin/top-words.sh words.txt exits with code $?"
fi
[ "$out" = "$want" ] || fail "bin/top-words.sh words.txt prints other lines or another order"

CB="$HOME/Documents/my/chain-stand"
mkdir -p "$CB"
tmp=$(mktemp -d "$CB/native-check.XXXXXX")
trap 'rm -rf "$tmp"' EXIT
: > "$tmp/empty.txt"
if out=$(cd "$P" && /bin/bash bin/top-words.sh "$tmp/empty.txt" 2>&1); then :; else
    fail "bin/top-words.sh on an empty file exits with code $?"
fi
[ -z "$out" ] || fail "bin/top-words.sh on an empty file prints \"$out\""
echo "hidden native: pass"
