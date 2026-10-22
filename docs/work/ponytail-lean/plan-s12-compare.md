# S12. Comparison of a baseline and a candidate series

> One command compares two series on every quality measure, the trap medians and ratios, tokens, time and cost, and prints whether the candidate is accepted.

- **Status:** done
- **Covers:** R24, R26, R45
- **Depends on:** S9, S10
- **Files:**
  - create: `tests/chain/compare.sh`, `tests/chain/compare-test.sh`
- **Interfaces:**
  - takes: `zero.sh`'s measures (stages, seeds, decisions, flaws, away, nonstop, pair) and `tally.sh`; `blind/key.tsv` and the verdicts of `judge.sh`; `<run>/trap-<name>.json` (S9, S10)
  - gives: `bash tests/chain/compare.sh [--only "<stages>"] <base series> <cand series>` and `bash tests/chain/compare.sh --map <series without map> <series with map>`; output lines below; code 0 on `accept: pass` / `map: keep`, 1 otherwise
- **Reuse:** `tests/chain/zero.sh` (the per-series counts), `tests/chain/tally.sh` (`tally_label`), `tests/chain/verdict-test.sh` (a throwaway `CHAIN_BASE` with fake series)
- **What to do:**
  1. Output, one line each, in this order: `violations: base <a> cand <b> (shared rules)`, `new rules: cand <n>`, `stages:`, `seeds:`, `decisions:`, `flaws:`, `away:`, `nonstop:`, `pair:` — each `base <x> cand <y>`; `trap runs: base <k>/15, cand <k>/15`; then per trap measure `<measure>: median base <x> cand <y> ratio <y/x>` for `hidden` (passes), `lines`, `gz_bytes`, `overeng`, `caught`, `tokens_out`, `wall_s`, `cost_usd` — medians over the runs of a task, the ratio the geometric mean of the per-task ratios — a task whose baseline median is 0 has the ratio `n/a` and is left out of the mean; acceptance compares the sums of per-task medians; `tokens: base <x> cand <y>`, `cost: base <x> cand <y>`, `wall: base <x> cand <y>` for the whole series, summed over every stage folder of every run — `tokens_out` by the rule of `measure.sh:46-55` over `raw/`, `wall_s` from `stage.json`, cost from the last `turns/*.json` of each stage; `speed: x<base wall / cand wall, two decimals>`; last `accept: pass` or `accept: fail — <the failing measures>`.
  2. Violations count only rule ids present in both series' `rules.md`; violations of ids only the candidate has go to `new rules:` and do not decide.
  3. Accepted when all hold: violations not more; stages, seeds, decisions, flaws, away, nonstop, pair not lower; trap hidden passes not lower; trap lines lower; overeng not higher; caught not lower; series wall and trap wall not higher. A fail named only by `wall` prints `accept: fail — wall (time only)`.
  4. `--only "<stages>"`: only the named stages are compared. `stages:` counts only the named stages in both series; violations and seeds only when a judged stage (`brain`, `plan`, `work`, `seed`, `away`) is named; decisions and flaws only when `survey` or `grill` is named; `away:`, `nonstop:`, `pair:` only when that stage is named; trap measures only when `traps` is named; `tokens:`, `cost:`, `wall:` summed over the named stages' folders only. Every other line prints `skipped`.
  5. `--map`: compares only the traps; `map: keep` when hidden passes and overeng are not worse and `tokens_out` of the map series is lower; else `map: drop`.
  6. `compare-test.sh` on fake series under a temp `CHAIN_BASE`: cases `pass`, `violations`, `hidden`, `lines`, `time`, `overeng`, `caught`, `new-rules` (the candidate's violations only on new ids → still pass, `new rules: cand 2`), `medians` (known numbers → known medians and ratio), `report` (the `tokens:`, `cost:`, `speed:` lines exist), `map`, `only` (a traps-only candidate against a full baseline with `--only traps` → pass), `zero-ratio` (a baseline median of 0 → `n/a`, no error); each `case <name>: ok`, last `compare test: all ok` or exit 1.
- **Checks:** lines 43–46
