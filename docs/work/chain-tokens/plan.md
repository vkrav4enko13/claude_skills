# Plan of topic chain-tokens

> Plan header: goal, shared constraints, what we do not do, and the rule for the executor.

- **Goal:** the chain at effort `medium` with quality not worse, then fewer tokens per run
- **Requirements:** `requirements-gate.md`, `requirements-levers.md`, `requirements-proof.md` — R1–R29
- **Checked against code:** commit `1c4f384`, branch `main` — 2026-10-13
- **Execution:** slices in dependency order; the gate procedure and "Kept in place" are in `plan-2.md`; the discrepancy rule is at the end of this card

## Shared constraints

- Stand tools are bash with `jq`, `awk` and `perl`, no Python. The header of a script is as in `tests/chain/series.sh`: a usage comment, `export LC_ALL=C.UTF-8`, `set -euo pipefail`; the stands folder is `${CHAIN_BASE:-$HOME/Documents/my/chain-stand}`, below `$S`.
- The model is `claude-opus-5-5` everywhere; the judge and the blind reader stay at `--effort xhigh`.
- The four skills are edited only in this repository; nothing reaches the profiles before S12.
- An edit that shifts the lines of a skill file re-points the `file:line` tail of every rule in `tests/chain/rules.md` that points into that file to the present line of its sentence.
- Skill texts stay English; a new sentence follows the wording of its neighbours.
- A series takes an hour or more: start it in the background and wait for its end; one series at a time.
- A check line of a lever that `tests/chain/levers.tsv` marks `deferred` gets the result `not run: deferred by R11`.

## Not doing

- "Out of scope" of `scope.md` — as written there.
- `tests/chain/trigger.sh`, `judge.sh`, `judge-prompt.md`, `seed.sh`, `seeds.md` are not changed.
- The `effort` mode of `verdict.sh`, `seed_first_agent_effort` of `measure.sh` and the scripts in `~/Documents/my/chain-stand/analysis-2026-10-13/` stay as they are.

## If the code differs from the plan

Stop and report: **expected** — what the plan says; **found** — what is in the code, with the path;
**why it matters** — what fails to line up because of it. Do not silently bend the code to the plan or the plan to the code.
Report a minor discrepancy too (a file moved, a name changed, the meaning is the same): the slice card is fixed by `swork`, not by you.
