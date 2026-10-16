#!/bin/bash
# The tally of one judge verdict, sourced by verdict.sh and survey-gate.sh.
#
#   . tests/chain/tally.sh; tally_label <label folder>
#
# Reads verdict.tsv of the label folder. A word of an earlier verdict is first
# replaced by its English name from the rows of tests/translate/map.tsv with
# the scope "stand" and the kind "judge". Prints one line
#   <rule no> <decision carried> <flaw named> <seed found> <sbrain no>
#   <splan no> <swork no> <saway no> <sv no> <saway answered>
# — the numbers of the lines of that kind with that answer; "<skill> no" —
# the "rule" lines of the rules <skill>-<N> with "no"; "saway answered" — the
# "rule" lines of the rules saway-<N> with "yes" or "no". Return 1 and no line
# when the verdict is malformed: there is no verdict or no rules file, a
# non-empty line has not four tab-separated fields, or there are fewer "rule"
# lines than rule lines in the rules file of the label — rules-survey.md
# ("- sv-<N>.") for a survey label, that is one that has it, otherwise
# rules.md ("- <skill>-<N>."), or fewer seed, decision and flaw lines than
# items in the seeds file of the label — seeds-survey.md or seeds.md.

tally_map="$(cd "$(dirname "${BASH_SOURCE[0]}")/../translate" && pwd)/map.tsv"

tally_label() {
    local file="$1/verdict.tsv" rules="$1/rules.md" pattern='^- [a-z]+-[0-9]+\.' want
    local seeds="$1/seeds.md" items=0
    if [ -f "$1/rules-survey.md" ]; then
        rules="$1/rules-survey.md"
        pattern='^- sv-[0-9]+\.'
        seeds="$1/seeds-survey.md"
    fi
    [ -s "$file" ] || return 1
    [ -f "$rules" ] || return 1
    want=$(grep -cE "$pattern" "$rules" || true)
    # The seeds of the label: every one needs its line in the verdict.
    if [ -f "$seeds" ]; then items=$(grep -cE '^- (seed|decision|flaw)-[0-9]+\.' "$seeds" || true); fi
    # The first file is the table: the English names of the judge words.
    awk -F'\t' -v want="$want" -v items="$items" '
        FILENAME == ARGV[1] {
            if ($1 == "stand" && $2 == "judge") english[$3] = $4
            next
        }
        $0 == "" { next }
        NF != 4 { bad = 1; next }
        {
            k = ($1 in english) ? english[$1] : $1
            a = ($3 in english) ? english[$3] : $3
            skill = $2
            sub(/-[0-9]+$/, "", skill)
            if (k == "rule") {
                rules++
                if (a == "no") { n["rule"]++; n[skill]++ }
                if (skill == "saway" && (a == "yes" || a == "no")) answered++
            }
            if (k == "decision" || k == "flaw" || k == "seed") got++
            if (k == "decision" && a == "carried") n["decision"]++
            if (k == "flaw" && a == "named") n["flaw"]++
            if (k == "seed" && a == "found") n["seed"]++
        }
        END {
            if (bad || rules + 0 < want + 0 || got + 0 < items + 0) exit 1
            print n["rule"] + 0, n["decision"] + 0, n["flaw"] + 0, n["seed"] + 0,
                n["sbrain"] + 0, n["splan"] + 0, n["swork"] + 0, n["saway"] + 0,
                n["sv"] + 0, answered + 0
        }' "$tally_map" "$file"
}
