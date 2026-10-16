# Plan of topic multi-agent

> Plan header: goal, shared constraints, what we do not do, assumptions and the rule for the executor.

- **Goal:** several agents in one folder, waiting instead of asking
- **Requirements:** [requirements.md](requirements.md)
- **Checked against code:** 55bbe31, branch main, 2026-10-15
- **Execution:** slices in dependency order; the discrepancy rule is at the end of the card

## Shared constraints

- Skill texts, `agents.sh` messages and records are English; the chat lines `⏳ …` are shown in the user's language.
- The chain runs strictly at effort `medium`; stand runs too.
- One owner per rule: the claim rule is written in full only in `sbrain/references/agents-rules.md`; other texts refer to it by section. One script `sbrain/scripts/agents.sh`; no claim logic is copied into another script or text.
- `.agents/` lies in the project root, found as S2 step 1 says; every record in it is one tab-separated line.
- Every agent runs on this Mac: liveness is the process number plus its start time (`ps -o lstart=`).
- Bash 3.2 of macOS and BSD tools: no `flock`, no GNU-only flags; atomicity by `mkdir`.
- Exception: the blind reader of `away-blind.sh` runs at `xhigh` as it always did; it judges, it is not the chain.
- Stand outputs go under `$HOME/Documents/my/chain-stand/` or a stage folder, never into the repository or the shared `$TMPDIR`.

## Not doing

- Out of scope — [scope.md](scope.md).
- `install.sh --mac` and a commit: the user's choice after the report (check line 12).
- The `rm -rf` of a reviewer found on 2026-10-15 — the topic `quality-zero`.
- No rewording of skill text that the slice does not name.

## Assumptions

- `$CLAUDE_PID` names the `claude` process of the session — seen in an interactive session and in `claude -p` on 2026-10-15; a Codex session is found by climbing the parent chain to the first process whose name holds `codex` — untested, no Codex run on the stand — slices: S2
- A `claude -p` stand turn lives as one process for the whole turn, so a claim taken and released within one turn is checked correctly — slices: S1, S6

## If the code differs from the plan

Stop and report: **expected** — what the plan says; **found** — what is in the code, with the path;
**why it matters** — what fails to line up because of it. Do not silently bend the code to the plan or the plan to the code.
Report a minor discrepancy too (a file moved, a name changed, the meaning is the same): the slice card is fixed by `swork`, not by you.
