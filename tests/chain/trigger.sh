#!/bin/bash
# Probes which skill a request triggers.
#
#   bash tests/chain/trigger.sh <skills folder> <requests file> <result file>
#
# The requests file: a request per line, up to the first tab. For every
# request — an empty temporary project with the four skills from the skills
# folder in its .claude/skills/ and one claude -p session in it, the request
# as its text: the only allowed tool is Skill, the limit is 120 seconds. The
# result file gets a line "<request>⇥<skill>" per request: the skill of the
# first Skill call in the session records; no call — none.
# Plugins: every temporary project gets a .claude/settings.json holding only
# the enabledPlugins object of the profile's settings.json, so the plugin
# skills compete for the request; with --setting-sources project,local the
# profile's hooks, status line and installed skills stay out. The sessions
# run at effort medium, as the chain does.
# Takes from ten minutes to an hour and longer.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 3 ]; then
    echo "usage: bash trigger.sh <skills folder> <requests file> <result file>" >&2
    exit 2
fi
src="$(cd "$1" && pwd)"
requests="$2"
result="$3"
profile="${CLAUDE_CONFIG_DIR:-$HOME/claude/personal}"
plugins="$(jq '{enabledPlugins: (.enabledPlugins // {})}' "$profile/settings.json")"

base="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
mkdir -p "$base"
tmp="$(mktemp -d "$base/trigger.XXXXXX")"
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$(dirname "$result")"
: > "$result"
n=0
while IFS=$'\t' read -r request _; do
    n=$((n + 1))
    project="$tmp/$n"
    mkdir -p "$project/.claude/skills"
    for skill in sbrain splan swork saway; do
        cp -R "$src/$skill" "$project/.claude/skills/$skill"
    done
    printf '%s\n' "$plugins" > "$project/.claude/settings.json"

    # The session is found by an id of its own: a session cut off by the limit
    # leaves no reply. The alarm outlives exec and ends the session after 120
    # seconds, so the exit code says nothing.
    sid="$(uuidgen | tr 'A-Z' 'a-z')"
    (
        cd "$project"
        CLAUDE_CONFIG_DIR="$profile" \
            perl -e 'alarm 120; exec @ARGV' \
            "$HOME/.local/bin/claude" -p "$request" --session-id "$sid" \
            --setting-sources project,local --permission-prompts none \
            --permission-mode acceptEdits \
            --allowedTools Skill \
            --model claude-opus-5-5 --effort medium --output-format json \
            < /dev/null > /dev/null
    ) || true

    records=""
    for f in "$profile/projects"/*/"$sid".jsonl; do
        if [ -f "$f" ]; then records="$f"; fi
    done
    if [ -z "$records" ]; then
        echo "no session records: $request" >&2
        exit 1
    fi
    skill="$(jq -rn '
        first(
            inputs | select(.type == "assistant") | .message.content[]?
            | select(.type == "tool_use" and .name == "Skill") | .input.skill
        ) // "none"
    ' "$records")"
    printf '%s\t%s\n' "$request" "$skill" >> "$result"
done < "$requests"
