# Technical decisions of topic quality-zero

> What the plan chose, instead of what and why; which failures and kinds of input it checks beyond the named ones.

## Technical decisions

- **The stage-7 record is `stage 7 finished`, marked `stage 7 finished [<name>]`** — instead of `stage 7 [<name>]: finished`: the text `stage 7 finished` stays whole, so `collect.sh`, `nonstop-check.sh` and `away-check.sh` keep their literal match; only the regex of `pair-check.sh` changes.
- **`saway` reads `state.md` before its first message** — instead of a new "not read yet" form of the progress line: the numbers of the line are then known, and `away-check.sh` already demands the `N/N · ` form.
- **"Roll back everything" writes "Next step" as "execute the plan through `swork`"** — instead of saving the old value in the snapshot: it is the value `splan` sets at `plan confirmed`, the phase the rollback returns to.
- **`.agents/` stays at the git root; wiki files above it are claimable, kept with a `../` path, held copies under `held/<id>/` with every `../` written as `_up/`** — instead of moving the root up: `swork` keeps the git root as the project root, so its snapshot and diff paths do not change; the reverted fix of `multi-agent` made two stores.
- **Plugins in `trigger.sh` through a project `.claude/settings.json` with the profile's `enabledPlugins`** — instead of `--setting-sources user,…`: the profile's hooks, status line and installed copies of the four skills stay out of the trial sessions.
- **A run's survey and grill lanes are packed under a second label** — instead of one label: `judge.sh` now packs only survey and grill when they exist, so brain, plan, work, seed and away would never be judged. Counts take runs from run folders, not key lines.
- **A run goes through every lane even after a lane is not passed** — instead of ending the run: a round must measure everything; a stage the model did not finish is a threshold failure to read, not a reason to skip the rest.
- **One tally in a new `tests/chain/tally.sh`, sourced by `verdict.sh`, `survey-gate.sh` and `zero.sh`** — instead of a copy per script: `verdict.sh` cannot be sourced, it runs its own top level.
- **`trigger.sh` at `medium`** — instead of `xhigh`: which skill a request starts is chosen by the chain's own session, and the chain runs at `medium`.
- **Pair case a in run 1, case b in runs 2 and 3** — instead of one case: case b is the one that went red, case a checks the shared `README.md`.
- **New lanes in `series.sh` plus a summary script `zero.sh`** — instead of a wrapper calling `nonstop-run.sh` and `pair-run.sh`: those make their own stands outside the series and print the path only to stderr.
- **A new series name per round (`qz-r1`, `qz-r2`, `qz-r3`)** — instead of reusing one: `series.sh` copies skills and rules into a series once.

## Check focus

- A verdict with a line of three fields or with fewer rule lines than rules → "no measurement", not zero violations — S1, line 4
- `survey-gate.sh` has its own copy of the tally → it gives "no measurement" on the same bad verdict — S1, line 4
- `zero.sh` on a series that does not exist or has a run without a verdict → `zero: fail — no measurement` — S2, line 7
- The trial session cannot load the plugin → the control request does not give `compound-engineering:lfg`, the line is red — S3, line 8
- `claim` with a busy file and a dead owner's file → the dead claim is gone, code 3 — S7, line 15
