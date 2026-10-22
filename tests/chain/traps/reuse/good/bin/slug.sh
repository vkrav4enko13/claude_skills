#!/bin/bash
# Prints the slug of a title: the title trimmed, in lower case, inner spaces as -.
#
#   bash bin/slug.sh <title>
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
. "$here/lib/text.sh"

if [ $# -ne 1 ]; then
    echo "usage: bash bin/slug.sh <title>" >&2
    exit 2
fi
s="$(lower "$(trim "$1")")"
echo "${s// /-}"
