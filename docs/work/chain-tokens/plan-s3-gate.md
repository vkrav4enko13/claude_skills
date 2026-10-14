# S3. Quality gate tool `gate.sh`

> One command says whether a series passed the quality gate, and why not.

- **Status:** done
- **Covers:** R6
- **Depends on:** none
- **Files:**
  - create: `tests/chain/gate.sh`
- **Interfaces:**
  - gives: `bash tests/chain/gate.sh <reference series> <series> [--group <group>]`. It prints `stages: <done>/<all>`, `seeds: <found>/<5 × runs>`, the line of `verdict.sh quality`, and a last line: `gate: passed` with code 0; `gate: failed — <reasons>` with code 1, the reasons joined by `, ` from `stages <done>/<all>`, `seeds <found>/<5 × runs>`, `violations more`, `no measurement`; `gate: skipped — no lever taken in <group>` with code 0.
  - takes: `tests/chain/levers.tsv` in the form S5 gives — tab-separated, a header row, the group in column 2, the verdict in column 6
- **Reuse:** `bash tests/chain/verdict.sh quality <reference> <series>` — its line and its exit code; `bash tests/chain/verdict.sh seeds <series> <series>` — the number after `after ` in its line `seeds found: before <n>, after <n> — not less`; either prints `no measurement: …` with code 1 when a key, a verdict or a run is missing
- **What to do:**
  - `<all>` is 4 × the number of run folders `$S/<series>/[0-9]*`; `<done>` is the number of files `brain|plan|work|seed/stage.json` in them with `done` true.
  - The gate is passed when `<done>` equals `<all>`, `<found>` equals 5 × runs, and `verdict.sh quality` ends with code 0. A `no measurement` answer of either `verdict.sh` call gives the reason `no measurement` and the line `seeds: 0/<5 × runs>`.
  - With `--group`: when no row of that group in `levers.tsv` has the verdict `taken`, print the `skipped` line and end before the series is looked at. No `levers.tsv` — `gate: failed — no levers.tsv` and code 1.
  - A wrong number of arguments — the usage line and code 2.
- **Checks:** lines 8, 9, 10, 11
