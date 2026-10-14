# S4. The survey gate `survey-gate.sh`

> One command prints the three numbers of two series and says whether the second is not worse on all and better on one.

- **Status:** done
- **Covers:** R6
- **Depends on:** S3
- **Files:**
  - create: `tests/chain/survey-gate.sh`
- **Interfaces:**
  - gives: `bash tests/chain/survey-gate.sh <baseline> <series>` — lines `violations: <baseline> <n>, <series> <n>` (the `rule` lines with `no`), `decisions: <baseline> <n>/<5×runs>, <series> <n>/<5×runs>`, `flaws: …` the same, then `survey gate: passed` (code 0), `survey gate: not worse, not better` (code 1), `survey gate: failed — <worse numbers>` (code 1) or `survey gate: failed — no measurement` (code 1)
- **Reuse:** the key and verdict reading of `tests/chain/verdict.sh:53-76` (`tally`), adapted: it must not exit on a missing verdict
- **What to do:** a series without a key line or a verdict, or two series of different run counts — no number lines, only `survey gate: failed — no measurement`, code 1.
- **Checks:** lines 9, 10
