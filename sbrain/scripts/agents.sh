#!/bin/bash
# Claims of project files between agents working at the same time on this Mac.
# When to call it — references/agents-rules.md.
#
#   bash agents.sh claim <file>…          take every file or none
#   bash agents.sh wait [--for <s>] <file>…  wait until every file is free; claims nothing
#   bash agents.sh done "<essence>" <file>…  log the edits with diffs and release
#   bash agents.sh release <file>… | --all   release without logging
#   bash agents.sh busy                   live claims of other agents
#   bash agents.sh others [--since <file>]   paths other agents hold or logged
#   bash agents.sh id                     this agent's id
#   bash agents.sh on [auto|worktree|shared]  switch the multi-agent mode on (default auto)
#   bash agents.sh off [--if-last]        switch it off; --if-last only when no other agent is active
#   bash agents.sh mode                   the mode word, or "off"
#   bash agents.sh wt                     this agent's worktree: create it from a snapshot, print its path
#   bash agents.sh sync                   take the shared folder's changes into the worktree
#   bash agents.sh merge "<essence>" [--base <snapshot folder>]  merge the worktree's edits back
#   bash agents.sh drop                   remove this agent's worktree
#
# Every command takes --topic <topic> — the name of the topic folder, default "-".
# Paths are taken from the current folder and kept relative to the project root, without "./";
# a file of a wiki above the root (the folder holding docs/00-index.md) is kept with "../".
#
# claim: code 0 — all claimed; for each file "no changes: <file>", the diffs other agents
#   logged since this agent last held it, or "reread: <file>" when they exceed 100 lines.
#   Code 3 — nothing claimed, a line "busy: <file> held by <name>" per busy file; a dead owner's
#   claim is removed all the same and named "abandoned: <file> by <name>". A dead owner's worktree
#   is saved and removed first: "orphan saved: .agents/orphans/<id>.diff".
# wait: at most 540 s (--for shortens it), checks every 2 s. Code 0 — every file is free:
#   "free: <file>", or "abandoned: <file> by <name>" when a dead owner's claim was removed.
#   Code 3 — still busy, call again. A dead owner's worktree is saved as by claim; every wait
#   appends a line to waits.tsv.
# done: logs a line per changed file, keeps its diff; an unchanged or never existing path
#   logs nothing. busy: code 0 and a line per claim, code 1 when there is none.
# on: code 0 "mode: <word>"; writes the word into .agents/mode and, under git, the line ".agents/"
#   into the repository's info/exclude if missing. Another word — code 2.
# off: code 0 "mode: off" — removed or already absent; this agent's own claims are removed
#   first. With --if-last, code 1 and nothing changed, "mode: kept — <reason>", while another
#   live agent holds a claim ("claim of <name>"), owns .agents/wt/<id> ("worktree of <id>") or
#   wrote its seen record after the switch and within the last 300 s ("agent <id> active").
# mode: code 0 and the word, code 1 and "off".
# wt, sync, merge, drop take no files; merge takes the essence like done.
# wt: code 0 and the absolute path <root>/.agents/wt/<id>, the id with ":" as "-"; the worktree
#   holds a snapshot of the shared folder (no .agents/, no .swork*), clones of its ignored files
#   and read-only clones of its submodules without their .git.
# wt and sync first save and remove the worktree of every agent in .agents/wt/ no longer alive,
#   a line "orphan saved: .agents/orphans/<id>.diff" each; wt prints its path last.
# sync: code 0 — synced; code 4 — a line "conflict: <path>" per path, diff3 markers in the worktree.
# merge: code 0 — a line "merged: <path>" per path written into the shared folder ("merged: nothing"
#   when the worktree has no edits), then the worktree is synced; code 4 — as sync on conflict;
#   code 3 — "busy: <path> held by <name>" when a path stays claimed after 540 s, call again.
#   With --base, a path's content before its first merge goes to <snapshot>/base/<path>, a new
#   path to <snapshot>/new-files.txt. A merge that waited 1 s or more for the lock or a claimed
#   path appends a line to waits.tsv.
# drop: code 0, the worktree removed or absent.
# Code 5 from wt, sync, merge — use the shared mode, one line "shared: <reason>": mode file says
#   shared, not under git, git older than 2.40, root is not the git top level, worktree add failed,
#   merge-tree failed.
# While .agents/mode is absent nothing is created or written: claim, wait, done, release — code 0
#   and "agents: off"; busy — code 1, nothing; others — code 0, nothing; id — as always;
#   wt, sync, merge — code 5 and "agents: off"; drop — code 0.
# Wrong arguments — a message and code 2.
#
# Records in <project root>/.agents/, one tab-separated line each:
#   claims.tsv  id, name, topic, time, file
#   log.tsv     n, id, name, topic, time, file, lines, essence; the diff is diffs/<n>.diff
#   held/<id>/<file>  the copy taken at the claim
#   seen/<id>.tsv     line 1: the log length at this agent's start; then file, last seen n
#   lock/             the mutex, holding the pid of its owner
#   mode              one word: auto, worktree or shared; absent — the mode is off
#   wt/<id>/          this agent's worktree, the id with ":" as "-"
#   index/<id>-root, index/<id>-wt  the snapshot indexes of the shared folder and the worktree
#   attributes        the merge attributes: mergiraf for code files when it is installed
#   waits.tsv         id, name, topic, files (space-separated; ".agents/lock" for a merge's lock
#                     wait), holder (name of the first busy owner, "-" if none), start, seconds,
#                     outcome: free, abandoned or busy
#   orphans/<id>.diff the unmerged edits of a dead agent's worktree, the id with ":" as "-":
#                     git diff HEAD, then a diff from /dev/null per untracked file
# The id is <pid>:<start epoch> of the agent's process; AGENTS_ID="<id><tab><name>" overrides it.
export LC_ALL=C.UTF-8
set -euo pipefail

TAB=$(printf '\t')
NL='
'

usage() {
    echo "usage: bash agents.sh claim|wait|done|release|busy|others|id|on|off|mode|wt|sync|merge|drop [--topic <topic>] …" >&2
    exit 2
}

cmd="${1:-}"
[ -n "$cmd" ] || usage
shift
topic=-
topic_set=0
piece=540
since=""
all=0
essence=""
iflast=0
word=""
base=""
files=()
case "$cmd" in
    claim | wait | release | busy | others | id | on | off | mode | wt | sync | drop) ;;
    done | merge)
        [ $# -gt 0 ] || usage
        essence="$1"
        shift
        ;;
    *) usage ;;
esac
while [ $# -gt 0 ]; do
    case "$1" in
        --topic)
            [ $# -ge 2 ] && [ -n "$2" ] || usage
            topic="$2"
            topic_set=1
            shift 2
            ;;
        --for)
            [ "$cmd" = wait ] && [ $# -ge 2 ] || usage
            case "$2" in '' | *[!0-9]*) usage ;; esac
            piece="$2"
            shift 2
            ;;
        --since)
            [ "$cmd" = others ] && [ $# -ge 2 ] || usage
            since="$2"
            shift 2
            ;;
        --all)
            [ "$cmd" = release ] || usage
            all=1
            shift
            ;;
        --if-last)
            [ "$cmd" = off ] || usage
            iflast=1
            shift
            ;;
        --base)
            [ "$cmd" = merge ] && [ $# -ge 2 ] && [ -n "$2" ] || usage
            base="$2"
            shift 2
            ;;
        -*) usage ;;
        *)
            files+=("$1")
            shift
            ;;
    esac
done
case "$topic" in *"$TAB"* | *$'\n'* | */*) usage ;; esac
if [ $piece -gt 540 ]; then piece=540; fi
case "$cmd" in
    claim | wait | done) [ ${#files[@]} -gt 0 ] || usage ;;
    release) [ $all -eq 1 ] || [ ${#files[@]} -gt 0 ] || usage ;;
    busy | others | id | off | mode | wt | sync | merge | drop) [ ${#files[@]} -eq 0 ] || usage ;;
    on)
        [ ${#files[@]} -le 1 ] || usage
        word="${files[0]:-auto}"
        case "$word" in auto | worktree | shared) ;; *) usage ;; esac
        files=()
        ;;
esac
essence=$(printf '%s' "$essence" | tr '\t\n' '  ')

# --- the project root -------------------------------------------------------

here=$(pwd -P)
find_up() { # <test> <name> [<start folder>]: the first folder from the start (default here) up holding <name>
    local d="${3:-$here}"
    while :; do
        if [ "$1" "$d/$2" ]; then
            echo "$d"
            return 0
        fi
        [ "$d" != / ] || return 1
        d=$(dirname "$d")
    done
}
if [ -n "${AGENTS_ROOT:-}" ]; then
    ROOT=$(cd "$AGENTS_ROOT" && pwd -P)
elif ROOT=$(find_up -d .agents); then
    :
elif ROOT=$(git rev-parse --show-toplevel 2>/dev/null) && [ -n "$ROOT" ]; then
    ROOT=$(cd "$ROOT" && pwd -P)
elif ROOT=$(find_up -f docs/00-index.md); then
    :
else
    ROOT="$here"
fi
A="$ROOT/.agents"

# --- the mode ------------------------------------------------------------------

mode_now() { # the word of .agents/mode: auto, worktree, shared, or off when it is absent
    local w=""
    if [ -f "$A/mode" ]; then w=$(head -n 1 "$A/mode"); fi
    case "$w" in auto | worktree | shared) echo "$w" ;; *) echo off ;; esac
}
MODE=$(mode_now)
shared() { # <reason>: the worktree mode cannot be used — code 5
    echo "shared: $1"
    exit 5
}
wt_mode() { # code 5 unless the worktree mode can be used here
    local top v
    [ "$MODE" != shared ] || shared "mode file says shared"
    top=$(git -C "$ROOT" rev-parse --show-toplevel 2>/dev/null) && [ -n "$top" ] || shared "not under git"
    [ "$(cd "$top" && pwd -P)" = "$ROOT" ] || shared "root is not the git top level"
    v=$(git --version 2>/dev/null | awk '{ print $3 }')
    case "$v" in [0-9]*.[0-9]*) ;; *) shared "git older than 2.40" ;; esac
    awk -v v="$v" 'BEGIN { split(v, a, "."); exit !(a[1] + 0 > 2 || (a[1] + 0 == 2 && a[2] + 0 >= 40)) }' ||
        shared "git older than 2.40"
}
case "$cmd" in
    mode)
        echo "$MODE"
        [ "$MODE" != off ] || exit 1
        exit 0
        ;;
    on)
        mkdir -p "$A/diffs" "$A/held" "$A/seen"
        if [ "$MODE" != "$word" ]; then # the same word keeps the file and its time for off --if-last
            printf '%s\n' "$word" >"$A/mode.$$"
            mv "$A/mode.$$" "$A/mode"
        fi
        if ex=$(git -C "$ROOT" rev-parse --git-path info/exclude 2>/dev/null); then
            case "$ex" in /*) ;; *) ex="$ROOT/$ex" ;; esac
            if ! grep -qxF .agents/ "$ex" 2>/dev/null; then
                mkdir -p "$(dirname "$ex")"
                if [ -s "$ex" ] && [ -n "$(tail -c 1 "$ex")" ]; then echo >>"$ex"; fi
                echo .agents/ >>"$ex"
            fi
        fi
        echo "mode: $word"
        exit 0
        ;;
esac
if [ "$MODE" = off ]; then
    case "$cmd" in
        claim | wait | done | release)
            echo "agents: off"
            exit 0
            ;;
        busy) exit 1 ;;
        others) exit 0 ;;
        off)
            echo "mode: off"
            exit 0
            ;;
        wt | sync | merge)
            echo "agents: off"
            exit 5
            ;;
    esac
elif [ "$cmd" = off ]; then
    : # handled after the claim records: it drops this agent's own claims
else
    case "$cmd" in wt | sync | merge) wt_mode ;; esac
    mkdir -p "$A/diffs" "$A/held" "$A/seen" "$A/index"
fi
# The wiki root: its files above the root are kept from the root with "../".
WIKI=$(find_up -f docs/00-index.md "$ROOT") || WIKI=""

# A path from the current folder or absolute — as a path from the root, without "./";
# a path under a wiki root above the root starts with "../".
norm() {
    local p="$1" d abs="" out="" part up=""
    set -f
    case "$p" in
        /*)
            d=$(dirname "$p")
            if [ -d "$d" ]; then p="$(cd "$d" && pwd -P)/$(basename "$p")"; fi
            ;;
        *) p="$here/$p" ;;
    esac
    local IFS=/
    for part in $p; do
        case "$part" in
            '' | .) ;;
            ..) abs="${abs%/*}" ;;
            *) abs="$abs/$part" ;;
        esac
    done
    unset IFS
    d="$ROOT"
    while :; do
        case "$abs/" in
            "${d%/}"/*)
                out="${abs#"${d%/}"}"
                out="${out#/}"
                break
                ;;
        esac
        if [ -z "$WIKI" ] || [ "$d" = "$WIKI" ] || [ "$d" = / ]; then
            echo "$1: outside the project $ROOT" >&2
            exit 2
        fi
        d=$(dirname "$d")
        up="../$up"
    done
    if [ -n "$out" ]; then out="$up$out"; fi
    if [ -z "$out" ]; then
        echo "$1: not a file" >&2
        exit 2
    fi
    case "$out" in *"$TAB"* | *$'\n'*)
        echo "$1: a tab or a line break in the path" >&2
        exit 2
        ;;
    esac
    echo "$out"
}
if [ ${#files[@]} -gt 0 ]; then
    paths=()
    for f in "${files[@]}"; do
        n=$(norm "$f") || exit 2
        if [ -e "$ROOT/$n" ] && [ ! -f "$ROOT/$n" ]; then
            echo "$f: not a regular file" >&2
            exit 2
        fi
        paths+=("$n")
    done
    files=("${paths[@]}")
fi

# --- the agent id ------------------------------------------------------------

start_of() { # <pid>: its start epoch
    local s
    s=$(LC_ALL=C ps -o lstart= -p "$1" 2>/dev/null | awk '{$1=$1; print}') || return 1
    [ -n "$s" ] || return 1
    LC_ALL=C date -j -f "%a %b %d %T %Y" "$s" +%s 2>/dev/null
}
alive() { # <id>: its process runs and started at the same second
    local pid="${1%%:*}"
    kill -0 "$pid" 2>/dev/null && [ "$(start_of "$pid")" = "${1#*:}" ]
}

if [ -n "${AGENTS_ID:-}" ]; then
    ID="${AGENTS_ID%%"$TAB"*}"
    NAME="${AGENTS_ID#*"$TAB"}"
    case "$ID" in
        *[!0-9:]* | :* | *: | *:*:* | [!0-9]*) usage ;;
        *:*) ;;
        *) usage ;;
    esac
    [ "$NAME" != "$AGENTS_ID" ] && [ -n "$NAME" ] || usage
else
    pid=""
    if [ -n "${CLAUDE_PID:-}" ] && kill -0 "$CLAUDE_PID" 2>/dev/null; then
        case "$(ps -o command= -p "$CLAUDE_PID" 2>/dev/null)" in *claude*) pid="$CLAUDE_PID" ;; esac
    fi
    p=$PPID
    while [ -z "$pid" ] && [ "$p" -gt 1 ]; do
        line=$(ps -o ppid=,comm= -p "$p" 2>/dev/null | sed 's/^ *//') || break
        [ -n "$line" ] || break
        comm=$(basename "${line#* }")
        case "$comm" in *claude* | *codex*) pid=$p ;; esac
        p="${line%% *}"
    done
    if [ -n "$pid" ]; then
        NAME="${CLAUDE_CODE_SESSION_ID:-codex}"
    else
        pid=$PPID
        NAME=shell
    fi
    ID="$pid:$(start_of "$pid")"
fi
NAME=$(printf '%s' "$NAME" | tr '\t\n' '  ')

if [ "$cmd" = id ]; then
    printf '%s\t%s\n' "$ID" "$NAME"
    [ "$MODE" != off ] || exit 0
fi

WT="$A/wt/${ID//:/-}"
if [ "$cmd" = drop ]; then
    if [ -d "$WT" ]; then git -C "$ROOT" worktree remove --force "$WT"; fi
    exit 0
fi

# --- the mutex -----------------------------------------------------------------

locked=0
lwaited=0
unlock() {
    if [ $locked -eq 1 ]; then
        rm -rf "$A/lock"
        locked=0
    fi
}
trap unlock EXIT
trap 'exit 130' INT TERM
lock() {
    local L="$A/lock" lp age away
    while ! mkdir "$L" 2>/dev/null; do
        lp=$(cat "$L/pid" 2>/dev/null || true)
        if [ -n "$lp" ]; then
            if kill -0 "$lp" 2>/dev/null; then
                lwaited=1
                sleep 0.2
                continue
            fi
        else
            age=$(($(date +%s) - $(stat -f %m "$L" 2>/dev/null || date +%s)))
            if [ $age -le 5 ]; then
                lwaited=1
                sleep 0.2
                continue
            fi
        fi
        # Stale: move it away under a unique name, make sure it is the one judged stale.
        away="$A/lock.stale.$$.$RANDOM"
        if mv "$L" "$away" 2>/dev/null; then
            if [ "$(cat "$away/pid" 2>/dev/null || true)" = "$lp" ]; then
                rm -rf "$away"
            else
                mv "$away" "$L" 2>/dev/null || rm -rf "$away"
            fi
        fi
    done
    locked=1
    echo $$ >"$L/pid"
}

# --- records -------------------------------------------------------------------

CL="$A/claims.tsv"
LOG="$A/log.tsv"
SEEN="$A/seen/$ID.tsv"
HELD="$A/held/$ID"
touch "$CL" "$LOG"
now() { date +%Y-%m-%dT%H:%M:%S; }
loglen() { awk 'END { print NR }' "$LOG"; }
put() { # <file> <tmp>: replace a record atomically
    mv "$2" "$1"
}
in_list() { # <file>: is it one of the files of this call
    local f
    for f in "${files[@]}"; do [ "$f" = "$1" ] && return 0; done
    return 1
}
held() { # <file>: its held copy, every "../" written as "_up/"
    printf '%s/%s' "$HELD" "${1//..\//_up/}"
}
start_n() { head -n 1 "$SEEN"; }
seen_n() { # <file>: the last log number this agent saw for it, 0 if none
    awk -F '\t' -v f="$1" 'NR > 1 && $1 == f { n = $2 } END { print n + 0 }' "$SEEN"
}
set_seen() { # <file> <n>
    local t="$SEEN.$$"
    awk -F '\t' -v f="$1" 'NR == 1 || $1 != f' "$SEEN" >"$t"
    printf '%s\t%s\n' "$1" "$2" >>"$t"
    put "$SEEN" "$t"
}
drop_claims() { # <id> [<file>]: remove the claim lines of the id, of that file only if named
    local t="$CL.$$"
    awk -F '\t' -v id="$1" -v f="${2:-}" '!($1 == id && (f == "" || $5 == f))' "$CL" >"$t"
    put "$CL" "$t"
}
# off: drop this agent's own claims and remove the mode file. With --if-last keep the mode,
# changing nothing, while another live agent claims, owns a worktree or was active since the
# switch within the last 300 s.
if [ "$cmd" = off ]; then
    lock
    kept=""
    if [ $iflast -eq 1 ]; then
        while IFS="$TAB" read -r id name tp tm f; do
            [ "$id" != "$ID" ] || continue
            if alive "$id"; then
                kept="claim of $name"
                break
            fi
        done <"$CL"
    fi
    if [ $iflast -eq 1 ] && [ -z "$kept" ]; then
        for d in "$A/wt"/*/; do
            [ -d "$d" ] || continue
            id=$(basename "$d")
            id="${id//-/:}"
            [ "$id" != "$ID" ] || continue
            if alive "$id"; then
                kept="worktree of $id"
                break
            fi
        done
    fi
    if [ $iflast -eq 1 ] && [ -z "$kept" ]; then
        for s in "$A/seen"/*.tsv; do
            [ -f "$s" ] || continue
            id=$(basename "$s" .tsv)
            [ "$id" != "$ID" ] || continue
            [ "$s" -nt "$A/mode" ] || continue
            [ $(($(date +%s) - $(stat -f %m "$s"))) -le 300 ] || continue
            if alive "$id"; then
                kept="agent $id active"
                break
            fi
        done
    fi
    if [ -n "$kept" ]; then
        echo "mode: kept — $kept"
        exit 1
    fi
    drop_claims "$ID"
    rm -f "$A/mode"
    echo "mode: off"
    exit 0
fi

owners() { # lines "id<tab>name<tab>topic<tab>file" of claims of other ids on the files of this call
    local id name tp tm f
    while IFS="$TAB" read -r id name tp tm f; do
        [ "$id" != "$ID" ] || continue
        in_list "$f" || continue
        printf '%s\t%s\t%s\t%s\n' "$id" "$name" "$tp" "$f"
    done <"$CL"
}

log_diff() { # <file> <old copy> <new copy> <topic> <essence>: a log line and a diff when they differ
    local f="$1" old="$2" new="$3" n d ranges
    [ "$old" != /dev/null ] || [ "$new" != /dev/null ] || return 0
    n=$(($(loglen) + 1))
    d="$A/diffs/$n.diff"
    diff -u -L "$f (before)" -L "$f ($n by $NAME: $5)" "$old" "$new" >"$d" || true
    if [ -s "$d" ]; then
        if [ "$new" = /dev/null ]; then
            ranges=deleted
        else
            ranges=$(awk '/^@@ / {
                    split($3, a, ","); s = substr(a[1], 2) + 0; c = (2 in a) ? a[2] + 0 : 1
                    r = (c > 1) ? s "-" (s + c - 1) : s
                    out = out (out == "" ? "" : ",") r
                } END { print out }' "$d")
        fi
        printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
            "$n" "$ID" "$NAME" "$4" "$(now)" "$f" "$ranges" "$5" >>"$LOG"
        set_seen "$f" "$n"
    else
        rm -f "$d"
    fi
}

# --- the worktree --------------------------------------------------------------

subs() { # the submodule paths of the root, one per line
    git -C "$ROOT" ls-files -s | awk -F '\t' '$1 ~ /^160000 / { print $2 }'
}
SUBS=""
case "$cmd" in wt | sync | merge) SUBS=$(subs) ;; esac
in_subs() { # <path>: a submodule path or a path under one
    local p
    while IFS= read -r p; do
        [ -n "$p" ] || continue
        case "$1" in "$p" | "$p"/*) return 0 ;; esac
    done <<<"$SUBS"
    return 1
}
snap() { # <dir>: a commit of the folder as it is, through this agent's own index; prints its id
    local d="$1" idx src p tree
    local ex=()
    if [ "$d" = "$ROOT" ]; then idx="$A/index/$ID-root"; else idx="$A/index/$ID-wt"; fi
    if [ ! -f "$idx" ]; then
        src=$(git -C "$d" rev-parse --path-format=absolute --git-path index) || return 1
        if [ -f "$src" ]; then cp "$src" "$idx"; fi
    fi
    while IFS= read -r p; do
        [ -z "$p" ] || ex+=(":(exclude)$p")
    done <<<"$SUBS"
    GIT_INDEX_FILE="$idx" git -C "$d" add -A -- . ':(exclude,glob)**/.swork*' ':(exclude,glob)**/.swork*/**' \
        ${ex[@]+"${ex[@]}"} || return 1
    tree=$(GIT_INDEX_FILE="$idx" git -C "$d" write-tree) || return 1
    if git -C "$d" rev-parse -q --verify HEAD >/dev/null; then
        git -C "$d" -c user.name=agents -c user.email=agents@local \
            commit-tree --no-gpg-sign -m agents-snapshot -p HEAD "$tree"
    else
        git -C "$d" -c user.name=agents -c user.email=agents@local \
            commit-tree --no-gpg-sign -m agents-snapshot "$tree"
    fi
}
clone() { # <from> <to>: a copy-on-write clone, a plain copy when the clone fails
    mkdir -p "$(dirname "$2")"
    cp -cR "$1" "$2" 2>/dev/null || {
        rm -rf "$2"
        cp -R "$1" "$2"
    }
}
need_wt() {
    if [ ! -d "$WT" ]; then
        echo "no worktree of this agent: call wt first" >&2
        exit 2
    fi
}
MT=()
attrs() { # writes .agents/attributes and sets MT, the options of every merge-tree call
    MT=(-c "core.attributesFile=$A/attributes" -c merge.conflictStyle=diff3)
    if command -v mergiraf >/dev/null 2>&1; then
        printf '%s merge=mergiraf\n' '*.js' '*.ts' '*.jsx' '*.tsx' '*.json' >"$A/attributes"
        MT+=(-c merge.mergiraf.name=mergiraf
            -c 'merge.mergiraf.driver=mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P')
    else
        : >"$A/attributes"
    fi
}
conflicts() { # <base> <ours> <theirs>: a line "conflict: <path>" per conflicted path
    { git "${MT[@]}" -C "$ROOT" merge-tree --write-tree --name-only --merge-base="$1" "$2" "$3" || true; } |
        awk 'NR == 1 { next } $0 == "" { exit } !seen[$0]++ { print "conflict: " $0 }'
}
do_sync() { # the shared folder into the worktree: 0, 4 on a conflict; code 5 when merge-tree fails
    local B S W out rc=0 tree p
    B=$(git -C "$WT" rev-parse HEAD) || return 1
    S=$(snap "$ROOT") || return 1
    W=$(snap "$WT") || return 1
    attrs
    out=$(git "${MT[@]}" -C "$ROOT" merge-tree --write-tree --merge-base="$B" "$S" "$W") || rc=$?
    [ $rc -le 1 ] || shared "merge-tree failed"
    tree=$(printf '%s\n' "$out" | head -n 1)
    # The index first equals the worktree's files, so the reset rewrites only what the merge changed.
    git -C "$WT" read-tree "$W^{tree}" || return 1
    git -C "$WT" read-tree -u --reset "$tree" || return 1
    git -C "$WT" update-ref --no-deref HEAD "$S" || return 1
    while IFS= read -r p; do
        [ -n "$p" ] || continue
        /usr/bin/rsync -a --delete --exclude=.git "$ROOT/$p/" "$WT/$p/" || return 1
    done <<<"$SUBS"
    if [ $rc -eq 1 ]; then
        conflicts "$B" "$S" "$W"
        return 4
    fi
    return 0
}
blob_of() { # <path>: the blob id of the shared file as git would store it; nothing when it is absent
    if [ -L "$ROOT/$1" ]; then
        printf '%s' "$(readlink "$ROOT/$1")" | git -C "$ROOT" hash-object --stdin
    elif [ -f "$ROOT/$1" ]; then
        git -C "$ROOT" hash-object -- "$1"
    fi
}
orphan() { # <id>: save a dead agent's worktree edits into orphans/ and remove the worktree
    local w="$A/wt/${1//:/-}" o=".agents/orphans/${1//:/-}.diff" f
    [ -d "$w" ] || return 0
    mkdir -p "$A/orphans"
    {
        git -C "$w" diff HEAD || true
        git -C "$w" ls-files -o --exclude-standard -z 2>/dev/null | while IFS= read -r -d '' f; do
            git -C "$w" diff --no-index /dev/null "$f" || true
        done
    } >"$ROOT/$o"
    git -C "$ROOT" worktree remove --force "$w" >/dev/null 2>&1 || true
    echo "orphan saved: $o"
}
reap() { # every worktree in .agents/wt/ whose agent is not alive is saved and removed
    local d id
    for d in "$A/wt"/*/; do
        [ -d "$d" ] || continue
        id=$(basename "$d")
        id="${id//-/:}"
        [ "$id" != "$ID" ] || continue
        alive "$id" || orphan "$id"
    done
}
wait_line() { # <files> <holder> <start> <seconds> <outcome>: a line of waits.tsv; the caller holds the lock
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$ID" "$NAME" "$topic" "$1" "$2" "$3" "$4" "$5" >>"$A/waits.tsv"
}

lock
if [ ! -f "$SEEN" ]; then
    loglen >"$SEEN"
fi

case "$cmd" in
    id)
        exit 0
        ;;

    claim)
        busy=0
        gone=""
        while IFS="$TAB" read -r id name tp f; do
            if alive "$id"; then
                echo "busy: $f held by $name"
                busy=1
            else
                orphan "$id"
                drop_claims "$id" "$f"
                gone="$gone$f$NL"
                echo "abandoned: $f by $name"
            fi
        done < <(owners)
        if [ $busy -eq 1 ]; then
            exit 3
        fi
        t="$CL.$$"
        awk -F '\t' -v me="$ID" 'BEGIN { while ((getline l < ARGV[2]) > 0) want[l] = 1; ARGV[2] = "" }
            !($5 in want) || $1 == me' "$CL" <(printf '%s\n' "${files[@]}") >"$t"
        put "$CL" "$t"
        for f in "${files[@]}"; do
            if awk -F '\t' -v me="$ID" -v f="$f" '$1 == me && $5 == f { found = 1 } END { exit !found }' "$CL"; then
                continue
            fi
            printf '%s\t%s\t%s\t%s\t%s\n' "$ID" "$NAME" "$topic" "$(now)" "$f" >>"$CL"
            h=$(held "$f")
            rm -f "$h"
            if [ -f "$ROOT/$f" ]; then
                mkdir -p "$(dirname "$h")"
                cp -p "$ROOT/$f" "$h"
            fi
        done
        last=$(loglen)
        s=$(start_n)
        for f in "${files[@]}"; do
            v=$(seen_n "$f")
            [ "$v" -gt "$s" ] || v=$s
            ds=$(awk -F '\t' -v me="$ID" -v f="$f" -v v="$v" -v d="$A/diffs" \
                '$6 == f && $2 != me && $1 + 0 > v { print d "/" $1 ".diff" }' "$LOG")
            if printf '%s' "$gone" | grep -qxF -- "$f"; then
                echo "reread: $f"
            elif [ -z "$ds" ]; then
                echo "no changes: $f"
            else
                lines=0
                while IFS= read -r d; do
                    if [ -f "$d" ]; then lines=$((lines + $(wc -l <"$d"))); fi
                done <<<"$ds"
                if [ $lines -gt 100 ]; then
                    echo "reread: $f"
                else
                    while IFS= read -r d; do
                        if [ -f "$d" ]; then cat "$d"; fi
                    done <<<"$ds"
                fi
            fi
            set_seen "$f" "$last"
        done
        exit 0
        ;;

    wait)
        unlock
        t0=$(date +%s)
        st=$(now)
        holder=-
        end=$((t0 + piece))
        gone=()
        while :; do
            lock
            busy=()
            while IFS="$TAB" read -r id name tp f; do
                if alive "$id"; then
                    [ "$holder" != - ] || holder="$name"
                    busy+=("busy: $f held by $name")
                else
                    orphan "$id"
                    drop_claims "$id" "$f"
                    echo "abandoned: $f by $name"
                    gone+=("$f")
                fi
            done < <(owners)
            unlock
            if [ ${#busy[@]} -eq 0 ]; then
                for f in "${files[@]}"; do
                    case " ${gone[*]+${gone[*]}} " in *" $f "*) ;; *) echo "free: $f" ;; esac
                done
                outcome=free
                [ ${#gone[@]} -eq 0 ] || outcome=abandoned
                lock
                wait_line "${files[*]}" "$holder" "$st" $(($(date +%s) - t0)) $outcome
                exit 0
            fi
            if [ "$(date +%s)" -ge $end ]; then
                printf '%s\n' "${busy[@]}"
                outcome=busy
                [ ${#gone[@]} -eq 0 ] || outcome=abandoned
                lock
                wait_line "${files[*]}" "$holder" "$st" $(($(date +%s) - t0)) $outcome
                exit 3
            fi
            sleep 2
        done
        ;;

    done)
        for f in "${files[@]}"; do
            if ! awk -F '\t' -v me="$ID" -v f="$f" '$1 == me && $5 == f { found = 1 } END { exit !found }' "$CL"; then
                echo "$f: not claimed by this agent" >&2
                exit 2
            fi
        done
        for f in "${files[@]}"; do
            tp=$(awk -F '\t' -v me="$ID" -v f="$f" '$1 == me && $5 == f { print $3; exit }' "$CL")
            old=$(held "$f")
            new="$ROOT/$f"
            [ -f "$old" ] || old=/dev/null
            [ -f "$new" ] || new=/dev/null
            log_diff "$f" "$old" "$new" "$tp" "$essence"
            drop_claims "$ID" "$f"
            rm -f "$(held "$f")"
        done
        exit 0
        ;;

    wt)
        reap
        if [ ! -d "$WT" ]; then
            S=$(snap "$ROOT")
            mkdir -p "$A/wt"
            git -C "$ROOT" worktree add --detach "$WT" "$S" >/dev/null 2>&1 || shared "worktree add failed"
            while IFS= read -r -d '' e; do
                case "$e" in '!! '*) ;; *) continue ;; esac
                p="${e#!! }"
                p="${p%/}"
                case "$p" in .agents | .agents/*) continue ;; esac
                case "/$p" in */.swork*) continue ;; esac
                clone "$ROOT/$p" "$WT/$p"
            done < <(GIT_OPTIONAL_LOCKS=0 git -C "$ROOT" status --ignored --porcelain -z)
            while IFS= read -r p; do
                [ -n "$p" ] || continue
                rmdir "$WT/$p" 2>/dev/null || true
                clone "$ROOT/$p" "$WT/$p"
                rm -rf "$WT/$p/.git"
            done <<<"$SUBS"
        fi
        echo "$WT"
        exit 0
        ;;

    sync)
        reap
        unlock
        need_wt
        rc=0
        do_sync || rc=$?
        exit $rc
        ;;

    merge)
        unlock
        need_wt
        if [ -n "$base" ]; then
            if [ ! -d "$base" ]; then
                echo "$base: no such folder" >&2
                exit 2
            fi
            base=$(cd "$base" && pwd -P)
        fi
        limit="${AGENTS_MERGE_FOR:-540}"
        case "$limit" in '' | *[!0-9]*) usage ;; esac
        [ "$limit" -le 540 ] || limit=540
        end=$(($(date +%s) + limit))
        first=1
        waited=0
        wfiles=()
        mholder=-
        B=$(git -C "$WT" rev-parse HEAD)
        W=$(snap "$WT")
        if [ "$(git -C "$WT" rev-parse "$W^{tree}")" = "$(git -C "$WT" rev-parse "$B^{tree}")" ]; then
            echo "merged: nothing"
            rc=0
            do_sync || rc=$?
            exit $rc
        fi
        t0=$(date +%s)
        st=$(now)
        while :; do
            lwaited=0
            lock
            [ $lwaited -eq 0 ] || waited=1
            S=$(snap "$ROOT")
            attrs
            rc=0
            out=$(git "${MT[@]}" -C "$ROOT" merge-tree --write-tree --merge-base="$B" "$S" "$W") || rc=$?
            if [ $rc -gt 1 ]; then
                unlock
                shared "merge-tree failed"
            fi
            if [ $rc -eq 1 ]; then
                unlock
                rc=0
                do_sync || rc=$?
                [ $rc -eq 0 ] || exit $rc
                B=$(git -C "$WT" rev-parse HEAD)
                W=$(snap "$WT")
                continue
            fi
            tree=$(printf '%s\n' "$out" | head -n 1)
            # The paths to write: "<old mode> <new mode> <old blob> <new blob> <status><tab><path>".
            ch=()
            files=()
            while IFS= read -r -d '' meta && IFS= read -r -d '' p; do
                case "$meta" in :160000\ * | :??????\ 160000\ *) continue ;; esac
                if in_subs "$p"; then continue; fi
                ch+=("${meta#:}$TAB$p")
                files+=("$p")
            done < <(git -C "$ROOT" diff-tree -r -z "$S" "$tree")
            busy=()
            if [ ${#files[@]} -gt 0 ]; then
                while IFS="$TAB" read -r id name tp f; do
                    if alive "$id"; then
                        busy+=("busy: $f held by $name")
                        [ "$mholder" != - ] || mholder="$name"
                        case " ${wfiles[*]+${wfiles[*]}} " in *" $f "*) ;; *) wfiles+=("$f") ;; esac
                    else
                        orphan "$id"
                        drop_claims "$id" "$f"
                        echo "abandoned: $f by $name"
                    fi
                done < <(owners)
            fi
            if [ ${#busy[@]} -gt 0 ]; then
                unlock
                if [ "$(date +%s)" -ge $end ]; then
                    printf '%s\n' "${busy[@]}"
                    exit 3
                fi
                sleep 2
                continue
            fi
            if [ $first -eq 1 ] && [ -n "${AGENTS_BEFORE_WRITE:-}" ]; then
                (cd "$ROOT" && bash -c "$AGENTS_BEFORE_WRITE") || true
            fi
            first=0
            # A path changed in the shared folder since the snapshot: merge again (R20).
            moved=0
            for r in ${ch[@]+"${ch[@]}"}; do
                read -r om nm ob nb sl <<<"${r%%"$TAB"*}"
                p="${r#*"$TAB"}"
                if [ "$om" = 000000 ]; then
                    if [ -e "$ROOT/$p" ] || [ -L "$ROOT/$p" ]; then moved=1; fi
                elif [ "$(blob_of "$p")" != "$ob" ]; then
                    moved=1
                fi
                [ $moved -eq 0 ] || break
            done
            if [ $moved -eq 1 ]; then
                unlock
                continue
            fi
            [ ${#wfiles[@]} -eq 0 ] || waited=1
            secs=$(($(date +%s) - t0))
            if [ $waited -eq 1 ] && [ $secs -ge 1 ]; then
                if [ ${#wfiles[@]} -gt 0 ]; then wf="${wfiles[*]}"; else wf=.agents/lock; fi
                wait_line "$wf" "$mholder" "$st" $secs free
            fi
            for r in ${ch[@]+"${ch[@]}"}; do
                read -r om nm ob nb sl <<<"${r%%"$TAB"*}"
                p="${r#*"$TAB"}"
                f="$ROOT/$p"
                if [ -n "$base" ]; then
                    if [ ! -e "$f" ] && [ ! -L "$f" ]; then
                        touch "$base/new-files.txt"
                        grep -qxF -- "$p" "$base/new-files.txt" || printf '%s\n' "$p" >>"$base/new-files.txt"
                    elif [ ! -e "$base/base/$p" ] && ! grep -qxF -- "$p" "$base/new-files.txt" 2>/dev/null; then
                        mkdir -p "$(dirname "$base/base/$p")"
                        cp -p "$f" "$base/base/$p"
                    fi
                fi
                old=/dev/null
                if [ -f "$f" ]; then
                    old="$A/merge.$$.old"
                    cp -p "$f" "$old"
                fi
                if [ "$nm" = 000000 ]; then
                    rm -f "$f"
                elif [ "$nm" = 120000 ]; then
                    mkdir -p "$(dirname "$f")"
                    rm -f "$f"
                    ln -s "$(git -C "$ROOT" cat-file blob "$nb")" "$f"
                else
                    mkdir -p "$(dirname "$f")"
                    if [ -L "$f" ]; then rm -f "$f"; fi
                    git -C "$ROOT" cat-file --filters --path="$p" "$nb" >"$A/merge.$$.new"
                    cat "$A/merge.$$.new" >"$f"
                    rm -f "$A/merge.$$.new"
                    if [ "$nm" = 100755 ]; then chmod +x "$f"; else chmod -x "$f"; fi
                fi
                new="$f"
                [ -f "$new" ] || new=/dev/null
                log_diff "$p" "$old" "$new" "$topic" "$essence"
                rm -f "$A/merge.$$.old"
                echo "merged: $p"
            done
            unlock
            if [ ${#ch[@]} -eq 0 ]; then echo "merged: nothing"; fi
            rc=0
            do_sync || rc=$?
            exit $rc
        done
        ;;

    release)
        if [ $all -eq 1 ]; then
            drop_claims "$ID"
            rm -rf "$HELD"
        else
            for f in "${files[@]}"; do
                drop_claims "$ID" "$f"
                rm -f "$(held "$f")"
            done
        fi
        exit 0
        ;;

    busy)
        unlock
        found=0
        while IFS="$TAB" read -r id name tp tm f; do
            [ "$id" != "$ID" ] || continue
            [ $topic_set -eq 0 ] || [ "$tp" = "$topic" ] || continue
            if alive "$id"; then
                echo "busy: $f held by $name in $tp"
                found=1
            fi
        done <"$CL"
        [ $found -eq 1 ] || exit 1
        exit 0
        ;;

    others)
        unlock
        if [ -n "$since" ]; then
            [ -e "$since" ] || {
                echo "$since: no such file" >&2
                exit 2
            }
            mark=$(stat -f %Sm -t %Y-%m-%dT%H:%M:%S "$since")
        else
            mark=$(date -r "${ID#*:}" +%Y-%m-%dT%H:%M:%S)
        fi
        {
            while IFS="$TAB" read -r id name tp tm f; do
                [ "$id" != "$ID" ] || continue
                if alive "$id"; then echo "$f"; fi
            done <"$CL"
            awk -F '\t' -v me="$ID" -v m="$mark" '$2 != me && $5 >= m { print $6 }' "$LOG"
        } | awk '!seen[$0]++'
        exit 0
        ;;
esac
