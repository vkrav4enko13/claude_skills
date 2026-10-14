#!/bin/bash
# Prints what the final series of the chain stand saves in output tokens.
#
#   bash tests/chain/saving.sh <baseline> <final> <reference>
#
# Takes "total output_per_run" and the input lines of trace.sh for each of the
# three series and prints:
#   output per run: <baseline> <n>, <final> <n>, <reference> <n>
#   saving against <baseline>: <p> % — threshold met | threshold not met
#   saving against <reference>: <p> %
#   cache <series>: write <n> read <n> per run    (one line per series)
# <p> is (1 − final / other) × 100 with one decimal; the threshold is 10.0.
# Code 0 with either mark. A series that trace.sh cannot measure —
# "no measurement: <what>" and code 1.
# The stands folder — CHAIN_BASE, by default ~/Documents/my/chain-stand.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo 'usage: bash saving.sh <baseline> <final> <reference>' >&2
    exit 2
}
[ $# -eq 3 ] || usage
here="$(cd "$(dirname "$0")" && pwd)"

names=("$1" "$2" "$3")
out=() cw=() cr=()
for i in 0 1 2; do
    s="${names[$i]}"
    if ! lines="$(bash "$here/trace.sh" "$s" total input 2>/dev/null)"; then
        echo "no measurement: series $s"
        exit 1
    fi
    out[$i]="$(awk '$1 == "total" && $2 == "output_per_run" {print $3}' <<<"$lines")"
    cw[$i]="$(awk '$1 == "input" && $2 == "cache_write" {print $4}' <<<"$lines")"
    cr[$i]="$(awk '$1 == "input" && $2 == "cache_read" {print $4}' <<<"$lines")"
    if [ -z "${out[$i]}" ] || [ "${out[$i]}" = 0 ]; then
        echo "no measurement: output of series $s"
        exit 1
    fi
done

saving() {
    awk -v f="$1" -v o="$2" 'BEGIN { printf "%.1f", (1 - f / o) * 100 }'
}

echo "output per run: $1 ${out[0]}, $2 ${out[1]}, $3 ${out[2]}"
p="$(saving "${out[1]}" "${out[0]}")"
if awk -v p="$p" 'BEGIN { exit !(p >= 10.0) }'; then
    echo "saving against $1: $p % — threshold met"
else
    echo "saving against $1: $p % — threshold not met"
fi
echo "saving against $3: $(saving "${out[1]}" "${out[2]}") %"
for i in 0 1 2; do
    echo "cache ${names[$i]}: write ${cw[$i]} read ${cr[$i]} per run"
done
