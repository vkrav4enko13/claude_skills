# Plan of topic saway-nonstop

> Plan header: goal, shared constraints, what we do not do, and the rule for the executor.

- **Goal:** `saway` sees the work through without stopping and writes to the user in Russian
- **Requirements:** [rights and going around](requirements-rights.md) — R1–R10; [what the user sees and the check](requirements-view.md) — R11–R18
- **Checked against code:** commit `529351c`, branch `main`, plus the uncommitted edits of S1–S5: `saway/SKILL.md` and `tests/chain/` — 2026-10-13
- **Execution:** slices in dependency order; the discrepancy rule is at the end of the card

## Shared constraints

- Of the skill texts only `saway/SKILL.md` is edited; `sbrain/`, `splan/` and `swork/` stay byte for byte as in commit `529351c`.
- `saway` stays one file, without `references/`, at most 6000 tokens by the counter of line 28. It rereads itself before every skill of the chain and before the full description: after a compaction the tail of a long skill may be cut. Over the limit — shorten its own wording, do not drop a rule.
- The skill text and everything in `tests/` is English: no Cyrillic letters in `saway/SKILL.md`; in `tests/chain/` Cyrillic only inside the Russian request of the stage `away`, as in the stages of `drive.sh`.
- These strings stay word for word in `saway/SKILL.md`: `Waiting for the user`, `user's choice after the report`, `saway: work finished`, `saway: work stopped — waiting for the user` — `tests/translate/map.tsv` pins them.
- Scripts are bash 3.2: write `${name}` before a non-ASCII character; set `LC_ALL=C` for `awk` comparisons; a command of a check line holds no ` | `.
- Stand folders: `$HOME/Documents/my/chain-stand/away/` — `before/`, `after/`, `blind-before/`, `blind-s3/`, `blind-s4/`, `blind-s5/`, `blind/`. A stand run never reuses a project folder. A run or a reading is made by a slice step and stored; the check lines read what is stored and do not repeat it. `accepted.txt` there names the accepted run folder: `after` or `after-2`.

## Not doing

- No layout into the profiles (`install.sh`): the stand takes the skills from the repository; the installed `saway` stays the old one until the user asks.
- No stage `away` in `series.sh`, `measure.sh`, `judge.sh`; no judge rules for `saway`.
- No change to the trigger description of `saway` and nothing about `lfg`.
- No commit. The rest is in [Scope](scope.md), section "Out of scope".

Assumptions, deferred questions and the discrepancy rule — in [part 2](plan-2.md).
