# Plan of topic multi-agent — part 2

> The continuation R16–R36: goal, constraints, what we do not do and the assumptions of slices S7–S14; part 1 holds for S1–S6 and its constraints stay in force.

- **Goal:** the multi-agent mode works only while `.agents/mode` exists; in it each `swork` agent edits its own worktree under git 2.40+ and merges it after a green step, or shares the folder and claims a file only for a write; a neighbour waits for a merge or a write, not for a slice; after every merge or step a script names duplicate candidates
- **Requirements:** [requirements-2.md](requirements-2.md) (R16–R30), [requirements-3.md](requirements-3.md) (R31–R36); design — [design-2.md](design-2.md), [design-3.md](design-3.md), [design-4.md](design-4.md)
- **Checked against code:** cda6856, branch main, 2026-10-21
- **Execution:** slices S7–S14 in dependency order, S12 first; S1–S6 are done and accepted; the discrepancy rule is at the end of [plan.md](plan.md)

## Shared constraints

- The constraints of part 1 hold: English texts and records, effort `medium`, one owner per rule (`sbrain/references/agents-rules.md`, `sbrain/scripts/agents.sh`), Bash 3.2 and BSD tools, stand outputs under `$CHAIN_BASE` (default `~/Documents/my/chain-stand`).
- Skills are edited only in this repository (`sbrain/`, `splan/`, `swork/`, `saway/`, `tests/`); `install.sh` copies `agents.sh`, `check.sh`, `agents-rules.md` and `wiki-rules.md` from `sbrain/` into `splan` and `swork`.
- Off by default: without `<root>/.agents/mode` no `agents.sh` command creates `.agents/` or writes into it; `.agents/mode` holds one word — `auto`, `worktree` or `shared`.
- The worktree mode needs git 2.40 or newer (`merge-tree --merge-base`, git's `RelNotes/2.40.0.adoc`); this Mac has git 2.56, `python3`, `jq` and `/usr/bin/rsync` (openrsync).
- A repository with submodules keeps the worktree mode: submodule folders are cloned into the worktree without their `.git` and only read; a slice whose "Files" lie inside a submodule runs in the shared mode.
- Code 5 of `wt`, `sync`, `merge` means "use the shared mode"; whole-file claims for a whole slice are no longer used.
- `mergiraf`, `ast-grep`, `jscpd` are not installed and are never installed by this work: code uses them only when `command -v` finds them; tests fake them with stub scripts on `PATH`.
- Nothing of the mode is written to the user's `.git/config`, `.gitattributes`, branches or refs; the only git file touched is `.git/info/exclude` (one line `.agents/`).
- `agents.sh` calls pass `--topic <name>` after the files.
- The game project `~/Documents/7rings/islx-gods-of-olimpus_front` is read-only for this work.

## Not doing

- Out of scope — [scope.md](scope.md).
- `install.sh --mac` and a commit — the user's choice after the report (line 41).
- The flaky `progress line` of the away check and the other part-1 leftovers in the root index "Deferred".
- No early `merge-tree` warning against the neighbours' worktrees before a step.
- No rewording of skill text that the slice does not name; `sbrain`, `splan` and `saway` texts change only where S10 and S13 name them.
- No worktree for a session that joins the mode mid-work, and no merge of edits made inside a submodule.

## Assumptions

- A `claude -p` stand session runs the whole `swork` turn as one process, so its worktree id stays the same for the run — slices: S11, S14
- The executor subagent obeys "run every command from the project root you were given" — nothing sets its working directory — slices: S10, S11
- Snapshot commits without a ref may be pruned by `git gc` after two weeks; a worktree keeps its own HEAD, which is enough — slices: S7
- A session's subagents share its agent id (one `claude` process), so the executor's per-write claims are the agent's own — slices: S13
