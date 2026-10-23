# S12. The final series with the ponytail speed ideas

> One more "after" series measures R22 and R23 together with R6–R13 against "before".

- **Status:** bypassed
- **Covers:** R14, R15, R16, R17, R22, R23, goal
- **Depends on:** S11
- **Files:**
  - change: `docs/work/chain-speed/numbers.md` (`## After`, `## Outcome`)
- **Interfaces:**
  - takes: `cs-before` and `## Before` (S4); `cs-after-2` (S9) as the measure without R22, R23
- **Reuse:** the commands of line 16 with `cs-after-3`
- **What to do:**
  - `bash tests/chain/series.sh cs-after-3 "$PWD" --runs 2 --stages "$(cat tests/chain/cs-stages.txt)"`, `zero.sh cs-after-3`, the commands of line 16 against `cs-before` and against `cs-after-2`.
  - R15 against `cs-before` decides; `cs-after-2` shows what R22 and R23 add. This is the second and last extra series of R16: a quality fail reverts S11, then S10, by re-edit, without another series, and stops.
- **Checks:** line 23
