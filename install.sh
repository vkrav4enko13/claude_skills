#!/bin/bash
# Installs the personal skills from this folder into all the Claude Code and
# Codex profiles on the Mac and on the Windows PC (ssh pc). A repeated run is
# safe: the folder of every skill is replaced as a whole, other skills are not
# touched.
#
# It also puts copies of the wiki rules and of the check script into splan and
# swork and writes the wiki rules block into the shared instructions of every
# profile — between the project-wiki marks; the text outside the marks is not
# touched. The marks in even one file are not a pair — it writes nothing and
# ends with an error. The instructions file of the PC is edited on the Mac: it
# is downloaded with scp and uploaded back.
#
#   install.sh            — install
#   install.sh --uninstall — remove the installed skills and the block
#   install.sh --mac      — the Mac only (the PC is not touched)
#   install.sh --pc       — the PC only (the Mac is not touched)
#
# WIKI_PC_PREFIX — the path from the home folder of the PC to a stand-in home
# that holds the profiles; only the checks need it.
export LC_ALL=C.UTF-8
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"

MAC_TARGETS=(
    "$HOME/claude/personal/skills"
    "$HOME/claude/work/skills"
    "$HOME/.codex/skills"
)
# The shared instructions files of the same profiles, in the same order.
MAC_FILES=(
    "$HOME/claude/personal/CLAUDE.md"
    "$HOME/claude/work/CLAUDE.md"
    "$HOME/.codex/AGENTS.md"
)
# Relative to the home folder on the PC (C:\Users\vkravchenko); with WIKI_PC_PREFIX —
# inside the stand-in home.
prefix=${WIKI_PC_PREFIX:-}
[ -z "$prefix" ] || prefix="${prefix%/}/"
PC_TARGETS=(
    "${prefix}.claude-personal/skills"
    "${prefix}.claude-work/skills"
    "${prefix}.codex/skills"
)
# The shared instructions files of the same profiles, in the same order.
PC_FILES=(
    "${prefix}.claude-personal/CLAUDE.md"
    "${prefix}.claude-work/CLAUDE.md"
    "${prefix}.codex/AGENTS.md"
)

BEGIN='<!-- project-wiki:begin -->'
END='<!-- project-wiki:end -->'

# Reads the file $1 as a whole into text, together with the newlines at the end;
# no file — text is empty.
slurp() {
    text=""
    if [ -f "$1" ]; then
        text=$(cat "$1" && printf x)
        text=${text%x}
    fi
}

# The block marks in the file $1 are one pair, or there are none at all.
marks_paired() {
    slurp "$1"
    case "$text" in
        *"$BEGIN"*"$BEGIN"* | *"$END"*"$END"* | *"$END"*"$BEGIN"*) return 1 ;;
        *"$BEGIN"*"$END"*) return 0 ;;
        *"$BEGIN"* | *"$END"*) return 1 ;;
    esac
}

# Writes the wiki block into the instructions file $1. Substitutes: $2 — the path to the wiki rules,
# $3 — the command of the check script, $4 — a note to it. No file — creates it
# with the block alone; the marks are there — replaces the text from mark to mark; no marks —
# appends the block at the end after one empty line.
write_block() {
    local block
    block=$(cat "$SRC/sbrain/references/wiki-block.md")
    block=${block//'{{RULES}}'/"$2"}
    block=${block//'{{CHECK}}'/"$3"}
    block=${block//'{{NOTE}}'/"$4"}
    slurp "$1"
    case "$text" in
        *"$BEGIN"*) text="${text%%"$BEGIN"*}$block${text#*"$END"}" ;;
        "") text="$block"$'\n' ;;
        *$'\n') text="$text"$'\n'"$block"$'\n' ;;
        # The file ended without a newline — and there is none after the block:
        # by this remove_block returns the file byte for byte.
        *) text="$text"$'\n\n'"$block" ;;
    esac
    printf '%s' "$text" > "$1"
}

# Removes the wiki block from the instructions file $1 together with the empty line before it.
# A file with not a single character left after that is deleted.
remove_block() {
    local pre post
    slurp "$1"
    case "$text" in
        *"$BEGIN"*) ;;
        *) return 0 ;;
    esac
    pre=${text%%"$BEGIN"*}
    post=${text#*"$END"}
    if [ -z "$post" ]; then
        # The block was appended to a file without a newline at the end — see write_block.
        pre=${pre%$'\n\n'}
    else
        post=${post#$'\n'}
        case "$pre" in
            $'\n' | *$'\n\n') pre=${pre%$'\n'} ;;
        esac
    fi
    if [ -z "$pre$post" ]; then
        rm -f "$1"
    else
        printf '%s' "$pre$post" > "$1"
    fi
}

uninstall=0
mac=1
pc=1
for arg in "$@"; do
    case "$arg" in
        --uninstall) uninstall=1 ;;
        --mac) pc=0 ;;
        --pc) mac=0 ;;
        *) echo "unknown option: $arg" >&2; exit 2 ;;
    esac
done
if [ $mac -eq 0 ] && [ $pc -eq 0 ]; then
    echo "--mac and --pc are not given together: both machines — without these options" >&2
    exit 2
fi

skills=()
for dir in "$SRC"/*/; do
    [ -f "$dir/SKILL.md" ] && skills+=("$(basename "$dir")")
done
[ ${#skills[@]} -gt 0 ] || { echo "no skills in $SRC" >&2; exit 1; }

# The PC answers — learn its home folder and download into a temporary folder the
# instructions files that exist: the marks in them are checked together with the files of the Mac.
pc_up=0
if [ $pc -eq 1 ] && ssh -o ConnectTimeout=5 -o BatchMode=yes pc exit 2>/dev/null; then
    pc_up=1
    pc_home=$(ssh pc 'Write-Output $HOME' | tr -d '\r')
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    for i in "${!PC_FILES[@]}"; do
        found=$(ssh pc "Test-Path \"\$HOME/${PC_FILES[$i]}\"" | tr -d '\r')
        [ "$found" != True ] || scp -q "pc:${PC_FILES[$i]}" "$tmp/$i"
    done
fi

# Before the first write: an unpaired mark in even one file stops everything.
unpaired=0
if [ $mac -eq 1 ]; then
    for file in "${MAC_FILES[@]}"; do
        if ! marks_paired "$file"; then
            echo "$file: unpaired project-wiki mark — fix the file; nothing is written" >&2
            unpaired=1
        fi
    done
fi
if [ $pc_up -eq 1 ]; then
    for i in "${!PC_FILES[@]}"; do
        if ! marks_paired "$tmp/$i"; then
            echo "PC, ~/${PC_FILES[$i]}: unpaired project-wiki mark — fix the file; nothing is written" >&2
            unpaired=1
        fi
    done
fi
[ $unpaired -eq 0 ] || exit 4

if [ $mac -eq 1 ]; then
    for i in "${!MAC_TARGETS[@]}"; do
        target=${MAC_TARGETS[$i]}
        for skill in "${skills[@]}"; do
            rm -rf "${target:?}/$skill"
            if [ $uninstall -eq 0 ]; then
                mkdir -p "$target"
                cp -R "$SRC/$skill" "$target/$skill"
            fi
        done
        if [ $uninstall -eq 0 ]; then
            # splan and swork keep their own copies of the wiki rules, the claim rules and their scripts.
            for skill in splan swork; do
                mkdir -p "$target/$skill/references" "$target/$skill/scripts"
                cp "$SRC/sbrain/references/wiki-rules.md" "$target/$skill/references/"
                cp "$SRC/sbrain/scripts/check.sh" "$target/$skill/scripts/"
                cp "$SRC/sbrain/references/agents-rules.md" "$target/$skill/references/"
                cp "$SRC/sbrain/scripts/agents.sh" "$target/$skill/scripts/"
            done
            write_block "${MAC_FILES[$i]}" "$target/sbrain/references/wiki-rules.md" \
                "bash \"$target/sbrain/scripts/check.sh\"" ""
        else
            remove_block "${MAC_FILES[$i]}"
        fi
        echo "Mac: $target"
    done
fi

[ $pc -eq 1 ] || exit 0

if [ $pc_up -eq 0 ]; then
    echo "the PC does not answer — nothing is installed on it (wake-pc and repeat)" >&2
    exit 3
fi

for i in "${!PC_TARGETS[@]}"; do
    target=${PC_TARGETS[$i]}
    for skill in "${skills[@]}"; do
        ssh pc "Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"\$HOME/$target/$skill\"; if ($uninstall -eq 0) { New-Item -ItemType Directory -Force \"\$HOME/$target\" | Out-Null }"
        [ $uninstall -eq 1 ] || scp -qr "$SRC/$skill" "pc:$target/"
    done
    if [ $uninstall -eq 0 ]; then
        for skill in splan swork; do
            ssh pc "New-Item -ItemType Directory -Force \"\$HOME/$target/$skill/references\", \"\$HOME/$target/$skill/scripts\" | Out-Null"
            scp -q "$SRC/sbrain/references/wiki-rules.md" "pc:$target/$skill/references/"
            scp -q "$SRC/sbrain/scripts/check.sh" "pc:$target/$skill/scripts/"
            scp -q "$SRC/sbrain/references/agents-rules.md" "pc:$target/$skill/references/"
            scp -q "$SRC/sbrain/scripts/agents.sh" "pc:$target/$skill/scripts/"
        done
        # In the block the paths are written the way Windows writes them.
        win="$pc_home\\${target//\//\\}"
        write_block "$tmp/$i" "$win\\sbrain\\references\\wiki-rules.md" \
            "\"C:\\Program Files\\Git\\bin\\bash.exe\" \"$win\\sbrain\\scripts\\check.sh\"" \
            " (in PowerShell — with the & sign before the command)"
        scp -q "$tmp/$i" "pc:${PC_FILES[$i]}"
    elif grep -qF "$BEGIN" "$tmp/$i" 2>/dev/null; then
        remove_block "$tmp/$i"
        if [ -f "$tmp/$i" ]; then
            scp -q "$tmp/$i" "pc:${PC_FILES[$i]}"
        else
            ssh pc "Remove-Item -Force \"\$HOME/${PC_FILES[$i]}\""
        fi
    fi
    echo "PC: ~/$target"
done
