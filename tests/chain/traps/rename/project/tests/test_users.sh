#!/bin/bash
# Checks the user helpers of lib/users.sh on tests/fixtures/users.txt.
#
#   bash tests/test_users.sh
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
. "$here/lib/users.sh"
f="$here/tests/fixtures/users.txt"

[ "$(user_name "$f" 1)" = Ann ] || { echo "fail: user_name of user 1"; exit 1; }
[ "$(user_name "$f" 2)" = Bob ] || { echo "fail: user_name of user 2"; exit 1; }
echo "test_users: ok"
