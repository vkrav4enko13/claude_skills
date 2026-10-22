#!/bin/bash
# Money helpers of the scripts in bin/.
set -euo pipefail

# Prints an amount of cents $1 as units and cents: 105 → 1.05.
cents_to_str() {
    echo "$(($1 / 100)).$(($1 % 100))"
}
