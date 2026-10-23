#!/bin/bash
# Hands the results of each lane of two chain stand series to a blind pairwise judge.
#
#   bash tests/chain/pair-judge.sh <series A> <series B>
#
# The stands folder — CHAIN_BASE, by default ~/Documents/my/chain-stand; the
# run — 1 of both series. The lanes, in this order: count (stages brain plan
# work), seed, survey, grill, away, small, trap-reuse, trap-shared-bug,
# trap-rename, trap-traversal, trap-native (stages trap-<name>-plan and
# trap-<name>-work); a lane is present when the run has all its stage folders.
# A lane present in both series gets a label of eight random hexadecimal
# characters, its folder blind-pj/<label>/ and its key line in blind-pj/key.tsv:
# "<label>⇥<series A>⇥<series B>⇥<lane>⇥<letter of series A>", the letter A or
# B drawn at random; a key line that is already there is not made again. The
# label folder has A/ and B/, each with the input of the lane from the run of
# its series: count — cards/ (docs/work/count/ of wiki-trial/clean), count.sh
# of wiki-trial/clean, report.md (the .result of the last turns/*.json of
# work); seed — cards/ (docs/work/longest/ of seedbox/wiki-trial/clean),
# report.md (of seed); survey, grill — chat.md; away — chat.md and away.md of
# awaybox/wiki-trial/clean/docs/work/longest/; small — chat.md and count.sh of
# smallbox/wiki-trial/clean; trap-<name> — changed/, the files of
# trapbox-<name>/wiki-trial/clean that differ from trapbox-<name>/seeded,
# outside docs/, .claude/, .git/, .agents/ and .swork*. The run path in the
# copied texts is replaced with /stand, its form with hyphens in place of the
# other characters — with -stand.
# The judge is a claude -p session at effort medium in the label folder with
# the text of pair-judge-prompt.md and the lane name, the tools Read Glob Grep
# Write and the flag --restricted; it writes verdict.txt, "<A|B|equal>⇥<reason>",
# its reply goes to blind-pj/<label>.json. The sessions go at the same time; a
# label that already has verdict.txt is skipped.
# Prints per lane "<lane>: better|equal|worse — <reason>" (series B against
# series A), "<lane>: skipped" for a lane not in both, "<lane>: no verdict"
# when the judge wrote none; the last line "pair: <b> better, <e> equal, <w> worse".
# Code 0; a lane without a verdict — code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "usage: bash pair-judge.sh <series A> <series B>" >&2
    exit 2
fi

here="$(cd "$(dirname "$0")" && pwd)"
B="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
blind="$B/blind-pj"
key="$blind/key.tsv"
prompt="$(cat "$here/pair-judge-prompt.md")"
sa="$1"
sb="$2"
RA="$B/$sa/1"
RB="$B/$sb/1"
for R in "$RA" "$RB"; do
    [ -d "$R" ] || { echo "no run ${R#"$B"/}" >&2; exit 1; }
done
lanes='count seed survey grill away small trap-reuse trap-shared-bug trap-rename trap-traversal trap-native'

mkdir -p "$blind"
if [ ! -f "$key" ]; then : > "$key"; fi

# The stage folders of the lane $1.
folders() {
    case "$1" in
        count) echo 'brain plan work' ;;
        trap-*) echo "$1-plan $1-work" ;;
        *) echo "$1" ;;
    esac
}

# The run $1 has every stage folder of the lane $2.
present() {
    local f
    for f in $(folders "$2"); do
        [ -d "$1/$f" ] || return 1
    done
}

# The file $1 copied to $2 when it exists.
put() {
    if [ -f "$1" ]; then cp "$1" "$2"; fi
}

# The .result of the last turns/*.json of the stage folder $1 into the file $2.
report() {
    local f last=""
    for f in "$1"/turns/*.json; do
        if [ -f "$f" ]; then last="$f"; fi
    done
    if [ -n "$last" ]; then jq -r '.result // empty' "$last" > "$2"; fi
}

# The changed files of the trap project $1 against its seeded copy $2 into the folder $3.
changed() {
    local f rel
    [ -d "$1" ] || return 0
    while IFS= read -r -d '' f; do
        rel="${f#"$1"/}"
        if [ -f "$2/$rel" ] && cmp -s "$2/$rel" "$f"; then continue; fi
        mkdir -p "$3/$(dirname "$rel")"
        cp "$f" "$3/$rel"
    done < <(find "$1" \( -path "$1/docs" -o -path "$1/.claude" -o -path "$1/.git" -o -path "$1/.agents" \) \
        -prune -o -type f -print0)
}

# The input of the lane $2 from the run folder $1 into the side folder $3.
side() {
    local R="$1" D="$3" S f text
    mkdir -p "$D"
    case "$2" in
        count)
            if [ -d "$R/wiki-trial/clean/docs/work/count" ]; then
                cp -R "$R/wiki-trial/clean/docs/work/count" "$D/cards"
            fi
            put "$R/wiki-trial/clean/count.sh" "$D/count.sh"
            report "$R/work" "$D/report.md"
            ;;
        seed)
            if [ -d "$R/seedbox/wiki-trial/clean/docs/work/longest" ]; then
                cp -R "$R/seedbox/wiki-trial/clean/docs/work/longest" "$D/cards"
            fi
            report "$R/seed" "$D/report.md"
            ;;
        survey | grill) put "$R/$2/chat.md" "$D/chat.md" ;;
        away)
            put "$R/away/chat.md" "$D/chat.md"
            put "$R/awaybox/wiki-trial/clean/docs/work/longest/away.md" "$D/away.md"
            ;;
        small)
            put "$R/small/chat.md" "$D/chat.md"
            put "$R/smallbox/wiki-trial/clean/count.sh" "$D/count.sh"
            ;;
        trap-*)
            changed "$R/trapbox-${2#trap-}/wiki-trial/clean" "$R/trapbox-${2#trap-}/seeded" "$D/changed"
            ;;
    esac
    find "$D" \( -name .swork -o -name .swork-marker -o -name '.swork-*' \) -prune -exec rm -rf {} +
    S=${R//[^A-Za-z0-9]/-}
    while IFS= read -r f; do
        text="$(cat "$f"; printf x)"
        text=${text%x}
        text=${text//"$R"//stand}
        text=${text//"$S"/-stand}
        printf '%s' "$text" > "$f"
    done < <(grep -rlF -e "$R" -e "$S" "$D" || true)
}

# The judge session in the label folder $1 for the lane $2.
judge() {
    (
        cd "$blind/$1"
        CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/claude/personal}" \
            "$HOME/.local/bin/claude" -p "$prompt"$'\n\n'"The lane of this folder: \`$2\`." \
            --setting-sources project,local --permission-prompts none \
            --permission-mode acceptEdits \
            --allowedTools Read Glob Grep Write \
            --restricted \
            --model claude-opus-5-5 --effort medium --output-format json \
            < /dev/null > "$blind/$1.json"
    )
}

# The key line of the lane $1: "<label> <letter of series A>"; none — empty.
key_of() {
    awk -F'\t' -v a="$sa" -v b="$sb" -v lane="$1" \
        '$2 == a && $3 == b && $4 == lane { print $1, $5; exit }' "$key"
}

judged=()
for lane in $lanes; do
    present "$RA" "$lane" && present "$RB" "$lane" || continue
    if [ -z "$(key_of "$lane")" ]; then
        label="$(od -An -N4 -tx1 /dev/urandom | tr -d ' \n')"
        letter=A other=B
        if [ $(( $(od -An -N1 -tu1 /dev/urandom) % 2 )) -eq 1 ]; then letter=B other=A; fi
        mkdir "$blind/$label"
        side "$RA" "$lane" "$blind/$label/$letter"
        side "$RB" "$lane" "$blind/$label/$other"
        printf '%s\t%s\t%s\t%s\t%s\n' "$label" "$sa" "$sb" "$lane" "$letter" >> "$key"
    fi
    judged+=("$lane")
done

for lane in ${judged[@]+"${judged[@]}"}; do
    read -r label letter <<< "$(key_of "$lane")"
    if [ ! -s "$blind/$label/verdict.txt" ]; then judge "$label" "$lane" & fi
done
wait

better=0 equal=0 worse=0 missing=0
for lane in $lanes; do
    case " ${judged[*]+"${judged[*]}"} " in
        *" $lane "*) ;;
        *) echo "$lane: skipped"; continue ;;
    esac
    read -r label letter <<< "$(key_of "$lane")"
    v="$blind/$label/verdict.txt"
    pick="" reason=""
    if [ -s "$v" ]; then
        IFS=$'\t' read -r pick reason < "$v" || true
    fi
    case "$pick" in
        equal) word=equal; equal=$((equal + 1)) ;;
        A | B)
            if [ "$pick" = "$letter" ]; then
                word=worse; worse=$((worse + 1))
            else
                word=better; better=$((better + 1))
            fi
            ;;
        *) echo "$lane: no verdict"; missing=1; continue ;;
    esac
    echo "$lane: $word — $reason"
done
echo "pair: $better better, $equal equal, $worse worse"
[ $missing -eq 0 ] || exit 1
