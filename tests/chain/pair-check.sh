#!/bin/bash
# Tells whether two swork sessions run at once in one project both ended without losing an edit.
#
#   bash tests/chain/pair-check.sh <project> <stage folder 1> <stage folder 2> a|b
#
# <project> was seeded by seed-pair.sh with the same case and driven by drive.sh with the
# stage pair into the two stage folders — case a: session 1 on topic usage, session 2 on
# topic version; case b: both on topic pair. Each session is judged by its own reply, .result
# of turns/01.json: the mark ⏸ of a short report, or the choice of the final report — accept
# or Принять, any case — while the progress cards of its topic hold a stage-7 finished record
# with no agent mark, or with the mark of that session: "stage 7 [<session id>]: finished",
# the session id being .session_id of its turns/01.json.
# Prints the lines "<name>: <value>" — the passing value of each
# is the third argument of its `line` call below; `split` (case b) is printed and not
# judged — then "pair run: pass" and code 0 when every judged line holds its passing value,
# otherwise "pair run: fail" and code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 4 ]; then
    echo "usage: bash pair-check.sh <project> <stage folder 1> <stage folder 2> a|b" >&2
    exit 2
fi
project="${1%/}"
case "$4" in
    a) topics='usage version'; topic1=usage; topic2=version ;;
    b) topics='pair'; topic1=pair; topic2=pair ;;
    *) echo "usage: bash pair-check.sh <project> <stage folder 1> <stage folder 2> a|b" >&2; exit 2 ;;
esac
work="$project/docs/work"

failed=0
# A line of the output: $1 — the name, $2 — the value found, $3 — the passing value.
line() {
    echo "$1: $2"
    if [ "$2" != "$3" ]; then failed=1; fi
}

# The report of the reply of the stage folder $1 on topic $2: final, short or none.
# Final is the choice of the final report in the reply while the progress cards of the
# topic hold a stage-7 finished record with no agent mark or with the mark of this session;
# short is the mark ⏸ in the reply. "Принять" and the mark ⏸ are written as escapes.
report() {
    local result="" session="" stage7
    if [ -f "$1/turns/01.json" ]; then
        result="$(jq -r '.result // ""' "$1/turns/01.json")"
        session="$(jq -r '.session_id // ""' "$1/turns/01.json")"
    fi
    stage7="$(cat "$work/$2"/progress*.md 2>/dev/null | perl -ne '
        BEGIN { $id = shift @ARGV; $ok = "no" }
        $ok = "yes" if /stage 7(?: \[([^\]]*)\])?:? finished/ && (!defined $1 || $1 eq $id);
        END { print "$ok\n" }
    ' "$session" || true)"
    perl -CSDA -e '
        my ($reply, $stage7) = @ARGV;
        if ($stage7 eq "yes" && $reply =~ /accept|\x{41f}\x{440}\x{438}\x{43d}\x{44f}\x{442}\x{44c}/i) { print "final\n" }
        elsif ($reply =~ /\x{23f8}/) { print "short\n" }
        else { print "none\n" }
    ' "$result" "$stage7"
}

# ---------- the replies ----------

r1="$(report "${2%/}" "$topic1")"
r2="$(report "${3%/}" "$topic2")"
ended1=no
if [ "$r1" != none ]; then ended1=yes; fi
ended2=no
if [ "$r2" != none ]; then ended2=yes; fi
final=no
if [ "$r1" = final ] || [ "$r2" = final ]; then final=yes; fi

# ---------- the slices ----------

# Every slice card of the seeded topics that is not done: "<topic> S<N> <status>".
slices=""
cards=0
for topic in $topics; do
    for card in "$work/$topic"/plan-s*.md; do
        [ -f "$card" ] || continue
        found="$(grep -m1 '^- \*\*Status:\*\* ' "$card" || true)"
        [ -n "$found" ] || continue
        cards=$((cards + 1))
        status="${found#"- **Status:** "}"
        if [ "$status" != done ]; then
            n="${card##*/plan-s}"
            slices="${slices:+$slices; }$topic S${n%%-*} $status"
        fi
    done
done
if [ $cards -eq 0 ]; then
    slices=missing
elif [ -z "$slices" ]; then
    slices='all done'
fi

# ---------- the claims ----------

claims=none
if [ -f "$project/.agents/claims.tsv" ]; then
    k=$(grep -c . "$project/.agents/claims.tsv" || true)
    if [ "$k" -gt 0 ]; then claims="$k lines"; fi
fi

# ---------- the lines ----------

line 'ended 1' "$ended1" 'yes'
line 'ended 2' "$ended2" 'yes'
line 'slices' "$slices" 'all done'
if [ "$4" = a ]; then
    usage=no
    version=no
    if grep -qxF 'Usage: see USAGE.md' "$project/README.md" 2>/dev/null; then usage=yes; fi
    if grep -qxF 'Version: see VERSION' "$project/README.md" 2>/dev/null; then version=yes; fi
    case "$usage:$version" in
        yes:yes) readme=both ;;
        yes:no) readme='usage only' ;;
        no:yes) readme='version only' ;;
        *) readme=neither ;;
    esac
    line 'readme' "$readme" 'both'
else
    # Who did which slice: the last record "S<N> [<name>]:" of each slice in the progress log.
    split="$(cat "$work/pair"/progress*.md 2>/dev/null \
        | perl -ne '$who{$1} = $2 while /\bS(\d+) \[([^\]]+)\]:/g; END { print join(", ", map { "S$_ $who{$_}" } sort { $a <=> $b } keys %who) }' || true)"
    echo "split: ${split:-none}"
fi
line 'final' "$final" 'yes'
line 'claims' "$claims" 'none'

if [ $failed -eq 0 ]; then
    echo 'pair run: pass'
    exit 0
fi
echo 'pair run: fail'
exit 1
