#!/bin/bash
# Checks the project wiki and names the violations. Changes nothing itself.
#
#   bash check.sh <wiki folder>
#
# No violations — the line "wiki is fine", code 0.
# Any — a line "<path from the wiki folder>[:<line number>]: <violation>" each, code 1.
# No argument, or the folder has no 00-index.md — a message and code 2.
#
# Sees only five parts of the wiki: 00-index.md, rules.md, journal/, work/, notes/.
# Does not see folders whose name starts with a dot, at any depth.
# The plan overview plan-overview.md is not a card: it has one limit, the line length.
# How to fix each violation — references/wiki-rules.md, section "Check".
export LC_ALL=C.UTF-8
set -euo pipefail

if [ -z "${1:-}" ]; then
    echo "usage: bash check.sh <wiki folder>" >&2
    exit 2
fi
W="${1%/}"
if [ ! -f "$W/00-index.md" ]; then
    echo "$1: not a wiki: no 00-index.md" >&2
    exit 2
fi

bad=0
say() {
    printf '%s: %s\n' "$1" "$2"
    bad=1
}

# The wiki files, as full paths.
wiki_files() {
    local part
    echo "$W/00-index.md"
    if [ -f "$W/rules.md" ]; then echo "$W/rules.md"; fi
    for part in journal notes work; do
        if [ -d "$W/$part" ]; then
            find "$W/$part" -name '.*' -prune -o -type f -name '*.md' -print
        fi
    done
}

link_re='\[[^]]*\]\(([^)]*)\)'
scheme_re='^[A-Za-z][A-Za-z0-9+.-]*:'

# The link targets [text](target) of the line $1 — into the array targets:
# without a scheme, up to "#". Code is not a link: neither in backticks nor in
# a block between lines of three backticks. fence is reset to 0 before each file.
bt='`'
fence=0
links() {
    local rest="$1" m t
    targets=()
    case "${rest#"${rest%%[! ]*}"}" in
        "$bt$bt$bt"*)
            fence=$((1 - fence))
            return 0
            ;;
    esac
    if [ $fence -eq 1 ]; then return 0; fi
    while [[ $rest == *"$bt"*"$bt"* ]]; do
        rest=${rest%%"$bt"*}' '${rest#*"$bt"*"$bt"}
    done
    while [[ $rest =~ $link_re ]]; do
        m=${BASH_REMATCH[0]}
        t=${BASH_REMATCH[1]}
        rest=${rest#*"$m"}
        if [[ $t =~ $scheme_re ]]; then continue; fi
        t=${t%%#*}
        if [ -n "$t" ]; then targets+=("$t"); fi
    done
}

# The folder of the file $1 from the wiki folder, with a trailing slash; for the root — empty.
dir_of() {
    case "$1" in
        */*) dir="${1%/*}/" ;;
        *) dir="" ;;
    esac
}

files=$(wiki_files | sort)

# First pass: what the indexes and the archives name. An index names the cards
# of its own folder and the indexes of the folders one level down — nothing else.
named=$'\n'
while IFS= read -r file; do
    rel=${file#"$W/"}
    case "$rel" in
        00-index.md | */00-index.md | */00-archive.md) ;;
        *) continue ;;
    esac
    dir_of "$rel"
    fence=0
    while IFS= read -r line || [ -n "$line" ]; do
        links "$line"
        if [ ${#targets[@]} -eq 0 ]; then continue; fi
        for t in "${targets[@]}"; do
            case "${t%/00-index.md}" in
                */* | 00-index.md) ;;
                *) named="$named$dir$t"$'\n' ;;
            esac
        done
    done < "$file"
done <<< "$files"

# Second pass: the limits, the links, the title and the hook line, the line in the index.
while IFS= read -r file; do
    rel=${file#"$W/"}
    dir_of "$rel"
    lines=$(($(wc -l < "$file")))
    kind=list
    case "$rel" in
        00-index.md)
            if [ $lines -gt 40 ]; then say "$rel" "root index is longer than 40 lines"; fi
            ;;
        rules.md)
            if [ $lines -gt 30 ]; then say "$rel" "rules are longer than 30 lines"; fi
            ;;
        journal/* | */00-archive.md | */plan-overview.md) ;;
        */00-index.md)
            kind=folder
            if [ $lines -gt 50 ]; then say "$rel" "index is longer than 50 lines"; fi
            ;;
        *)
            kind=card
            if [ $lines -gt 30 ]; then say "$rel" "card is longer than 30 lines"; fi
            if [ $(($(wc -m < "$file"))) -gt 3000 ]; then say "$rel" "card is longer than 3000 characters"; fi
            ;;
    esac

    n=0
    title=0
    hook=0
    fence=0
    while IFS= read -r line || [ -n "$line" ]; do
        n=$((n + 1))
        if [ $kind != card ] && [ ${#line} -gt 200 ]; then
            say "$rel:$n" "line is longer than 200 characters"
        fi
        case "$line" in
            '# '*) title=1 ;;
            '> '*) hook=1 ;;
        esac
        links "$line"
        if [ ${#targets[@]} -eq 0 ]; then continue; fi
        for t in "${targets[@]}"; do
            if [ ! -e "$W/$dir$t" ]; then say "$rel:$n" "broken link $t"; fi
        done
    done < "$file"

    if [ $kind = card ] && { [ $title -eq 0 ] || [ $hook -eq 0 ]; }; then
        say "$rel" "no title or hook line"
    fi
    if [ $kind = folder ]; then dir_of "${dir%/}"; fi
    if [ $kind != list ]; then
        case "$named" in
            *$'\n'"$rel"$'\n'*) ;;
            *) say "$rel" "no line in index ${dir}00-index.md" ;;
        esac
    fi
done <<< "$files"

if [ $bad -eq 1 ]; then exit 1; fi
echo "wiki is fine"
