# Plan of topic quality-zero

> Plan header: goal, shared constraints, what we do not do, assumptions and the rule for the executor.

- **Goal:** the four skills pass one whole stand series with zero judge violations
- **Requirements:** [requirements.md](requirements.md) — R1–R22
- **Checked against code:** ee94340, branch main, 2026-10-16
- **Execution:** slices in dependency order; the discrepancy rule is at the end of the card

## Shared constraints

- Skill texts, script messages, rules and wiki records are English; chat to the user is in their language.
- The chain runs strictly at effort `medium`, stand runs too, the trigger probe of `trigger.sh` included. Exceptions as they always were: the judge (`judge.sh`), the blind reader of `away-blind.sh` and the stand-in user of `answer.sh` run at `xhigh` — they judge or play the user, they are not the chain.
- Errors of the model are reduced by editing skill texts, not by the effort and not by a script that does the model's step.
- Stand outputs go under `$HOME/Documents/my/chain-stand/` (`CHAIN_BASE`) or a stage folder, never into the repository or the shared system `$TMPDIR`.
- Bash 3.2 of macOS and BSD tools; no GNU-only flags.
- One owner per rule: a rule edited in a skill is written in full in one place; other places refer to it. A cited line in `tests/chain/rules.md` is moved with its source.
- The full stage list of a series is `brain plan work seed survey grill away nonstop pair` — written below as `<all stages>`.

## Not doing

- Out of scope — [scope.md](scope.md).
- The `agents.sh done --topic X "<essence>"` argument order bug.
- `verdict.sh quality` against the series of earlier topics: not used here.
- No rewording of skill text that the slice does not name; no change to `requests.tsv`, `gate.sh` or the default stages of `series.sh`.
- A commit: only at the user's request.

## Assumptions

- Three runs of a series at once, each with its own stand and its own `.agents/`, do not disturb each other's pair lanes — slices: S2, S8
- `nonstop` and `pair` runs are judged by their check scripts only, not by the judge — slices: S2, S8
- The plugin cache of the profile `~/claude/personal` is read by a `claude -p` session whose project `.claude/settings.json` has the profile's `enabledPlugins` — slices: S3
- R13 holds three of its four findings: the one of `saway/SKILL.md:73` at 1c4f384 (bypass lines on entry) is obsolete — that rule is no longer in `saway`, and `:85` already names the last part of `away.md`; needs the user's confirmation — slices: S5
- A series of all stages takes several hours — a run has seven lanes one after another; up to four series (smoke and three rounds) are acceptable — slices: S2, S8

## If the code differs from the plan

Stop and report: **expected** — what the plan says; **found** — what is in the code, with the path;
**why it matters** — what fails to line up because of it. Do not silently bend the code to the plan or the plan to the code.
Report a minor discrepancy too (a file moved, a name changed, the meaning is the same): the slice card is fixed by `swork`, not by you.
