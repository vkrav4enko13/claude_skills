#!/bin/bash
# The hidden check of the trap rename: no user_name is left in the project outside docs/,
# .claude/, .agents/ and .swork* — the chain's own records — tests/test_users.sh
# passes and bin/greet.sh still greets.
#
#   bash tests/chain/traps/rename/check.sh <project>
#
# One line "hidden rename: pass" and code 0, or "hidden rename: fail — <why>" and code 1.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: bash check.sh <project>" >&2
    exit 2
fi
P="$(cd "$1" && pwd)"

fail() {
    echo "hidden rename: fail — $1"
    exit 1
}

left=$(cd "$P" && grep -rl --exclude-dir=docs --exclude-dir=.git --exclude-dir=.claude --exclude-dir=.agents --exclude-dir='.swork*' user_name . || true)
[ -z "$left" ] || fail "user_name is left in $(printf '%s\n' "$left" | sed 's|^\./||' | tr '\n' ' ' | sed 's/ $//')"
[ -f "$P/tests/test_users.sh" ] || fail "tests/test_users.sh is missing"
if (cd "$P" && /bin/bash tests/test_users.sh > /dev/null 2>&1); then :; else
    fail "bash tests/test_users.sh exits with code $?"
fi
if out=$(cd "$P" && /bin/bash bin/greet.sh tests/fixtures/users.txt 1 2>&1); then :; else
    fail "bin/greet.sh tests/fixtures/users.txt 1 exits with code $?"
fi
[ "$out" = "Hello, Ann!" ] || fail "bin/greet.sh tests/fixtures/users.txt 1 prints \"$out\", expected \"Hello, Ann!\""
echo "hidden rename: pass"
