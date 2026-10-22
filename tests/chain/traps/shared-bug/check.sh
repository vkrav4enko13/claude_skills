#!/bin/bash
# The hidden check of the trap shared-bug: both bin/receipt.sh and bin/refund.sh print
# 0.05, 1.05 and 0.00 for 5, 105 and 0 cents.
#
#   bash tests/chain/traps/shared-bug/check.sh <project>
#
# One line "hidden shared-bug: pass" and code 0, or "hidden shared-bug: fail — <why>" and code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: bash check.sh <project>" >&2
    exit 2
fi
P="$(cd "$1" && pwd)"

fail() {
    echo "hidden shared-bug: fail — $1"
    exit 1
}

for pair in receipt:Total refund:Refund; do
    script="bin/${pair%%:*}.sh"
    label="${pair#*:}"
    [ -f "$P/$script" ] || fail "$script is missing"
    for case in 5:0.05 105:1.05 0:0.00; do
        cents="${case%%:*}"
        want="$label: ${case#*:}"
        if out=$(cd "$P" && /bin/bash "$script" "$cents" 2>&1); then :; else
            fail "$script $cents exits with code $?"
        fi
        [ "$out" = "$want" ] || fail "$script $cents prints \"$out\", expected \"$want\""
    done
done
echo "hidden shared-bug: pass"
