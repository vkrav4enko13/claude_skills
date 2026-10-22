#!/bin/bash
# Seeds a trap of traps/ into a stand project as a topic with confirmed requirements.
#
#   bash tests/chain/seed-trap.sh <project> <name>
#
# <project> is clean from make-wiki.sh; <name> is reuse, shared-bug, rename, traversal or
# native. The files of traps/<name>/project/ are copied into the project root. The topic <name>
# gets the six cards as sbrain writes them, in the phase "requirements confirmed": task.md and
# requirements.md are those of the trap, scope.md has "Out of scope: none". Then the project
# goes under git with the commit "seed". The hidden check and the references of the trap stay
# in traps/<name>/. Like seed-pair.sh, it is not run a second time on the same project.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo "usage: bash seed-trap.sh <project> reuse|shared-bug|rename|traversal|native" >&2
    exit 2
}
[ $# -eq 2 ] || usage
case "$2" in
    reuse | shared-bug | rename | traversal | native) ;;
    *) usage ;;
esac
name="$2"
T="$(cd "$(dirname "$0")" && pwd)/traps/$name"
P="$(cd "$1" && pwd)"
D="$P/docs"
W="$D/work/$name"
today=$(date +%F)
month=${today%-*}
next='make a plan through `splan`'

# The state card of a topic: $1 — the file, $2 — the topic, $3 — the phase with the date,
# $4 — the journal, $5 — what is verified, $6 — the next step. A copy of seed-pair.sh.
state() {
    cat > "$1" <<EOT
# State of topic $2

> Topic phase and the step the next session starts from.

- **Phase:** $3
- **Path:** large
- **Journal:** $4
- **Verified:** $5
- **Next step:** $6
EOT
}

# The index of a topic folder: $1 — the file, $2 — the topic, $3 — the essence, $4 — the date and the goal.
# A copy of seed-pair.sh.
topic_index() {
    cat > "$1" <<EOT
# $2

> $3

**Requirements confirmed:** $4

## Cards

- [State](state.md) — topic phase and next step
EOT
}

# ---------- project files ----------

cp -R "$T/project/." "$P/"

# ---------- the topic cards ----------

mkdir -p "$W"
cp "$T/task.md" "$T/requirements.md" "$W/"
# The goal: the line under "## In brief" of the trap's task.md.
goal=$(awk 'f && NF { print; exit } /^## In brief$/ { f = 1 }' "$T/task.md")
goal=${goal%.}
n=$(grep -c '^- R[0-9][0-9]*\. ' "$T/requirements.md")

topic_index "$W/00-index.md" "$name" "$goal." "$today — goal: «$goal»"
cat >> "$W/00-index.md" <<EOT
- [Task](task.md) — what we build, for whom, and how we will know it worked
- [Requirements](requirements.md) — R1–R$n
- [Decisions](decisions.md) — what was chosen, instead of what, and whose decision
- [Scope](scope.md) — what is out of scope, assumptions and open questions
EOT
state "$W/state.md" "$name" "requirements confirmed — $today" "journal/$month.md, line of $today" \
    "none" "$next"

cat > "$W/decisions.md" <<EOT
# Decisions of topic $name

> What was chosen, instead of what, and whose decision.

- No decisions: the task leaves no choice open.
EOT

cat > "$W/scope.md" <<'EOT'
# Scope

> What is out of scope, assumptions and open questions.

## Out of scope

Out of scope: none

## Assumptions and open questions

- There are no questions without an answer to which planning is impossible.
EOT

echo "- [$name]($name/00-index.md) — $goal" >> "$D/work/00-index.md"
echo "- $today · [$name](../work/$name/00-index.md): $goal — requirements written" >> "$D/journal/$month.md"

# The topic line goes to the end of the "In progress" list of the root index: before the empty
# line that ends the section. As in seed-pair.sh.
index="- [$name](work/$name/00-index.md) — requirements confirmed — next: $next"$'\n'
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
