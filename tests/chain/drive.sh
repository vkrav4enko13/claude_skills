#!/bin/bash
# Drives one stage of the chain on the stand without a person: a claude -p
# session with project-level skills; the questions of the skill are answered
# by the fixed line of the stage.
#
#   bash tests/chain/drive.sh <project> <stage> <stage folder> [<level>]
#
# The level is the effort of the session: low medium high xhigh max, without
# it — medium. Stages: brain, plan, work, seed, away. The first turn starts the skill. While
# the topic phase in state.md is not the one the stage is passed with — one more
# turn with the stage answer into the same session, at most six answers. The
# stage away is exactly one turn and no answer: saway reads any answer as the
# user's return. Its project is seeded by seed-away.sh. The
# reply of every turn goes to turns/NN.json of the stage folder, the wall-clock
# seconds — to wall.txt; at the end it calls collect.sh.
# Takes from ten minutes to an hour and longer.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo "usage: bash drive.sh <project> <stage> <stage folder> [<level>]" >&2
    exit 2
}
[ $# -eq 3 ] || [ $# -eq 4 ] || usage
effort="${4:-medium}"
case "$effort" in
    low | medium | high | xhigh | max) ;;
    *) usage ;;
esac
project="${1%/}"
stage="$2"
dir="${3%/}"
here="$(cd "$(dirname "$0")" && pwd)"

# The stage topic, the phase it is passed with, the first turn and the stage answer.
case "$stage" in
    brain)
        topic=count
        phase='requirements confirmed'
        first="/sbrain Тема count. Опрос и подходы закончены, дизайн по частям не проводился; сводка ниже подтверждена пользователем — начни с записи итога большого пути.

$(cat "$here/../trial-summary.md")"
        answer='После показа итога: да, на этом остановиться.'
        ;;
    plan)
        topic=count
        phase='plan confirmed'
        first='/splan count — спланируй тему'
        answer='Да, одобряю показанное как есть. После показа плана: да, исполнять.'
        ;;
    work)
        topic=count
        phase='done'
        first='/swork count — исполни план'
        answer='Принять работу; коммит не нужен.'
        ;;
    seed)
        topic=longest
        phase='done'
        first='/swork longest — продолжи работу'
        answer='Принять работу; коммит не нужен.'
        ;;
    away)
        topic=longest
        first='/saway longest — я ушёл, доделай без меня: решай сам и не жди моих ответов'
        answer=''
        ;;
    *) echo "unknown stage: $stage" >&2; exit 2 ;;
esac
answer="$answer На любой другой вопрос — рекомендованный вариант."

# A turn: $1 — the text, the rest — an addition to the call (--resume <id>). The reply goes to $out.
n=0
turn() {
    n=$((n + 1))
    out="$dir/turns/$(printf '%02d' "$n").json"
    (
        cd "$project"
        CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/claude/personal}" \
            "$HOME/.local/bin/claude" -p "$1" "${@:2}" \
            --setting-sources project,local --permission-prompts none \
            --permission-mode acceptEdits \
            --allowedTools Bash Read Edit Write Glob Grep Agent Skill \
            --model claude-opus-5-5 --effort "$effort" --output-format json \
            < /dev/null > "$out"
    )
}

passed() {
    grep -q "Phase:\*\* $phase" "$project/docs/work/$topic/state.md" 2>/dev/null
}

mkdir -p "$dir/turns"
SECONDS=0
turn "$first"
answers=0
if [ "$stage" != away ]; then
    while ! passed && [ $answers -lt 6 ]; do
        answers=$((answers + 1))
        turn "$answer" --resume "$(jq -r .session_id "$out")"
    done
fi
echo "$SECONDS" > "$dir/wall.txt"

"$BASH" "$here/collect.sh" "$project" "$stage" "$dir"
