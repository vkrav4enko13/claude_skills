# Technical decisions of topic multi-agent, part 3

> What the plan chose for R31–R36 — the switch, the shared mode, submodules — instead of what and why; the failures it checks beyond the named ones.

## Technical decisions

- **`agents.sh` itself is the switch**: without `<root>/.agents/mode` `claim`, `wait`, `done`, `release` answer `agents: off` with code 0, `busy` finds nothing, and nothing is created — instead of a test of the file in four skills (design §12 "skip every call"): the claim call each skill already makes before a write is the check, so a session started before the switch joins at its next write.
- **`on [auto|worktree|shared]`, `off [--if-last]`, `mode`** in `agents.sh` — instead of the skills writing the file by hand: one writer adds the `.git/info/exclude` line, one remover tests the last agent.
- **`off --if-last` keeps the mode** while another live agent holds a claim, owns a worktree in `.agents/wt/`, or has claimed since the switch within the last 300 s (`seen/<id>.tsv` newer than `.agents/mode`) — instead of claims and worktrees alone: a shared-mode neighbour between two writes holds nothing. Only the `swork` report and the `saway` full description call it: a `saway` stage subagent shares its session's id, so a stage end is not the end of the work.
- **`swork` reads `agents.sh mode` before each slice**; a mode switched on mid-work gives the shared mode from the next slice — instead of a worktree started mid-work without a clean sync base.
- **The executor claims per write** when its message holds `AGENTS=<path> TOPIC=<topic>` (rule 11 of its task); the main session claims only the slice card — instead of the main session claiming the slice "Files", which R27 drops.
- **R31's "a file another live agent edited during the step"** is what `agents.sh others --since <snapshot>/agents/<id>/step` lists, the marker touched at the start of each step — instead of parsing check output for file names.
- **The duplicate script of the shared mode** runs on the paths of this agent's own `.agents/log.tsv` lines logged during the step — the files the step changed, with no other search.
- **Submodules** — `wt` clones each submodule folder with `cp -cR` and deletes the clone's `.git`; snapshots exclude the submodule paths; `sync` refreshes the clones with `/usr/bin/rsync -a --delete --exclude=.git`; instead of cloning `.git` too, whose relative `gitdir:` breaks git inside the worktree. Measured: 851 MB, 16 893 files clone in 2.8 s, refresh in 1.2 s.
- **`swork/references/modes.md`** holds the mode choice, the off mode, the shared mode and the switch — instead of growing `slices.md`; `worktree.md` of S10 starts where `modes.md` says "worktree".

## Check focus

- `.agents/` left from an earlier period of the mode, without `mode` → a claim and a `done` leave its records byte-equal — S12, line 33
- `on` twice with different words → the last word wins, the exclude line stays single — S12, line 33
- A neighbour active between two writes, with no claim and no worktree → `off --if-last` keeps the mode — S12, line 33
- A submodule whose `.git` is a file → the clone in the worktree has no `.git` and `git status` of the worktree is clean — S7, line 35
- A session started while the mode was off, the mode switched on mid-work → it claims from its next write — S14, line 40
