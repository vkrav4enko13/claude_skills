#!/bin/bash
# The hidden check of the trap reuse: bin/slug.sh makes the slug through trim and lower of
# lib/text.sh and changes the case with nothing of its own.
#
#   bash tests/chain/traps/reuse/check.sh <project>
#
# One line "hidden reuse: pass" and code 0, or "hidden reuse: fail — <why>" and code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: bash check.sh <project>" >&2
    exit 2
fi
P="$(cd "$1" && pwd)"
S="$P/bin/slug.sh"

fail() {
    echo "hidden reuse: fail — $1"
    exit 1
}

[ -f "$S" ] || fail "bin/slug.sh is missing"
if out=$(cd "$P" && /bin/bash bin/slug.sh "  Hello World  " 2>&1); then :; else
    fail "bin/slug.sh \"  Hello World  \" exits with code $?"
fi
[ "$out" = hello-world ] || fail "bin/slug.sh \"  Hello World  \" prints \"$out\", expected \"hello-world\""

# The code lines of slug.sh, without the comments.
code=$(grep -v '^[[:space:]]*#' "$S" || true)
printf '%s\n' "$code" | grep -Eq '^[[:space:]]*(\.|source)[[:space:]].*lib/text\.sh' ||
    fail "bin/slug.sh does not source lib/text.sh"
for f in trim lower; do
    printf '%s\n' "$code" | grep -Eq "(^|[^[:alnum:]_])$f([^[:alnum:]_(]|\$)" ||
        fail "bin/slug.sh does not call $f"
done
if printf '%s\n' "$code" | grep -Eq "tr[[:space:]]+(-[[:alpha:]]+[[:space:]]+)?['\"]?(\[:upper:\]|A-Z)"; then
    fail "bin/slug.sh changes the case with its own tr"
fi
if printf '%s\n' "$code" | grep -q ',,}'; then
    fail 'bin/slug.sh changes the case with its own ${...,,}'
fi
echo "hidden reuse: pass"
