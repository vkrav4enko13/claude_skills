#!/bin/bash
# Builds the stands for checking the wiki: clean/, broken/, empty/, occupied/, big/.
#
#   bash tests/make-wiki.sh <folder>
#
# The folder is recreated as a whole, so its name must be wiki-trial:
# with any other path the script refuses and touches nothing.
export LC_ALL=C.UTF-8
set -euo pipefail

T="${1:-}"
T="${T%/}"
if [ "${T##*/}" != wiki-trial ]; then
    echo "refused: the name of the stands folder must be wiki-trial, got \"${1:-}\"" >&2
    exit 2
fi
rm -rf "$T"
mkdir -p "$T"

# $1 Russian letters in a row.
letters() {
    local s=""
    while [ ${#s} -lt "$1" ]; do s="${s}абвгдежзиклмнопрстуфхцчшщэюя"; done
    printf '%s' "${s:0:$1}"
}

# The string $1, padded with Russian letters to $2 characters.
pad() {
    printf '%s' "$1"
    letters $(($2 - ${#1}))
}

# Appends to the file $1 lines by the pattern $3 (%d in it is the line number)
# until the file has $2 lines.
grow() {
    local i n
    n=$(($(wc -l < "$1")))
    for ((i = n + 1; i <= $2; i++)); do printf -- "$3\n" "$i"; done >> "$1"
}

# Pads line $2 of the file $1 to $3 characters.
stretch() {
    local n=0 line out=""
    while IFS= read -r line; do
        n=$((n + 1))
        if [ $n -eq "$2" ]; then line=$(pad "$line " "$3"); fi
        out="$out$line"$'\n'
    done < "$1"
    printf '%s' "$out" > "$1"
}

app() {
    printf '%s\n' карточка викки журнал > "$1/app.txt"
}

# The state card of a topic: $1 — the file, $2 — the topic, $3 — the phase with the date,
# $4 — the journal, $5 — what is verified, $6 — the next step.
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
topic_index() {
    cat > "$1" <<EOF
# $2

> $3

**Requirements confirmed:** $4

## Cards

- [State](state.md) — topic phase and next step
EOF
}

# ---------- clean: a wiki without violations ----------

C="$T/clean"
D="$C/docs"
mkdir -p "$D/journal" "$D/notes" "$D/work/demo/.swork/base" "$D/work/old"
app "$C"

# The root index; $1 — how many "Deferred" items without links to add.
# The first line of "Deferred" is exactly 150 characters of Russian text.
root_index() {
    local i
    cat <<'EOF'
# Word list

> A trial project: a list of words in `app.txt`, one per line.

## In progress

- [demo](work/demo/00-index.md) — requirements confirmed — next: make a plan through `splan`

## Deferred

- Перевод списка слов на английский язык — отложен, пока пользователь не решит, нужен ли проекту второй файл рядом с первым и кто будет сверять слова.
EOF
    for ((i = 1; i <= $1; i++)); do
        echo "- deferred item $i — until the next trial"
    done
    cat <<'EOF'

## Sections

- [Project rules](rules.md) — decisions that hold for the whole project
- [Journal](journal/) — a line per task, a file per month
- [Topics](work/00-index.md) — topic folders: requirements, plan, progress of the work
- [Notes](notes/00-index.md) — facts that cannot be recovered from the code
EOF
}
root_index 0 > "$D/00-index.md"

cat > "$D/rules.md" <<'EOF'
# Project rules

> Decisions and answers that hold for the whole project: a line per rule.

- the words in `app.txt` — one per line — 2026-08-03, in the user's words
- the project files — in UTF-8 — 2026-08-03, in the user's words
- the file names — in Latin letters — 2026-08-17, in the user's words
EOF

cat > "$D/journal/2026-08.md" <<'EOF'
- 2026-08-03 · the word list `app.txt` set up — the project needs a shared dictionary · [Format of app.txt](../notes/app-format.md)
- 2026-08-04 · [old](../work/old/00-index.md): convert `app.txt` to UTF-8 — done: the file is in UTF-8, the words did not change
- 2026-08-17 · the list file renamed in Latin letters — the user's rule about names · [Project rules](../rules.md)
- 2026-08-21 · empty lines removed from `app.txt` — the format requires a word on every line · [Format of app.txt](../notes/app-format.md)
- 2026-08-28 · a repeated word removed from `app.txt` — a word occurs in the list once · [Format of app.txt](../notes/app-format.md)
EOF

cat > "$D/journal/2026-09.md" <<'EOF'
- 2026-09-02 · a third word added to `app.txt` — the user asked for it · [Format of app.txt](../notes/app-format.md)
- 2026-09-05 · a note about Cyrillic written — the length is counted in characters, not in bytes · [Cyrillic in a card](../notes/cyrillic-2000.md)
- 2026-09-09 · the words in `app.txt` checked for repeats — a repeat would break the sorting · [Format of app.txt](../notes/app-format.md)
- 2026-09-12 · [demo](../work/demo/00-index.md): sort the words in `app.txt` alphabetically — requirements written
- 2026-09-15 · an item about repeats added to the note about the format — the user asked about them · [Format of app.txt](../notes/app-format.md)
- 2026-09-20 · a line about Cyrillic added to the notes index — the card had no line in the index · [Notes](../notes/00-index.md)
- 2026-09-26 · the deferred translation of the words written to the root index — the user has not decided yet · [Word list](../00-index.md)
EOF

cat > "$D/notes/00-index.md" <<'EOF'
# Notes

> Facts about the project that cannot be recovered from the code.

## Cards

- [Format of app.txt](app-format.md) — one word per line, without empty lines and repeats
- [Cyrillic in a card](cyrillic-2000.md) — two thousand Russian letters fit into the card limit
EOF

cat > "$D/notes/app-format.md" <<'EOF'
# Format of app.txt

> `app.txt` is the project's word list: one word per line, without empty lines.

- There are no spaces at the edges of a line: a line is exactly one word.
- There are no repeats: a word occurs in the file once.
- A record in code does not count as a link: `[word](net-v-stroke.md)`, neither in a line nor in a block:

  ```
  [word](net-v-bloke.md)
  ```
- Source: the user's words, 2026-08-03 and 2026-09-15
EOF

# 20 lines; the items hold exactly 2000 Russian letters: 14 × 133 + 138.
{
    printf '%s\n\n' "# Cyrillic in a card"
    printf '%s\n\n' "> The card limit is counted in characters: a Russian letter is one character, not two bytes."
    for ((i = 1; i <= 14; i++)); do
        printf -- '- %s\n' "$(letters 133)"
    done
    printf -- '- %s\n' "$(letters 138)"
    echo "- Source: tests/make-wiki.sh"
} > "$D/notes/cyrillic-2000.md"

cat > "$D/work/00-index.md" <<'EOF'
# Topics

> Topic folders: the requirements, the plan and the progress of the work for each.

## Cards

- [demo](demo/00-index.md) — the words in `app.txt` in alphabetical order
EOF

cat > "$D/work/00-archive.md" <<'EOF'
# Topics: archive

> Finished topics: the lines are moved from the index, the folders stayed in place.

## Cards

- [old](old/00-index.md) — `app.txt` converted to UTF-8
EOF

topic_index "$D/work/demo/00-index.md" demo \
    "The words in \`app.txt\` must go in alphabetical order." \
    "2026-09-12 — goal: «the words in \`app.txt\` are sorted alphabetically»"
state "$D/work/demo/state.md" demo "requirements confirmed — 2026-09-12" \
    "journal/2026-09.md, line of 2026-09-12" "none" "make a plan through \`splan\`"

topic_index "$D/work/old/00-index.md" old \
    "The file \`app.txt\` is converted to UTF-8." \
    "2026-08-04 — goal: «\`app.txt\` is read as UTF-8»"
state "$D/work/old/state.md" old "done — 2026-08-05" \
    "journal/2026-08.md, line of 2026-08-04" "S1 and lines 1, 2" "none — work accepted"

for ((i = 1; i <= 100; i++)); do
    echo "line $i of a file from the snapshot: the wiki does not see it"
done > "$D/work/demo/.swork/base/big.md"

# ---------- broken: a copy of clean with eleven violations ----------

B="$T/broken"
cp -R "$C" "$B"
D="$B/docs"

# 1. The root index — 45 lines.
extra=$((45 - $(wc -l < "$D/00-index.md")))
root_index "$extra" > "$D/00-index.md"

# 2. rules.md — 35 lines.
grow "$D/rules.md" 35 "- trial rule %d — 2026-09-01, in the user's words"

# 3. The third line of the journal — 250 characters.
stretch "$D/journal/2026-09.md" 3 250

# 4. The notes index — 105 lines; all the cards are named except orphan.md.
cat >> "$D/notes/00-index.md" <<'EOF'
- [A long card](long-card.md) — more lines than the limit
- [A fat card](fat-card.md) — more characters than the limit
- [A card without a hook line](no-hook.md) — there is no hook line under the title
- [A card with a broken link](dead-link.md) — links to a file that does not exist
EOF
grow "$D/notes/00-index.md" 105 "- item %d without a link — filling the index up to 105 lines"
# Not a violation: the seventh line of the notes index — 300 characters, under the folder index limit.
stretch "$D/notes/00-index.md" 7 300

# 5. A card of 65 lines.
cat > "$D/notes/long-card.md" <<'EOF'
# A long card

> This card has sixty-five lines.

EOF
grow "$D/notes/long-card.md" 64 "- item %d of the long card"
echo "- Source: tests/make-wiki.sh" >> "$D/notes/long-card.md"

# 6. A card of 34 lines and 6200 characters: the last item takes up the remainder.
top="# A fat card"$'\n\n'"> This card has thirty-four lines and six thousand two hundred characters."$'\n\n'
body=""
for ((i = 1; i <= 28; i++)); do
    body="$body$(pad "- " 200)"$'\n'
done
bottom="- Source: tests/make-wiki.sh"$'\n'
rest=$((6200 - ${#top} - ${#body} - ${#bottom} - 1))
printf '%s%s%s\n%s' "$top" "$body" "$(pad "- " "$rest")" "$bottom" > "$D/notes/fat-card.md"

# 7. A card without a hook line.
cat > "$D/notes/no-hook.md" <<'EOF'
# A card without a hook line

- There is no hook line under the title of this card.
- Source: tests/make-wiki.sh
EOF

# 8. A card that is not in the index.
cat > "$D/notes/orphan.md" <<'EOF'
# A card without a line in the index

> This card is not named in the index of its folder.

- Source: tests/make-wiki.sh
EOF

# 9. A broken link in the fourth line.
cat > "$D/notes/dead-link.md" <<'EOF'
# A card with a broken link

> The fourth line links to a file that does not exist.
- There is no file behind this link: [none](missing.md)
- Source: tests/make-wiki.sh
EOF

# 10. The fifth line of the topics index — 450 characters.
stretch "$D/work/00-index.md" 5 450

# 11. A plan overview of 12 lines; the twelfth line — 450 characters.
cat > "$D/work/demo/plan-overview.md" <<'EOF'
# Plan overview of topic demo

> The plan as one file for reading; the source is the slice cards: where they differ, the card is right.
EOF
grow "$D/work/demo/plan-overview.md" 12 "- item %d of the overview — filling up to 12 lines"
stretch "$D/work/demo/plan-overview.md" 12 450

# ---------- empty: a project without a wiki ----------

mkdir -p "$T/empty"
app "$T/empty"

# ---------- occupied: docs/ is taken by other content ----------

mkdir -p "$T/occupied/docs"
app "$T/occupied"
cat > "$T/occupied/docs/guide.md" <<'EOF'
# User guide

The word list lies in `app.txt`: one word per line.

To add a word, write it as a new line at the end of the file.
EOF

# ---------- big: a hundred journal lines and thirty topics ----------

D="$T/big/docs"
mkdir -p "$D/journal" "$D/work"

cat > "$D/rules.md" <<'EOF'
# Project rules

> Decisions and answers that hold for the whole project: a line per rule.

EOF
grow "$D/rules.md" 30 "- trial rule %d — 2026-07-01, in the user's words"

cat > "$D/work/00-index.md" <<'EOF'
# Topics

> Topic folders: the requirements, the plan and the progress of the work for each.

## Cards

EOF

# Topics 1–25 are finished, 26–30 are in progress; ten topics per journal month.
active=""
for ((t = 1; t <= 30; t++)); do
    name=$(printf 'topic-%02d' "$t")
    month=$(printf '%02d' $((7 + (t - 1) / 10)))
    day=$(printf '%02d' $(((t - 1) % 10 + 1)))
    if [ $t -le 25 ]; then
        phase="done"
        done_note="done: trial topic $t is closed"
        checked="S1 and lines 1, 2"
        next="none — work accepted"
    else
        phase="execution in progress"
        done_note="requirements written"
        checked="none"
        next="continue \`swork\` from slice S1"
        active="$active- [$name](work/$name/00-index.md) — $phase — next: $next"$'\n'
    fi
    mkdir -p "$D/work/$name"
    topic_index "$D/work/$name/00-index.md" "$name" "Trial topic $t of the big stand." \
        "2026-$month-$day — goal: «check the wiki on thirty topics»"
    state "$D/work/$name/state.md" "$name" "$phase — 2026-$month-$day" \
        "journal/2026-$month.md, line of 2026-$month-$day" "$checked" "$next"
    echo "- [$name]($name/00-index.md) — trial topic $t of the big stand" >> "$D/work/00-index.md"
    echo "- 2026-$month-$day · [$name](../work/$name/00-index.md): check the wiki on thirty topics — $done_note" \
        >> "$D/journal/2026-$month.md"
done
grow "$D/journal/2026-07.md" 40 "- 2026-07-28 · trial record %d — filling the journal for July · [Topics](../work/00-index.md)"
grow "$D/journal/2026-08.md" 30 "- 2026-08-28 · trial record %d — filling the journal for August · [Topics](../work/00-index.md)"
grow "$D/journal/2026-09.md" 30 "- 2026-09-28 · trial record %d — filling the journal for September · [Topics](../work/00-index.md)"

# The plan overview of the first topic — exactly 40 lines: the overview has no limit on the number of lines.
cat > "$D/work/topic-01/plan-overview.md" <<'EOF'
# Plan overview of topic topic-01

> The plan as one file for reading; the source is the slice cards: where they differ, the card is right.
EOF
grow "$D/work/topic-01/plan-overview.md" 40 "- item %d of the overview — filling up to 40 lines"

cat > "$D/00-index.md" <<EOF
# Big stand

> A trial project with a journal of a hundred lines and thirty topics.

## In progress

$active
## Deferred

## Sections

- [Project rules](rules.md) — decisions that hold for the whole project
- [Journal](journal/) — a line per task, a file per month
- [Topics](work/00-index.md) — topic folders: requirements, plan, progress of the work
EOF
