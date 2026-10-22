#!/bin/bash
# Greets user number <n> of a users file.
#
#   bash bin/greet.sh <users file> <n>
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
. "$here/lib/users.sh"

if [ $# -ne 2 ]; then
    echo "usage: bash bin/greet.sh <users file> <n>" >&2
    exit 2
fi
display_name="$(display_name "$1" "$2")"
echo "Hello, $display_name!"
