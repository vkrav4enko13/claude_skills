# Plan of topic ponytail-lean

> Plan header: goal, shared constraints, what we do not do, and the rule for the executor.

- **Goal:** the chain writes less superfluous code from the start, with ponytail ideas taken through a clean room, at quality not worse on the stand
- **Requirements:** [requirements.md](requirements.md), [requirements-2.md](requirements-2.md), [requirements-3.md](requirements-3.md); [design.md](design.md), [decisions.md](decisions.md), [scope.md](scope.md)
- **Checked against code:** cda6856, branch main; the skill folders, `install.sh` and `tests/` have no uncommitted changes
- **Execution:** slices in dependency order; the discrepancy rule is at the end of the card

## Shared constraints

- Skill texts, stand files, cards and subagent tasks are in English; only the answers to the user are in Russian.
- The only source of ponytail ideas is [ideas.md](ideas.md): the ponytail source is not read, fetched or quoted by any executor — only the clean-room checker of S13 step 9 reads it, and it writes nothing; no wording from it goes into a skill or stand file.
- Scripts are bash run by `/bin/bash` 3.2 on macOS, with `export LC_ALL=C.UTF-8` and `set -euo pipefail` like their neighbours; coreutils `timeout` does not exist on this Mac.
- Every chain subagent and every stand session of the chain runs at effort `medium`; the existing main judge keeps `xhigh`.
- Stand outputs go under `CB` = `"$HOME/Documents/my/chain-stand"`, outside the project; temporary folders are made with `mktemp -d "$CB/<name>.XXXXXX"`.
- A skill file cited by `tests/chain/rules.md` that a slice edits gets its citations moved to the current lines in S11.
- `sbrain` and `saway` get only the closing lines and the full-explanation rule (S6).
- A phrase that a check line looks for with `grep -F` stays on one line of its file: do not wrap it.

## Not doing

- No Russian copies of the skills and no rows in `tests/translate/map.tsv` for the new reply fields.
- No hooks for Codex and no hooks on the Windows PC; `install.sh` keeps copying skills to the PC as now.
- No change of the existing judge's stages, rule sections or effort beyond the new rules of S11.
- No shortening of skill texts for tokens; no rewording of rules this plan does not name.
- Out of scope of the topic — [scope.md](scope.md).

## Assumptions

- The stand runs `claude -p` with `--setting-sources project,local`: hooks of the user profiles do not reach stand runs, so the candidate gets its hooks only through the box project's `.claude/settings.json` — slices: S7, S9, S13
- `total_cost_usd` of a `claude -p` turn covers its subagents and, like `duration_api_ms` (`tests/chain/collect.sh:14`), is cumulative over the resumed session: the cost of a stage is the value of its last turn — slices: S9, S12
- Claude Code 2.1.302 hook events: `SessionStart` with sources `startup`, `resume`, `clear`, `compact`; `SubagentStart` takes JSON `hookSpecificOutput.additionalContext`; `UserPromptSubmit` stdout is added to the prompt; only exit code 2 blocks — slices: S7
- `UserPromptSubmit` fires on the user's prompts only: turns started by `/goal` or by a background result get no language line — slices: S7

## Deferred questions

- none

## If the code differs from the plan

Stop and report: **expected** — what the plan says; **found** — what is in the code, with the path;
**why it matters** — what fails to line up because of it. Do not silently bend the code to the plan or the plan to the code.
Report a minor discrepancy too (a file moved, a name changed, the meaning is the same): the slice card is fixed by `swork`, not by you.
