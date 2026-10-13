#!/bin/bash
# Takes the measurement of one run of the chain stand from the folders of its stages.
#
#   bash tests/chain/measure.sh <run folder>
#
# Writes <run folder>/metrics.json. The stages are the folders brain, plan, work
# and seed, whichever exist. wall_min and model_min — the sums of wall_s and
# api_ms from stage.json, in minutes; agents — the number of files
# raw/subagents/agent-*.jsonl; agents_min — the sum of their durations in
# minutes, from the first to the last record of a file; tokens_in and
# tokens_out — by the assistant records of all the raw/ files: of a request
# (requestId) the last record is taken — for subagents output_tokens is
# complete only in it; the input is input_tokens together with both cache
# fields; seed_first_agent_min and seed_first_agent_effort — the duration and
# the effort field of the records of the earliest subagent of the stage seed,
# without one — null.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: bash measure.sh <run folder>" >&2
    exit 2
fi
run="${1%/}"

# Every list starts with /dev/null: without files jq would read the input.
stages=(/dev/null)
raws=(/dev/null)
agents=(/dev/null)
for s in brain plan work seed; do
    if [ -f "$run/$s/stage.json" ]; then stages+=("$run/$s/stage.json"); fi
    for f in "$run/$s"/raw/*.jsonl "$run/$s"/raw/subagents/*.jsonl; do
        if [ -f "$f" ]; then raws+=("$f"); fi
    done
    for f in "$run/$s"/raw/subagents/agent-*.jsonl; do
        if [ -f "$f" ]; then agents+=("$f"); fi
    done
done

minutes=$(jq -s '{
    wall_min: ((map(.wall_s) | add // 0) / 60),
    model_min: ((map(.api_ms) | add // 0) / 60000)
}' "${stages[@]}")

# A record of a request overwrites the earlier record of the same requestId: the last one stays.
tokens=$(jq -n '
    reduce (inputs | select(.type == "assistant")) as $r ({};
        .[$r.requestId // ""] = ($r.message.usage // {}))
    | [.[]]
    | {
        tokens_in: (map((.input_tokens // 0) + (.cache_creation_input_tokens // 0)
            + (.cache_read_input_tokens // 0)) | add // 0),
        tokens_out: (map(.output_tokens // 0) | add // 0)
    }
' "${raws[@]}")

# The time of a record — seconds with fractions: fromdateiso8601 does not parse fractions of a second.
jq -n --argjson minutes "$minutes" --argjson tokens "$tokens" \
    --argjson count "$((${#agents[@]} - 1))" --arg seed "$run/seed/" '
    def secs: (.[0:19] + "Z" | fromdateiso8601) + ("0" + (.[19:] | rtrimstr("Z")) | tonumber);
    [inputs | select(.timestamp) | {f: input_filename, t: (.timestamp | secs), e: .effort}]
    | group_by(.f)
    | map({
        f: first.f,
        start: (map(.t) | min),
        len: (((map(.t) | max) - (map(.t) | min)) / 60),
        effort: (map(.e | select(. != null)) | first)
    })
    | (map(select(.f | startswith($seed))) | min_by(.start)) as $first
    | {
        wall_min: $minutes.wall_min,
        model_min: $minutes.model_min,
        agents: $count,
        agents_min: (map(.len) | add // 0),
        tokens_in: $tokens.tokens_in,
        tokens_out: $tokens.tokens_out,
        seed_first_agent_min: $first.len,
        seed_first_agent_effort: $first.effort
    }
' "${agents[@]}" > "$run/metrics.json"
