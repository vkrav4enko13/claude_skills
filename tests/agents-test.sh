#!/bin/bash
# Checks sbrain/scripts/agents.sh alone, in a temporary project with git.
#
#   bash tests/agents-test.sh
#
# Fake agents through AGENTS_ID: background sleeps (live), a finished process (dead) and a live
# sleep with another start epoch (reused pid). Cases: all or nothing; a busy file waits and the
# wait ends on release; dead and reused owners are taken over; a stale mutex is cleared; paths
# are normalised; done logs one line and a diff; claim prints the diffs of others, "no changes"
# or, over 100 lines, "reread"; of two claims at once one wins; a busy and a dead owner's file
# together give code 3 and the dead claim goes; a wiki above the git root is claimed from the repo.
# Everything passed — "agents: all ok", code 0. Otherwise — the first failing case and code 1.
export LC_ALL=C.UTF-8
set -uo pipefail

S="$(cd "$(dirname "$0")/.." && pwd)/sbrain/scripts/agents.sh"
TAB=$(printf '\t')
base="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
mkdir -p "$base"
P=$(mktemp -d "$base/agents-test.XXXXXX")
P=$(cd "$P" && pwd -P)
pids=()
cleanup() {
    local p
    for p in ${pids[@]+"${pids[@]}"}; do kill "$p" 2>/dev/null; done
    rm -rf "$P" "$P-wiki"
}
trap cleanup EXIT

fail() {
    echo "agents: $1"
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
mkdir sub
printf 'one\ntwo\nthree\n' >a.txt
printf 'b\n' >b.txt
printf 'g\n' >g.txt
printf 'x\n' >sub/x.txt

live
A="${pids[0]}:$(start_of "${pids[0]}")"
live
B="${pids[1]}:$(start_of "${pids[1]}")"
(:) &
dead=$!
wait $dead
D="$dead:1700000000"
R="${pids[0]}:1700000000"

# B starts before any edit: its later claims show what others logged since.
as "$B" bee id
expect "id" 0
[ "$out" = "$B${TAB}bee" ] || fail "id: printed \"$out\""

# All or nothing.
as "$A" ay claim a.txt
expect "claim a" 0
as "$B" bee claim b.txt a.txt
expect "all or nothing" 3
has "all or nothing" "busy: a.txt held by ay"
grep -q "${TAB}b.txt\$" .agents/claims.tsv && fail "all or nothing: b.txt was claimed"

# A busy file waits; the wait ends on release.
as "$B" bee wait --for 1 a.txt
expect "wait busy" 3
(sleep 1 && AGENTS_ID="$A${TAB}ay" "$BASH" "$S" release a.txt) &
t0=$(date +%s)
as "$B" bee wait --for 20 a.txt
expect "wait ends on release" 0
has "wait ends on release" "free: a.txt"
[ $(($(date +%s) - t0)) -lt 10 ] || fail "wait ends on release: took too long"
grep -q "${TAB}a.txt\$" .agents/claims.tsv && fail "wait: it claimed a.txt"

# A dead owner is taken over; wait names it.
as "$D" dead claim c.txt
expect "dead claims" 0
as "$B" bee wait --for 5 c.txt
expect "wait on a dead owner" 0
has "wait on a dead owner" "abandoned: c.txt by dead"
as "$D" dead claim c.txt
as "$B" bee claim c.txt
expect "claim over a dead owner" 0
has "claim over a dead owner" "abandoned: c.txt by dead"
has "claim over a dead owner" "reread: c.txt"
as "$B" bee release c.txt

# A reused pid with another start time is taken over.
as "$R" reused claim d.txt
as "$B" bee claim d.txt
expect "claim over a reused pid" 0
as "$B" bee release --all
expect "release all" 0
[ -s .agents/claims.tsv ] && fail "release --all: claims left"

# A busy and a dead owner's file together: code 3, the dead claim is removed.
as "$A" ay claim h.txt
as "$D" dead claim i.txt
as "$B" bee claim h.txt i.txt
expect "a busy and a dead owner's file together" 3
has "a busy and a dead owner's file together" "abandoned: i.txt by dead"
grep -q "^$D$TAB" .agents/claims.tsv && fail "a busy and a dead owner's file together: the dead claim is left"
as "$A" ay release --all

# A stale mutex of a dead process is cleared; one with no pid, older than 5 s, too.
mkdir .agents/lock
echo "$dead" >.agents/lock/pid
t0=$(date +%s)
as "$B" bee claim e.txt
expect "stale mutex" 0
[ $(($(date +%s) - t0)) -lt 5 ] || fail "stale mutex: took too long"
as "$B" bee release e.txt
mkdir .agents/lock
touch -t "$(date -v-1M +%Y%m%d%H%M.%S)" .agents/lock
as "$B" bee claim e.txt
expect "stale mutex without pid" 0
as "$B" bee release e.txt
[ -d .agents/lock ] && fail "mutex left after a call"

# Paths are normalised.
out=$(cd sub && AGENTS_ID="$A${TAB}ay" "$BASH" "$S" claim ./x.txt ../sub/./x.txt 2>&1)
code=$?
expect "relative paths" 0
[ "$(cut -f 5 .agents/claims.tsv)" = "sub/x.txt" ] || fail "paths: claims hold $(cut -f 5 .agents/claims.tsv | tr '\n' ' ')"
as "$B" bee claim "$P/sub//x.txt"
expect "absolute path" 3
as "$A" ay release sub/x.txt

# done logs one line and a diff; a path absent at the claim and now logs nothing.
as "$A" ay claim --topic t1 a.txt t1/.stage
printf 'one\nTWO\nthree\n' >a.txt
as "$A" ay done "upper two" --topic t1 a.txt t1/.stage
expect "done" 0
[ "$(awk 'END { print NR }' .agents/log.tsv)" = 1 ] || fail "done: log has $(awk 'END { print NR }' .agents/log.tsv) lines"
IFS="$TAB" read -r n id name tp tm f lines ess <.agents/log.tsv
[ "$n|$id|$name|$tp|$f|$lines|$ess" = "1|$A|ay|t1|a.txt|1-3|upper two" ] || fail "done: log line \"$(cat .agents/log.tsv)\""
grep -q '^+TWO$' .agents/diffs/1.diff || fail "done: no diff"
[ -s .agents/claims.tsv ] && fail "done: claims left"

# claim prints the diffs of others or "no changes".
as "$B" bee claim a.txt g.txt
expect "claim after done" 0
has "claim shows a diff" "+TWO"
has "claim with no changes" "no changes: g.txt"
as "$B" bee release a.txt g.txt
as "$B" bee claim a.txt
has "claim seen once" "no changes: a.txt"
as "$B" bee release a.txt

# Over 100 lines — reread.
as "$A" ay claim a.txt
seq 1 150 >a.txt
as "$A" ay done "numbers" a.txt
as "$B" bee claim a.txt
expect "claim over 100 lines" 0
has "claim over 100 lines" "reread: a.txt"
case "$out" in *"+150"*) fail "claim over 100 lines: printed the diff" ;; esac
as "$B" bee release a.txt

# Two claims at once: one wins, the other gets nothing.
for round in 1 2 3 4 5; do
    AGENTS_ID="$A${TAB}ay" "$BASH" "$S" claim p.txt q.txt >/dev/null 2>&1 &
    pa=$!
    AGENTS_ID="$B${TAB}bee" "$BASH" "$S" claim q.txt p.txt >/dev/null 2>&1 &
    pb=$!
    wait $pa
    ca=$?
    wait $pb
    cb=$?
    [ "$ca$cb" = 03 ] || [ "$ca$cb" = 30 ] || fail "two claims at once, round $round: codes $ca and $cb"
    [ "$(cut -f 1 .agents/claims.tsv | sort -u | wc -l | tr -d ' ')" = 1 ] || fail "two claims at once, round $round: claims of both"
    [ "$(awk 'END { print NR }' .agents/claims.tsv)" = 2 ] || fail "two claims at once, round $round: not two lines"
    as "$A" ay release --all
    as "$B" bee release --all
done

# A wiki above the git root: its files are claimed from the repo, with one store.
W="$P-wiki"
mkdir -p "$W/docs" "$W/repo"
printf 'index\n' >"$W/docs/00-index.md"
git -C "$W/repo" init -q
cd "$W/repo"
as "$A" ay claim ../docs/00-index.md
expect "a wiki above the git root" 0
[ -d "$W/repo/.agents" ] && [ ! -d "$W/.agents" ] || fail "a wiki above the git root: .agents/ not only in the repo"

echo "agents: all ok"
