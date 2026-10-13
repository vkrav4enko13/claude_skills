#!/bin/bash
# Runs the earlier check lines of both topics with one command.
#
#   bash tests/translate/lines.sh
#
# The chain-cleanup cards plan-checks-*.md, except plan-checks-en-*.md, are
# copied to a temporary folder and tests/plan-lines.sh runs on the copy; then
# it runs on docs/work/quality-tokens. Skipped lines:
#   chain-cleanup 2 - runs the quality-tokens lines itself;
#   chain-cleanup 74, 76, 77 - belong to later slices;
#   quality-tokens 4, 9, 14 - require word-for-word text the topic has changed;
#   quality-tokens 40 - calls the model, line 119 checks the size.
# No red lines - "old lines: green" and exit code 0. Otherwise the output
# of plan-lines.sh for each topic with red lines and exit code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

cd "$(dirname "$0")/../.."

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
for card in docs/work/chain-cleanup/plan-checks-*.md; do
    case "$card" in */plan-checks-en-*.md) continue ;; esac
    cp "$card" "$tmp/"
done

# Runs plan-lines.sh with the given arguments; its output is shown only
# when it reports red lines.
red=0
lines() {
    local out
    if ! out=$("$BASH" tests/plan-lines.sh "$@" 2>&1); then
        printf '%s\n' "$out"
        red=1
    fi
}
lines "$tmp" 2,74,76,77
lines docs/work/quality-tokens 4,9,14,40
[ $red -eq 0 ] || exit 1
echo "old lines: green"
