#!/bin/bash
# Tells, without a model run, whether the skills still link, cite and contain what the stand needs.
#
#   bash tests/skills-check.sh [--root <dir>]
#
# <dir> holds sbrain/ splan/ swork/ saway/ and tests/chain/; by default the folder above this
# script. Reads the *.md files of the four skills and the rule lists tests/chain/rules.md and
# tests/chain/rules-survey.md. Four checks, one line per fault:
#   link: <file>: <target>          a relative ](…) outside backticks that does not resolve from its file
#   heading: <file>: <heading>      a cited heading missing from the file it names (a "#" heading or a
#                                   bold lead "**<Heading>.**" at a line start); the forms are
#                                   "<Heading>" of `<path>`, `<path>` `## <Heading>` and
#                                   section "<Heading>" with a `<path>.md` in the same sentence;
#                                   the path is taken from the skill root, then from the file's folder,
#                                   and a path found in neither is not checked
#   citation: <rule id>: <file>:<line>   the cited line and the lines around it share fewer than two
#                                   content words with the rule
#   literal: <string>               a string the stand greps is in none of the skills
# No fault — "skills ok" and code 0; any — code 1.
export LC_ALL=C.UTF-8
set -uo pipefail

R="$(cd "$(dirname "$0")/.." && pwd)"
if [ $# -eq 2 ] && [ "$1" = "--root" ]; then
    R="${2%/}"
elif [ $# -ne 0 ]; then
    echo "usage: bash skills-check.sh [--root <dir>]" >&2
    exit 2
fi
SKILLS="sbrain splan swork saway"
for s in $SKILLS; do
    if [ ! -d "$R/$s" ]; then
        echo "no skill $s in $R" >&2
        exit 2
    fi
done

bad=0
say() {
    printf '%s\n' "$1"
    bad=1
}

link_re='\[[^]]*\]\(([^)]*)\)'
scheme_re='^[A-Za-z][A-Za-z0-9+.-]*:'

# The link targets [text](target) of the line $1 — into the array targets, as in
# sbrain/scripts/check.sh: without a scheme, up to "#", code in backticks and fences skipped.
bt='`'
fence=0
links() {
    local rest="$1" m t
    targets=()
    case "${rest#"${rest%%[! ]*}"}" in
        "$bt$bt$bt"*)
            fence=$((1 - fence))
            return 0
            ;;
    esac
    if [ $fence -eq 1 ]; then return 0; fi
    while [[ $rest == *"$bt"*"$bt"* ]]; do
        rest=${rest%%"$bt"*}' '${rest#*"$bt"*"$bt"}
    done
    while [[ $rest =~ $link_re ]]; do
        m=${BASH_REMATCH[0]}
        t=${BASH_REMATCH[1]}
        rest=${rest#*"$m"}
        if [[ $t =~ $scheme_re ]]; then continue; fi
        t=${t%%#*}
        if [ -n "$t" ]; then targets+=("$t"); fi
    done
}

files=$(cd "$R" && find $SKILLS -type f -name '*.md' | sort)

while IFS= read -r file; do
    dir=$(dirname "$file")
    fence=0
    while IFS= read -r line || [ -n "$line" ]; do
        links "$line"
        if [ ${#targets[@]} -eq 0 ]; then continue; fi
        for t in "${targets[@]}"; do
            if [ ! -e "$R/$dir/$t" ]; then say "link: $file: $t"; fi
        done
    done < "$R/$file"
done <<< "$files"

# The heading citations of the files on stdin: "<file>\t<heading>\t<path>" per citation.
citations() {
    while IFS= read -r file; do
        awk -v file="$file" '
            function put(h, p) { if (p ~ /\.md$/) print file "\t" h "\t" p }
            /^ *```/ { fence = !fence; next }
            fence { next }
            {
                rest = $0
                while (match(rest, /"[^"]+" of `[^`]+`/)) {
                    m = substr(rest, RSTART, RLENGTH)
                    rest = substr(rest, RSTART + RLENGTH)
                    h = m; sub(/^"/, "", h); sub(/" of `.*$/, "", h)
                    p = m; sub(/^.*" of `/, "", p); sub(/`$/, "", p)
                    put(h, p)
                }
                rest = $0
                while (match(rest, /`[^`]+` `## [^`]+`/)) {
                    m = substr(rest, RSTART, RLENGTH)
                    rest = substr(rest, RSTART + RLENGTH)
                    p = m; sub(/^`/, "", p); sub(/` `## .*$/, "", p)
                    h = m; sub(/^.*` `## /, "", h); sub(/`$/, "", h)
                    put(h, p)
                }
                n = split($0, sents, /\. /)
                for (i = 1; i <= n; i++) {
                    s = sents[i]
                    while (match(s, /section "[^"]+"/)) {
                        h = substr(s, RSTART + 9, RLENGTH - 10)
                        before = substr(s, 1, RSTART - 1)
                        after = substr(s, RSTART + RLENGTH)
                        p = ""
                        b = before
                        while (match(b, /`[^`]+\.md`/)) {
                            p = substr(b, RSTART + 1, RLENGTH - 2)
                            b = substr(b, RSTART + RLENGTH)
                        }
                        if (p == "" && match(after, /`[^`]+\.md`/)) p = substr(after, RSTART + 1, RLENGTH - 2)
                        if (p != "") put(h, p)
                        s = after
                    }
                }
            }
        ' "$R/$file"
    done
}

while IFS=$'\t' read -r file heading path; do
    skill=${file%%/*}
    target=""
    if [ -f "$R/$skill/$path" ]; then
        target="$R/$skill/$path"
    elif [ -f "$R/$(dirname "$file")/$path" ]; then
        target="$R/$(dirname "$file")/$path"
    fi
    if [ -z "$target" ]; then continue; fi
    if ! awk -v h="$heading" '{ l = $0; if ((sub(/^#+ /, "", l) || sub(/^\*\*/, "", l) && sub(/\.\*\*.*$/, "", l)) && l == h) f = 1 } END { exit !f }' "$target"; then
        say "heading: $file: $heading"
    fi
done < <(citations <<< "$files" | sort -u)

# The stale citations of the rule lists: "<rule id>: <file>:<line>" per rule.
for list in "$R/tests/chain/rules.md" "$R/tests/chain/rules-survey.md"; do
    if [ ! -f "$list" ]; then
        say "citation: no rule list ${list#"$R/"}"
        continue
    fi
    while IFS= read -r stale; do say "citation: $stale"; done < <(awk -v root="$R" '
        BEGIN {
            n = split("the and are not for its has had was but can any all one two who how why yes you your our use via per that this with from into each every only after before what when which their they them there other same does been than then also have none word words line lines file files says said must first second", sw, " ")
            for (i = 1; i <= n; i++) stop[sw[i]] = 1
        }
        function words(text, set,    k, a, i, w) {
            text = tolower(text)
            gsub(/[^a-z]+/, " ", text)
            k = split(text, a, " ")
            for (i = 1; i <= k; i++) {
                w = a[i]
                if (length(w) < 3 || (w in stop)) continue
                if (length(w) > 4) sub(/s$/, "", w)
                set[w] = 1
            }
        }
        /^- [a-z]+-[0-9]+\. .* — [a-z]+\/[^ :]+:[0-9]+$/ {
            id = $2; sub(/\.$/, "", id)
            cite = $NF
            rule = $0; sub(/^- [a-z]+-[0-9]+\. /, "", rule); sub(/ — [^ ]+$/, "", rule)
            path = cite; sub(/:[0-9]+$/, "", path)
            num = cite; sub(/^.*:/, "", num); num += 0
            split("", rw); split("", lw)
            words(rule, rw)
            k = 0
            while ((getline l < (root "/" path)) > 0) {
                k++
                if (k >= num - 1 && k <= num + 1) words(l, lw)
            }
            close(root "/" path)
            shared = 0
            for (w in rw) if (w in lw) shared++
            if (shared < 2) print id ": " cite
        }
    ' "$list")
done

LITERALS=(
    'stage 7 finished'
    '- **Status:** not started'
    'done'
    'awaiting manual check'
    'S<N>: attempt'
    'saway: work finished'
    'saway: work stopped — waiting for the user'
    'Progress: slices'
    '- bypassed:'
    '## Waiting for the user'
    'execution in progress'
    "user's choice after the report"
    'Phase:**'
    'requirements confirmed'
    'plan confirmed'
    ' · '
    'stages 5–7 skipped: no code'
    'small code (one file'
    'in one batch before the report and before any stop'
    'whose files changed after their check'
    'no fresh reviewer: small plan'
    'several requirements that one command checks'
    'small work runs in this session'
    'mode: worktree'
    'inside submodule'
)
for s in "${LITERALS[@]}"; do
    if ! (cd "$R" && grep -rqF -- "$s" $SKILLS); then say "literal: $s"; fi
done

if [ $bad -eq 1 ]; then exit 1; fi
echo "skills ok"
