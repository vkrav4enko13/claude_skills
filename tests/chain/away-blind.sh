#!/bin/bash
# Gives the scenarios of work without the user to a blind reader and compares its answers
# with the required ones.
#
#   bash tests/chain/away-blind.sh <skills folder> <out folder>
#
# <out folder> is erased and created anew. Into it go saway, sbrain, splan and swork from
# the skills folder and away-scenarios.md; away-expected.tsv never gets there. The reader
# is one claude -p session in that folder with the tools Read Glob Grep Write and the flag
# --restricted: it can read nothing outside the folder. It writes verdict.tsv —
# "B<N>⇥<letter>⇥<sentence>"; its reply goes to reader.json.
# Then <out folder>/result.txt is written and printed: a line "B<N> <letter> ok|differs"
# per scenario and the last line "<k> of 15 ok". Code 0 when the reader answered every
# scenario, whatever the answers; fewer answers — "reader gave <k> answers", no result.txt
# and code 1.
# Takes from ten minutes to an hour.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "usage: bash away-blind.sh <skills folder> <out folder>" >&2
    exit 2
fi
here="$(cd "$(dirname "$0")" && pwd)"
src="$(cd "$1" && pwd)"
out="${2%/}"

rm -rf "$out"
mkdir -p "$out"
out="$(cd "$out" && pwd)"
for skill in saway sbrain splan swork; do
    cp -R "$src/$skill" "$out/$skill"
done
cp "$here/away-scenarios.md" "$out/"

prompt='The user has left and `saway/SKILL.md` drives the work. For every scenario of `away-scenarios.md` decide by the skill texts alone what happens and write `verdict.tsv`: `B<N>⇥<letter>⇥<the sentence of the text you rely on>`.'

# A failed session leaves no answers: the count below reports it.
(
    cd "$out"
    CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/claude/personal}" \
        "$HOME/.local/bin/claude" -p "$prompt" \
        --setting-sources project,local --permission-prompts none \
        --permission-mode acceptEdits \
        --allowedTools Read Glob Grep Write \
        --restricted \
        --model claude-opus-5-5 --effort xhigh --output-format json \
        < /dev/null > "$out/reader.json"
) || true

verdict="$out/verdict.tsv"
if [ ! -f "$verdict" ]; then verdict=/dev/null; fi

# The first answer of the reader to every scenario of away-expected.tsv, in its order.
if result="$(LC_ALL=C awk -F'\t' '
    FILENAME == ARGV[1] { want[$1] = $2; order[++n] = $1; next }
    {
        sub(/\r$/, "")
        key = $1; letter = tolower($2)
        gsub(/ /, "", key); gsub(/ /, "", letter)
        if ((key in want) && !(key in got) && letter ~ /^[abc]$/) { got[key] = letter; k++ }
    }
    END {
        if (k < n) { print "reader gave " (k + 0) " answers"; exit 1 }
        for (i = 1; i <= n; i++) {
            same = (got[order[i]] == want[order[i]])
            ok += same
            print order[i], got[order[i]], (same ? "ok" : "differs")
        }
        print (ok + 0) " of " n " ok"
    }
' "$here/away-expected.tsv" "$verdict")"; then
    printf '%s\n' "$result" > "$out/result.txt"
    cat "$out/result.txt"
else
    echo "$result"
    exit 1
fi
