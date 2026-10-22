# S7. agents.sh: worktree, sync and merge — part 3

> What to do in S7, items 8–10: `drop`, the test and the part-1 test.

## What to do

8. **`drop`** — `git worktree remove --force .agents/wt/<id>`; no worktree — code 0, nothing printed.
9. **`tests/merge-test.sh`** — `fail` prints `merge <case>: …`; line 19's subfolder root is set with `AGENTS_ROOT`; — `set -uo pipefail`, a project per case under `${CHAIN_BASE:-$HOME/Documents/my/chain-stand}/merge-test.XXXXXX` removed by a trap; helpers copied from `tests/agents-test.sh:30–55`; each case runs `agents.sh on` in its project first, except the off part of `mode`; one function per case of lines 13–20, 34 and 35 named as the case (`mode`, `submodule`); `all` runs every case; each prints `merge <case>: ok` or `merge <case>: <what failed>` and exits 1. The stub `mergiraf` of line 18 records its call, then runs `git merge-file "$4" "$3" "$5"` — its arguments are `merge --git %O %A %B …`, so this is `%A %O %B` — and exits with its code. The stub `git` for line 19 is a script on a temp `PATH` that prints `git version 2.39.0` for `--version` and `exec`s the real git otherwise. The submodule of line 35 is a local repository added with `git -c protocol.file.allow=always submodule add`.
10. Keep `bash tests/agents-test.sh` green: `done` must log exactly as before after the move into `log_diff`.
