#!/bin/bash
# Builds one project of the chain stand: the wiki from make-wiki.sh and project-level skills.
#
#   bash tests/chain/stand.sh <folder> <skills folder>
#
# <folder>/wiki-trial is erased and built anew; the project is <folder>/wiki-trial/clean.
# The four skills from the skills folder are put into its .claude/skills/; splan and swork
# get copies of the wiki rules and of the check script from sbrain — as in install.sh — and of
# the claim rules and agents.sh when the skills folder has them.
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
