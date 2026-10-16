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
#
# Every command takes --topic <topic> — the name of the topic folder, default "-".
# Paths are taken from the current folder and kept relative to the project root, without "./";
# a file of a wiki above the root (the folder holding docs/00-index.md) is kept with "../".
#
# claim: code 0 — all claimed; for each file "no changes: <file>", the diffs other agents
#   logged since this agent last held it, or "reread: <file>" when they exceed 100 lines.
#   Code 3 — nothing claimed, a line "busy: <file> held by <name>" per busy file; a dead owner's
#   claim is removed all the same and named "abandoned: <file> by <name>".
# wait: at most 540 s (--for shortens it), checks every 2 s. Code 0 — every file is free:
#   "free: <file>", or "abandoned: <file> by <name>" when a dead owner's claim was removed.
#   Code 3 — still busy, call again.
# done: logs a line per changed file, keeps its diff; an unchanged or never existing path
#   logs nothing. busy: code 0 and a line per claim, code 1 when there is none.
# Wrong arguments — a message and code 2.
#
# Records in <project root>/.agents/, one tab-separated line each:
#   claims.tsv  id, name, topic, time, file
#   log.tsv     n, id, name, topic, time, file, lines, essence; the diff is diffs/<n>.diff
#   held/<id>/<file>  the copy taken at the claim
#   seen/<id>.tsv     line 1: the log length at this agent's start; then file, last seen n
#   lock/             the mutex, holding the pid of its owner
# The id is <pid>:<start epoch> of the agent's process; AGENTS_ID="<id><tab><name>" overrides it.
export LC_ALL=C.UTF-8
set -euo pipefail

TAB=$(printf '\t')
NL='
'

usage() {
    echo "usage: bash agents.sh claim|wait|done|release|busy|others|id [--topic <topic>] …" >&2
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
files=()
case "$cmd" in
    claim | wait | release | busy | others | id) ;;
    done)
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
    busy | others | id) [ ${#files[@]} -eq 0 ] || usage ;;
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
mkdir -p "$A/diffs" "$A/held" "$A/seen"
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
fi

# --- the mutex -----------------------------------------------------------------

locked=0
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
                sleep 0.2
                continue
            fi
        else
            age=$(($(date +%s) - $(stat -f %m "$L" 2>/dev/null || date +%s)))
            if [ $age -le 5 ]; then
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
owners() { # lines "id<tab>name<tab>topic<tab>file" of claims of other ids on the files of this call
    local id name tp tm f
    while IFS="$TAB" read -r id name tp tm f; do
        [ "$id" != "$ID" ] || continue
        in_list "$f" || continue
        printf '%s\t%s\t%s\t%s\n' "$id" "$name" "$tp" "$f"
    done <"$CL"
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
        end=$(($(date +%s) + piece))
        gone=()
        while :; do
            lock
            busy=()
            while IFS="$TAB" read -r id name tp f; do
                if alive "$id"; then
                    busy+=("busy: $f held by $name")
                else
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
                exit 0
            fi
            if [ "$(date +%s)" -ge $end ]; then
                printf '%s\n' "${busy[@]}"
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
            if [ "$old" != /dev/null ] || [ "$new" != /dev/null ]; then
                n=$(($(loglen) + 1))
                d="$A/diffs/$n.diff"
                diff -u -L "$f (before)" -L "$f ($n by $NAME: $essence)" "$old" "$new" >"$d" || true
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
                        "$n" "$ID" "$NAME" "$tp" "$(now)" "$f" "$ranges" "$essence" >>"$LOG"
                    set_seen "$f" "$n"
                else
                    rm -f "$d"
                fi
            fi
            drop_claims "$ID" "$f"
            rm -f "$(held "$f")"
        done
        exit 0
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
