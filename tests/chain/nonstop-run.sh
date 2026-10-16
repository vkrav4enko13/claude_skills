#!/bin/bash
# One live run of swork on the seeded plan of seed-away.sh and its check.
#
#   bash tests/chain/nonstop-run.sh <skills folder>
#
# Builds a stand in a new mktemp -d folder under $CHAIN_BASE (default ~/Documents/my/chain-stand) with the skills of <skills folder>, seeds the
# topic longest with seed-away.sh, drives the stage seed at effort medium and passes on
# the output and the code of nonstop-check.sh: the last line "nonstop run: pass" with
# code 0 or "nonstop run: fail" with code 1. The stand folder goes to stderr.
# Takes from ten minutes to an hour.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: bash nonstop-run.sh <skills folder>" >&2
    exit 2
fi
here="$(cd "$(dirname "$0")" && pwd)"
skills="$(cd "$1" && pwd)"

B="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"; mkdir -p "$B"; T=$(mktemp -d "$B/nonstop.XXXXXX")
echo "stand: $T" >&2
P="$T/wiki-trial/clean"
"$BASH" "$here/stand.sh" "$T" "$skills" >&2
"$BASH" "$here/seed-away.sh" "$P" >&2
# A failed drive still leaves the check to tell what the stage reached.
"$BASH" "$here/drive.sh" "$P" seed "$T/stage" medium >&2 || echo "drive.sh failed" >&2
exec "$BASH" "$here/nonstop-check.sh" "$P" "$T/stage"
