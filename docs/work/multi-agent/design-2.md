# Design of topic multi-agent, part 2

> Sections 5–7 of the continuation, approved without the user on 2026-10-21: what the user gets, the worktree of an agent and the merge.

## 5. What the user gets

Two or more `swork` agents edit one file — `GameView.js`, `resources.json` — at the same time: each in its own copy, merged into the shared folder after a green step. A neighbour waits only for one merge, seconds, instead of a whole slice run (43 minutes seen). Edits on different lines merge by themselves; on the same lines the agent that merges second resolves the conflict itself. After every merge a script names candidate duplicates, and the agent keeps one version. Without git, or with git older than 2.38, everything works as before: whole files in turn — R16–R30.

## 6. Worktree of an agent

**Snapshot.** A commit of the shared folder as it is, made without touching the user's index or branch: a temp index seeded from `.git/index` (only changed files are hashed again), `git add -A`, `git write-tree`, `git commit-tree`. It holds the uncommitted and untracked files; it skips the gitignored ones and `.agents/`. `git stash create` is not used: it drops untracked files.

**Creation.** At the agent's first slice: `git worktree add --detach .agents/wt/<id> <snapshot>`; `.agents/` is added once to `.git/info/exclude`, a local file never committed. The gitignored files the checks need — `node_modules`, `.env`, build output — are cloned with `cp -cR` (an APFS clone; a plain copy elsewhere), except `.agents/` and `.swork*/`. The detached HEAD of the worktree always holds the last sync snapshot: that is the merge base, and it keeps the commits from `git gc`.

**Sync before a step (R17).** A new snapshot of the shared folder and one of the worktree; `git merge-tree` of the two over the base; the result is written into the worktree and HEAD moves to the new shared snapshot. A conflict here goes the way of R21, before the step starts.

**The executor** gets the worktree path as the project root: nothing sets its working directory today (`swork/scripts/packet.sh` prints the root as text), so the packet names the absolute worktree path, and its paths and check commands run there.

**Stray edits (R18).** `git status` of the worktree against HEAD lists every change; a path outside the slice's "Files" is restored from HEAD inside the worktree. The user's and the neighbours' work in the shared folder is never touched.

## 7. Merge into the shared folder

One new command of `agents.sh`, `merge`, so the steps cannot be done in a wrong order:

1. Snapshot of the worktree `A`; no change against the base — nothing to merge.
2. Take `.agents/lock/` (the existing mutex); snapshot of the shared folder `S`.
3. `git merge-tree --write-tree --merge-base=<base> S A`, with `-c merge.conflictStyle=diff3` and `-c core.attributesFile=.agents/attributes`: `merge=union` for append-only files, `merge=mergiraf` for JS, TS and JSON when `mergiraf` is installed. Nothing in `.git/config` or `.gitattributes` changes.
4. Clean — for every path changed between `S` and the result: if its file in the folder no longer matches `S`, release the lock and start from 2 (R20); otherwise write it, log it with its diff (R23), take a copy into the `swork` snapshot's `base/` before its first write. Deleted paths are deleted the same way.
5. Release the lock; the worktree syncs to the result; the step check runs again (R22); the duplicate script runs (R24).
6. Conflict — release the lock, write the result with diff3 markers into the worktree, HEAD to `S`; the agent resolves, reruns the step check and merges again (R21).

Codes: 0 merged, 4 conflict — the paths are listed, 2 wrong arguments. The lock is held only for steps 2–4.
