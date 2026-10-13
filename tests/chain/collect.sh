#!/bin/bash
# Collects the result of a chain stage into the stage folder.
#
#   bash tests/chain/collect.sh <project> <stage> <stage folder>
#
# stage.json: stage, turns, session_id; denials — the permission denials of all
# the turns; done — the stage phase is reached: a denial does not fail the
# stage; for work and seed — also every slice of the topic has the status
# "done" or "awaiting manual check" and the progress log has the record
# "stage 7 finished"; api_ms — duration_api_ms of the last turn: the field is
# cumulative; wall_s — from wall.txt, no file — 0. The session records are
# copied from the profile into raw/ together with subagents/; chat.md — the
# requests and all the reply texts of the main session; agents/NN.md — the task
# and the last reply of a subagent, in the order they were started. No session
# records — not an error: only stage.json is left.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 3 ]; then
    echo "usage: bash collect.sh <project> <stage> <stage folder>" >&2
    exit 2
fi
project="${1%/}"
stage="$2"
dir="${3%/}"

# The stage topic and the phase it is passed with — the same as in drive.sh.
case "$stage" in
    brain) topic=count; phase='requirements confirmed' ;;
    plan) topic=count; phase='plan confirmed' ;;
    work) topic=count; phase='done' ;;
    seed) topic=longest; phase='done' ;;
    *) echo "unknown stage: $stage" >&2; exit 2 ;;
esac

cards="$project/docs/work/$topic"
finished=false
if grep -q "Phase:\*\* $phase" "$cards/state.md" 2>/dev/null; then
    finished=true
fi
# For work and seed the phase is not enough: the slices are finished and the
# review — stage 7 — is over.
# A card plan-s*.md without a status line — a part of a slice — does not count.
case "$stage" in
    work | seed)
        for card in "$cards"/plan-s*.md; do
            [ -f "$card" ] || continue
            status="$(grep -m1 '^- \*\*Status:\*\*' "$card" || true)"
            case "$status" in
                '' | '- **Status:** done' | '- **Status:** awaiting manual check') ;;
                *) finished=false ;;
            esac
        done
        if ! grep -qs 'stage 7 finished' "$cards"/progress*.md; then
            finished=false
        fi
        ;;
esac
wall=0
if [ -f "$dir/wall.txt" ]; then
    wall=$(cat "$dir/wall.txt")
fi

jq -s --arg stage "$stage" --argjson finished "$finished" --argjson wall "$wall" '
    {
        stage: $stage,
        turns: length,
        session_id: last.session_id,
        denials: (map(.permission_denials // [] | length) | add),
        done: $finished,
        api_ms: (last.duration_api_ms // 0),
        wall_s: $wall
    }
' "$dir"/turns/*.json > "$dir/stage.json"

sid=$(jq -r .session_id "$dir/stage.json")
main=""
for f in "${CLAUDE_CONFIG_DIR:-$HOME/claude/personal}/projects"/*/"$sid".jsonl; do
    if [ -f "$f" ]; then main="$f"; fi
done
[ -n "$main" ] || exit 0

mkdir -p "$dir/raw"
cp "$main" "$dir/raw/"
if [ -d "${main%.jsonl}/subagents" ]; then
    cp -R "${main%.jsonl}/subagents" "$dir/raw/"
fi

# The texts of a record: the whole string or the text blocks; tool results are skipped.
texts='def texts: if type == "string" then [.] else map(select(.type == "text") | .text) end;'

jq -r "$texts"'
    if .type == "user" and (.isMeta | not) then
        (.message.content | texts) as $t
        | select($t | length > 0)
        | "## Request\n\n" + ($t | join("\n\n")) + "\n"
    elif .type == "assistant" then
        (.message.content | texts)[] | "## Reply\n\n" + . + "\n"
    else empty end
' "$dir/raw/$sid.jsonl" > "$dir/chat.md"

agents=("$dir"/raw/subagents/agent-*.jsonl)
[ -f "${agents[0]}" ] || exit 0

mkdir -p "$dir/agents"
n=0
while IFS= read -r f; do
    n=$((n + 1))
    jq -rs "$texts"'
        (map(select(.type == "user")) | first | .message.content | texts | join("\n\n")) as $task
        | (map(select(.type == "assistant") | .message.content | texts[]) | last // "") as $answer
        | "## Task\n\n" + $task + "\n\n## Last reply\n\n" + $answer + "\n"
    ' "$f" > "$dir/agents/$(printf '%02d' "$n").md"
done < <(jq -rn '
    [inputs | select(.timestamp) | {f: input_filename, t: .timestamp}]
    | group_by(.f) | map(min_by(.t)) | sort_by(.t) | .[].f
' "${agents[@]}")
