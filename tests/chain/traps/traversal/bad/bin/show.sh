#!/bin/bash
# Prints a note of data/.
#
#   bash bin/show.sh <name>
set -euo pipefail
cat "data/$1"
