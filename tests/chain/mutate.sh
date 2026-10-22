#!/bin/bash
# Injected bugs of a trap run: how many of them the delivered tests catch.
#
#   bash tests/chain/mutate.sh <seeded folder> <project>
#
# Delivered are the files of <project> new or changed against <seeded folder>: the tests are
# those under tests/; the non-test files are those outside tests/, docs/, .claude/, .git/,
# .agents/ and .swork*, as in trap-measure.sh. Per delivered text file three sed mutants, each
# in a fresh temporary copy of the project; comment lines are left alone:
#   - the first comparison operator flipped: -lt/-ge, -gt/-le, -eq/-ne, </>=, >/<=, ==/!=,
#     an operator standing between blanks;
#   - the first "if <condition>; then" made "if true; then";
#   - the first integer literal plus one, not one of $0, &2 or 2>.
# A mutant that changes nothing is not counted. A mutant is caught when any test, run with
# bash from the copy's root, exits non-zero. Prints "caught <k>/<n>", or without tests
# "caught 0/<n> — no tests"; code 0.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "usage: bash mutate.sh <seeded folder> <project>" >&2
    exit 2
fi
B="$(cd "$1" && pwd)"
P="$(cd "$2" && pwd)"
CB="$HOME/Documents/my/chain-stand"
mkdir -p "$CB"
tmp=$(mktemp -d "$CB/mutate.XXXXXX")
trap 'rm -rf "$tmp"' EXIT

files=()
tests=()
while IFS= read -r -d '' f; do
    rel="${f#"$P"/}"
    case "$rel" in .swork*) continue ;; esac
    if [ -f "$B/$rel" ] && cmp -s "$B/$rel" "$f"; then continue; fi
    case "$rel" in
        tests/*) tests+=("$rel") ;;
        *) if grep -Iq . "$f"; then files+=("$rel"); fi ;;
    esac
done < <(find "$P" \( -path "$P/docs" -o -path "$P/.claude" -o -path "$P/.git" -o -path "$P/.agents" \) \
    -prune -o -type f -print0 | sort -z)

# The first match of the ERE $2 in the file $1 outside comment lines: "<line number> <match>".
first() {
    awk -v re="$2" '/^[[:space:]]*#/ { next } match($0, re) { print NR, substr($0, RSTART, RLENGTH); exit }' "$1"
}

# Writes into $2 the mutant number $3 (1, 2 or 3) of the file $1; code 1 when none applies.
mutant() {
    local src="$1" out="$2" hit n m op new v
    case "$3" in
        1)
            hit=$(first "$src" '[[:space:]](-lt|-ge|-gt|-le|-eq|-ne|<=|>=|==|!=|<|>)[[:space:]]')
            [ -n "$hit" ] || return 1
            n=${hit%% *}
            m=${hit#* }
            op=$(printf '%s' "$m" | tr -d '[:space:]')
            case "$op" in
                -lt) new=-ge ;; -ge) new=-lt ;; -gt) new=-le ;; -le) new=-gt ;;
                -eq) new=-ne ;; -ne) new=-eq ;; '<') new='>=' ;; '>=') new='<' ;;
                '>') new='<=' ;; '<=') new='>' ;; '==') new='!=' ;; '!=') new='==' ;;
            esac
            sed -E "${n}s/([[:space:]])${op}([[:space:]])/\\1${new}\\2/" "$src" > "$out"
            ;;
        2)
            hit=$(first "$src" '(^|[[:space:]])if[[:space:]].*;[[:space:]]*then')
            [ -n "$hit" ] || return 1
            n=${hit%% *}
            sed -E "${n}s/(^|[[:space:]])if[[:space:]].*;[[:space:]]*then/\\1if true; then/" "$src" > "$out"
            ;;
        3)
            hit=$(first "$src" '(^|[^$&[:alnum:]_.-])[0-9]+([^[:alnum:]_.>]|$)')
            [ -n "$hit" ] || return 1
            n=${hit%% *}
            v=$(printf '%s' "${hit#* }" | tr -cd '0-9')
            sed -E "${n}s/(^|[^\$&[:alnum:]_.-])${v}([^[:alnum:]_.>]|\$)/\\1$((10#$v + 1))\\2/" "$src" > "$out"
            ;;
    esac
    ! cmp -s "$src" "$out"
}

total=0
caught=0
for rel in ${files[@]+"${files[@]}"}; do
    for i in 1 2 3; do
        mutant "$P/$rel" "$tmp/mutant" "$i" || continue
        total=$((total + 1))
        [ ${#tests[@]} -gt 0 ] || continue
        c="$tmp/copy"
        rm -rf "$c"
        cp -R "$P" "$c"
        cp "$tmp/mutant" "$c/$rel"
        for t in "${tests[@]}"; do
            if ! (cd "$c" && bash "$t") > /dev/null 2>&1 < /dev/null; then
                caught=$((caught + 1))
                break
            fi
        done
    done
done

if [ ${#tests[@]} -eq 0 ]; then
    echo "caught 0/$total — no tests"
else
    echo "caught $caught/$total"
fi
