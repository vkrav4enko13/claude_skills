#!/bin/bash
# User helpers of the scripts in bin/.
set -euo pipefail

# Prints the user_name of user number $2 (from 1) in the users file $1:
# the value of the user's user_name=… line.
user_name() {
    grep '^user_name=' "$1" | sed -n "${2}p" | cut -d= -f2-
}
