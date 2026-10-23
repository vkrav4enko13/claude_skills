#!/bin/bash
# Checks the count.sh of the count lane on fixed inputs.
#
#   bash tests/chain/count-check.sh <dir with count.sh>
#
# Copies <dir>/count.sh into a temporary folder and runs it there with bash,
# the working folder being that folder, beside an app.txt written for each
# input: 3 lines holding 6 words — wants "3"; an empty file — wants "0"; -v on
# the 3 lines — wants "3 слов". The output is compared whole, stderr ignored.
# All right — "count ok" and code 0; the first wrong input —
# "count wrong: <input> → <got>, want <want>" and code 1; no count.sh —
# "count wrong: no count.sh in <dir>" and code 1.
export LC_ALL=C.UTF-8
set -uo pipefail

if [ $# -ne 1 ]; then
    echo "usage: bash count-check.sh <dir with count.sh>" >&2
    exit 2
fi
if [ ! -f "$1/count.sh" ]; then
    echo "count wrong: no count.sh in $1"
    exit 1
fi
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
cp "$1/count.sh" "$T/count.sh"

# count.sh on the app.txt $2 with the arguments after it must print $1; the input is named $3.
expect() {
    local want="$1" text="$2" input="$3" got
    shift 3
    printf '%s' "$text" > "$T/app.txt"
    got=$(cd "$T" && bash ./count.sh "$@" < /dev/null 2> /dev/null)
    if [ "$got" != "$want" ]; then
        echo "count wrong: $input → ${got:-<nothing>}, want $want"
        exit 1
    fi
}

three=$'one two\nthree four\nfive six\n'
expect 3 "$three" '3 lines of 6 words'
expect 0 '' 'an empty file'
expect '3 слов' "$three" '-v on 3 lines' -v
echo 'count ok'
