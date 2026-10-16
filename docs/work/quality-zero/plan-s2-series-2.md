# S2. The series judges every stage — part 2

> The new lanes of `series.sh` and the summary `zero.sh`.

- **What to do (continued):**
  4. `series.sh`: allow the stages `away`, `nonstop`, `pair`; the default stages do not change. `run()` goes through every lane even after one is not passed, prints `run <N>: lane <name> not passed` for each, and still ends with code 1. New lanes, each after the existing four, in this order:
     - `away` — box `$R/awaybox`, `stand.sh`, `seed-away.sh`, `drive.sh … away "$R/away"`, then `away-check.sh` into `$R/away-check.txt`;
     - `nonstop` — box `$R/nonstopbox`, `stand.sh`, `seed-away.sh`, `drive.sh … seed "$R/nonstop"`, then `nonstop-check.sh` into `$R/nonstop-check.txt`;
     - `pair` — box `$R/pairbox`, `stand.sh`, `seed-pair.sh` with case `a` in run 1 and `b` in the others, two `drive.sh … pair` into `$R/pair1` and `$R/pair2` at the same time with the topics of `pair-run.sh:22-23` (case a: `usage` and `version`, case b: `pair` and `pair`), then `pair-check.sh` into `$R/pair-check.txt`. The lane is passed when both `pair1` and `pair2` are done; a rerun erases both.
     A check that fails does not end the run: the lane is passed when its stages are done; the check file holds the verdict. A lane whose stage did not finish is "not passed" as now.
  5. `zero.sh <series>`: no series folder — `zero: fail — no measurement`, code 1. Otherwise it runs `judge.sh <series>` first; then a run without its key lines or a label without a verdict, or `tally_label` failing — `zero: fail — no measurement`, code 1. Otherwise it prints:
     ```
     stages: <done>/<all>
     seeds: <found>/<5 × runs>
     violations: <n> (sbrain <n>, splan <n>, swork <n>, saway <n>, sv <n>)
     decisions: <n>/<5 × runs>
     flaws: <n>/<5 × runs>
     away: <passed>/<runs>
     nonstop: <passed>/<runs>
     pair: <passed>/<runs>
     judged: saway <n> rules
     zero: pass | zero: fail — <reasons>
     ```
     `runs` is the number of run folders. `<all>` is the number of named stages × runs, `pair` counted as 2 (10 per run for `<all stages>`); `<done>` — the stage folders with done in `stage.json`. Seeds come from the main labels, decisions and flaws from the `-survey` labels. `judged:` counts the `saway-` rule lines answered yes or no; every number comes from `tally_label`, the verdicts are not read a second time; `pass` — every stage done, every seed found, 0 violations, decisions and flaws at 5 × runs, every check file passed.
  6. Run line 6 once: it proves the lanes and the summary, not the thresholds.
