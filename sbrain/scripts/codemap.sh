#!/bin/bash
# Prints a short map of a project's code: the top-level names of each folder.
#
#   bash codemap.sh <project root>
#
# One line per folder, "<folder>: <name>, <name> …": bash functions, JS/TS
# functions, classes, variables and exports, Python functions and classes —
# the name patterns of swork/scripts/dups.py. Folders whose names other
# folders use go first, the most used first. Skipped: tests/, test/,
# __tests__/, node_modules/, dot-folders, vendored and generated folders.
# At most about 2000 characters; a cut map ends with "… <n> more".
# Code 0, an empty output when there is no code; code 1 on an error.
export LC_ALL=C
set -uo pipefail

usage() {
    echo "codemap: $1" >&2
    echo "usage: bash codemap.sh <project root>" >&2
    exit 1
}
[ $# -eq 1 ] || usage "need one project root"
root="${1%/}"
[ -d "$root" ] || usage "no folder $1"

SKIP='(^|/)(tests|test|__tests__|node_modules|vendor|vendors|third_party|dist|build|out|coverage|generated|__pycache__|\.[^/]*)/'
CODE='\.(sh|js|jsx|ts|tsx|py)$'

if git -C "$root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    files=$(git -C "$root" ls-files -co --exclude-standard) || usage "git ls-files failed in $root"
else
    files=$(cd "$root" && find . -type f | sed 's|^\./||') || usage "cannot list $root"
fi
files=$(printf '%s\n' "$files" | grep -E "$CODE" | grep -Ev "$SKIP" | sort)
[ -n "$files" ] || exit 0

printf '%s\n' "$files" | awk -v root="$root" '
    function folder(p) { return p ~ /\// ? substr(p, 1, match(p, /\/[^\/]*$/) - 1) : "." }
    function def(line, ext,    m) {
        if (ext == "sh") {
            if (match(line, /^[A-Za-z_][A-Za-z0-9_.:-]*[ \t]*\(\)[ \t]*\{/)) { m = substr(line, 1, RLENGTH); sub(/[ \t]*\(.*/, "", m); return m }
            return ""
        }
        if (ext == "py") {
            if (match(line, /^(def|class)[ \t]+[A-Za-z_][A-Za-z0-9_]*/)) { m = substr(line, 1, RLENGTH); sub(/^(def|class)[ \t]+/, "", m); return m }
            return ""
        }
        sub(/^export[ \t]+(default[ \t]+)?(async[ \t]+)?/, "", line)
        if (match(line, /^(function|class)[ \t]+[A-Za-z_$][A-Za-z0-9_$]*/)) { m = substr(line, 1, RLENGTH); sub(/^(function|class)[ \t]+/, "", m); return m }
        if (match(line, /^(const|let|var)[ \t]+[A-Za-z_$][A-Za-z0-9_$]*[ \t]*=/)) { m = substr(line, 1, RLENGTH); sub(/^(const|let|var)[ \t]+/, "", m); sub(/[ \t]*=$/, "", m); return m }
        return ""
    }
    { path[++nf] = $0 }
    END {
        for (i = 1; i <= nf; i++) {
            p = path[i]; d = folder(p); ext = p; sub(/.*\./, "", ext)
            if (!(d in seen)) { seen[d] = 1; order[++nd] = d }
            while ((getline line < (root "/" p)) > 0) {
                n = def(line, ext)
                if (n == "" || ((d, n) in has)) continue
                has[d, n] = 1
                names[d] = names[d] (names[d] == "" ? "" : ", ") n
                if (n in owner && owner[n] != d) owner[n] = ""
                else owner[n] = d
            }
            close(root "/" p)
        }
        for (i = 1; i <= nf; i++) {
            p = path[i]; d = folder(p)
            while ((getline line < (root "/" p)) > 0) {
                k = split(line, w, /[^A-Za-z0-9_$]+/)
                for (j = 1; j <= k; j++) {
                    o = (length(w[j]) >= 4 && w[j] in owner) ? owner[w[j]] : ""
                    if (o != "" && o != d && !((o, d) in uses)) { uses[o, d] = 1; used[o]++ }
                }
            }
            close(root "/" p)
        }
        for (i = 1; i <= nd; i++) if (names[order[i]] != "") printf "%d\t%s\t%s\n", used[order[i]] + 0, order[i], names[order[i]]
    }
' | sort -t $'\t' -k1,1nr -k2,2 | awk -F '\t' '
    {
        line = $2 ": " $3
        if (length(line) > 240) { line = substr(line, 1, 238); sub(/, [^,]*$/, "", line); line = line " …" }
        rows[++n] = line
    }
    END {
        total = 0
        for (i = 1; i <= n; i++) {
            if (total + length(rows[i]) + 1 > 1950) { left++; continue }
            print rows[i]
            total += length(rows[i]) + 1
        }
        if (left) print "… " left " more"
    }
' || exit 1
