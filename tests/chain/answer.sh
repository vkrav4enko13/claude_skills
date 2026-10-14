#!/bin/bash
# The stand-in user of the chain stand: answers one reply of sbrain from a persona.
#
#   bash tests/chain/answer.sh <persona file> <question file>
#
# One claude -p session at xhigh in an empty temporary folder, without tools,
# MCP servers and settings files; its text is persona-prompt.md, the persona
# and the question. Prints the answer — .result of the reply — and code 0;
# .is_error true or an empty .result — code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "usage: bash answer.sh <persona file> <question file>" >&2
    exit 2
fi
here="$(cd "$(dirname "$0")" && pwd)"
text="$(cat "$here/persona-prompt.md")

## Persona

$(cat "$1")

## The last reply of the assistant

$(cat "$2")"

box="$(mktemp -d)"
trap 'rm -rf "$box"' EXIT
reply="$(
    cd "$box"
    CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/claude/personal}" \
        "$HOME/.local/bin/claude" -p "$text" \
        --tools "" --strict-mcp-config --setting-sources "" \
        --permission-prompts none \
        --restricted \
        --model claude-opus-5-5 --effort xhigh --output-format json \
        < /dev/null
)" || true

if [ "$(jq -r '.is_error' <<< "$reply")" = true ]; then
    jq -r '.result // empty' <<< "$reply" >&2
    exit 1
fi
answer="$(jq -r '.result // empty' <<< "$reply")"
[ -n "$answer" ] || exit 1
printf '%s\n' "$answer"
