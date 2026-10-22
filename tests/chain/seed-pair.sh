#!/bin/bash
# Seeds into a stand project the topics two swork sessions execute at once.
#
#   bash tests/chain/seed-pair.sh <project> a|b|c|d|e|f|g|h
#
# <project> is clean from make-wiki.sh. Case a: the topics usage and version — S1 of usage
# creates USAGE.md, S1 of version creates VERSION, and S2 of each appends its own line to
# the one shared README.md and depends on its S1. Case b: the topic pair — four slices
# that depend on nothing, each creating its own file. Cases c–f seed app.js (~50 lines,
# left() near the top, right() near line 40, the line of label), src/shop.js with buy(),
# src/hud.js with draw() and resources.json {}, and topics of one slice each with no
# dependency, whose ready text replaces whole lines: case c and f — the topics left and
# right each change the return value of its own function of app.js; case d — both change
# the label line, left its text and right its color; case e — the topics shop and hud each
# add the same function formatReward() to their file, call it, and add the key bonus_win
# with their own value to resources.json. Every topic is in the phase "plan confirmed": no
# .swork/, no progress card, no marker. Then the project goes under git with the commit
# "seed", and the line "Checked against code" of each plan.md names it; case f stays without
# git and that line holds the date. Case g: the repository <project>/../lib-src with util.js
# holding tag() is added to the stand as the submodule lib/ with its own commit, named by
# "Checked against code"; the topic left is that of case c, the topic right one slice that
# changes "old" to "new" in lib/util.js. Case h: the topics left and right of case c, left
# with two slices and right with three, each later slice depending on the one before and
# changing another line of its own function of app.js, every check starting with `sleep 20`.
# Every case but h ends with `agents.sh on`: .agents/mode holds auto; case h has no .agents/.
# The checks of cases a and b are order-free: `grep -qxF '<line>' <file> && echo ok`
# prints `ok`; those of cases c–g start with `sleep 20`, so that both sessions overlap, and
# grep or jq their own edits. Like seed.sh, it is not run a second time on the same project.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo "usage: bash seed-pair.sh <project> a|b|c|d|e|f|g|h" >&2
    exit 2
}
[ $# -eq 2 ] || usage
case "$2" in
    a | b | c | d | e | f | g | h) ;;
    *) usage ;;
esac
P="$(cd "$1" && pwd)"
D="$P/docs"
today=$(date +%F)
month=${today%-*}
next='execute the plan through `swork`'

# The state card of a topic: $1 — the file, $2 — the topic, $3 — the phase with the date,
# $4 — the journal, $5 — what is verified, $6 — the next step. A copy of make-wiki.sh.
state() {
    cat > "$1" <<EOF
# State of topic $2

> Topic phase and the step the next session starts from.

- **Phase:** $3
- **Path:** large
- **Journal:** $4
- **Verified:** $5
- **Next step:** $6
EOF
}

# The index of a topic folder: $1 — the file, $2 — the topic, $3 — the essence, $4 — the date and the goal.
# A copy of make-wiki.sh.
topic_index() {
    cat > "$1" <<EOF
# $2

> $3

**Requirements confirmed:** $4

## Cards

- [State](state.md) — topic phase and next step
EOF
}

# ---------- project files ----------

cat > "$P/README.md" <<'EOF'
# Word list

A trial project: a list of words in `app.txt`, one per line.

## Running

The commands are run from the project root.

- `cat app.txt` — show the word list
EOF

if [ "$2" != a ] && [ "$2" != b ]; then
    {
        echo '// The word game: two panels, a label and a word list.'
        echo 'function left() {'
        echo '  return "left panel";'
        echo '}'
        echo
        echo 'const label = { text: "Play", color: "grey" };'
        echo
        echo 'const words = ['
        for w in apple brook cedar dune ember fjord grove heron iris jade kelp lark maple \
            north olive pearl quill reed sage thorn umber vale wren yarrow zinc; do
            echo "  \"$w\","
        done
        echo '];'
        echo
        echo 'function count() {'
        echo '  return words.length;'
        echo '}'
        echo
        echo 'function right() {'
        echo '  return "right panel";'
        echo '}'
        echo
        echo 'function last() {'
        echo '  return words[words.length - 1];'
        echo '}'
        echo
        echo 'module.exports = { left, right, count, last, label };'
    } > "$P/app.js"
    mkdir -p "$P/src"
    cat > "$P/src/shop.js" <<'EOF'
// The shop: buying an item gives a reward.
function buy(item) {
  return { item: item, reward: 10 };
}

module.exports = { buy };
EOF
    cat > "$P/src/hud.js" <<'EOF'
// The HUD: draws the score line.
function draw(score) {
  return "Score: " + score;
}

module.exports = { draw };
EOF
    echo '{}' > "$P/resources.json"
fi

# ---------- the slices ----------

# What slice() gathers for the topic cards; begin() empties it.
begin() {
    reqs=""
    cards=""
    rows=""
    n=0
    edit_files=""
    edit_todo=""
}

# One replacement of the next slice with the action replace: $1 — the file, $2 — the whole
# line it replaces, $3 — the new text, one line or several. A slice may gather several files.
replace() {
    case " $edit_files " in
        *" $1 "*) ;;
        *) edit_files="${edit_files:+$edit_files }$1" ;;
    esac
    edit_todo="$edit_todo

  In \`$1\`, the line

  \`\`\`
$(printf '%s\n' "$2" | sed 's/^/  /')
  \`\`\`

  becomes

  \`\`\`
$(printf '%s\n' "$3" | sed 's/^/  /')
  \`\`\`"
}

# A slice card with ready text and its requirement and check line: $1 — the topic, $2 — the
# file name part, $3 — the title, $4 — the essence, $5 — "none" or the slice it depends on,
# $6 — create or append, $7 — the file, $8 — the ready text, $9 — the line the check looks for.
# With $6 replace the edits are the replace() calls made since the last slice and $7 is the
# whole check command.
slice() {
    local W="$D/work/$1" files todo takes count check where done gives f
    n=$((n + 1))
    count=$(printf '%s\n' "${8-}" | wc -l | tr -d ' ')
    check="grep -qxF '${9-}' $7 && echo ok"
    where="\`$7\`"
    done="its line is in $where"
    gives="$where in the project root"
    if [ "$6" = replace ]; then
        check="$7"
        where="\`${edit_files// /\`, \`}\`"
        files=""
        for f in $edit_files; do
            files="${files:+$files$'\n'  - }change: \`$f\`"
        done
        todo="replace whole lines verbatim: each line below goes and the text under it takes its place.$edit_todo"
        reqs="$reqs- R$n. $where hold the edits of slice S$n."$'\n'
        done="its edits are in $where"
        gives="$where in the project"
        edit_files=""
        edit_todo=""
    elif [ "$6" = create ]; then
        files="create: \`$7\`"
        todo="create \`$7\` of exactly $count lines, verbatim:"
        if [ "$count" -eq 1 ]; then todo="create \`$7\` of exactly one line, verbatim:"; fi
        reqs="$reqs- R$n. The project keeps the file \`$7\` in its root with the text of slice S$n."$'\n'
    else
        files="change: \`$7\` (one line at the end)"
        todo="append to the end of \`$7\` one line, verbatim:"
        reqs="$reqs- R$n. \`$7\` ends with the line of slice S$n."$'\n'
    fi
    takes=nothing
    if [ "$5" != none ]; then takes="the result of $5"; fi
    cards="$cards- [S$n. $3](plan-s$n-$2.md) — $4"$'\n'
    rows="$rows| $n | R$n | the slice is done → $done | \`$check\` | \`ok\` | S$n | not run |"$'\n'
    cat > "$W/plan-s$n-$2.md" <<EOF
# S$n. $3

> $4

- **Status:** not started
- **Covers:** R$n
- **Depends on:** $5
- **Marks:** ready text
- **Files:**
  - $files
- **Interfaces:**
  - takes: $takes
  - gives: $gives
- **Reuse:** nothing to reuse — searched: the project root, the word $where
EOF
    if [ "$6" = replace ]; then
        echo "- **What to do:** $todo" >> "$W/plan-s$n-$2.md"
    else
        cat >> "$W/plan-s$n-$2.md" <<EOF
- **What to do:** $todo

  \`\`\`
$(printf '%s\n' "$8" | sed 's/^/  /')
  \`\`\`
EOF
    fi
    echo "- **Checks:** line $n" >> "$W/plan-s$n-$2.md"
}

# The cards of a topic around its slices: $1 — the topic, $2 — the essence, $3 — the goal.
finish() {
    local W="$D/work/$1"
    topic_index "$W/00-index.md" "$1 — $2" "The goal: $3." "$today — goal: «$3»"
    cat >> "$W/00-index.md" <<EOF
- [Task](task.md) — what we build, for whom, and how we will know it worked
- [Requirements](requirements.md) — R1–R$n
- [Scope](scope.md) — what is out of scope, assumptions and open questions
- [Plan](plan.md) — goal, shared constraints, what we do not do, and the discrepancy rule
- [Technical decisions](plan-decisions.md) — what was chosen, instead of what, and the check focus
- [Check lines](plan-checks.md) — lines 1–$n: how each requirement is checked
${cards%$'\n'}
EOF
    state "$W/state.md" "$1" "plan confirmed — $today" "journal/$month.md, line of $today" \
        "the plan against the code" "$next"

    cat > "$W/task.md" <<EOF
# Task of topic $1

> What we build, for whom, and how we will know it worked.

## In brief

$3.

## Success criteria

- Every check line of the plan prints \`ok\`.
EOF

    cat > "$W/requirements.md" <<EOF
# Requirements of topic $1

> What the topic builds: $2.

${reqs%$'\n'}
EOF

    cat > "$W/scope.md" <<'EOF'
# Scope

> What is out of scope, assumptions and open questions.

## Out of scope

- Editing `app.txt`.

## Assumptions and open questions

- There are no questions without an answer to which planning is impossible.
EOF

    cat > "$W/plan.md" <<EOF
# Plan of topic $1

> Plan header: goal, shared constraints, what we do not do, and the rule for the executor.

- **Goal:** $3
- **Requirements:** [Requirements](requirements.md) — R1–R$n
- **Checked against code:** SEED
- **Execution:** slices in dependency order; the discrepancy rule is at the end of the card

## Shared constraints

- The texts of the files are written verbatim, as the slice cards give them.

## Not doing

- We do not edit \`app.txt\` or the wiki cards outside the topic.
- The rest is in [Scope](scope.md), section "Out of scope".

## If the code differs from the plan

Stop and report: **expected** — what the plan says; **found** — what is in the code, with the path;
**why it matters** — what fails to line up because of it. Do not silently bend the code to the plan or the plan to the code.
Report a minor discrepancy too (a file moved, a name changed, the meaning is the same): the slice card is fixed by \`swork\`, not by you.
EOF

    cat > "$W/plan-decisions.md" <<EOF
# Technical decisions of topic $1

> What the plan chose, instead of what and why; which failures and kinds of input it checks beyond the named ones.

## Technical decisions

- **Ready text in every slice** — instead of a description: the files are short.

## Check focus

- every check looks for its line wherever it stands in the file — S1–S$n
EOF

    cat > "$W/plan-checks.md" <<EOF
# Check lines of topic $1

> How each requirement is checked: scenario, command, expected result and the owning slice.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
${rows%$'\n'}
EOF

    index="$index- [$1](work/$1/00-index.md) — plan confirmed — next: $next"$'\n'
    echo "- [$1](${1}/00-index.md) — $2" >> "$D/work/00-index.md"
    echo "- $today · [$1](../work/$1/00-index.md): $3 — plan confirmed" >> "$D/journal/$month.md"
}

usage_text='# Using the word list
- cat app.txt — show the word list
- wc -l app.txt — count the words'
changes_text='# Changes
- 1.0 — the first version'

index=""
if [ "$2" = a ]; then
    mkdir -p "$D/work/usage" "$D/work/version"
    begin
    slice usage memo 'The usage memo' '`USAGE.md`: three lines about the word list' none \
        create USAGE.md "$usage_text" '# Using the word list'
    slice usage readme 'The usage line' '`README.md` points to `USAGE.md`' S1 \
        append README.md 'Usage: see USAGE.md' 'Usage: see USAGE.md'
    finish usage 'the usage memo' 'the memo `USAGE.md` and a line about it in `README.md`'
    begin
    slice version file 'The version file' '`VERSION`: one line with the version' none \
        create VERSION '1.0' '1.0'
    slice version readme 'The version line' '`README.md` points to `VERSION`' S1 \
        append README.md 'Version: see VERSION' 'Version: see VERSION'
    finish version 'the version file' 'the file `VERSION` and a line about it in `README.md`'
elif [ "$2" = b ]; then
    mkdir -p "$D/work/pair"
    begin
    slice pair usage 'The usage memo' '`USAGE.md`: three lines about the word list' none \
        create USAGE.md "$usage_text" '# Using the word list'
    slice pair version 'The version file' '`VERSION`: one line with the version' none \
        create VERSION '1.0' '1.0'
    slice pair authors 'The authors file' '`AUTHORS`: one line' none \
        create AUTHORS 'stand <stand@local>' 'stand <stand@local>'
    slice pair changes 'The change list' '`CHANGES.md`: two lines' none \
        create CHANGES.md "$changes_text" '# Changes'
    finish pair 'four project files' 'the files `USAGE.md`, `VERSION`, `AUTHORS` and `CHANGES.md`'
elif [ "$2" = e ]; then
    reward='function formatReward(n) {
  return "+" + n + " coins";
}

module.exports = '
    mkdir -p "$D/work/shop" "$D/work/hud"
    begin
    replace src/shop.js '  return { item: item, reward: 10 };' '  return { item: item, reward: formatReward(10) };'
    replace src/shop.js 'module.exports = { buy };' "${reward}{ buy };"
    replace resources.json '{}' '{
  "bonus_win": "Bonus"
}'
    slice shop reward 'The shop reward' '`buy()` formats its reward; the resource `bonus_win`' none replace \
        "sleep 20 && grep -qF 'reward: formatReward(10)' src/shop.js && jq -e '.bonus_win' resources.json >/dev/null && echo ok"
    finish shop 'the shop reward' 'the reward of `buy()` formatted and the resource `bonus_win`'
    begin
    replace src/hud.js '  return "Score: " + score;' '  return "Score: " + formatReward(score);'
    replace src/hud.js 'module.exports = { draw };' "${reward}{ draw };"
    replace resources.json '{}' '{
  "bonus_win": "Win bonus"
}'
    slice hud reward 'The HUD reward' '`draw()` formats the score; the resource `bonus_win`' none replace \
        "sleep 20 && grep -qF '\"Score: \" + formatReward(score)' src/hud.js && jq -e '.bonus_win' resources.json >/dev/null && echo ok"
    finish hud 'the HUD reward' 'the score of `draw()` formatted and the resource `bonus_win`'
elif [ "$2" = h ]; then
    mkdir -p "$D/work/left" "$D/work/right"
    begin
    replace app.js '  return "left panel";' '  return "left panel, ready";'
    slice left return 'The left return' '`app.js`: the return line of `left()`' none replace \
        "sleep 20 && grep -qF '  return \"left panel, ready\";' app.js && echo ok"
    replace app.js 'function left() {' 'function left() { // left: checked'
    slice left head 'The left head' '`app.js`: the first line of `left()`' S1 replace \
        "sleep 20 && grep -qF 'function left() { // left: checked' app.js && echo ok"
    finish left 'the left change' 'the left changes of `app.js`'
    begin
    replace app.js '  return "right panel";' '  // right panel
  return "right panel, ready";'
    slice right return 'The right return' '`app.js`: the return line of `right()` and a comment' none replace \
        "sleep 20 && grep -qF '  return \"right panel, ready\";' app.js && echo ok"
    replace app.js 'function right() {' 'function right() { // right: checked'
    slice right head 'The right head' '`app.js`: the first line of `right()`' S1 replace \
        "sleep 20 && grep -qF 'function right() { // right: checked' app.js && echo ok"
    replace app.js '  // right panel' '  // right panel: done'
    slice right comment 'The right comment' '`app.js`: the comment line of `right()`' S2 replace \
        "sleep 20 && grep -qF '  // right panel: done' app.js && echo ok"
    finish right 'the right change' 'the right changes of `app.js`'
else
    if [ "$2" = d ]; then
        old='const label = { text: "Play", color: "grey" };'
        new1='const label = { text: "Start", color: "grey" };'
        new2='const label = { text: "Play", color: "gold" };'
        look1='text: "Start"'
        look2='color: "gold"'
        title1='The label text'
        title2='The label color'
    else
        old=""
        title1='The left panel'
        title2='The right panel'
    fi
    mkdir -p "$D/work/left" "$D/work/right"
    begin
    if [ -z "$old" ]; then
        new1='  return "left panel, ready";'
        look1="$new1"
        replace app.js '  return "left panel";' "$new1"
    else
        replace app.js "$old" "$new1"
    fi
    slice left change "$title1" '`app.js`: one line of the left topic' none replace \
        "sleep 20 && grep -qF '$look1' app.js && echo ok"
    finish left 'the left change' 'the left change of `app.js`'
    begin
    if [ "$2" = g ]; then
        title2='The submodule tag'
        replace lib/util.js 'function tag() { return "old"; }' 'function tag() { return "new"; }'
        slice right tag "$title2" '`lib/util.js`: the tag of the submodule' none replace \
            "sleep 20; grep -qF '\"new\"' lib/util.js && echo ok"
        finish right 'the right change' 'the tag of `lib/util.js` changed'
    else
        if [ -z "$old" ]; then
            new2='  return "right panel, ready";'
            look2="$new2"
            replace app.js '  return "right panel";' "$new2"
        else
            replace app.js "$old" "$new2"
        fi
        slice right change "$title2" '`app.js`: one line of the right topic' none replace \
            "sleep 20 && grep -qF '$look2' app.js && echo ok"
        finish right 'the right change' 'the right change of `app.js`'
    fi
fi

# The topic lines go to the end of the "In progress" list of the root index: before the empty
# line that ends the section.
out=""
part=0
while IFS= read -r line; do
    case "$part:$line" in
        "0:## In progress") part=1 ;;
        1:) part=2 ;;
        2:)
            out="$out$index"
            part=3
            ;;
    esac
    out="$out$line"$'\n'
done < "$D/00-index.md"
printf '%s' "$out" > "$D/00-index.md"

# ---------- git ----------

if [ "$2" != f ]; then
    (
        cd "$P"
        git init -q
        git add -A
        git -c user.name=stand -c user.email=stand@local commit -qm seed
    )
    if [ "$2" = g ]; then
        # The submodule lib/: a repository beside the project with one committed file.
        L="$(cd "$P/.." && pwd)/lib-src"
        mkdir -p "$L"
        (
            cd "$L"
            git init -q
            echo 'function tag() { return "old"; }' > util.js
            git add -A
            git -c user.name=stand -c user.email=stand@local commit -qm lib
        )
        (
            cd "$P"
            git -c protocol.file.allow=always submodule add -q "$L" lib
            git -c user.name=stand -c user.email=stand@local commit -qm 'submodule lib'
        )
    fi
    seed="$(git -C "$P" rev-parse --short HEAD), branch $(git -C "$P" rev-parse --abbrev-ref HEAD), $today"
else
    seed="$today"
fi
SEED="$seed" perl -pi -e 's/^- \*\*Checked against code:\*\* SEED$/- **Checked against code:** $ENV{SEED}/' \
    "$D"/work/*/plan.md

# ---------- the multi-agent mode ----------

# Only when the stand's skills have agents.sh: skills from before it seed without the mode.
if [ "$2" != h ] && [ -f "$P/.claude/skills/swork/scripts/agents.sh" ]; then
    (
        cd "$P"
        bash "$P/.claude/skills/swork/scripts/agents.sh" on
    )
fi
