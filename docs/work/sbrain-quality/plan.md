# Plan of topic sbrain-quality

> Plan header: goal, shared constraints, what we do not do, and the rule for the executor.

- **Goal:** the survey and the grill of `sbrain` measured on the stand and fixed by the numbers
- **Requirements:** `requirements.md` — R1–R12
- **Checked against code:** commit `7795b3f`, branch `main` — 2026-10-14
- **Execution:** slices in dependency order; the discrepancy rule is at the end of this card

## Shared constraints

- Stand tools are bash with `jq`, `awk` and `perl`, headed as `tests/chain/series.sh`; the stands folder is `${CHAIN_BASE:-$HOME/Documents/my/chain-stand}`, below `$S`.
- The chain sessions run at `--effort medium`; the stand-in user and the judge at `xhigh`; the model is `claude-opus-5-5`.
- The existing stages `brain plan work seed away`, `judge-prompt.md`, `seeds.md`, the rule texts of `rules.md` and what `gate.sh` counts stay as they are — only the `file:line` tails move: the chain series of earlier topics must keep their meaning.
- Stand runs go one at a time; a series of three runs is started as `--runs 1`, then `2`, then `3`. A session-limit hit — in `.result` of any `turns/NN.json` or as `error` in `ended.txt` — is a stop, not a rerun.
- An edit that shifts the lines of a skill file re-points the `file:line` tails of `tests/chain/rules.md` and `tests/chain/rules-survey.md`.
- Nothing reaches the Mac profiles before S7.

## Not doing

- "Out of scope" of `scope.md`.
- The paths "Probe", "Small", "Non-software" of `sbrain`; the other three skills.

## If the code differs from the plan

Stop and report: **expected** — what the plan says; **found** — what is in the code, with the path;
**why it matters** — what fails to line up because of it. Do not silently bend the code to the plan or the plan to the code.
Report a minor discrepancy too (a file moved, a name changed, the meaning is the same): the slice card is fixed by `swork`, not by you.
