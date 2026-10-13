#!/bin/bash
# Seeds into a stand project the ready topic longest with five known defects.
#
#   bash tests/chain/seed.sh <project>
#
# <project> is clean from make-wiki.sh: app.txt of three words and a wiki in docs/.
# The topic docs/work/longest stays in the phase "execution in progress": the slices S1 and S2
# are done, S3 is not started; their code is longest.sh in the project root. The defects are
# named in seeds.md next to this script. The dates in the cards are today's: the file times are
# set by the run itself. README.md is written before the marker .swork-marker, longest.sh —
# a second after it. It is not run a second time on the same project: the topic lines
# in the indexes and the journal would be added again.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: bash seed.sh <project>" >&2
    exit 2
fi
P="$(cd "$1" && pwd)"
D="$P/docs"
W="$D/work/longest"
S="$W/.swork"

today=$(date +%F)
month=${today%-*}
goal='the script `longest.sh` prints the longest word of `app.txt`, and with the `-n` flag also its line number'
next='slice S3 — the memo `USAGE.md` of three lines'

# The commands of the check lines of the done slices: they go both into the table and into the snapshot.
line1='bash longest.sh'
line2='d=$(mktemp -d) && : > "$d/app.txt" && cp longest.sh "$d/" && cd "$d" && bash longest.sh > out.txt && wc -c < out.txt'
line3='bash longest.sh -n'

# ---------- project files ----------

# For the topic plan README.md is a ready file of the project: the slice S2 was to
# add a line about the flag to "Running" and did not (seed-3).
cat > "$P/README.md" <<'EOF'
# Word list

A trial project: a list of words in `app.txt`, one per line.

## Running

The commands are run from the project root.

- `cat app.txt` — show the word list
EOF

touch "$P/.swork-marker"
sleep 1

# The defects: the -a flag (seed-1), "error" and code 1 without the file (seed-2), the length
# in bytes (seed-4), the loop loses the last line that has no newline (seed-5).
cat > "$P/longest.sh" <<'EOF'
#!/bin/bash
# Prints the longest word of app.txt; of words of equal length — the first.
#
#   bash longest.sh [-n | -a]
#
# -n — the word and its line number separated by a space; -a — all the longest words.
# The file is empty — an empty line.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ ! -f app.txt ]; then
    echo "error" >&2
    exit 1
fi

# The length of the word $1.
length() {
    echo $(($(printf '%s' "$1" | wc -c)))
}

best=""
max=0
at=0
all=""
n=0
while IFS= read -r word; do
    n=$((n + 1))
    len=$(length "$word")
    if [ "$len" -gt "$max" ]; then
        best="$word"
        max=$len
        at=$n
        all="$word"
    elif [ "$len" -eq "$max" ]; then
        all="$all"$'\n'"$word"
    fi
done < app.txt

out="$best"
case "${1:-}" in
    -n) [ -z "$best" ] || out="$best $at" ;;
    -a) out="$all" ;;
esac
printf '%s\n' "$out"
EOF

# ---------- wiki: the topic lines ----------

mkdir -p "$W" "$S/base" "$S/checks"

# The topic line goes to the end of the "In progress" list of the root index: before the empty
# line that ends the section.
out=""
part=0
while IFS= read -r line; do
    case "$part:$line" in
        "0:## In progress") part=1 ;;
        1:) part=2 ;;
        2:)
            out="$out- [longest](work/longest/00-index.md) — execution in progress — next: $next"$'\n'
            part=3
            ;;
    esac
    out="$out$line"$'\n'
done < "$D/00-index.md"
printf '%s' "$out" > "$D/00-index.md"

echo '- [longest](longest/00-index.md) — the longest word of the list' >> "$D/work/00-index.md"
echo "- $today · [longest](../work/longest/00-index.md): $goal — requirements written" >> "$D/journal/$month.md"

# ---------- wiki: the topic cards ----------

cat > "$W/00-index.md" <<EOF
# longest — the longest word of the list

> The script prints the longest word of \`app.txt\`; how to run it is described in \`README.md\` and \`USAGE.md\`.

**Requirements confirmed:** $today — goal: «${goal}»

## Cards

- [State](state.md) — topic phase and next step
- [Task](task.md) — what we build, for whom, and how we will know it worked
- [Requirements](requirements.md) — R1–R3
- [Decisions](decisions.md) — what was chosen, instead of what, and whose decision
- [Scope](scope.md) — what is out of scope, assumptions and open questions
- [Plan](plan.md) — goal, shared constraints, what we do not do, and the discrepancy rule
- [Technical decisions](plan-decisions.md) — what was chosen, instead of what, and the check focus
- [Check lines](plan-checks.md) — lines 1–4: how each requirement is checked
- [S1. The longest word](plan-s1-longest.md) — \`bash longest.sh\` prints the longest word of the list
- [S2. The line number](plan-s2-number.md) — \`bash longest.sh -n\` prints the word with its line number
- [S3. The usage memo](plan-s3-usage.md) — \`USAGE.md\`: three lines about running the script
- [Progress log](progress.md) — the records of \`swork\` in order: slices, attempts, stops
EOF

cat > "$W/state.md" <<EOF
# State of topic longest

> Topic phase and the step the next session starts from.

- **Phase:** execution in progress — $today
- **Path:** large
- **Journal:** journal/$month.md, line of $today
- **Verified:** S1 and lines 1, 2; S2 and line 3
- **Next step:** $next
EOF

cat > "$W/task.md" <<'EOF'
# Task of topic longest

> What we build, for whom, and how we will know it worked.

## In brief

The script `longest.sh` prints the longest word of `app.txt`, and with the `-n` flag also its line number. The flag is described in `README.md`, and how to run the script — in the memo `USAGE.md`.

## Task

The longest word of the list is now looked for by eye: the user reads `app.txt` in full and counts the letters. The list grows, and counting by hand takes longer and gets less reliable.

## Success criteria

- `bash longest.sh` in the project root prints `карточка`, `bash longest.sh -n` — `карточка 1`.
- How to run the script is described: the `-n` flag — in `README.md`, both commands — in `USAGE.md`.
EOF

cat > "$W/requirements.md" <<'EOF'
# Requirements of topic longest

> What the script `longest.sh` prints and where it is described how to run the script.

- R1. The script `longest.sh` prints the longest word of `app.txt`: on an empty file — an empty line, without the file — `no file app.txt` to stderr and code 2.
- R2. When the script is run with the `-n` flag, it prints the word and its line number separated by a space; the flag is described in the "Running" section of the file `README.md`.
- R3. The project keeps the memo `USAGE.md` in its root: three lines about running the script.
EOF

cat > "$W/decisions.md" <<'EOF'
# Decisions of topic longest

> What was chosen, instead of what, and whose decision.

- of words of equal length the first in order is printed, instead of all of them at once — the output is always one line; agreed; in force
- the line number — by the `-n` flag of the same script, instead of a second script — one command is easier to run and to remember; user chose; in force
EOF

cat > "$W/scope.md" <<'EOF'
# Scope of topic longest

> What is out of scope, assumptions and open questions.

## Out of scope

- Sorting the words in `app.txt` — the topic `demo` deals with it.
- Editing `app.txt`: the script only reads the file.
- Other flags and output modes besides `-n`.

## Assumptions and open questions

- `app.txt` has one word per line, without empty lines and repeats — by the note "Format of app.txt".
- There are no questions without an answer to which planning is impossible.
EOF

cat > "$W/plan.md" <<EOF
# Plan of topic longest

> Plan header: goal, shared constraints, what we do not do, and the rule for the executor.

- **Goal:** $goal
- **Requirements:** [Requirements](requirements.md) — R1–R3
- **Checked against code:** the project is not under git — $today $(date +%H:%M)
- **Execution:** slices in dependency order; the discrepancy rule is at the end of the card

## Shared constraints

- The script is bash; it is run from the project root and reads \`app.txt\` from the current folder.
- The words in \`app.txt\` — one per line, the file — in UTF-8: the project rules.

## Not doing

- We do not edit \`app.txt\` or the wiki cards outside the topic.
- We do not add flags or modes beyond those named in the slices.
- The rest is in [Scope](scope.md), section "Out of scope".

## If the code differs from the plan

Stop and report: **expected** — what the plan says; **found** — what is in the code, with the path;
**why it matters** — what fails to line up because of it. Do not silently bend the code to the plan or the plan to the code.
Report a minor discrepancy too (a file moved, a name changed, the meaning is the same): the slice card is fixed by \`swork\`, not by you.
EOF

cat > "$W/plan-decisions.md" <<'EOF'
# Technical decisions of topic longest

> What the plan chose, instead of what and why; which failures and kinds of input it checks beyond the named ones.

## Technical decisions

- **One pass over the file with a `while read` loop** — instead of `sort` and `awk`: the words are few, and the line number for the `-n` flag is already at hand in the loop.
- **The flag — by comparing the first argument** — instead of `getopts`: there is one flag.

## Check focus

- the file `app.txt` is empty → an empty line, not an error — S1, line 2
EOF

cat > "$W/plan-checks.md" <<EOF
# Check lines of topic longest

> How each requirement is checked: scenario, command, expected result and the owning slice.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 1 | R1 | \`app.txt\` holds the words \`карточка\`, \`викки\`, \`журнал\` → the longest one is printed | \`$line1\` | \`карточка\` | S1 | green $today |
| 2 | R1 | \`app.txt\` is empty → an empty line is printed | \`$line2\` | \`1\` — one newline in the output | S1 | green $today |
| 3 | R2 | the \`-n\` flag → the word and its line number separated by a space | \`$line3\` | \`карточка 1\` | S2 | green $today |
| 4 | R3 | the memo is created → it holds the three lines from the slice card | \`cat USAGE.md\` | three lines — verbatim those in the card of S3 | S3 | not run |
EOF

cat > "$W/plan-s1-longest.md" <<'EOF'
# S1. The longest word

> The command `bash longest.sh` prints the longest word of the list.

- **Status:** done
- **Covers:** R1
- **Depends on:** none
- **Files:**
  - create: `longest.sh`
- **Interfaces:**
  - takes: `app.txt` in the current folder — a word per line
  - gives: `bash longest.sh` — the word to stdout, code 0
- **Reuse:** nothing to reuse — searched: the project root, the words `longest`, `wc`
- **What to do:**
  1. `longest.sh` is bash: it reads `app.txt` from the current folder with a `while read` loop and prints the longest word; of words of equal length — the first in order.
  2. The file is empty — it prints an empty line, code 0.
  3. There is no file — it writes `no file app.txt` to stderr and exits with code 2.
- **Checks:** lines 1, 2
EOF

cat > "$W/plan-s2-number.md" <<'EOF'
# S2. The line number

> The command `bash longest.sh -n` prints the word together with its line number.

- **Status:** done
- **Covers:** R2
- **Depends on:** S1
- **Files:**
  - change: `longest.sh` (the parsing of the flag and the output)
  - change: `README.md` (the "Running" section: a line about the `-n` flag)
- **Interfaces:**
  - takes: `bash longest.sh` from S1 — the loop that reads `app.txt`
  - gives: `bash longest.sh -n` — the line `<word> <line number>`
- **Reuse:** nothing to reuse — searched: `longest.sh`, the words `getopts`, `-n`
- **What to do:**
  1. The `-n` flag is the first argument of the script: the word and its line number in `app.txt` are printed separated by a space; the lines are counted from one.
  2. Without the flag the output is as before.
  3. Add a line about the `-n` flag to the "Running" section of the file `README.md`: the command `bash longest.sh -n` and what it prints.
- **Checks:** line 3
EOF

cat > "$W/plan-s3-usage.md" <<'EOF'
# S3. The usage memo

> The memo `USAGE.md` appears in the project root: three lines about running the script.

- **Status:** not started
- **Covers:** R3
- **Depends on:** none
- **Marks:** ready text
- **Files:**
  - create: `USAGE.md`
- **Interfaces:**
  - takes: nothing
  - gives: `USAGE.md` in the project root
- **Reuse:** nothing to reuse — searched: the project root, the word `USAGE`
- **What to do:** create `USAGE.md` of exactly three lines, verbatim:

  ```
  # Running longest.sh
  - `bash longest.sh` — the longest word of `app.txt`
  - `bash longest.sh -n` — the word and its line number separated by a space
  ```
- **Checks:** line 4
EOF

cat > "$W/progress.md" <<EOF
# Progress log of topic longest

> The records of \`swork\` in order: slices, attempts, stops and what was written to the wiki.

- $today · search exclusions: the project is not under git, there are no ignore files; the checks write only to a temporary folder; the standard list — \`build/\`, \`out/\`, \`bin/\`, \`obj/\`, \`node_modules/\`, \`__pycache__/\`, \`*.o\`, \`*.obj\`, \`*.pdb\`, \`*.log\`, \`*.tmp\`; the snapshot, the marker and the wiki folder \`docs/\` are always subtracted
- $today · S1: started
- $today · S1: done — lines 1, 2 green · \`checks/S1-1.txt\`
- $today · S2: started
- $today · S2: done — line 3 green · \`checks/S2-1.txt\`
EOF

# ---------- snapshot ----------

echo longest.sh > "$S/new-files.txt"
cp -p "$P/README.md" "$S/base/README.md"
echo 'S1: length(word) — longest.sh' > "$S/created.txt"

# The output of the checks of the done slices is real: the commands of the lines run from the project root.
(
    cd "$P"
    { "$BASH" -o pipefail -c "$line1"; "$BASH" -o pipefail -c "$line2"; } > "$S/checks/S1-1.txt" 2>&1
    "$BASH" -o pipefail -c "$line3" > "$S/checks/S2-1.txt" 2>&1
)
