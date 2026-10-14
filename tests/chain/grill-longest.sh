#!/bin/bash
# Prints the longest word of app.txt; of words of equal length — the first.
#
#   bash longest.sh [-n]
#
# -n — the word and its line number separated by a space.
# The file is empty — an empty line.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ ! -f app.txt ]; then
    echo "no file app.txt" >&2
    exit 2
fi

# The length of the word $1 in letters.
length() {
    echo $(($(printf '%s' "$1" | wc -m)))
}

best=""
max=0
at=0
n=0
while IFS= read -r word || [ -n "$word" ]; do
    n=$((n + 1))
    len=$(length "$word")
    if [ "$len" -gt "$max" ]; then
        best="$word"
        max=$len
        at=$n
    fi
done < app.txt

out="$best"
case "${1:-}" in
    -n) [ -z "$best" ] || out="$best $at" ;;
esac
printf '%s\n' "$out"
