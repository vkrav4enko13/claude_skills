# S9. The final series

> One "after" series with all levers proves the saving and that quality did not drop, or names what to revert.

- **Status:** done
- **Covers:** R14, R15, R16, R17, goal
- **Depends on:** S8
- **Files:**
  - change: `docs/work/chain-speed/numbers.md` (`## After`, `## Outcome`)
- **Interfaces:**
  - takes: `cs-stages.txt`, `count-check.sh`, `pair-judge.sh`, `levers-check.sh` (S1, S2); `cs-before` and `## Before` (S4)
- **Reuse:** `tests/chain/series.sh`, `zero.sh`, `compare.sh`
- **What to do:**
  - `bash tests/chain/series.sh cs-after "$PWD" --runs 2 --stages "$(cat tests/chain/cs-stages.txt)"`, `zero.sh cs-after`, then the commands of line 16; `## After` in the same form as `## Before`.
  - R15 all hold → `## Outcome`: `accepted` with the numbers.
  - Quality fails → revert in the order R13 (S8), R8, R9, then the rest, one at a time: re-edit the slimmed text back to the behaviour of `~/Documents/my/chain-stand/cs-snap/before/` for that lever, then `skills-check`; after each revert one series `cs-after-2`, then `cs-after-3`; still failing → `stopped`, the numbers shown to the user (R16).
  - Quality holds, saving under 20 % → `threshold not met` with the number; the edits stay (R17).
- **Checks:** lines 16, 17
