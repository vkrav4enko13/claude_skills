#!/bin/bash
# Checks the duplicate script swork/scripts/dups.py in temporary projects, one per case.
#
#   bash tests/dups-test.sh <case>|all
#
# Cases: base — one candidate of each kind (name, similar, key, value, resource), nothing for a
# clean file, "dups: none" for the clean file alone; tools — stub ast-grep and jscpd on PATH are
# called on the changed paths, without them "not installed: ast-grep, jscpd" once; odd — a PNG,
# a Latin-1 file and an invalid JSON each give a "skipped:" line, the rest still listed, code 0.
# Each case prints "dups <case>: ok", or "dups <case>: <what failed>" and code 1.
export LC_ALL=C.UTF-8
set -uo pipefail

D="$(cd "$(dirname "$0")/.." && pwd)/swork/scripts/dups.py"
PY=$(command -v python3)
TAB=$(printf '\t')
base="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
mkdir -p "$base"
T=$(mktemp -d "$base/dups-test.XXXXXX")
T=$(cd "$T" && pwd -P)
trap 'rm -rf "$T"' EXIT

# A PATH with git and the system tools only, so a real ast-grep or jscpd is never found.
mkdir -p "$T/bin"
ln -s "$(command -v git)" "$T/bin/git"
CLEAN_PATH="$T/bin:/usr/bin:/bin"

case_name=""
fail() {
    echo "dups $case_name: $1"
    if [ -n "${out:-}" ]; then printf '%s\n' "$out"; fi
    exit 1
}
proj() { # <name>: a fresh project folder, made the current folder
    P="$T/$1"
    mkdir -p "$P"
    cd "$P" || exit 1
}
run() { # <PATH> <changed path…>: output into $out, code into $code
    local path="$1"
    shift
    out=$(PATH="$path" "$PY" -I "$D" "$P" "$@" 2>&1)
    code=$?
}
has() { # <line>: the last output holds this exact line
    printf '%s\n' "$out" | grep -qxF -- "$1" || fail "no line \"$1\""
}
count() { # <ERE> <n>: the last output has n lines matching
    local n
    n=$(printf '%s\n' "$out" | grep -cE -- "$1")
    [ "$n" -eq "$2" ] || fail "$n lines match \"$1\", not $2"
}
last() { # <line>: the last output ends with this line
    [ "$(printf '%s\n' "$out" | tail -n 1)" = "$1" ] || fail "the last line is not \"$1\""
}

sources() { # the planted project of the base case
    mkdir -p src locale
    cat >src/utils.js <<'EOF'
function formatReward(amount) {
  return amount + " coins";
}
EOF
    cat >src/ui.js <<'EOF'
function formatReward(value) {
  return "+" + value;
}
document.title = formatReward(5);
EOF
    cat >src/a.js <<'EOF'
function sumScores(list) {
  let total = 0;
  for (const item of list) {
    total += item.score;
  }
  return total;
}
EOF
    cat >src/b.js <<'EOF'
function sumPoints(list) {
  let acc = 0;
  for (const row of list) {
    acc += row.score;
  }
  return acc;
}
EOF
    cat >resources.json <<'EOF'
{
  "bonus_win": "Win",
  "bonus_lose": "Lose",
  "bonus_win": "Big win"
}
EOF
    cat >locale/en.str <<'EOF'
bonus_win = Win
bonus_lose = Lose
bonus_win = Big win
EOF
    cat >assets.json <<'EOF'
{
  "images": [
    "img/coin.png",
    "img/star.png",
    "img/coin.png"
  ]
}
EOF
    cat >src/clean.js <<'EOF'
// Unrelated helper.
function parseMoon(phase) {
  if (phase > 4) {
    return "waning";
  }
  return "waxing";
}
EOF
}

base_case() {
    proj base
    git init -q .
    sources
    run "$CLEAN_PATH" src/ui.js src/a.js resources.json locale/en.str assets.json
    [ "$code" -eq 0 ] || fail "code $code"
    has "name${TAB}formatReward${TAB}src/ui.js:1${TAB}src/utils.js:1"
    has "similar${TAB}6 lines${TAB}src/a.js:2${TAB}src/b.js:2"
    has "key${TAB}bonus_win${TAB}resources.json:2${TAB}resources.json:4"
    has "value${TAB}bonus_win${TAB}locale/en.str:1${TAB}locale/en.str:3"
    has "resource${TAB}img/coin.png${TAB}assets.json:3${TAB}assets.json:5"
    count "^(name|similar|key|value|resource)$TAB" 5
    count "clean\.js" 0
    last "dups: 5 candidates"
    run "$CLEAN_PATH" src/clean.js
    [ "$code" -eq 0 ] || fail "clean alone: code $code"
    last "dups: none"
}

tools_case() {
    proj tools
    git init -q .
    sources
    mkdir -p "$T/stubs"
    cat >"$T/stubs/ast-grep" <<EOF
#!/bin/bash
echo "ast-grep \$*" >>"$T/calls.txt"
echo "[]"
EOF
    cat >"$T/stubs/jscpd" <<EOF
#!/bin/bash
echo "jscpd \$*" >>"$T/calls.txt"
EOF
    chmod +x "$T/stubs/ast-grep" "$T/stubs/jscpd"
    : >"$T/calls.txt"
    run "$T/stubs:$CLEAN_PATH" src/ui.js src/a.js
    [ "$code" -eq 0 ] || fail "with stubs: code $code"
    count "^not installed" 0
    for t in ast-grep jscpd; do
        for f in src/ui.js src/a.js; do
            grep -E "^$t .* $f( |$)" "$T/calls.txt" >/dev/null || fail "$t was not called on $f"
        done
    done
    run "$CLEAN_PATH" src/ui.js src/a.js
    [ "$code" -eq 0 ] || fail "without tools: code $code"
    count "^not installed" 1
    has "not installed: ast-grep, jscpd"
    has "name${TAB}formatReward${TAB}src/ui.js:1${TAB}src/utils.js:1"
    has "similar${TAB}6 lines${TAB}src/a.js:2${TAB}src/b.js:2"
}

odd_case() {
    proj odd
    sources
    printf '\211PNG\r\n\032\n\000\000\000\rIHDR' >img.png
    printf 'caf\351 cr\350me\n' >latin.txt
    printf '{"a": 1,}\n' >bad.json
    run "$CLEAN_PATH" img.png latin.txt bad.json src/ui.js
    [ "$code" -eq 0 ] || fail "code $code"
    count "^skipped: img\.png — binary$" 1
    count "^skipped: latin\.txt — not UTF-8$" 1
    count "^skipped: bad\.json — invalid JSON" 1
    has "name${TAB}formatReward${TAB}src/ui.js:1${TAB}src/utils.js:1"
    last "dups: 1 candidates"
}

CASES="base tools odd"
run_case() { # <case>
    case_name="$1"
    "${1}_case"
    echo "dups $1: ok"
}
want="${1:-}"
case " $CASES all " in
    *" $want "*) [ -n "$want" ] || want=x ;;
    *) want=x ;;
esac
if [ "$want" = x ]; then
    echo "usage: bash tests/dups-test.sh <case>|all — cases: $CASES" >&2
    exit 2
fi
if [ "$want" = all ]; then
    for c in $CASES; do run_case "$c"; done
else
    run_case "$want"
fi
