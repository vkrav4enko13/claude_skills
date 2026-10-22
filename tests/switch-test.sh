#!/bin/bash
# Checks the switch of the multi-agent mode in sbrain/scripts/agents.sh, in a temporary git project.
#
#   bash tests/switch-test.sh
#
# Cases: with no .agents/mode every command answers "off" and writes nothing, an old .agents/
# stays byte-equal; on writes the word and one exclude line; off --if-last keeps the mode for a
# live claim, a recent claimer and a live worktree, and removes it otherwise; off removes it.
# Everything passed — "switch: ok", code 0. Otherwise — the first failing case and code 1.
export LC_ALL=C.UTF-8
set -uo pipefail

S="$(cd "$(dirname "$0")/.." && pwd)/sbrain/scripts/agents.sh"
TAB=$(printf '\t')
base="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
mkdir -p "$base"
P=$(mktemp -d "$base/switch-test.XXXXXX")
P=$(cd "$P" && pwd -P)
pids=()
cleanup() {
    local p
    for p in ${pids[@]+"${pids[@]}"}; do kill "$p" 2>/dev/null; done
    rm -rf "$P"
}
trap cleanup EXIT

fail() {
    echo "switch: $1"
    if [ -n "${out:-}" ]; then printf '%s\n' "$out"; fi
    exit 1
}
start_of() {
    LC_ALL=C date -j -f "%a %b %d %T %Y" "$(LC_ALL=C ps -o lstart= -p "$1" | awk '{$1=$1; print}')" +%s
}
live() { # a background sleep; prints its pid
    sleep 600 &
    pids+=($!)
    disown $!
}
as() { # <agent id> <name> <args…>: run agents.sh as that agent, output into $out, code into $code
    local id="$1" name="$2"
    shift 2
    out=$(AGENTS_ID="$id$TAB$name" "$BASH" "$S" "$@" 2>&1)
    code=$?
}
expect() { # <case> <code>: the last call gave this code
    [ "$code" -eq "$2" ] || fail "$1: expected code $2, got $code"
}
has() { # <case> <text>: the last output holds the text
    case "$out" in *"$2"*) ;; *) fail "$1: no \"$2\" in the output" ;; esac
}

cd "$P" || exit 1
git init -q .
printf 'one\n' >a.txt

live
A="${pids[0]}:$(start_of "${pids[0]}")"
live
B="${pids[1]}:$(start_of "${pids[1]}")"
excl=$(git rev-parse --git-path info/exclude)

# No .agents/: every command answers "off" and nothing is created.
for c in claim wait done release; do
    if [ $c = done ]; then as "$A" ay done "x" a.txt; else as "$A" ay $c a.txt; fi
    expect "$c while off" 0
    [ "$out" = "agents: off" ] || fail "$c while off: printed \"$out\""
done
as "$A" ay busy
expect "busy while off" 1
[ -z "$out" ] || fail "busy while off: printed \"$out\""
as "$A" ay others
expect "others while off" 0
[ -z "$out" ] || fail "others while off: printed \"$out\""
as "$A" ay id
expect "id while off" 0
[ "$out" = "$A${TAB}ay" ] || fail "id while off: printed \"$out\""
as "$A" ay mode
expect "mode while off" 1
[ "$out" = off ] || fail "mode while off: printed \"$out\""
[ -e .agents ] && fail "off: .agents/ was created"

# An old .agents/ without mode: a claim and a done leave its records byte-equal.
mkdir .agents
printf '1\t1:1700000000\told\t-\t2026-10-01T00:00:00\ta.txt\t1\told edit\n' >.agents/log.tsv
printf '1:1700000000\told\t-\t2026-10-01T00:00:00\tb.txt\n' >.agents/claims.tsv
cp .agents/log.tsv log.before
cp .agents/claims.tsv claims.before
as "$A" ay claim a.txt
has "claim in an old .agents/" "agents: off"
as "$A" ay done "x" a.txt
has "done in an old .agents/" "agents: off"
cmp -s .agents/log.tsv log.before && cmp -s .agents/claims.tsv claims.before ||
    fail "an old .agents/: records changed"
[ "$(ls .agents)" = "$(printf 'claims.tsv\nlog.tsv')" ] || fail "an old .agents/: holds $(ls .agents | tr '\n' ' ')"
rm log.before claims.before

# on: the word and one exclude line.
as "$A" ay on
expect "on" 0
[ "$out" = "mode: auto" ] || fail "on: printed \"$out\""
[ "$(cat .agents/mode)" = auto ] || fail "on: .agents/mode holds \"$(cat .agents/mode)\""
[ "$(grep -cxF .agents/ "$excl")" = 1 ] || fail "on: exclude holds .agents/ $(grep -cxF .agents/ "$excl") times"
as "$A" ay on shared
expect "on shared" 0
[ "$out" = "mode: shared" ] || fail "on shared: printed \"$out\""
[ "$(cat .agents/mode)" = shared ] || fail "on shared: .agents/mode holds \"$(cat .agents/mode)\""
[ "$(grep -cxF .agents/ "$excl")" = 1 ] || fail "on shared: exclude holds .agents/ $(grep -cxF .agents/ "$excl") times"
as "$A" ay on bogus
expect "on bogus" 2
[ "$(cat .agents/mode)" = shared ] || fail "on bogus: .agents/mode changed"
as "$A" ay mode
expect "mode while on" 0
[ "$out" = shared ] || fail "mode while on: printed \"$out\""

# A claim and a done work as before.
as "$A" ay claim a.txt
expect "claim while on" 0
has "claim while on" "no changes: a.txt"
printf 'ONE\n' >a.txt
as "$A" ay done "upper" a.txt
expect "done while on" 0
[ "$(awk 'END { print NR }' .agents/log.tsv)" = 2 ] || fail "done while on: log has $(awk 'END { print NR }' .agents/log.tsv) lines"
grep -q '^+ONE$' .agents/diffs/2.diff || fail "done while on: no diff"

# off --if-last: a live claim of bee keeps the mode. The seen record must be a second newer
# than the mode file: the test of "newer" counts whole seconds.
sleep 1
as "$B" bee claim a.txt
expect "bee claims" 0
as "$A" ay off --if-last
expect "off --if-last with a claim" 1
[ "$out" = "mode: kept — claim of bee" ] || fail "off --if-last with a claim: printed \"$out\""
[ -f .agents/mode ] || fail "off --if-last with a claim: the mode was removed"

# bee released but claimed since the switch: still active.
as "$B" bee release a.txt
as "$A" ay off --if-last
expect "off --if-last after a recent claim" 1
[ "$out" = "mode: kept — agent $B active" ] || fail "off --if-last after a recent claim: printed \"$out\""

# bee's seen record 6 minutes old: off.
touch -t "$(date -v-6M +%Y%m%d%H%M.%S)" ".agents/seen/$B.tsv"
as "$A" ay off --if-last
expect "off --if-last with an old record" 0
[ "$out" = "mode: off" ] || fail "off --if-last with an old record: printed \"$out\""
[ -e .agents/mode ] && fail "off --if-last with an old record: the mode is left"
as "$A" ay on

# A worktree folder of a live agent keeps the mode.
mkdir -p ".agents/wt/${B//:/-}"
as "$A" ay off --if-last
expect "off --if-last with a worktree" 1
[ "$out" = "mode: kept — worktree of $B" ] || fail "off --if-last with a worktree: printed \"$out\""

# bee dead: off.
kill "${pids[1]}" 2>/dev/null
while kill -0 "${pids[1]}" 2>/dev/null; do sleep 0.1; done
as "$A" ay off --if-last
expect "off --if-last with bee dead" 0
[ "$out" = "mode: off" ] || fail "off --if-last with bee dead: printed \"$out\""
[ -e .agents/mode ] && fail "off --if-last with bee dead: the mode is left"

# off alone removes the file.
as "$A" ay on
as "$A" ay off
expect "off" 0
[ "$out" = "mode: off" ] || fail "off: printed \"$out\""
[ -e .agents/mode ] && fail "off: the mode is left"

echo "switch: ok"
