#!/bin/bash
# Compares two series of runs of the chain stand: "before" and "after".
#
#   bash tests/chain/verdict.sh quality|seeds|speed <series before> <series after>
#   bash tests/chain/verdict.sh effort <series> <probe series>
#
# Counts over all the runs of a series. quality and seeds read the verdicts of
# the judge: the labels of the runs of a series — from blind/key.tsv, the
# answer — the whole third field of a line of verdict.tsv. The words of a line
# are English; a word of an earlier verdict is first replaced by its English
# name from the rows of tests/translate/map.tsv with the scope "stand" and the
# kind "judge". quality — the "rule" lines with the answer "no": "after" has
# not more — code 0. seeds — the "seed" lines with the answer "found": "after"
# has not less — code 0. speed — the sum of wall_min from metrics.json of the
# runs of a finished series, to hundredths: "after" has less — code 0.
# Otherwise code 1.
# No series, key, verdict or measurement, or the series have a different number
# of runs — "no measurement: <what is missing>" and code 1.
# effort — the probe of the effort "high" for the executor of a slice marked
# "ready text": writes the word accepted or rejected into verdict.txt of the
# probe series and prints "effort high: <word>", code 0 with either word.
# accepted — in every run of the probe the stage seed is passed (done in
# seed/stage.json), seed_first_agent_effort in metrics.json is "high" and the
# progress log of the topic longest has no record "S3: attempt", and the sum
# of seed_first_agent_min of the probe is less than that of the series. No
# series, runs or metrics.json, or a different number of runs — "no
# measurement: <what is missing>" and code 1.
# The stands folder — CHAIN_BASE, by default ~/Documents/my/chain-stand.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo "usage: bash verdict.sh quality|seeds|speed <series before> <series after>" >&2
    echo "       bash verdict.sh effort <series> <probe series>" >&2
    exit 2
}
[ $# -eq 3 ] || usage
mode="$1"
before="$2"
after="$3"
here="$(cd "$(dirname "$0")" && pwd)"
B="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
key="$B/blind/key.tsv"
map="$here/../translate/map.tsv"

none() {
    echo "no measurement: $1"
    exit 1
}

# The number of lines of the kind $1 with the answer $2 in the verdicts of the
# runs of the series $3 — into $total, the number of its runs — into $runs.
tally() {
    local label file
    total=0
    runs=0
    [ -f "$key" ] || none "no key $key"
    while IFS= read -r label; do
        file="$B/blind/$label/verdict.tsv"
        [ -s "$file" ] || none "no verdict $file"
        runs=$((runs + 1))
        # The first file is the table: the English names of the judge words.
        total=$((total + $(awk -F'\t' -v kind="$1" -v answer="$2" '
            FILENAME == ARGV[1] {
                if ($1 == "stand" && $2 == "judge") english[$3] = $4
                next
            }
            {
                k = ($1 in english) ? english[$1] : $1
                a = ($3 in english) ? english[$3] : $3
                if (k == kind && a == answer) n++
            }
            END { print n + 0 }' "$map" "$file")))
    done < <(awk -F'\t' -v series="$3" '$2 == series { print $1 }' "$key")
    [ $runs -gt 0 ] || none "the key has no series $3"
}

# What the jq filter $2 counts from metrics.json of the runs of the series $1
# — into $total, the number of its runs — into $runs.
sum_metric() {
    local dir files=()
    runs=0
    for dir in "$B/$1"/[0-9]*; do
        [ -d "$dir" ] || continue
        [ -f "$dir/metrics.json" ] || none "no measurement $dir/metrics.json"
        runs=$((runs + 1))
        files+=("$dir/metrics.json")
    done
    [ $runs -gt 0 ] || none "the series $1 has no runs"
    total=$(jq -s "$2" "${files[@]}")
}

# The sum of wall_min of the runs of the series $1 — into $total, the number
# of its runs — into $runs.
minutes() {
    [ -f "$B/$1/done" ] || none "no finished series $1 — the file $B/$1/done"
    sum_metric "$1" 'map(.wall_min) | add | . * 100 | round / 100'
}

# The sum of seed_first_agent_min of the runs of the series $1 — into $total,
# the number of its runs — into $runs. A run without a subagent of the stage
# seed adds nothing to the sum. A series that is not finished counts too: a
# probe with a run that is not passed gets the word rejected.
first_agent() {
    [ -d "$B/$1" ] || none "no series $1 — the folder $B/$1"
    sum_metric "$1" 'map(.seed_first_agent_min // 0) | add'
}

# Counts both series with the command from the arguments: the total of
# "before" — into $a, of "after" — into $b.
both() {
    local n
    "$@" "$before"
    a=$total
    n=$runs
    "$@" "$after"
    b=$total
    [ "$n" -eq "$runs" ] || none "the series have a different number of runs — $n and $runs"
}

case "$mode" in
    quality)
        both tally rule no
        if [ "$b" -le "$a" ]; then
            echo "violations: before $a, after $b — not more"
            exit 0
        fi
        echo "violations: before $a, after $b — more"
        ;;
    seeds)
        both tally seed found
        if [ "$b" -ge "$a" ]; then
            echo "seeds found: before $a, after $b — not less"
            exit 0
        fi
        echo "seeds found: before $a, after $b — less"
        ;;
    speed)
        both minutes
        if jq -en --argjson a "$a" --argjson b "$b" '$b < $a' > /dev/null; then
            echo "wall-clock minutes: before $a, after $b — less"
            exit 0
        fi
        echo "wall-clock minutes: before $a, after $b — not less"
        ;;
    effort)
        # The series — $before, the probe — $after.
        both first_agent
        word=accepted
        jq -en --argjson a "$a" --argjson b "$b" '$b < $a' > /dev/null || word=rejected
        for dir in "$B/$after"/[0-9]*; do
            [ -d "$dir" ] || continue
            jq -e '.done == true' "$dir/seed/stage.json" > /dev/null 2>&1 || word=rejected
            jq -e '.seed_first_agent_effort == "high"' "$dir/metrics.json" > /dev/null || word=rejected
            # The progress log — progress.md and its parts, as in collect.sh.
            if grep -qs 'S3: attempt' "$dir/seedbox/wiki-trial/clean/docs/work/longest"/progress*.md; then
                word=rejected
            fi
        done
        echo "$word" > "$B/$after/verdict.txt"
        echo "effort high: $word"
        exit 0
        ;;
    *) usage ;;
esac
exit 1
