#!/bin/bash
# Prints a note of data/.
#
#   bash bin/show.sh <name>
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"

if [ $# -ne 1 ]; then
    echo "usage: bash bin/show.sh <name>" >&2
    exit 2
fi
name="$1"
# A note is a file right inside data/: a name with a slash would lead out of it.
if [ -z "$name" ] || [ "${name#*/}" != "$name" ]; then
    echo "show.sh: no such note: $name" >&2
    exit 1
fi
cat "$here/data/$name"
