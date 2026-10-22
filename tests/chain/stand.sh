#!/bin/bash
# Builds one project of the chain stand: the wiki from make-wiki.sh and project-level skills.
#
#   bash tests/chain/stand.sh <folder> <skills folder>
#
# <folder>/wiki-trial is erased and built anew; the project is <folder>/wiki-trial/clean.
# The four skills from the skills folder are put into its .claude/skills/; splan and swork
# get copies of the wiki rules and of the check script from sbrain — as in install.sh — and of
# the claim rules and agents.sh when the skills folder has them. A skills folder with hooks/
# gives the project the chain hooks: .claude/chain-hooks/ and three entries in .claude/settings.json.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "usage: bash stand.sh <folder> <skills folder>" >&2
    exit 2
fi
dir="${1%/}"
src="$(cd "$2" && pwd)"
tests="$(cd "$(dirname "$0")/.." && pwd)"

"$BASH" "$tests/make-wiki.sh" "$dir/wiki-trial"

target="$dir/wiki-trial/clean/.claude/skills"
mkdir -p "$target"
for skill in sbrain splan swork saway; do
    cp -R "$src/$skill" "$target/$skill"
done
for skill in splan swork; do
    mkdir -p "$target/$skill/references" "$target/$skill/scripts"
    cp "$src/sbrain/references/wiki-rules.md" "$target/$skill/references/"
    cp "$src/sbrain/scripts/check.sh" "$target/$skill/scripts/"
    # The claim rules and script — only in skills that have them.
    if [ -f "$src/sbrain/references/agents-rules.md" ]; then
        cp "$src/sbrain/references/agents-rules.md" "$target/$skill/references/"
    fi
    if [ -f "$src/sbrain/scripts/agents.sh" ]; then
        cp "$src/sbrain/scripts/agents.sh" "$target/$skill/scripts/"
    fi
done
# The code map script of swork — into splan too, only in skills that have it.
if [ -f "$src/swork/scripts/codemap.sh" ]; then
    cp "$src/swork/scripts/codemap.sh" "$target/splan/scripts/"
fi
# The chain hooks — only from skills that have hooks/: the folder goes to the project's
# .claude/chain-hooks/ and the three entries of install.sh into its .claude/settings.json,
# merged into the file when it is there. The stand sessions read only project settings.
if [ -d "$src/hooks" ]; then
    project="$dir/wiki-trial/clean"
    hooks="$(cd "$project" && pwd)/.claude/chain-hooks"
    rm -rf "$hooks"
    cp -R "$src/hooks" "$hooks"
    settings="$project/.claude/settings.json"
    [ -f "$settings" ] || printf '{}\n' > "$settings"
    jq --arg inj "bash \"$hooks/inject.sh\"" --arg lang "bash \"$hooks/lang.sh\"" '
        .hooks.SessionStart += [{matcher: "startup|resume|clear|compact", hooks: [{type: "command", command: $inj, timeout: 5}]}]
        | .hooks.SubagentStart += [{hooks: [{type: "command", command: $inj, timeout: 5}]}]
        | .hooks.UserPromptSubmit += [{hooks: [{type: "command", command: $lang, timeout: 5}]}]
    ' "$settings" > "$settings.tmp"
    mv "$settings.tmp" "$settings"
fi
