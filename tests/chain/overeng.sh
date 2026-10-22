#!/bin/bash
# The over-engineering judge of a trap run: how much of the added code the task did not need.
#
#   bash tests/chain/overeng.sh <seeded folder> <project> [<level>]
#
# The added code is every file of <project> that is new or changed against <seeded folder>,
# outside tests/, docs/, .claude/, .git/, .agents/ and .swork* — as in trap-measure.sh: a new
# file in full with line numbers, a changed one as its diff. The task is every
# docs/work/*/task.md of <project>. One claude -p session in an empty temporary folder without
# tools, MCP servers and settings files, at effort <level> (medium by default), as answer.sh;
# its text is overeng-prompt.md, the task and the added code. Prints one line
# "<score 0–3><TAB><construct or none>" and code 0; no such line in the answer — code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "usage: bash overeng.sh <seeded folder> <project> [<level>]" >&2
    exit 2
fi
B="$(cd "$1" && pwd)"
P="$(cd "$2" && pwd)"
level="${3:-medium}"
here="$(cd "$(dirname "$0")" && pwd)"

task=""
for f in "$P"/docs/work/*/task.md; do
    if [ -f "$f" ]; then task="$task$(cat "$f")"$'\n\n'; fi
done
[ -n "$task" ] || task="(the project has no task card)"

code=""
while IFS= read -r -d '' f; do
    rel="${f#"$P"/}"
    case "$rel" in tests/* | .swork*) continue ;; esac
    old="$B/$rel"
    if [ -f "$old" ]; then
        cmp -s "$old" "$f" && continue
        # Code 1 of git diff means "differs"; the hunks without the header of absolute paths.
        diff=$({ git diff --no-index "$old" "$f" || true; } | awk '/^@@/ { body = 1 } body')
        code="$code=== changed file: $rel (diff)"$'\n'"$diff"$'\n\n'
    else
        grep -Iq . "$f" || continue
        code="$code=== new file: $rel"$'\n'"$(awk '{ printf "%4d  %s\n", NR, $0 }' "$f")"$'\n\n'
    fi
done < <(find "$P" \( -path "$P/docs" -o -path "$P/.claude" -o -path "$P/.git" -o -path "$P/.agents" \) \
    -prune -o -type f -print0 | sort -z)
[ -n "$code" ] || code="(no code was added)"

text="$(cat "$here/overeng-prompt.md")

## Task

$task
## Added code

$code"

base="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
mkdir -p "$base"
box="$(mktemp -d "$base/overeng.XXXXXX")"
trap 'rm -rf "$box"' EXIT
reply="$(
    cd "$box"
    CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/claude/personal}" \
        "$HOME/.local/bin/claude" -p "$text" \
        --tools "" --strict-mcp-config --setting-sources "" \
        --permission-prompts none \
        --restricted \
        --model claude-opus-5-5 --effort "$level" --output-format json \
        < /dev/null
)" || true

if [ "$(jq -r '.is_error' <<< "$reply" 2>/dev/null)" = true ]; then
    jq -r '.result // empty' <<< "$reply" >&2
    exit 1
fi
answer="$(jq -r '.result // empty' <<< "$reply" 2>/dev/null)" || answer=""
# The first line "<score> <construct>": backquotes dropped, the gap made one tab.
line=$(printf '%s\n' "$answer" | tr -d '`' |
    awk '/^[0-3][ \t]+[^ \t]/ { s = substr($0, 1, 1); c = substr($0, 2); sub(/^[ \t]+/, "", c); print s "\t" c; exit }')
[ -n "$line" ] || { printf '%s\n' "$answer" >&2; exit 1; }
printf '%s\n' "$line"
