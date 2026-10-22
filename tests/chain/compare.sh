#!/bin/bash
# Compares a baseline series of the chain stand with a candidate series.
#
#   bash tests/chain/compare.sh [--only "<stages>"] <base series> <cand series>
#   bash tests/chain/compare.sh --map <series without map> <series with map>
#
# A series is the folder $CHAIN_BASE/<series>, by default
# ~/Documents/my/chain-stand/<series>. Prints, a line each:
#   violations: base <a> cand <b> (shared rules) — "rule" lines answered no of
#       the rule ids present in the rules files of both series' labels;
#   new rules: cand <n> — the candidate's violations of ids only it has: they
#       do not decide;
#   stages:, seeds:, decisions:, flaws:, away:, nonstop:, pair: base <x> cand <y>
#       — the lines of zero.sh;
#   trap runs: base <k>/15, cand <k>/15 — the files <run>/trap-<name>.json;
#   <measure>: median base <x> cand <y> ratio <r> — for hidden (passes),
#       lines, gz_bytes, overeng, caught, tokens_out, wall_s, cost_usd: x and y
#       — the sums of the per-task medians over the runs, r — the geometric
#       mean of the per-task ratios cand/base; a task whose baseline median is
#       0 is left out of it, none left — n/a;
#   tokens:, cost:, wall: base <x> cand <y> — over every stage folder of every
#       run: tokens_out by the rule of measure.sh over raw/, wall_s of
#       stage.json, total_cost_usd of the last turns/*.json;
#   speed: x<base wall / cand wall>;
#   accept: pass | accept: fail — <the failing measures>; a fail only on wall —
#       "accept: fail — wall (time only)".
# Accepted when violations are not more; stages, seeds, decisions, flaws,
# away, nonstop, pair, hidden and caught not lower; lines lower; overeng not
# higher; the series wall and the trap wall_s not higher: code 0, otherwise 1.
# --only "<stages>": stages counts only the named stages; violations and seeds
# only with brain, plan, work, seed or away named; decisions and flaws only
# with survey or grill; away, nonstop, pair only when named; the trap lines
# only with traps; tokens, cost and wall over the named stages' folders. Every
# other line prints "skipped" and does not decide.
# --map: only the trap lines, then "map: keep" — hidden not lower, overeng not
# higher and tokens_out lower in the map series, code 0 — or "map: drop", 1.
# zero.sh goes first when a line needs it, so the judge may take an hour.
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo 'usage: bash compare.sh [--only "<stages>"] <base series> <cand series>' >&2
    echo '       bash compare.sh --map <series without map> <series with map>' >&2
    exit 2
}
here="$(cd "$(dirname "$0")" && pwd)"
B="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
key="$B/blind/key.tsv"
. "$here/tally.sh"

map=0 has_only=0 only=""
if [ $# -ge 1 ] && [ "$1" = --map ]; then
    map=1
    shift
elif [ $# -ge 1 ] && [ "$1" = --only ]; then
    [ $# -ge 2 ] || usage
    has_only=1
    only="$2"
    shift 2
fi
[ $# -eq 2 ] || usage
base="$1"
cand="$2"
for s in "$base" "$cand"; do
    [ -d "$B/$s" ] || { echo "compare: no series $s"; exit 1; }
done

traps='reuse shared-bug rename traversal native'
measures='hidden lines gz_bytes overeng caught tokens_out wall_s cost_usd'

# The stage $1 is compared: no --only, or it is named.
named() {
    [ $has_only -eq 0 ] && return 0
    case " $only " in *" $1 "*) return 0 ;; esac
    return 1
}

# One of the stages $@ is named.
any() {
    local s
    for s in "$@"; do
        if named "$s"; then return 0; fi
    done
    return 1
}

# The numbers $1 and $2 hold the awk comparison $3: "$1 $3 $2", e.g. "<=".
holds() {
    awk -v a="$1" -v b="$2" "BEGIN { exit !(a + 0 $3 b + 0) }"
}

# The stage folders of the stage $1: pair has two, a trap two, traps ten.
folders() {
    local t
    case "$1" in
        pair) echo 'pair1 pair2' ;;
        traps) for t in $traps; do echo "trap-$t-plan trap-$t-work"; done ;;
        trap-*) echo "$1-plan $1-work" ;;
        *) echo "$1" ;;
    esac
}

# The trap rows of the series $1, prefixed by $2: "<side> <task> <measure> <value>"; hidden —
# 1 for pass, 0 for fail; a null is left out.
trap_rows() {
    local R f t
    for R in "$B/$1"/[0-9]*; do
        [ -d "$R" ] || continue
        for f in "$R"/trap-*.json; do
            [ -f "$f" ] || continue
            t="${f##*/trap-}"
            t="${t%.json}"
            jq -r --arg side "$2" --arg t "$t" --arg m "$measures" '
                . as $j | ($m | split(" "))[] as $k
                | ($j[$k] | if $k == "hidden" then (if . == "pass" then 1 else 0 end) else . end)
                | select(. != null)
                | "\($side)\t\($t)\t\($k)\t\(.)"' "$f"
        done
    done
}

# The number of trap measurements of the series $1.
trap_runs() {
    local n=0 R f
    for R in "$B/$1"/[0-9]*; do
        [ -d "$R" ] || continue
        for f in "$R"/trap-*.json; do
            if [ -f "$f" ]; then n=$((n + 1)); fi
        done
    done
    echo "$n"
}

# Per measure "<measure> <base sum> <cand sum> <ratio>" from the rows of both series.
trap_table() {
    { trap_rows "$base" b; trap_rows "$cand" c; } | awk -F'\t' -v measures="$measures" '
        function num(x,  s) {
            if (x == int(x)) return sprintf("%d", x)
            s = sprintf("%.4f", x)
            sub(/0+$/, "", s)
            return s
        }
        function median(k,  c, i, j, a, t) {
            c = n[k]
            for (i = 1; i <= c; i++) a[i] = val[k, i] + 0
            for (i = 2; i <= c; i++) {
                t = a[i]
                for (j = i - 1; j > 0 && a[j] > t; j--) a[j + 1] = a[j]
                a[j + 1] = t
            }
            if (c % 2) return a[(c + 1) / 2]
            return (a[c / 2] + a[c / 2 + 1]) / 2
        }
        { k = $1 SUBSEP $2 SUBSEP $3; n[k]++; val[k, n[k]] = $4; tasks[$2] = 1 }
        END {
            split(measures, M, " ")
            for (i = 1; i in M; i++) {
                m = M[i]; sb = 0; sc = 0; logs = 0; cnt = 0; nil = 0
                for (t in tasks) {
                    kb = "b" SUBSEP t SUBSEP m; kc = "c" SUBSEP t SUBSEP m
                    hb = (kb in n); hc = (kc in n)
                    if (hb) { mb = median(kb); sb += mb }
                    if (hc) { mc = median(kc); sc += mc }
                    if (hb && hc && mb > 0) {
                        cnt++
                        if (mc == 0) nil = 1; else logs += log(mc / mb)
                    }
                }
                r = "n/a"
                if (cnt > 0) r = nil ? "0.00" : sprintf("%.2f", exp(logs / cnt))
                print m, num(sb), num(sc), r
            }
        }'
}

# The output tokens of the stage folder $1 by the rule of measure.sh: of a request the last record.
tokens_of() {
    local raws=(/dev/null) f
    for f in "$1"/raw/*.jsonl "$1"/raw/subagents/*.jsonl; do
        if [ -f "$f" ]; then raws+=("$f"); fi
    done
    jq -n '
        reduce (inputs | select(.type == "assistant")) as $r ({};
            .[$r.requestId // ""] = ($r.message.usage // {}))
        | [.[]] | map(.output_tokens // 0) | add // 0
    ' "${raws[@]}"
}

# "<tokens> <wall> <cost>" of the series $1: every stage folder of every run, with --only —
# the named stages' folders.
totals() {
    local R d f last tokens=0 wall=0 cost=0 list s
    for R in "$B/$1"/[0-9]*; do
        [ -d "$R" ] || continue
        list=""
        if [ $has_only -eq 1 ]; then
            for s in $only; do list="$list $(folders "$s")"; done
        else
            for d in "$R"/*/; do
                d="${d%/}"
                if [ -f "$d/stage.json" ] || [ -d "$d/raw" ] || [ -d "$d/turns" ]; then
                    list="$list ${d##*/}"
                fi
            done
        fi
        for d in $list; do
            d="$R/$d"
            [ -d "$d" ] || continue
            tokens=$((tokens + $(tokens_of "$d")))
            if [ -f "$d/stage.json" ]; then
                wall=$((wall + $(jq '.wall_s // 0 | floor' "$d/stage.json")))
            fi
            last=""
            for f in "$d"/turns/*.json; do
                if [ -f "$f" ]; then last="$f"; fi
            done
            if [ -n "$last" ]; then
                cost=$(awk -v a="$cost" -v b="$(jq '.total_cost_usd // 0' "$last" 2>/dev/null || echo 0)" \
                    'BEGIN { printf "%.4f", a + b }')
            fi
        done
    done
    echo "$tokens $wall $(awk -v c="$cost" 'BEGIN { printf "%.2f", c }')"
}

# The rule ids of the labels of the series $1: from rules.md and rules-survey.md.
rule_ids() {
    local l f
    for l in $(awk -F'\t' -v s="$1" '$2 == s { print $1 }' "$key"); do
        for f in "$B/blind/$l/rules.md" "$B/blind/$l/rules-survey.md"; do
            if [ -f "$f" ]; then sed -nE 's/^- ([a-z]+-[0-9]+)\..*/\1/p' "$f"; fi
        done
    done
}

# The rule ids answered "no" in the verdicts of the labels of the series $1, one per violation;
# a word of an earlier verdict by its English name, as tally.sh.
noes() {
    local l
    for l in $(awk -F'\t' -v s="$1" '$2 == s { print $1 }' "$key"); do
        [ -f "$B/blind/$l/verdict.tsv" ] || continue
        awk -F'\t' '
            FILENAME == ARGV[1] {
                if ($1 == "stand" && $2 == "judge") english[$3] = $4
                next
            }
            NF == 4 {
                k = ($1 in english) ? english[$1] : $1
                a = ($3 in english) ? english[$3] : $3
                if (k == "rule" && a == "no") print $2
            }' "$tally_map" "$B/blind/$l/verdict.tsv"
    done
}

# The value of the line "<name>: <value> …" of the zero.sh output $2 of the series $1.
zero_of() {
    printf '%s\n' "$2" | awk -v k="$1:" '$1 == k { print $2; exit }'
}

# The number before the slash of "<n>/<all>".
count() {
    echo "${1%%/*}"
}

fails=""
fail() {
    case ", $fails, " in *", $1, "*) return ;; esac
    fails="${fails:+$fails, }$1"
}

# The trap lines; with --map — the decision.
trap_lines() {
    local m x y r
    echo "trap runs: base $(trap_runs "$base")/15, cand $(trap_runs "$cand")/15"
    while read -r m x y r; do
        echo "$m: median base $x cand $y ratio $r"
        case "$m" in
            hidden | caught) holds "$y" "$x" '>=' || fail "$m" ;;
            lines) holds "$y" "$x" '<' || fail lines ;;
            overeng) holds "$y" "$x" '<=' || fail overeng ;;
            wall_s) holds "$y" "$x" '<=' || fail wall ;;
            tokens_out) holds "$y" "$x" '<' || map_tokens=1 ;;
        esac
    done < <(trap_table)
}

if [ $map -eq 1 ]; then
    map_tokens=0
    trap_lines
    case ", $fails, " in
        *", hidden, "* | *", overeng, "*) map_tokens=1 ;;
    esac
    if [ $map_tokens -eq 0 ]; then
        echo 'map: keep'
        exit 0
    fi
    echo 'map: drop'
    exit 1
fi

judged=0 survey=0
if any brain plan work seed away; then judged=1; fi
if any survey grill; then survey=1; fi
zb="" zc=""
if [ $has_only -eq 0 ] || [ $judged -eq 1 ] || [ $survey -eq 1 ] || any away nonstop pair; then
    zb="$("$BASH" "$here/zero.sh" "$base" 2>/dev/null || true)"
    zc="$("$BASH" "$here/zero.sh" "$cand" 2>/dev/null || true)"
    for z in "$zb" "$zc"; do
        if [ -z "$(zero_of stages "$z")" ]; then
            echo 'compare: no measurement — zero.sh has no counts'
            exit 1
        fi
    done
fi

if [ $judged -eq 1 ]; then
    ib="$(rule_ids "$base" | sort -u)"
    ic="$(rule_ids "$cand" | sort -u)"
    shared="$(comm -12 <(printf '%s\n' "$ib") <(printf '%s\n' "$ic"))"
    only_c="$(comm -13 <(printf '%s\n' "$ib") <(printf '%s\n' "$ic"))"
    # The violations of the series $1 among the ids $2.
    among() {
        noes "$1" | awk 'FILENAME == ARGV[1] { if (NF) id[$1] = 1; next } $1 in id { n++ } END { print n + 0 }' \
            <(printf '%s\n' "$2") -
    }
    vb=$(among "$base" "$shared")
    vc=$(among "$cand" "$shared")
    echo "violations: base $vb cand $vc (shared rules)"
    echo "new rules: cand $(among "$cand" "$only_c")"
    holds "$vc" "$vb" '<=' || fail violations
else
    echo 'violations: skipped'
    echo 'new rules: skipped'
fi

# The stages: with --only, the named ones but the traps, per run.
if [ $has_only -eq 0 ]; then
    sb="$(zero_of stages "$zb")"
    sc="$(zero_of stages "$zc")"
else
    sb="" sc=""
    for side in base cand; do
        s_name="$base"
        if [ $side = cand ]; then s_name="$cand"; fi
        done_n=0 all_n=0
        for R in "$B/$s_name"/[0-9]*; do
            [ -d "$R" ] || continue
            for s in $only; do
                case "$s" in traps | trap-*) continue ;; esac
                for f in $(folders "$s"); do
                    all_n=$((all_n + 1))
                    if jq -e '.done == true' "$R/$f/stage.json" > /dev/null 2>&1; then done_n=$((done_n + 1)); fi
                done
            done
        done
        if [ $all_n -gt 0 ]; then
            if [ $side = base ]; then sb="$done_n/$all_n"; else sc="$done_n/$all_n"; fi
        fi
    done
fi
if [ -n "$sb" ]; then
    echo "stages: base $sb cand $sc"
    holds "$(count "$sc")" "$(count "$sb")" '>=' || fail stages
else
    echo 'stages: skipped'
fi

# A zero.sh line $1 compared when $2 is 1: not lower.
zero_line() {
    local x y
    if [ "$2" -eq 1 ]; then
        x="$(zero_of "$1" "$zb")"
        y="$(zero_of "$1" "$zc")"
        echo "$1: base $x cand $y"
        holds "$(count "$y")" "$(count "$x")" '>=' || fail "$1"
    else
        echo "$1: skipped"
    fi
}
zero_line seeds $judged
zero_line decisions $survey
zero_line flaws $survey
for s in away nonstop pair; do
    on=0
    if named "$s"; then on=1; fi
    zero_line "$s" $on
done

if named traps; then
    map_tokens=0
    trap_lines
else
    echo 'trap runs: skipped'
    for m in $measures; do echo "$m: skipped"; done
fi

read -r tb wb cb <<< "$(totals "$base")"
read -r tc wc cc <<< "$(totals "$cand")"
echo "tokens: base $tb cand $tc"
echo "cost: base $cb cand $cc"
echo "wall: base $wb cand $wc"
if [ "$wc" -gt 0 ]; then
    echo "speed: x$(awk -v a="$wb" -v b="$wc" 'BEGIN { printf "%.2f", a / b }')"
else
    echo 'speed: n/a'
fi
holds "$wc" "$wb" '<=' || fail wall

if [ -z "$fails" ]; then
    echo 'accept: pass'
    exit 0
fi
if [ "$fails" = wall ]; then
    echo 'accept: fail — wall (time only)'
else
    echo "accept: fail — $fails"
fi
exit 1
