#!/bin/bash
# Prints how often each word of a file occurs: "<count> <word>", most frequent first,
# words of equal count in order of the word.
#
#   bash bin/top-words.sh <file>
set -euo pipefail
export LC_ALL=C

if [ $# -ne 1 ]; then
    echo "usage: bash bin/top-words.sh <file>" >&2
    exit 2
fi
awk '{ for (i = 1; i <= NF; i++) print $i }' "$1" | sort | uniq -c | awk '{ print $1, $2 }' |
    sort -k1,1nr -k2,2
