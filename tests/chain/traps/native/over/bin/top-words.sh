#!/bin/bash
# Prints how often each word of a file occurs: "<count> <word>", most frequent first,
# words of equal count in order of the word.
#
#   bash bin/top-words.sh <file>
set -euo pipefail
export LC_ALL=C

# The separator between the count and the word.
SEPARATOR=' '

usage() {
    echo "usage: bash bin/top-words.sh <file>" >&2
    echo "  prints <count>${SEPARATOR}<word> per word of <file>, most frequent first" >&2
    exit 2
}

[ $# -eq 1 ] || usage
[ -f "$1" ] || usage

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# One word per line, sorted: equal words stand together.
awk '{ for (i = 1; i <= NF; i++) print $i }' "$1" | sort > "$tmp/words"

# Counts the runs of equal words.
: > "$tmp/counts"
prev=""
count=0
while IFS= read -r word; do
    if [ "$count" -gt 0 ] && [ "$word" = "$prev" ]; then
        count=$((count + 1))
        continue
    fi
    if [ "$count" -gt 0 ]; then
        printf '%s%s%s\n' "$count" "$SEPARATOR" "$prev" >> "$tmp/counts"
    fi
    prev="$word"
    count=1
done < "$tmp/words"
if [ "$count" -gt 0 ]; then
    printf '%s%s%s\n' "$count" "$SEPARATOR" "$prev" >> "$tmp/counts"
fi

sort -k1,1nr -k2,2 "$tmp/counts"
