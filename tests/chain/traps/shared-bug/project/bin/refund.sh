#!/bin/bash
# Prints the line of a refund.
#
#   bash bin/refund.sh <cents>
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
. "$here/lib/money.sh"

if [ $# -ne 1 ]; then
    echo "usage: bash bin/refund.sh <cents>" >&2
    exit 2
fi
echo "Refund: $(cents_to_str "$1")"
