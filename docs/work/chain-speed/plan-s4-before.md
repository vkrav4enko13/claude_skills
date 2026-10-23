# S4. The "before" series

> The current skills are measured once on the reduced stand, so the final has something to beat.

- **Status:** done
- **Covers:** R4
- **Depends on:** S1, S2, S3
- **Files:**
  - create: `docs/work/chain-speed/numbers.md`
  - change: `docs/work/chain-speed/00-index.md` (a line for `numbers.md`)
- **Interfaces:**
  - takes: `tests/chain/cs-stages.txt`, `count-check.sh`, `levers-check.sh` (S1, S2)
  - gives: `numbers.md` sections `## Sizes`, `## Before`, `## After`, `## Outcome`; series `cs-before`
- **Reuse:** `tests/chain/series.sh`, `tests/chain/zero.sh` (calls `judge.sh`), `tests/chain/compare.sh`
- **What to do:**
  - Copy `sbrain/ splan/ swork/ saway/` into `~/Documents/my/chain-stand/cs-snap/before/` (the base of the reverts of S9).
  - `## Sizes`: bytes of each skill now, by the command of line 14 (without `wiki-rules.md`, `wiki-block.md`, `wiki-migrate.md`).
  - `bash tests/chain/series.sh cs-before "$PWD" --runs 2 --stages "$(cat tests/chain/cs-stages.txt)"`, then `bash tests/chain/zero.sh cs-before` (its `fail` on `nonstop 0/2`, `pair 0/2` is expected), `levers-check.sh cs-before`, `count-check.sh` on both `count` runs.
  - `## Before`: per run — `wall:`, `tokens:` (output) and `cost:` of `compare.sh --only "$(cat tests/chain/cs-stages.txt)" cs-before cs-before` divided by 2, the violations of `zero.sh`, `count ok|wrong` per run (`$ST/cs-before/<run>/wiki-trial/clean`), the `levers-check` lines.
- **Checks:** line 11
