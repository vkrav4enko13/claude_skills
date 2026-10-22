#!/bin/bash
# Checks the worktree mode of sbrain/scripts/agents.sh — wt, sync, merge, drop — in temporary
# git projects, one per case.
#
#   bash tests/merge-test.sh <case>|all
#
# Cases: snapshot, sync, clean, race, conflict, driver, fallback, claimed, mode, submodule, orphan,
# waits.
# Fake agents through AGENTS_ID: background sleeps (live), killed and reaped ones (dead).
# Each case prints "merge <case>: ok", or "merge <case>: <what failed>" and code 1.
export LC_ALL=C.UTF-8
set -uo pipefail

S="$(cd "$(dirname "$0")/.." && pwd)/sbrain/scripts/agents.sh"
TAB=$(printf '\t')
GIT=$(command -v git)
base="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
mkdir -p "$base"
T=$(mktemp -d "$base/merge-test.XXXXXX")
T=$(cd "$T" && pwd -P)
pids=()
cleanup() {
    local p
    for p in ${pids[@]+"${pids[@]}"}; do kill "$p" 2>/dev/null; done
    rm -rf "$T"
}
trap cleanup EXIT

case_name=""
fail() {
    echo "merge $case_name: $1"
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
dead() { # a process started and ended; its id goes into $D
    local p
    sleep 600 &
    p=$!
    D="$p:$(start_of "$p")"
    kill "$p" 2>/dev/null
    wait "$p" 2>/dev/null
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

live
A="${pids[0]}:$(start_of "${pids[0]}")"
live
B="${pids[1]}:$(start_of "${pids[1]}")"
live
C="${pids[2]}:$(start_of "${pids[2]}")"

proj() { # <name>: a new git project under the test folder, made the current folder
    P="$T/$1"
    mkdir -p "$P"
    cd "$P" || exit 1
    git init -q .
}
commit() { # <message>: commit everything
    git add -A && git -c user.name=t -c user.email=t@t -c commit.gpgsign=false commit -qm "$1"
}
wt_of() { # <agent id>: the worktree path of that agent
    echo "$P/.agents/wt/${1//:/-}"
}
lines() { # <file> <count>: numbered lines "l1".."l<count>"
    seq 1 "$2" | sed 's/^/l/' >"$1"
}
set_line() { # <file> <n> <text>: replace line n
    awk -v n="$2" -v t="$3" 'NR == n { $0 = t } { print }' "$1" >"$1.tmp" && mv "$1.tmp" "$1"
}
line_is() { # <what> <file> <n> <text>
    [ "$(sed -n "$3p" "$2")" = "$4" ] || fail "$1: line $3 of $2 is \"$(sed -n "$3p" "$2")\""
}
no_markers() { # <what> <file>
    if grep -q '^<<<<<<<\|^>>>>>>>' "$2"; then fail "$1: conflict markers in $2"; fi
}

snapshot() {
    proj snapshot
    printf 'node_modules/\n.env\n' >.gitignore
    printf 'one\n' >a.txt
    commit init
    printf 'one\nedited\n' >a.txt
    printf 'u\n' >u.txt
    mkdir -p node_modules docs/work/t/.swork .swork
    printf 'x\n' >node_modules/x.js
    printf 'SECRET=1\n' >.env
    printf 's\n' >.swork/state.md
    printf 's\n' >docs/work/t/.swork/state.md
    as "$A" ay on
    as "$B" bee on
    st=$(git status --porcelain)
    ls=$(git ls-files -s)
    refs=$(git for-each-ref)
    as "$B" bee wt
    expect "an existing worktree" 0
    as "$A" ay wt
    expect "wt" 0
    w=$(wt_of "$A")
    [ "$out" = "$w" ] || fail "wt: printed \"$out\", not $w"
    [ "$(cat "$w/a.txt")" = "$(printf 'one\nedited')" ] || fail "the worktree has no uncommitted edit"
    [ -f "$w/u.txt" ] || fail "the worktree has no untracked file"
    [ -f "$w/node_modules/x.js" ] && [ -f "$w/.env" ] || fail "the ignored files are not cloned"
    [ ! -e "$w/.swork" ] && [ ! -e "$w/docs/work/t/.swork" ] || fail "a .swork folder in the worktree"
    tree=$(git -C "$w" ls-tree -r --name-only HEAD)
    case "$NL$tree$NL" in *"$NL.agents"* | *.swork*) fail "the snapshot tree holds .agents or .swork: $tree" ;; esac
    [ "$(git status --porcelain)" = "$st" ] || fail "git status changed"
    [ "$(git ls-files -s)" = "$ls" ] || fail "the index changed"
    [ "$(git for-each-ref)" = "$refs" ] || fail "the refs changed"
    [ "$(grep -cxF .agents/ "$(git rev-parse --git-path info/exclude)")" = 1 ] || fail "the exclude line is not single"
    as "$A" ay wt
    expect "wt again" 0
    [ "$out" = "$w" ] || fail "wt again: printed \"$out\""

    proj snapshot-empty
    printf 'first\n' >f.txt
    as "$A" ay on
    as "$A" ay wt
    expect "wt with no commit" 0
    [ "$(cat "$(wt_of "$A")/f.txt" 2>/dev/null)" = first ] || fail "wt with no commit: no file"
}

sync() {
    proj sync
    lines b.txt 5
    printf 'a\n' >a.txt
    commit init
    as "$A" ay on
    as "$A" ay wt
    wa="$out"
    as "$B" bee wt
    wb="$out"
    set_line "$wb/b.txt" 2 "by B"
    as "$B" bee merge "b two"
    expect "B merges" 0
    as "$A" ay sync
    expect "sync" 0
    line_is "sync" "$wa/b.txt" 2 "by B"
    [ "$(git -C "$wa" show HEAD:b.txt)" = "$(cat b.txt)" ] || fail "sync: HEAD is not the shared snapshot"
    [ -z "$(git -C "$wa" status --porcelain)" ] || fail "sync: the worktree differs from HEAD"

    set_line "$wa/b.txt" 4 "A four"
    set_line "$wb/b.txt" 4 "B four"
    as "$B" bee merge "b four"
    expect "B merges line 4" 0
    as "$A" ay sync
    expect "a conflicting sync" 4
    has "a conflicting sync" "conflict: b.txt"
    grep -q '^|||||||' "$wa/b.txt" || fail "a conflicting sync: no diff3 markers in A's worktree"
    no_markers "a conflicting sync" b.txt
}

clean() {
    proj clean
    lines app.js 50
    printf 'old\n' >old.txt
    printf 'mine\n' >"my file.txt"
    printf 'keep\n' >keep.txt
    commit init
    touch -t 202001010000 keep.txt
    kt=$(stat -f %m keep.txt)
    snapd="$T/clean-snap"
    mkdir -p "$snapd"
    as "$A" ay on
    as "$A" ay wt
    wa="$out"
    as "$B" bee wt
    wb="$out"
    set_line "$wa/app.js" 2 "A two"
    rm "$wa/old.txt"
    printf 'new\n' >"$wa/new.txt"
    printf 'mine, edited\n' >"$wa/my file.txt"
    set_line "$wb/app.js" 40 "B forty"
    as "$A" ay merge "a edits" --base "$snapd"
    expect "A merges" 0
    for p in app.js old.txt new.txt "my file.txt"; do has "A merges" "merged: $p"; done
    as "$B" bee merge "b edits" --base "$snapd"
    expect "B merges" 0
    has "B merges" "merged: app.js"
    line_is "both edits" app.js 2 "A two"
    line_is "both edits" app.js 40 "B forty"
    [ ! -e old.txt ] || fail "old.txt is not deleted"
    [ "$(cat new.txt)" = new ] || fail "new.txt is not written"
    [ "$(cat "my file.txt")" = "mine, edited" ] || fail "my file.txt is not written"
    [ "$(stat -f %m keep.txt)" = "$kt" ] || fail "an untouched file changed its mtime"
    [ "$(awk 'END { print NR }' .agents/log.tsv)" = 5 ] || fail "the log has $(awk 'END { print NR }' .agents/log.tsv) lines, not 5"
    while IFS="$TAB" read -r n id name tp tm f rest; do
        [ -s ".agents/diffs/$n.diff" ] || fail "no diff for log line $n ($f)"
    done <.agents/log.tsv
    [ "$(git show HEAD:app.js)" = "$(cat "$snapd/base/app.js")" ] || fail "base/app.js is not the content before the first merge"
    grep -qxF new.txt "$snapd/new-files.txt" || fail "new.txt is not in new-files.txt"
}

race() {
    proj race
    lines app.js 10
    commit init
    as "$A" ay on
    as "$A" ay wt
    wa="$out"
    set_line "$wa/app.js" 2 "A two"
    export AGENTS_BEFORE_WRITE='echo user >>app.js'
    as "$A" ay merge "a two"
    unset AGENTS_BEFORE_WRITE
    expect "merge" 0
    line_is "the agent's edit" app.js 2 "A two"
    [ "$(tail -n 1 app.js)" = user ] || fail "the user's line is lost"
    [ "$(awk 'END { print NR }' .agents/log.tsv)" = 1 ] || fail "the first pass wrote: the log has $(awk 'END { print NR }' .agents/log.tsv) lines"
}

conflict() {
    proj conflict
    lines app.js 10
    commit init
    as "$A" ay on
    as "$A" ay wt
    wa="$out"
    as "$B" bee wt
    wb="$out"
    set_line "$wa/app.js" 2 "A two"
    set_line "$wb/app.js" 2 "B two"
    as "$A" ay merge "a two"
    expect "A merges" 0
    as "$B" bee merge "b two"
    expect "B's merge" 4
    has "B's merge" "conflict: app.js"
    line_is "the shared file" app.js 2 "A two"
    no_markers "the shared file" app.js
    grep -q '^<<<<<<<' "$wb/app.js" && grep -q '^|||||||' "$wb/app.js" && grep -q '^>>>>>>>' "$wb/app.js" ||
        fail "no diff3 markers in B's worktree"
    { echo l1; echo "A two"; echo "B two"; seq 3 10 | sed 's/^/l/'; } >"$wb/app.js"
    as "$B" bee merge "b two, resolved"
    expect "B merges the resolution" 0
    line_is "the resolution" app.js 2 "A two"
    line_is "the resolution" app.js 3 "B two"
}

driver() {
    proj driver
    lines app.js 50
    commit init
    cfg=$(shasum .git/config)
    stub="$T/driver-bin"
    mkdir -p "$stub"
    rec="$T/driver-calls.txt"
    : >"$rec"
    cat >"$stub/mergiraf" <<EOF
#!/bin/bash
echo "\$*" >>"$rec"
git merge-file "\$4" "\$3" "\$5"
EOF
    chmod +x "$stub/mergiraf"
    as "$A" ay on
    as "$A" ay wt
    wa="$out"
    as "$B" bee wt
    wb="$out"
    set_line "$wa/app.js" 2 "A two"
    set_line "$wb/app.js" 40 "B forty"
    PATH="$stub:$PATH" as "$A" ay merge "a two"
    expect "A merges with the driver" 0
    PATH="$stub:$PATH" as "$B" bee merge "b forty"
    expect "B merges with the driver" 0
    grep -q 'app.js' "$rec" || fail "the driver was not used for app.js"
    line_is "the driver merge" app.js 2 "A two"
    line_is "the driver merge" app.js 40 "B forty"
    calls=$(awk 'END { print NR }' "$rec")
    set_line "$wa/app.js" 3 "A three"
    set_line "$wb/app.js" 41 "B forty-one"
    as "$A" ay merge "a three"
    expect "A merges without the driver" 0
    as "$B" bee merge "b forty-one"
    expect "B merges without the driver" 0
    [ "$(awk 'END { print NR }' "$rec")" = "$calls" ] || fail "the driver was used while not on PATH"
    line_is "the line merge" app.js 3 "A three"
    line_is "the line merge" app.js 41 "B forty-one"
    [ "$(shasum .git/config)" = "$cfg" ] || fail ".git/config changed"
    [ ! -e .gitattributes ] || fail ".gitattributes was written"
}

falls() { # <what> <reason>: wt, sync and merge exit 5 with that line; nothing in .agents/wt/
    local c
    for c in wt sync merge; do
        if [ $c = merge ]; then as "$A" ay merge "x"; else as "$A" ay $c; fi
        expect "$1, $c" 5
        [ "$out" = "shared: $2" ] || fail "$1, $c: printed \"$out\""
    done
    [ -z "$(ls -A .agents/wt 2>/dev/null)" ] || fail "$1: something in .agents/wt/"
}
fallback() {
    P="$T/fallback-nogit"
    mkdir -p "$P"
    cd "$P" || exit 1
    as "$A" ay on
    falls "no git" "not under git"

    proj fallback-old
    printf 'a\n' >a.txt
    commit init
    as "$A" ay on
    stub="$T/fallback-bin"
    mkdir -p "$stub"
    cat >"$stub/git" <<EOF
#!/bin/bash
if [ "\${1:-}" = --version ]; then
    echo "git version 2.39.0"
    exit 0
fi
exec "$GIT" "\$@"
EOF
    chmod +x "$stub/git"
    PATH="$stub:$PATH" falls "git 2.39.0" "git older than 2.40"

    proj fallback-sub
    mkdir sub
    printf 'a\n' >sub/a.txt
    commit init
    cd sub || exit 1
    export AGENTS_ROOT="$P/sub"
    as "$A" ay on
    falls "a subfolder root" "root is not the git top level"
    unset AGENTS_ROOT
}

claimed() {
    proj claimed
    lines app.js 50
    commit init
    as "$A" ay on
    as "$A" ay wt
    wa="$out"
    set_line "$wa/app.js" 2 "A two"
    as "$C" cee claim app.js
    expect "C claims" 0
    (
        sleep 3
        set_line app.js 40 "C forty"
        AGENTS_ID="$C${TAB}cee" "$BASH" "$S" done "c forty" app.js >/dev/null 2>&1
    ) &
    t0=$(date +%s)
    as "$A" ay merge "a two"
    expect "A's merge after the wait" 0
    [ $(($(date +%s) - t0)) -ge 3 ] || fail "A's merge did not wait"
    line_is "both edits" app.js 2 "A two"
    line_is "both edits" app.js 40 "C forty"
    as "$C" cee claim app.js
    set_line "$wa/app.js" 3 "A three"
    export AGENTS_MERGE_FOR=3
    as "$A" ay merge "a three"
    unset AGENTS_MERGE_FOR
    expect "a claim held too long" 3
    has "a claim held too long" "busy: app.js held by cee"
    line_is "a claim held too long" app.js 3 l3
    as "$C" cee release app.js
}

mode() {
    proj mode-off
    printf 'a\n' >a.txt
    commit init
    as "$A" ay wt
    expect "wt while off" 5
    [ "$out" = "agents: off" ] || fail "wt while off: printed \"$out\""
    as "$A" ay drop
    expect "drop while off" 0
    [ ! -e .agents ] || fail ".agents/ was created while off"

    proj mode
    printf 'a\n' >a.txt
    commit init
    as "$A" ay on shared
    as "$A" ay wt
    expect "shared" 5
    [ "$out" = "shared: mode file says shared" ] || fail "shared: printed \"$out\""
    [ ! -e .agents/wt ] || fail "shared: .agents/wt/ was created"
    as "$A" ay on worktree
    as "$A" ay wt
    expect "worktree" 0
    [ "$out" = "$(wt_of "$A")" ] && [ -d "$out" ] || fail "worktree: printed \"$out\""
    as "$A" ay drop
    expect "drop" 0
    [ ! -e "$(wt_of "$A")" ] || fail "drop: the worktree is left"
    as "$A" ay on auto
    as "$A" ay wt
    expect "auto" 0
    [ "$out" = "$(wt_of "$A")" ] && [ -d "$out" ] || fail "auto: printed \"$out\""
}

submodule() {
    L="$T/submodule-lib"
    mkdir -p "$L"
    git -C "$L" init -q
    printf 's\n' >"$L/s.txt"
    (cd "$L" && commit lib)
    proj submodule
    printf 'a\n' >a.txt
    git -c protocol.file.allow=always submodule add -q "$L" lib >/dev/null 2>&1 || fail "submodule add failed"
    commit init
    [ -f lib/.git ] || fail "lib/.git is not a file"
    st=$(git -C lib status --porcelain)
    ls=$(git ls-files -s lib)
    as "$A" ay on
    as "$A" ay wt
    expect "wt" 0
    w="$out"
    cmp -s "$w/lib/s.txt" lib/s.txt || fail "the worktree's lib/s.txt differs"
    [ ! -e "$w/lib/.git" ] || fail "the worktree's lib/.git exists"
    [ -z "$(git -C "$w" status --porcelain)" ] || fail "git status of the worktree: $(git -C "$w" status --porcelain)"
    printf 'a, edited\n' >"$w/a.txt"
    printf 's, edited\n' >"$w/lib/s.txt"
    as "$A" ay merge "a and lib"
    expect "merge" 0
    [ "$out" = "merged: a.txt" ] || fail "merge printed \"$out\""
    [ "$(cat lib/s.txt)" = s ] || fail "the shared lib/s.txt changed"
    [ "$(git -C lib status --porcelain)" = "$st" ] && [ "$(git ls-files -s lib)" = "$ls" ] ||
        fail "the submodule's status changed after wt and merge"
    printf 's, by another\n' >lib/s.txt
    st=$(git -C lib status --porcelain)
    as "$A" ay sync
    expect "sync" 0
    cmp -s "$w/lib/s.txt" lib/s.txt || fail "sync: the worktree's lib/s.txt differs"
    [ "$(git -C lib status --porcelain)" = "$st" ] && [ "$(git ls-files -s lib)" = "$ls" ] ||
        fail "the submodule's status changed after sync"
}

orphan() {
    proj orphan
    lines app.js 10
    mkdir -p docs/work/t
    printf 'card\n' >docs/work/t/S1.md
    commit init
    as "$A" ay on
    dead
    as "$D" dee wt
    expect "D's wt" 0
    wd="$out"
    set_line "$wd/app.js" 2 "D two"
    printf 'fresh\n' >"$wd/new.txt"
    as "$D" dee claim docs/work/t/S1.md
    expect "D claims" 0
    as "$A" ay claim docs/work/t/S1.md
    expect "A claims" 0
    has "A claims" "abandoned: docs/work/t/S1.md by dee"
    o=".agents/orphans/${D//:/-}.diff"
    has "A claims" "orphan saved: $o"
    [ -f "$o" ] || fail "no $o"
    grep -qxF '+D two' "$o" || fail "$o has no D's edit of app.js"
    grep -qxF '+fresh' "$o" || fail "$o has no D's new file"
    [ ! -e "$wd" ] || fail "D's worktree folder is left"
    case "$(git worktree list --porcelain)" in *"$wd"*) fail "git worktree list still shows D's worktree" ;; esac
    [ "$(awk -F '\t' '$5 == "docs/work/t/S1.md" { print $1 }' .agents/claims.tsv)" = "$A" ] ||
        fail "the claim of the card is not A's: $(cat .agents/claims.tsv)"
}

waits() {
    proj waits
    lines app.js 10
    printf 'x\n' >x.txt
    printf 'y\n' >y.txt
    printf 'z\n' >z.txt
    commit init
    W=.agents/waits.tsv
    as "$A" ay on
    as "$B" bee claim x.txt
    (
        sleep 3
        AGENTS_ID="$B${TAB}bee" "$BASH" "$S" release x.txt >/dev/null 2>&1
    ) &
    as "$A" ay wait x.txt --topic t
    expect "the wait for B" 0
    has "the wait for B" "free: x.txt"
    dead
    as "$D" dee claim y.txt
    as "$A" ay wait y.txt --topic t
    expect "the wait for a dead owner" 0
    has "the wait for a dead owner" "abandoned: y.txt by dee"
    as "$B" bee claim z.txt
    as "$A" ay wait --for 2 z.txt --topic t
    expect "a wait that runs out" 3
    as "$B" bee release z.txt
    [ "$(awk 'END { print NR }' "$W")" = 3 ] || fail "$W has $(awk 'END { print NR }' "$W") lines, not 3"
    awk -F '\t' 'NF != 8 { exit 1 }' "$W" || fail "a line of $W has not 8 fields: $(cat "$W")"
    [ "$(cut -f 8 "$W" | tr '\n' ' ')" = "free abandoned busy " ] || fail "the outcomes: $(cut -f 8 "$W" | tr '\n' ' ')"
    IFS="$TAB" read -r id name tp fs holder st secs oc <"$W"
    [ "$id" = "$A" ] && [ "$name" = ay ] && [ "$tp" = t ] && [ "$fs" = x.txt ] && [ "$holder" = bee ] ||
        fail "the first line: $(head -n 1 "$W")"
    case "$st" in [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]) ;;
        *) fail "the start \"$st\" is not in the now() form" ;; esac
    [ "$secs" -ge 2 ] && [ "$secs" -le 6 ] || fail "the first wait took $secs s"

    as "$A" ay wt
    wa="$out"
    set_line "$wa/app.js" 2 "A two"
    as "$C" cee claim app.js
    (
        sleep 3
        AGENTS_ID="$C${TAB}cee" "$BASH" "$S" release app.js >/dev/null 2>&1
    ) &
    as "$A" ay merge "a two" --topic t
    expect "the merge" 0
    [ "$(awk 'END { print NR }' "$W")" = 4 ] || fail "$W has $(awk 'END { print NR }' "$W") lines after the merge, not 4"
    l=$(tail -n 1 "$W")
    [ "$(printf '%s' "$l" | cut -f 4,5,8)" = "app.js${TAB}cee${TAB}free" ] || fail "the merge line: $l"
    secs=$(printf '%s' "$l" | cut -f 7)
    [ "$secs" -ge 2 ] && [ "$secs" -le 6 ] || fail "the merge waited $secs s"
}

NL='
'
CASES="snapshot sync clean race conflict driver fallback claimed mode submodule orphan waits"
run_case() { # <case>
    case_name="$1"
    "$1"
    echo "merge $1: ok"
}
want="${1:-}"
case " $CASES all " in
    *" $want "*) [ -n "$want" ] || want=x ;;
    *) want=x ;;
esac
if [ "$want" = x ]; then
    echo "usage: bash tests/merge-test.sh <case>|all — cases: $CASES" >&2
    exit 2
fi
if [ "$want" = all ]; then
    for c in $CASES; do run_case "$c"; done
else
    run_case "$want"
fi
