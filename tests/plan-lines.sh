#!/bin/bash
# Runs the commands of a topic's check lines — the tables of the cards plan-checks*.md.
#
#   bash tests/plan-lines.sh <topic folder> [<numbers separated by commas>]
#
# A table line is split at " | " into seven fields: the number is in the first, the command —
# in the fourth, in backticks. The lines with the numbers from the second argument
# and the "checked manually" lines are skipped. A command ended with a code other than 0 —
# "line <No.>: red". No red ones — "all lines green" and code 0, otherwise code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "usage: bash plan-lines.sh <topic folder> [<numbers separated by commas>]" >&2
    exit 2
fi
topic="${1%/}"
skip=",${2:-},"

sep=' | '
red=0
for card in "$topic"/plan-checks*.md; do
    while IFS= read -r line; do
        fields=()
        while [[ $line == *"$sep"* ]]; do
            fields+=("${line%%"$sep"*}")
            line=${line#*"$sep"}
        done
        fields+=("$line")
        [ ${#fields[@]} -eq 7 ] || continue
        n=${fields[0]#'| '}
        [[ $n =~ ^[0-9]+$ ]] || continue
        cmd=${fields[3]}
        case "$skip" in *",$n,"*) continue ;; esac
        case "$cmd" in 'checked manually'*) continue ;; esac
        cmd=${cmd#'`'}
        cmd=${cmd%'`'}
        # The input of the command is not the table that the loop reads.
        if ! "$BASH" -o pipefail -c "$cmd" < /dev/null; then
            echo "line $n: red"
            red=1
        fi
    done < "$card"
done
[ $red -eq 0 ] || exit 1
echo "all lines green"
