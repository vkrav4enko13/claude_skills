#!/bin/bash
# Prints the executor's packet of one slice, assembled from the topic cards.
#
#   bash packet.sh <topic folder> <slice number> <project root> [<created file>…]
#
# The nine items of "Packet" in references/executor.md, in its order, each
# under its own line: === slice ===, === check lines ===, === shared
# constraints and not doing ===, === technical decisions ===, === out of
# scope ===, === discrepancy rule ===, === project root ===, === code map ===
# (codemap.sh; skipped when it fails or is empty), then a block per
# created file: the first, this topic's, under === created earlier: <file>
# (this topic) ===, the others under === created earlier: <file> ===.
# "Out of scope" is skipped when the topic has no such section, a created
# file — when it does not exist.
# No card of that slice — "no slice S<N>" to stderr and code 1.
# Wrong arguments or no topic folder — a message and code 2.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo "usage: bash packet.sh <topic folder> <slice number> <project root> [<created file>…]" >&2
    exit 2
}
[ $# -ge 3 ] || usage
T="${1%/}"
n="$2"
root="$3"
shift 3
[[ $n =~ ^[1-9][0-9]*$ ]] || usage
if [ ! -d "$T" ]; then
    echo "$1: no topic folder" >&2
    exit 2
fi

# The files of a card and its parts, the card first: <card>.md, <card>-2.md, …
# A shorter name goes first, so -10 comes after -9.
in_order() {
    local f
    for f in "$@"; do
        if [ -f "$f" ]; then printf '%d\t%s\n' "${#f}" "$f"; fi
    done | sort -t $'\t' -k1,1n -k2,2 | cut -f2-
}

# The section "## $1" of the files $2…: from its heading to the next "## " heading.
section() {
    local name="$1"
    shift
    awk -v h="## $name" '
        FNR == 1 { f = 0 }
        /^## / { f = ($0 == h) }
        f
    ' "$@"
}

slice=$(in_order "$T"/plan-s"$n"-*.md)
if [ -z "$slice" ]; then
    echo "no slice S$n" >&2
    exit 1
fi
plan=$(in_order "$T"/plan.md "$T"/plan-[0-9]*.md)
checks=$(in_order "$T"/plan-checks*.md)
decisions=$(in_order "$T"/plan-decisions*.md)
scope=$(in_order "$T"/scope*.md)
# The lists above hold a path per line: split them only at line breaks.
IFS=$'\n'
set -f

# The line numbers of the "Checks" field: numbers and ranges 1–5.
wanted=$(grep -h '^- \*\*Checks:\*\*' $slice |
    perl -CS -Mutf8 -ne 'while (/(\d+)(?:\s*[–-]\s*(\d+))?/g) { print "$_," for $1 .. ($2 // $1) }' || true)

echo "=== slice ==="
cat $slice

echo
echo "=== check lines ==="
if [ -n "$checks" ]; then
    awk -v wanted="$wanted" '
        BEGIN { split(wanted, w, ","); for (i in w) want[w[i]] = 1 }
        /^\|/ {
            cell = $0
            sub(/^\| */, "", cell)
            sub(/ *\|.*/, "", cell)
            if (!header && cell !~ /^[0-9]+$/ && cell !~ /^-+$/) { print; header = 1; next }
            if (cell in want) print
        }
    ' $checks
fi

echo
echo "=== shared constraints and not doing ==="
if [ -n "$plan" ]; then
    section "Shared constraints" $plan
    section "Not doing" $plan
fi

echo
echo "=== technical decisions ==="
if [ -n "$decisions" ]; then cat $decisions; fi

if [ -n "$scope" ]; then
    out=$(section "Out of scope" $scope)
    if [ -n "$out" ]; then
        echo
        echo "=== out of scope ==="
        printf '%s\n' "$out"
    fi
fi

echo
echo "=== discrepancy rule ==="
if [ -n "$plan" ]; then section "If the code differs from the plan" $plan; fi

echo
echo "=== project root ==="
echo "Project root: $root"

here=$(dirname "$0")
codemap="$here/codemap.sh"
[ -f "$codemap" ] || codemap="$here/../../sbrain/scripts/codemap.sh"
if map=$(bash "$codemap" "$root" 2>/dev/null) && [ -n "$map" ]; then
    echo
    echo "=== code map ==="
    printf '%s\n' "$map"
fi

own=" (this topic)"
for created in "$@"; do
    if [ -f "$created" ]; then
        echo
        echo "=== created earlier: $created$own ==="
        cat "$created"
    fi
    own=""
done
