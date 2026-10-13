#!/bin/bash
# Hands the traces of the chain stand runs to a blind judge.
#
#   bash tests/chain/judge.sh <series>…
#
# The stands folder — CHAIN_BASE, by default ~/Documents/my/chain-stand; the
# judge — its folder blind/. For every run of the named series — a folder
# <series>/<number> that is not in the key blind/key.tsv — it sets up a label
# of eight random hexadecimal characters, the folder blind/<label>/ and the
# key line "<label>⇥<series>⇥<run>". In the label folder: chat-<stage>.md and
# agents-<stage>/ from the stage folders; project/ — a copy of
# wiki-trial/clean, project-seed/ — a copy of seedbox/wiki-trial/clean, both
# without .claude/, .swork/ and .swork-marker; seeds.md; rules.md — from the
# series folder of the run; it is not there — from before/rules.md, and while
# that one does not exist either, from rules.md next to the script. What the
# run does not have is skipped. The run path in the copied texts is replaced
# with /stand, its form with hyphens in place of the other characters — with
# -stand.
# The judge is a claude -p session in the label folder with the text of
# judge-prompt.md, the tools Read Glob Grep Write and the flag --restricted:
# it can read nothing outside the label folder; its reply goes to
# blind/<label>.json.
# The sessions of the labels of the named series go at the same time; a label
# that already has verdict.tsv is skipped. After the sessions, per label — a
# line "label <label>: has a verdict" or "label <label>: no verdict"; at least
# one has none — code 1.
# Takes from ten minutes to an hour and longer.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -eq 0 ]; then
    echo "usage: bash judge.sh <series>…" >&2
    exit 2
fi

here="$(cd "$(dirname "$0")" && pwd)"
B="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
blind="$B/blind"
key="$blind/key.tsv"
# The rule lists of a series that has no rules.md of its own.
rules="$B/before/rules.md"
if [ ! -f "$rules" ]; then rules="$here/rules.md"; fi
prompt="$(cat "$here/judge-prompt.md")"

mkdir -p "$blind"
if [ ! -f "$key" ]; then : > "$key"; fi

# The label of the run $2 of the series $1 from the key; the run is not in
# the key — empty.
label_of() {
    awk -F'\t' -v series="$1" -v run="$2" '$2 == series && $3 == run { print $1 }' "$key"
}

# A copy of the project $1 in the folder $2 — without the skills, the snapshot
# and the timestamp marker. No project — no copy.
project() {
    [ -d "$1" ] || return 0
    cp -R "$1" "$2"
    find "$2" \( -name .claude -o -name .swork -o -name .swork-marker \) \
        -prune -exec rm -rf {} +
}

# The label folder $1 with the traces of the run from the folder $2.
pack() {
    local D="$blind/$1" R="$2" S s f text own
    S=${R//[^A-Za-z0-9]/-}
    own="${R%/*}/rules.md"
    if [ ! -f "$own" ]; then own="$rules"; fi
    mkdir "$D"
    for s in brain plan work seed; do
        if [ -f "$R/$s/chat.md" ]; then cp "$R/$s/chat.md" "$D/chat-$s.md"; fi
        if [ -d "$R/$s/agents" ]; then cp -R "$R/$s/agents" "$D/agents-$s"; fi
    done
    project "$R/wiki-trial/clean" "$D/project"
    project "$R/seedbox/wiki-trial/clean" "$D/project-seed"
    cp "$here/seeds.md" "$D/seeds.md"
    cp "$own" "$D/rules.md"
    # The run path names the series — also in the form $S, where every
    # character except Latin letters and digits has become a hyphen: this is
    # how the project folders are named in the profile and in the temporary
    # folder of a session. The character at the end keeps the newlines at the
    # end of a file: command substitution cuts them off.
    while IFS= read -r f; do
        text="$(cat "$f"; printf x)"
        text=${text%x}
        text=${text//"$R"//stand}
        text=${text//"$S"/-stand}
        printf '%s' "$text" > "$f"
    done < <(grep -rlF -e "$R" -e "$S" "$D" || true)
}

# The judge session in the label folder $1.
judge() {
    (
        cd "$blind/$1"
        CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/claude/personal}" \
            "$HOME/.local/bin/claude" -p "$prompt" \
            --setting-sources project,local --permission-prompts none \
            --permission-mode acceptEdits \
            --allowedTools Read Glob Grep Write \
            --restricted \
            --model claude-opus-5-5 --effort xhigh --output-format json \
            < /dev/null > "$blind/$1.json"
    )
}

labels=()
for series in "$@"; do
    for R in "$B/$series"/[0-9]*; do
        [ -d "$R" ] || continue
        run="${R##*/}"
        label="$(label_of "$series" "$run")"
        if [ -z "$label" ]; then
            label="$(od -An -N4 -tx1 /dev/urandom | tr -d ' \n')"
            pack "$label" "$R"
            printf '%s\t%s\t%s\n' "$label" "$series" "$run" >> "$key"
        fi
        labels+=("$label")
    done
done
if [ ${#labels[@]} -eq 0 ]; then
    echo "no runs: $*" >&2
    exit 1
fi

for label in "${labels[@]}"; do
    if [ ! -s "$blind/$label/verdict.tsv" ]; then judge "$label" & fi
done
wait

missing=0
for label in "${labels[@]}"; do
    if [ -s "$blind/$label/verdict.tsv" ]; then
        echo "label $label: has a verdict"
    else
        echo "label $label: no verdict"
        missing=1
    fi
done
[ $missing -eq 0 ] || exit 1
