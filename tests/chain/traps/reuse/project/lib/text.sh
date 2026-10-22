#!/bin/bash
# Text helpers of the scripts in bin/.
set -euo pipefail

# Prints $1 without the leading and trailing whitespace.
trim() {
    local s="$1"
    s="${s#"${s%%[![:space:]]*}"}"
    s="${s%"${s##*[![:space:]]}"}"
    printf '%s\n' "$s"
}

# Prints $1 in lower case.
lower() {
    printf '%s\n' "$1" | tr '[:upper:]' '[:lower:]'
}
