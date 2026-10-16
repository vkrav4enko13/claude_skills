#!/bin/bash
# Drives one stage of the chain on the stand without a person: a claude -p
# session with project-level skills; the questions of the skill are answered
# by the fixed line of the stage.
#
#   bash tests/chain/drive.sh <project> <stage> <stage folder> [<level>]
#   bash tests/chain/drive.sh <project> pair <stage folder> <level> <topic>
#
# The level is the effort of the session: low medium high xhigh max, without
# it — medium. Stages: brain, plan, work, seed, away, pair, survey, grill. The first turn starts the skill. While
# the topic phase in state.md is not the one the stage is passed with — one more
# turn with the stage answer into the same session, at most six answers. The
# stage away is exactly one turn and no answer: saway reads any answer as the
# user's return. Its project is seeded by seed-away.sh. The stage pair starts
# swork on the topic of the fifth argument and, like away, has exactly one turn: two
# of them run at once in one project seeded by seed-pair.sh. The stage survey starts
# sbrain from a raw idea; every next turn is the answer of answer.sh from
# persona.md to the reply texts of the last turn. It ends when a topic folder
# that was not there before the first turn has the phase requirements
# confirmed, on the answer END, on a failed answer.sh or after twelve answers;
# the reason — confirmed, END, error or cap — goes to ended.txt. The stage
# grill starts sbrain on the plan plan-shortest.md of the project root and goes
# as survey does, but ends after eight answers and never on confirmed; the
# reason — END, error or cap — goes to ended.txt as well. The
# reply of every turn goes to turns/NN.json of the stage folder, the wall-clock
# seconds — to wall.txt; at the end it calls collect.sh. Every turn gets the temp folder
# tmp/ of the stage folder as TMPDIR.
# Takes from ten minutes to an hour and longer.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo "usage: bash drive.sh <project> <stage> <stage folder> [<level>]" >&2
    echo "       bash drive.sh <project> pair <stage folder> <level> <topic>" >&2
    exit 2
}
if [ "${2:-}" = pair ]; then [ $# -eq 5 ] || usage; else [ $# -eq 3 ] || [ $# -eq 4 ] || usage; fi
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
    pair)
        topic="$5"
        first="/swork $topic — исполни план"
        answer=''
        ;;
    survey)
        topic=''
        phase='requirements confirmed'
        first='/sbrain погрилль меня: хочу скрипт long.sh, который считает, сколько слов в app.txt длиннее N букв'
        answer=''
        ;;
    grill)
        topic=''
        phase=''
        first='/sbrain погрилль мой план plan-shortest.md'
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
        TMPDIR="$dir/tmp" CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/claude/personal}" \
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

# survey: a topic folder that was not there before the first turn has the stage phase.
confirmed() {
    local d
    for d in "$project"/docs/work/*/; do
        case "$before" in *"|$d|"*) continue ;; esac
        if grep -q "Phase:\*\* $phase" "$d/state.md" 2>/dev/null; then return 0; fi
    done
    return 1
}

# survey and grill: the texts of all the reply blocks of the last turn — from the session
# records, after the last request with a text.
replies() {
    local f
    for f in "${CLAUDE_CONFIG_DIR:-$HOME/claude/personal}/projects"/*/"$1".jsonl; do
        [ -f "$f" ] || continue
        jq -rs 'def texts: if type == "string" then [.] else map(select(.type == "text") | .text) end;
            (to_entries
             | map(select(.value.type == "user" and (.value.isMeta | not)
                   and (.value.message.content | texts | length > 0)
                   and ((.value.message.content | texts | join("")) | test("^\\s*<task-notification>") | not)) | .key)
             | last // -1) as $i
            | .[$i + 1:][]
            | select(.type == "assistant")
            | (.message.content | texts)[]' "$f"
    done
}

mkdir -p "$dir/turns" "$dir/tmp"
before='|'
for d in "$project"/docs/work/*/; do before="$before$d|"; done
SECONDS=0
first_failed=0
turn "$first" || first_failed=1
answers=0
if [ "$stage" = survey ] || [ "$stage" = grill ]; then
    cap=12
    if [ "$stage" = grill ]; then cap=8; fi
    question="$(mktemp)"
    # The survey gets the persona without its grill part: there is no plan in that project.
    persona="$(mktemp)"
    trap 'rm -f "$question" "$persona"' EXIT
    if [ "$stage" = survey ]; then
        awk '/^## Грилль плана/ { exit } { print }' "$here/persona.md" > "$persona"
    else
        cp "$here/persona.md" "$persona"
    fi
    ended=error
    while [ $first_failed -eq 0 ]; do
        if [ "$stage" = survey ] && confirmed; then ended=confirmed; break; fi
        if [ $answers -ge $cap ]; then ended=cap; break; fi
        sid="$(jq -r .session_id "$out")" || { ended=error; break; }
        replies "$sid" > "$question" || { ended=error; break; }
        if ! reply="$("$BASH" "$here/answer.sh" "$persona" "$question")"; then
            ended=error
            break
        fi
        if [ "$(printf '%s' "$reply" | awk 'NF { last = $0 } END { gsub(/^[ \t]+|[ \t]+$/, "", last); print last }')" = END ]; then
            ended=END
            break
        fi
        answers=$((answers + 1))
        turn "$reply" --resume "$sid" || { ended=error; break; }
    done
    echo "$ended" > "$dir/ended.txt"
elif [ $first_failed -eq 1 ]; then
    exit 1
elif [ "$stage" != away ] && [ "$stage" != pair ]; then
    while ! passed && [ $answers -lt 6 ]; do
        answers=$((answers + 1))
        turn "$answer" --resume "$(jq -r .session_id "$out")"
    done
fi
echo "$SECONDS" > "$dir/wall.txt"

"$BASH" "$here/collect.sh" "$project" "$stage" "$dir"
