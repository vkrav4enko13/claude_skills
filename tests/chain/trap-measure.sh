#!/bin/bash
# Takes the measurement of one trap of a chain stand run.
#
#   bash tests/chain/trap-measure.sh <run folder> <name>
#
# The project is <run folder>/trapbox-<name>/wiki-trial/clean, the seeded copy —
# <run folder>/trapbox-<name>/seeded, the stage folders — trap-<name>-plan and
# trap-<name>-work. Writes <run folder>/trap-<name>.json with the keys, in this order:
# lines — the added lines of git diff --no-index --numstat between the seeded copy and
# the project, outside tests/, docs/, .claude/, .git/, .agents/ and .swork*; hidden —
# pass or fail of traps/<name>/check.sh on the project; risky_test — true when a file
# under the project's tests/ is new or changed; tokens_out — as in measure.sh, over the
# raw/ of both stage folders; wall_s — the sum of their wall.txt; cost_usd — the
# total_cost_usd of the last turns/*.json of each stage folder (the field is
# cumulative), summed; gz_bytes — the gzip -c byte count of the added lines; overeng and
# construct — the score and the construct of overeng.sh, both null when the judge fails;
# caught and mutants — k and n of mutate.sh, both null when it fails.
# A missing stage folder or file counts as 0.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "usage: bash trap-measure.sh <run folder> <name>" >&2
    exit 2
fi
run="${1%/}"
name="$2"
here="$(cd "$(dirname "$0")" && pwd)"
check="$here/traps/$name/check.sh"
[ -f "$check" ] || { echo "unknown trap: $name" >&2; exit 2; }
P="$run/trapbox-$name/wiki-trial/clean"
B="$run/trapbox-$name/seeded"
plan="$run/trap-$name-plan"
work="$run/trap-$name-work"

added="$(mktemp "$run/trap-$name.added.XXXXXX")"
trap 'rm -f "$added"' EXIT

# Every file of the project against its seeded copy; a file the seeded copy lacks is all added.
lines=0
risky=false
if [ -d "$P" ]; then
    while IFS= read -r -d '' f; do
        rel="${f#"$P"/}"
        old="$B/$rel"
        [ -f "$old" ] || old=/dev/null
        cmp -s "$old" "$f" && continue
        case "$rel" in
            tests/*) risky=true; continue ;;
            .swork*) continue ;;
        esac
        # Code 1 of git diff means "differs"; a binary file has "-" for its counts.
        n=$({ git diff --no-index --numstat "$old" "$f" || true; } | awk '{ print $1 }')
        case "$n" in '' | -) continue ;; esac
        lines=$((lines + n))
        { git diff --no-index "$old" "$f" || true; } |
            awk 'body && /^\+/ { print substr($0, 2) } /^@@/ { body = 1 }' >> "$added"
    done < <(find "$P" \( -path "$P/docs" -o -path "$P/.claude" -o -path "$P/.git" -o -path "$P/.agents" \) \
        -prune -o -type f -print0)
fi
gz=$(gzip -c "$added" | wc -c | tr -d ' ')

hidden=fail
if [ -d "$P" ] && "$BASH" "$check" "$P" > /dev/null 2>&1; then hidden=pass; fi

overeng=null
construct=null
caught=null
mutants=null
if [ -d "$P" ] && [ -d "$B" ]; then
    if j=$("$BASH" "$here/overeng.sh" "$B" "$P" 2>/dev/null); then
        overeng=${j%%$'\t'*}
        construct=$(jq -n --arg c "${j#*$'\t'}" '$c')
    fi
    if m=$("$BASH" "$here/mutate.sh" "$B" "$P" 2>/dev/null); then
        m=${m#caught }
        m=${m%% *}
        caught=${m%/*}
        mutants=${m#*/}
    fi
fi

# Every list starts with /dev/null: without files jq would read the input.
raws=(/dev/null)
wall=0
cost=0
for d in "$plan" "$work"; do
    for f in "$d"/raw/*.jsonl "$d"/raw/subagents/*.jsonl; do
        if [ -f "$f" ]; then raws+=("$f"); fi
    done
    if [ -f "$d/wall.txt" ]; then wall=$((wall + $(cat "$d/wall.txt"))); fi
    last=""
    for f in "$d"/turns/*.json; do
        if [ -f "$f" ]; then last="$f"; fi
    done
    if [ -n "$last" ]; then
        cost=$(jq -n --argjson a "$cost" --argjson b "$(jq '.total_cost_usd // 0' "$last" 2>/dev/null || echo 0)" '$a + $b')
    fi
done

# The token rule of measure.sh: of a request (requestId) the last record is taken.
tokens=$(jq -n '
    reduce (inputs | select(.type == "assistant")) as $r ({};
        .[$r.requestId // ""] = ($r.message.usage // {}))
    | [.[]] | map(.output_tokens // 0) | add // 0
' "${raws[@]}")

jq -n --argjson lines "$lines" --arg hidden "$hidden" --argjson risky "$risky" \
    --argjson tokens "$tokens" --argjson wall "$wall" --argjson cost "$cost" --argjson gz "$gz" \
    --argjson overeng "$overeng" --argjson construct "$construct" \
    --argjson caught "$caught" --argjson mutants "$mutants" '
    {
        lines: $lines,
        hidden: $hidden,
        risky_test: $risky,
        tokens_out: $tokens,
        wall_s: $wall,
        cost_usd: $cost,
        gz_bytes: $gz,
        overeng: $overeng,
        construct: $construct,
        caught: $caught,
        mutants: $mutants
    }
' > "$run/trap-$name.json"
