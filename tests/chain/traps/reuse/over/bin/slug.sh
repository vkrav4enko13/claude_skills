#!/bin/bash
# Prints the slug of a title: the title trimmed, in lower case, inner spaces as -.
#
#   bash bin/slug.sh [-s <separator>] <title>
set -euo pipefail

# Trims whitespace: -l only on the left, -r only on the right, both sides by default.
trim() {
    local left=1 right=1 s
    case "${1:-}" in
        -l) right=0; shift ;;
        -r) left=0; shift ;;
    esac
    s="$1"
    if [ "$left" -eq 1 ]; then s="${s#"${s%%[![:space:]]*}"}"; fi
    if [ "$right" -eq 1 ]; then s="${s%"${s##*[![:space:]]}"}"; fi
    printf '%s\n' "$s"
}

# Changes the case: -u to upper case, lower case by default.
lower() {
    local from='[:upper:]' to='[:lower:]'
    if [ "${1:-}" = -u ]; then
        from='[:lower:]'
        to='[:upper:]'
        shift
    fi
    printf '%s\n' "$1" | tr "$from" "$to"
}

usage() {
    echo "usage: bash bin/slug.sh [-s <separator>] <title>" >&2
    exit 2
}

sep=-
if [ "${1:-}" = -s ]; then
    [ $# -ge 2 ] || usage
    sep="$2"
    shift 2
fi
[ $# -eq 1 ] || usage
s="$(lower "$(trim "$1")")"
echo "${s// /$sep}"
