#!/bin/bash
# Seeds into a stand project the topic count-q in the state the stage small starts from.
#
#   bash tests/chain/seed-small.sh <project>
#
# <project> is clean from make-wiki.sh: app.txt of three words and a wiki in docs/.
# It adds count.sh — it prints the line count of app.txt — and the topic docs/work/count-q
# in the phase "requirements confirmed" with one requirement: the -q flag of count.sh. It is
# not run a second time on the same project: the topic lines in the indexes and the journal
# would be added again.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: bash seed-small.sh <project>" >&2
    exit 2
fi
P="$(cd "$1" && pwd)"
D="$P/docs"
W="$D/work/count-q"

today=$(date +%F)
month=${today%-*}
goal='with the `-q` flag, `count.sh` prints nothing and exits 0 when `app.txt` is empty, 1 otherwise'
next='make a plan through `splan`'

# ---------- project files ----------

cat > "$P/count.sh" <<'EOF'
#!/bin/bash
# Prints the line count of app.txt.
#
#   bash count.sh
export LC_ALL=C.UTF-8
set -euo pipefail

echo $(($(wc -l < app.txt)))
EOF

# ---------- wiki: the topic lines ----------

mkdir -p "$W"

# The topic line goes to the end of the "In progress" list of the root index: before the empty
# line that ends the section.
out=""
part=0
while IFS= read -r line; do
    case "$part:$line" in
        "0:## In progress") part=1 ;;
        1:) part=2 ;;
        2:)
            out="$out- [count-q](work/count-q/00-index.md) — requirements confirmed — next: $next"$'\n'
            part=3
            ;;
    esac
    out="$out$line"$'\n'
done < "$D/00-index.md"
printf '%s' "$out" > "$D/00-index.md"

echo '- [count-q](count-q/00-index.md) — the quiet flag of `count.sh`' >> "$D/work/00-index.md"
echo "- $today · [count-q](../work/count-q/00-index.md): $goal — requirements written" >> "$D/journal/$month.md"

# ---------- wiki: the topic cards ----------

cat > "$W/00-index.md" <<EOF
# count-q — the quiet flag of count.sh

> With \`-q\`, \`count.sh\` tells by its exit code alone whether \`app.txt\` is empty.

**Requirements confirmed:** $today — goal: «${goal}»

## Cards

- [State](state.md) — topic phase and next step
- [Task](task.md) — what we build, for whom, and how we will know it worked
- [Requirements](requirements.md) — R1
- [Decisions](decisions.md) — what was chosen, instead of what, and whose decision
- [Scope](scope.md) — what is out of scope, assumptions and open questions
EOF

cat > "$W/state.md" <<EOF
# State of topic count-q

> Topic phase and the step the next session starts from.

- **Phase:** requirements confirmed — $today
- **Path:** large
- **Journal:** journal/$month.md, line of $today
- **Verified:** none
- **Next step:** $next
EOF

cat > "$W/task.md" <<'EOF'
# Task of topic count-q

> What we build, for whom, and how we will know it worked.

## In brief

`count.sh` gets the `-q` flag: it prints nothing and tells by its exit code whether `app.txt` is empty.

## Task

A script that only needs to know whether the word list is empty now parses the number `count.sh` prints. An exit code is simpler to test in a shell condition.

## Success criteria

- `bash count.sh -q` on an empty `app.txt` prints nothing and exits 0.
- `bash count.sh -q` on a non-empty `app.txt` prints nothing and exits 1.
EOF

cat > "$W/requirements.md" <<'EOF'
# Requirements of topic count-q

> What the `-q` flag of `count.sh` prints and with which exit code.

- R1. With `-q`, `count.sh` prints nothing and exits 0 when `app.txt` is empty, 1 otherwise.
EOF

cat > "$W/decisions.md" <<'EOF'
# Decisions of topic count-q

> What was chosen, instead of what, and whose decision.

- the flag of the same script, instead of a second script — one command is easier to remember; user chose; in force
EOF

cat > "$W/scope.md" <<'EOF'
# Scope of topic count-q

> What is out of scope, assumptions and open questions.

## Out of scope

- Editing `app.txt`: the script only reads the file.
- The output of `count.sh` without the flag: it stays as it is.

## Assumptions and open questions

- `app.txt` exists in the current folder.
- There are no questions without an answer to which planning is impossible.
EOF
