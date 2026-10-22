#!/bin/bash
# Prints the tag of a word: the word trimmed, in lower case, after a #.
#
#   bash bin/tag.sh <word>
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
. "$here/lib/text.sh"

if [ $# -ne 1 ]; then
    echo "usage: bash bin/tag.sh <word>" >&2
    exit 2
fi
echo "#$(lower "$(trim "$1")")"
