#!/bin/bash
set -euo pipefail

n=$(grep -c '' "$(dirname "$0")/app.txt" || true)
if [ "${1:-}" = -v ]; then
    echo "$n слов"
else
    echo "$n"
fi
