#!/bin/bash
# Seeds into a stand project the topics two swork sessions execute at once.
#
#   bash tests/chain/seed-pair.sh <project> a|b
#
# <project> is clean from make-wiki.sh. Case a: the topics usage and version — S1 of usage
# creates USAGE.md, S1 of version creates VERSION, and S2 of each appends its own line to
# the one shared README.md and depends on its S1. Case b: the topic pair — four slices
# that depend on nothing, each creating its own file. Every topic is in the phase "plan
# confirmed": no .swork/, no progress card, no marker. Then the project goes under git with
# the commit "seed", and the line "Checked against code" of each plan.md names it. Every
# check line is order-free: `grep -qxF '<line>' <file> && echo ok` prints `ok`. Like seed.sh,
# it is not run a second time on the same project.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo "usage: bash seed-pair.sh <project> a|b" >&2
    exit 2
}
[ $# -eq 2 ] || usage
case "$2" in
    a | b) ;;
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

# ---------- the slices ----------

# What slice() gathers for the topic cards; begin() empties it.
begin() {
    reqs=""
    cards=""
    rows=""
    n=0
}

# A slice card with ready text and its requirement and check line: $1 — the topic, $2 — the
# file name part, $3 — the title, $4 — the essence, $5 — "none" or the slice it depends on,
# $6 — create or append, $7 — the file, $8 — the ready text, $9 — the line the check looks for.
slice() {
    local W="$D/work/$1" files todo takes count check
    n=$((n + 1))
    count=$(printf '%s\n' "$8" | wc -l | tr -d ' ')
    check="grep -qxF '$9' $7 && echo ok"
    if [ "$6" = create ]; then
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
    rows="$rows| $n | R$n | the slice is done → its line is in \`$7\` | \`$check\` | \`ok\` | S$n | not run |"$'\n'
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
  - gives: \`$7\` in the project root
- **Reuse:** nothing to reuse — searched: the project root, the word \`$7\`
- **What to do:** $todo

  \`\`\`
$(printf '%s\n' "$8" | sed 's/^/  /')
  \`\`\`
- **Checks:** line $n
EOF
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
else
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

(
    cd "$P"
    git init -q
    git add -A
    git -c user.name=stand -c user.email=stand@local commit -qm seed
)
seed="$(git -C "$P" rev-parse --short HEAD), branch $(git -C "$P" rev-parse --abbrev-ref HEAD), $today"
SEED="$seed" perl -pi -e 's/^- \*\*Checked against code:\*\* SEED$/- **Checked against code:** $ENV{SEED}/' \
    "$D"/work/*/plan.md
