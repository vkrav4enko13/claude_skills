# Requirements of topic multi-agent, part 3

> R31–R36: the shared mode without a worktree, the choice of the mode, submodules, the multi-agent mode only on the user's request, and their acceptance.

## Shared mode

- R31. In the shared mode a `swork` agent edits files in the shared folder and claims a file only for the time of one write — claim, edit, `done` — never for a whole slice; the claim prints the diffs others logged since its last hold, by R7; after every step the duplicate script of R24 runs on the files the step changed. If the check of a step is red in a file that another live agent edited during the step, the agent reruns the check once after that agent's next `done`; a red that stays is its own, and the report names the rerun.

## Choice of the mode

- R32. While the multi-agent mode is on (R35), `.agents/mode` holds `auto`, `worktree` or `shared`: `auto` — the worktree mode where it is possible (git 2.40 or newer, the worktree is created), the shared mode otherwise; `worktree` or `shared` — the mode the user named in the request. The `swork` report names the mode used and why.
- R33. A repository with submodules works in the worktree mode: the submodule folders are cloned into the worktree and only read there; a slice whose "Files" lie inside a submodule runs in the shared mode.

## Only on request

- R35. The multi-agent mode — claims, worktrees, merges, the duplicate check, the wait log — works only while the project root holds `.agents/mode`. Without it `sbrain`, `splan`, `swork` and `saway` write as a single agent and write nothing into `.agents/`. The file is written when the user asks any of these skills to work with several agents; every skill checks it before each write, so a session already running joins. R1 and R13 hold only while the mode is on.
- R36. `.agents/mode` is removed at the user's request, or by an agent that ends its work when no live claim and no worktree of another agent remain; the report says so.

## Acceptance

- R34. A stand test: two agents in the shared mode edit different lines of one file and the second waits only the seconds of a write; `.agents/mode` with `shared` or `worktree` is obeyed; a stand repository with a submodule gets the worktree mode and a slice inside the submodule runs in the shared mode; a run without `.agents/mode` leaves no record in `.agents/`; after the user's request the file appears and a second session joins; the last agent removes it.
