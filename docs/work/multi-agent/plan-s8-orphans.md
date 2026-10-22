# S8. agents.sh: a dead agent's worktree and the wait log

> A dead agent's unmerged edit is saved and its worktree removed so its slice is free; every wait leaves a line with its length.

- **Status:** done
- **Covers:** R28, R29
- **Depends on:** S7
- **Files:**
  - change: `sbrain/scripts/agents.sh` (the `abandoned:` places of `claim` and `wait`, the end of `wait`, the lock wait of `merge`)
  - change: `tests/merge-test.sh` (created in S7: cases `orphan`, `waits`)
- **Interfaces:**
  - takes: from S7 — the worktree folder `.agents/wt/<id with - for :>`, `merge`, the helpers of `tests/merge-test.sh`
  - gives: `.agents/orphans/<id>.diff`; `.agents/waits.tsv` with the fields id, name, topic, files (space-separated), holder (name of the first busy owner, `-` if none), start (`now()` form), seconds, outcome (`free` | `abandoned` | `busy`); `merge` writes a line with files `.agents/lock` or the claimed paths it waited for, outcome `free`, only when it waited 1 s or more
- **Reuse:** the two `abandoned:` branches (`claim` agents.sh:350–352, `wait` :414–417), `now()` (:295), the `wait` loop (:403–432)
- **What to do:**
  1. In both `abandoned:` branches, before `drop_claims`: if `.agents/wt/<dead id with - for :>` exists, write `git -C <wt> diff HEAD` plus each untracked file of `git -C <wt> ls-files -o --exclude-standard` as `git -C <wt> diff --no-index /dev/null <file> || true` into `.agents/orphans/<dead id with - for :>.diff`, then `git -C "$ROOT" worktree remove --force <wt>`; print `orphan saved: .agents/orphans/<dead id with - for :>.diff`. Both run under the lock already held there.
  2. `wait`: remember the start; before `exit 0` and `exit 3` append one line to `waits.tsv` (take the lock for the append): outcome `abandoned` when any `abandoned:` was printed, else `free` or `busy`.
  3. `merge` (S7): measure the time from the first try to take the lock or the first claimed-path wait to the write; 1 s or more → one `waits.tsv` line.
  4. `wt` and `sync` also scan `.agents/wt/*`: a folder whose id is not `alive` is orphaned the same way — an agent that died between slices or ended with a short report holds no claim.
  5. Header: describe `orphans/` and `waits.tsv` fields.
- **Checks:** lines 21, 22
