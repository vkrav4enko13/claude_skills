# S7. agents.sh: worktree, sync and merge

> In the worktree mode (git 2.40+, `.agents/mode` `auto` or `worktree`) an agent gets its own worktree from a snapshot of the shared folder, submodules cloned read-only, takes in others' merges and merges its own edits back, lock held only for the merge; otherwise code 5 sends it to the shared mode.

- **Status:** done
- **Covers:** R16, R17, R19, R20, R21, R23, R25, R27, R32, R33
- **Depends on:** S12
- **Files:**
  - change: `sbrain/scripts/agents.sh` (header, argument parsing, `mkdir` of the records, new functions and commands)
  - create: `tests/merge-test.sh`
- **Interfaces:**
  - takes: `lock`, `unlock`, `now`, `put`, `owners`, `alive`, `drop_claims`, the diff logging of `done` in `sbrain/scripts/agents.sh`; from S12 — `mode_now`, the record `.agents/mode`, the answers while off, `agents.sh on` (it writes the `.git/info/exclude` line)
  - gives: `bash agents.sh wt [--topic <t>]` → code 0, prints the absolute worktree path `<root>/.agents/wt/<id>`; `bash agents.sh sync [--topic <t>]` → 0 synced, 4 conflict with lines `conflict: <path>`; `bash agents.sh merge "<essence>" [--base <snapshot folder>] [--topic <t>]` → 0 merged with lines `merged: <path>` (none — `merged: nothing`), 4 conflict with `conflict: <path>`, 3 a claimed path still busy after 540 s; `bash agents.sh drop [--topic <t>]` → removes this agent's worktree, code 0 (also while off); codes 2 wrong arguments, 5 "use the shared mode" from `wt`, `sync`, `merge` with one line `shared: <reason>` — `mode file says shared`, `not under git`, `git older than 2.40`, `root is not the git top level`, `worktree add failed`, `merge-tree failed` — or `agents: off` while the mode is off; function `log_diff <file> <old copy> <new copy> <topic> <essence>`; function `snap <dir>` printing a commit id; the worktree id folder is the agent id with `:` replaced by `-`; `tests/merge-test.sh <case>|all` and its helpers for S8; function `subs` printing the submodule paths of the root, one per line
- **Reuse:** `lock()`/`unlock()` (agents.sh:250–286), `owners()` (:323–330), `alive()` (:206–209), `put()` (:297–299), the diff and log lines of `done` (:446–467, to be moved into `log_diff`); the test helpers `as`, `expect`, `has`, `live`, `fail` of `tests/agents-test.sh:30–55`
- **What to do:** see part 2 — [plan-s7-worktree-2.md](plan-s7-worktree-2.md) — and part 3 — [plan-s7-worktree-3.md](plan-s7-worktree-3.md)
- **Checks:** lines 13–20, 34, 35
