# Technical decisions of topic multi-agent, part 2

> What the plan of the continuation chose, instead of what and why; which failures it checks beyond the named ones.

## Technical decisions

- **Four new `agents.sh` commands — `wt`, `sync`, `merge "<essence>"`, `drop` — and a wait log inside `wait`** — instead of a second script: one owner per rule, and the merge reuses the mutex, the claim records and the diff logging of `done`.
- **Code 5 "use the shared mode"** from `wt`, `sync`, `merge`, with one line `shared: <reason>` — the mode file says `shared`, no git, git older than 2.40, the root is not the git top level, `git worktree add` failed — and `agents: off` while the mode is off; instead of a text message: `swork` branches on the code. Submodules are no reason.
- **The merge writes only what `git diff-tree -r` names between the shared snapshot `S` and the merge result**, each file checked unchanged against `S` by `git hash-object` before the write — instead of writing the whole tree; deleted paths are deleted, new ones created, gitlinks skipped.
- **`merge` waits while another live agent claims a path it is about to write**, releasing the lock meanwhile — instead of a mode fixed per project: an agent in the shared mode or a submodule slice claims a file for its write.
- **The lock waits of `merge` and every `wait` go to `.agents/waits.tsv`** — the stand reads the length of "waiting for one merge" there.
- **`AGENTS_BEFORE_WRITE=<command>`**, run by `merge` once, between its first snapshot and its write, exists only for `tests/merge-test.sh` — R20 cannot be hit by timing.
- **Ignored files are cloned with `cp -cR`, a plain `cp -R` when the clone fails**, all ignored entries except `.agents/` and `.swork*` — measured 0.62 s for 43 MB, 2212 files; ignored files never enter a merge.
- **`swork/scripts/dups.py`** (not `sbrain/scripts/` as design §8 reads: only `swork` runs it, and `install.sh` puts `agents.sh` next to it there), run as `python3 -I`, prints `<kind>⇥<name>⇥<place>⇥<place>` lines and the last line `dups: none` or `dups: <n> candidates` — instead of a shell script: JSON with duplicate keys needs `object_pairs_hook`.
- **The worktree rules of `swork` go to a new `swork/references/worktree.md`**, read only in the worktree mode, like `snapshot-powershell.md` only on Windows — instead of growing `slices.md` (12.3k characters) and `snapshot.md`.
- **A slice merged and red twice is bypassed by reversing its own merge diffs** (`patch -R` of its `.agents/diffs/<n>.diff`, newest first, under the lock) — instead of a `base/` restore that wipes later merges of others.
- **A small change works in a worktree too**, its whole change one step — R16 names every `swork` agent.

## Check focus

- A repository with no commit yet, or with no `.git/index` → the snapshot is made without a parent and the worktree is created — S7, line 13
- A worktree already exists inside `.agents/wt/` when a new snapshot is taken → no embedded repository and no `.swork*` copy in the snapshot tree — S7, line 13
- The agent deletes a file, adds one and edits one whose name has a space → the merge deletes, creates and writes them in the shared folder — S7, line 15
- A path the merge would write is claimed by a live agent for a write → the merge waits for the release and writes after it — S7, line 20
- A changed file is binary, not UTF-8, or an invalid JSON → the duplicate script skips it with a note, no crash — S9, line 25
