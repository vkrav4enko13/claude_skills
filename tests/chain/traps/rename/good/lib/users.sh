#!/bin/bash
# User helpers of the scripts in bin/.
set -euo pipefail

# Prints the display_name of user number $2 (from 1) in the users file $1:
# the value of the user's display_name=… line.
display_name() {
    grep '^display_name=' "$1" | sed -n "${2}p" | cut -d= -f2-
}
