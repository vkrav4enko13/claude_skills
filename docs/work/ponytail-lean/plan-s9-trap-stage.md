# S9. Traps run on the stand and are measured

> A series can run every trap through `splan` and `swork` in its own box and records per run the delivered lines, the hidden check, the risky test, tokens, time, cost and compressed size; the candidate gets its hooks in the box.

- **Status:** done
- **Covers:** R20, R21, R23, R44
- **Depends on:** S7, S8
- **Files:**
  - change: `tests/chain/drive.sh` (usage and header, the argument guard `:37`, the stage `case` `:49-99`)
  - change: `tests/chain/collect.sh` (usage, the argument guard `:23`, the stage `case` `:31-41`, the work-stage done rule)
  - change: `tests/chain/series.sh` (usage, stage names `:69-74`, skills copy `:90-96`, the `stages` file loop `:98-103`, `lane()` `:117-189`, `run()` `:191-204`)
  - change: `tests/chain/stand.sh` (after the skills copy: the hooks)
  - create: `tests/chain/trap-measure.sh`
- **Interfaces:**
  - takes: `seed-trap.sh`, `traps/<name>/check.sh` (S8); the folder `hooks/` and its three settings entries (S7)
  - gives: stages `trap-<name>` (one trap) and `traps` (all five) for `series.sh --stages`; stage folders `<run>/trap-<name>-plan`, `<run>/trap-<name>-work`; the box `<run>/trapbox-<name>`
  - gives: `bash tests/chain/drive.sh <project> trap-plan|trap-work <stage folder> <level> <topic>`; `bash tests/chain/collect.sh <project> <stage> <stage folder> [<topic>]`
  - gives: `bash tests/chain/trap-measure.sh <run folder> <name>` → writes `<run folder>/trap-<name>.json` with the keys, in this order, `lines`, `hidden`, `risky_test`, `tokens_out`, `wall_s`, `cost_usd`, `gz_bytes`; S10 adds keys to the same file
- **Reuse:** the `pair` stage of `drive.sh:80-84` (a topic as the fifth argument); the token rule of `measure.sh:46-55` (last record per `requestId`); `stage_done` and `lane()` of `series.sh`
- **What to do:**
  1. `drive.sh`: `trap-plan` — phase `plan confirmed`, first `/splan <topic> — спланируй тему`, answer as `plan`; `trap-work` — phase `done`, first `/swork <topic> — исполни план`, answer as `work`. Both take the topic from the fifth argument and pass it to `collect.sh`.
  2. `collect.sh`: the two stages with the topic from the fourth argument; `trap-work` is done by the same rule as `work`.
  3. `series.sh`: `traps` expands to `trap-reuse trap-shared-bug trap-rename trap-traversal trap-native` before the stage check; a lane per trap after `pair`: fresh box by `stand.sh`, `seed-trap.sh`, a copy of the seeded project to `<box>/seeded/` (without `docs/`, `.claude/`, `.git/`, `.agents/` and `.swork*`), drive `trap-plan` then `trap-work`, then `trap-measure.sh` — a failed drive still measures. The lane is passed when both `trap-<name>-plan` and `trap-<name>-work` have `done` in `stage.json`. Trap stage names are not written into the `stages` file: `zero.sh` and `judge.sh` stay on the main stages.
  4. `series.sh` skills copy: also `cp -R "$src/hooks" "$S/skills/hooks"` when `$src/hooks` exists, and `codemap.sh` reaches `splan` through `stand.sh` (S1); `rules.md` from `$src/tests/chain/rules.md` when it exists, else `$here/rules.md`.
  5. `stand.sh`: when `$src/hooks` exists, copy it to `<project>/.claude/chain-hooks/` and write `<project>/.claude/settings.json` with the three entries of S7 pointing there (merge into an existing file with `jq`); no `hooks/` — write nothing.
  6. `trap-measure.sh`: `lines` — added lines from `git diff --no-index --numstat <box>/seeded <project>` outside `tests/`, `docs/`, `.claude/`, `.git/`, `.agents/` and `.swork*`; `gz_bytes` — `gzip -c` byte count of those added lines; `hidden` — `pass`/`fail` from `traps/<name>/check.sh <project>`; `risky_test` — `true` when a file under the project's `tests/` is new or changed; `tokens_out` — as `measure.sh` over both stage folders' `raw/`; `wall_s` — sum of `wall.txt`; `cost_usd` — per stage folder `.total_cost_usd` of its last `turns/*.json` (the field is cumulative), summed over the two stages.
- **Checks:** lines 36, 37
