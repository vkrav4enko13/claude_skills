# S10. swork: the worktree mode

> In the worktree mode `swork` works in its own worktree, claims only the slice card, syncs before each step, merges after a green step, rechecks the merged result, acts on duplicates, runs a slice inside a submodule in the shared mode; the wiki is written onto the current version.

- **Status:** done
- **Covers:** R16, R17, R18, R21, R22, R24, R26, R27, R28, R29, R33
- **Depends on:** S7, S8, S9, S13
- **Files:**
  - create: `swork/references/worktree.md`
  - change: `swork/SKILL.md` (the stage table or "Rules for all stages": in the worktree mode read `references/worktree.md`)
  - change: `swork/references/slices.md` (steps 1, 5 and "Decisions and bypass" — a pointer each)
  - change: `swork/references/entry.md` (continuation and join in the worktree mode)
  - change: `swork/references/small.md` (a small change in the worktree mode)
  - change: `swork/references/executor.md` (rule on the working folder)
  - change: `swork/references/finish.md` (final checks and checkpoints in the worktree)
  - change: `swork/references/report.md` ("Waited", accept, roll back everything)
  - change: `sbrain/references/agents-rules.md` (code 0 bullet: the current version; a section "Worktree")
  - change: `saway/SKILL.md` (the item on files outside the plan: a restore inside the agent's own worktree is allowed)
  - create: `tests/chain/worktree-scenarios.md`, `tests/chain/worktree-expected.tsv`
- **Interfaces:**
  - takes: from S7 — `agents.sh wt`, `sync`, `merge "<essence>" --base <snapshot>`, `drop`, codes 0, 4, 5, the lines `merged: <path>`, `conflict: <path>`, `shared: <reason>`; from S13 — `modes.md` "Mode" and "Shared mode", the records `mode: worktree <path>`, `mode: shared — <reason>`, the line `AGENTS=<path> TOPIC=<topic>`; from S8 — `.agents/waits.tsv` fields and `.agents/orphans/<id>.diff`; from S9 — `python3 -I <swork>/scripts/dups.py <root> <path>…`, its kinds and last line
  - gives: the section names of `worktree.md` — "Mode", "Before a step", "Executor and checks", "After a green step", "Conflicts, red merges and duplicates", "Submodule slice", "Bypass", "Stages and the end"; the "Progress log" records `mode: worktree <path>` and `S<N>: shared mode — inside submodule <path>`
- **Reuse:** the claim and wait text of `sbrain/references/agents-rules.md`; the check runner of `swork/references/snapshot.md:93` with `cd "$WT" &&` in front; the reverse-diff text of `swork/references/report.md:41`; `away-blind.sh` 4-argument form and the scenario form of `tests/chain/pair-scenarios.md`
- **What to do:** see part 2 — [plan-s10-swork-2.md](plan-s10-swork-2.md)
- **Checks:** lines 26, 27
