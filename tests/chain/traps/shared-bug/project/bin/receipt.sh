#!/bin/bash
# Prints the total line of a receipt.
#
#   bash bin/receipt.sh <cents>
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
. "$here/lib/money.sh"

if [ $# -ne 1 ]; then
    echo "usage: bash bin/receipt.sh <cents>" >&2
    exit 2
fi
echo "Total: $(cents_to_str "$1")"
