#!/bin/bash
set -euo pipefail

n=$(wc -w < "$(dirname "$0")/app.txt" | tr -d ' ')
if [ "${1:-}" = -v ]; then
    echo "$n слов"
else
    echo "$n"
fi
