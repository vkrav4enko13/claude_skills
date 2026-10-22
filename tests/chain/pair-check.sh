#!/bin/bash
# Tells whether two swork sessions run at once in one project both ended without losing an edit.
#
#   bash tests/chain/pair-check.sh <project> <stage folder 1> <stage folder 2> a|b|c|d|e|f|g|h
#
# <project> was seeded by seed-pair.sh with the same case and driven by drive.sh with the
# stage pair into the two stage folders — case a: session 1 on topic usage, session 2 on
# topic version; case b: both on topic pair; cases c, d, f, g and h: session 1 on topic left,
# session 2 on topic right — in case h with the stage pair-multi, and pair-run.sh wrote
# before.txt into the folder that holds stage folder 1; case e: session 1 on topic shop,
# session 2 on topic hud. Each session is judged by its own reply, .result
# of turns/01.json: the mark ⏸ of a short report, or the choice of the final report — accept
# or Принять, any case — while the progress cards of its topic hold a stage-7 finished record
# with no agent mark, or with the mark of that session: "stage 7 finished [<session id>]" or
# the older "stage 7 [<session id>]: finished", the session id being .session_id of its
# turns/01.json.
#
#   bash tests/chain/pair-check.sh --record "<line>"
#
# Runs the same match on one line: prints "record: <id>" for a stage-7 record with a mark,
# "record: plain" for one without, "record: none" otherwise; code 0.
# Prints the lines "<name>: <value>" — the passing value of each
# is the third argument of its `line` call below; `split` (case b) is printed and not
# judged; a reply is the stage folder's chat.md (the whole turn), else .result of its
# turns/01.json, and case d matches a paragraph of it (lines between blank lines) — then
# "pair run: pass" and code 0 when every judged line holds its passing value,
# otherwise "pair run: fail" and code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

# The match of a stage-7 finished record, kept in one place: stage7(<line>) gives nothing
# when the line is no such record, otherwise [<mark>], the mark undefined when there is none.
match7='sub stage7 { $_[0] =~ /stage 7(?: \[([^\]]*)\])?:? finished(?: \[([^\]]*)\])?/ or return; return [ $1 // $2 ] }'

if [ $# -eq 2 ] && [ "$1" = --record ]; then
    perl -e "$match7"'
        my $m = stage7($ARGV[0]);
        print "record: ", (!$m ? "none" : defined $m->[0] ? $m->[0] : "plain"), "\n";
    ' -- "$2"
    exit 0
fi

if [ $# -ne 4 ]; then
    echo "usage: bash pair-check.sh <project> <stage folder 1> <stage folder 2> a|b|c|d|e|f|g|h" >&2
    exit 2
fi
project="${1%/}"
case "$4" in
    a) topics='usage version'; topic1=usage; topic2=version ;;
    b) topics='pair'; topic1=pair; topic2=pair ;;
    c | d | f | g | h) topics='left right'; topic1=left; topic2=right ;;
    e) topics='shop hud'; topic1=shop; topic2=hud ;;
    *) echo "usage: bash pair-check.sh <project> <stage folder 1> <stage folder 2> a|b|c|d|e|f|g|h" >&2; exit 2 ;;
esac
work="$project/docs/work"

failed=0
# A line of the output: $1 — the name, $2 — the value found, $3 — the passing value.
line() {
    echo "$1: $2"
    if [ "$2" != "$3" ]; then failed=1; fi
}

# The label of two yes/no flags $1 and $2: $3 when both, $4 for $1 only, $5 for $2 only,
# $6 for neither.
pair() {
    case "$1:$2" in
        yes:yes) echo "$3" ;;
        yes:no) echo "$4" ;;
        no:yes) echo "$5" ;;
        *) echo "$6" ;;
    esac
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
    stage7="$(cat "$work/$2"/progress*.md 2>/dev/null | perl -ne "$match7"'
        BEGIN { $id = shift @ARGV; $ok = "no" }
        my $m = stage7($_);
        $ok = "yes" if $m && (!defined $m->[0] || $m->[0] eq $id);
        END { print "$ok\n" }
    ' "$session" || true)"
    perl -CSDA -e '
        my ($reply, $stage7) = @ARGV;
        if ($stage7 eq "yes" && $reply =~ /accept|\x{41f}\x{440}\x{438}\x{43d}\x{44f}\x{442}\x{44c}/i) { print "final\n" }
        elsif ($reply =~ /\x{23f8}/) { print "short\n" }
        else { print "none\n" }
    ' "$result" "$stage7"
}

# Code 0 when a line of stdin names dups.py or a duplicate ("дубл") together with the word $1;
# with $2 "conflict" a conflict ("конфликт") counts too.
named() {
    perl -CSD -ne '
        BEGIN { $w = shift @ARGV; $c = shift @ARGV }
        $ok = 1 if (/dups\.py|duplicate|\x{434}\x{443}\x{431}\x{43b}/i
            || ($c && /conflict|\x{43a}\x{43e}\x{43d}\x{444}\x{43b}\x{438}\x{43a}\x{442}/i)) && index($_, $w) >= 0;
        END { exit !$ok }' "$1" "${2:-}"
}

# The reply text of the stage folder $1: the whole turn from its chat.md when there is one,
# otherwise .result of turns/01.json — its last message only; empty when there is neither.
reply() {
    if [ -f "$1/chat.md" ]; then
        cat "$1/chat.md"
    elif [ -f "$1/turns/01.json" ]; then
        jq -r '.result // ""' "$1/turns/01.json"
    fi
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
    readme=$(pair "$usage" "$version" both 'usage only' 'version only' neither)
    line 'readme' "$readme" 'both'
elif [ "$4" = b ]; then
    # Who did which slice: the last record "S<N> [<name>]:" of each slice in the progress log.
    split="$(cat "$work/pair"/progress*.md 2>/dev/null \
        | perl -ne '$who{$1} = $2 while /\bS(\d+) \[([^\]]+)\]:/g; END { print join(", ", map { "S$_ $who{$_}" } sort { $a <=> $b } keys %who) }' || true)"
    echo "split: ${split:-none}"
fi

# The edits of cases c and f: both return lines of app.js.
if [ "$4" = c ] || [ "$4" = f ]; then
    left=no
    right=no
    if grep -qF '  return "left panel, ready";' "$project/app.js" 2>/dev/null; then left=yes; fi
    if grep -qF '  return "right panel, ready";' "$project/app.js" 2>/dev/null; then right=yes; fi
    edits=$(pair "$left" "$right" both 'left only' 'right only' neither)
    line 'edits' "$edits" 'both'
fi

# Case d: both intentions on one line of app.js, and a reply paragraph naming the conflict
# together with app.js.
# The reply is in the user's language: "конфликт" counts as "conflict", written as escapes.
if [ "$4" = d ]; then
    label=neither
    if grep -F 'text: "Start"' "$project/app.js" 2>/dev/null | grep -F 'color: "gold"' >/dev/null; then
        label=both
    elif grep -qF 'text: "Start"' "$project/app.js" 2>/dev/null; then
        label='text only'
    elif grep -qF 'color: "gold"' "$project/app.js" 2>/dev/null; then
        label='color only'
    fi
    line 'label' "$label" 'both'
    named=no
    # A paragraph — lines between blank lines — of either reply holding both words counts.
    if { reply "${2%/}"; echo; reply "${3%/}"; } | perl -00 -CSD -ne '
        $ok = 1 if /conflict|\x{43a}\x{43e}\x{43d}\x{444}\x{43b}\x{438}\x{43a}\x{442}/i && /app\.js/;
        END { exit !$ok }'; then named=yes; fi
    line 'conflict named' "$named" 'yes'
fi

# Case e: the duplicate candidates named in a reply or a progress card — bonus_win as a
# duplicate or a merge conflict — and every candidate dups.py still lists named there too.
if [ "$4" = e ]; then
    text="$(reply "${2%/}"; reply "${3%/}"; cat "$work/shop"/progress*.md "$work/hud"/progress*.md 2>/dev/null || true)"
    reward=no
    bonus=no
    if printf '%s\n' "$text" | named formatReward; then reward=yes; fi
    if printf '%s\n' "$text" | named bonus_win conflict; then bonus=yes; fi
    dups=$(pair "$reward" "$bonus" yes 'formatReward only' 'bonus_win only' no)
    line 'dups named' "$dups" 'yes'
    # The names of the candidate lines "<kind>⇥<name>⇥<place>⇥<place>" not found in the text.
    missing=""
    found="$(cd "$project" && python3 -I "$project/.claude/skills/swork/scripts/dups.py" "$project" src/*.js resources.json 2>&1 || true)"
    while IFS="$(printf '\t')" read -r kind name rest; do
        [ -n "$rest" ] && [ -n "$name" ] || continue
        if ! printf '%s\n' "$text" | grep -F -- "$name" >/dev/null; then
            missing="${missing:+$missing, }$name"
        fi
    done <<EOF
$found
EOF
    if [ "${found##*$'\n'}" != 'dups: none' ] && ! printf '%s\n' "$found" | grep -E '^dups: [0-9]+ candidates$' >/dev/null; then
        missing="${missing:+$missing, }no dups line"
    fi
    left=named
    if [ -n "$missing" ]; then left="not named: $missing"; fi
    line 'dups left' "$left" 'named'
fi

# Case f: no worktree folder, and a reply line of each session naming the shared mode;
# the reply is in the user's language: "общ" (общий) counts as "shared", written as escapes.
if [ "$4" = f ]; then
    worktrees=none
    if [ -d "$project/.agents/wt" ]; then worktrees=present; fi
    line 'worktrees' "$worktrees" 'none'
    shared1=no
    shared2=no
    if reply "${2%/}" | perl -CSD -ne '$ok = 1 if /shared|\x{43e}\x{431}\x{449}/i; END { exit !$ok }'; then shared1=yes; fi
    if reply "${3%/}" | perl -CSD -ne '$ok = 1 if /shared|\x{43e}\x{431}\x{449}/i; END { exit !$ok }'; then shared2=yes; fi
    mode=$(pair "$shared1" "$shared2" shared 'session 1 only' 'session 2 only' neither)
    line 'mode named' "$mode" 'shared'
fi

# Case g: the left line of app.js and "new" in the submodule file lib/util.js; a "Progress log"
# record of left in the worktree mode and one of right naming the submodule slice.
if [ "$4" = g ]; then
    left=no
    right=no
    if grep -qF '  return "left panel, ready";' "$project/app.js" 2>/dev/null; then left=yes; fi
    if grep -qF '"new"' "$project/lib/util.js" 2>/dev/null; then right=yes; fi
    edits=$(pair "$left" "$right" both 'left only' 'right only' neither)
    line 'edits' "$edits" 'both'
    worktree=no
    if cat "$work/left"/progress*.md 2>/dev/null | grep -F 'mode: worktree' >/dev/null; then worktree=yes; fi
    line 'worktree used' "$worktree" 'yes'
    submodule=other
    if cat "$work/right"/progress*.md 2>/dev/null | grep -F 'inside submodule lib' >/dev/null; then submodule=shared; fi
    line 'submodule slice' "$submodule" 'shared'
fi

# Case h: no .agents/ before session 2, two agent ids in .agents/log.tsv, no mode file at the
# end, a reply line naming the mode off, and the edits of every slice in app.js. The reply is
# in the user's language: "режим" counts as "mode", "выключ" as "off", written as escapes.
if [ "$4" = h ]; then
    before="$(cat "$(dirname "${2%/}")/before.txt" 2>/dev/null || true)"
    line 'before switch' "${before#before switch: }" 'none'
    ids=0
    if [ -f "$project/.agents/log.tsv" ]; then
        ids=$(cut -f 2 "$project/.agents/log.tsv" | grep . | sort -u | wc -l | tr -d ' ')
    fi
    joined=no
    if [ "$ids" -ge 2 ]; then joined=yes; fi
    line 'joined' "$joined" 'yes'
    mode=off
    if [ -f "$project/.agents/mode" ]; then mode="$(head -1 "$project/.agents/mode")"; fi
    line 'mode at end' "$mode" 'off'
    named=no
    if { reply "${2%/}"; echo; reply "${3%/}"; } | perl -CSD -ne '
        $ok = 1 if /mode|\x{440}\x{435}\x{436}\x{438}\x{43c}/i && /off|\x{432}\x{44b}\x{43a}\x{43b}\x{44e}\x{447}/i;
        END { exit !$ok }'; then named=yes; fi
    line 'switch-off named' "$named" 'yes'
    left=yes
    right=yes
    for want in '  return "left panel, ready";' 'function left() { // left: checked'; do
        grep -qF "$want" "$project/app.js" 2>/dev/null || left=no
    done
    for want in '  return "right panel, ready";' 'function right() { // right: checked' '  // right panel: done'; do
        grep -qF "$want" "$project/app.js" 2>/dev/null || right=no
    done
    edits=$(pair "$left" "$right" both 'left only' 'right only' neither)
    line 'edits' "$edits" 'both'
fi

# Cases c, d and f: every wait of .agents/waits.tsv at most 30 s; no file — no wait.
if [ "$4" = c ] || [ "$4" = d ] || [ "$4" = f ]; then
    wait=ok
    if [ -f "$project/.agents/waits.tsv" ]; then
        most=$(awk -F '\t' '$7 + 0 > m { m = $7 + 0 } END { print m + 0 }' "$project/.agents/waits.tsv")
        if awk -v m="$most" 'BEGIN { exit !(m > 30) }'; then wait="$most s"; fi
    fi
    line 'max wait' "$wait" 'ok'
fi

line 'final' "$final" 'yes'
line 'claims' "$claims" 'none'

if [ $failed -eq 0 ]; then
    echo 'pair run: pass'
    exit 0
fi
echo 'pair run: fail'
exit 1
