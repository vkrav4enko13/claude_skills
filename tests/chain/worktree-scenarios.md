# Scenarios of the worktree mode

In every scenario several sessions of `swork` work in one git project, `.agents/mode` holds `auto`, git is 2.56 unless the scenario says otherwise. The user is busy and does not answer. Each scenario ends with one question and three answers; exactly one answer is what the agent does.

## W1

The agent works in the worktree mode, its worktree is `WT`. The executor of its slice S2 is running.
Meanwhile another agent finishes its step and its `agents.sh merge` writes `lib.sh` into the shared folder.

What does the agent do about the merged `lib.sh`?

- a) It runs `agents.sh sync` at once, so that the executor works on the newest `lib.sh`.
- b) Nothing in the middle of the step; it takes the change with `agents.sh sync` before its next step.
- c) It stops the executor and claims `lib.sh`, so that the other agent cannot merge it again.

## W2

The agent works in the worktree mode and picks slice S5; its "Files" are `app.sh`.
Another agent is editing `app.sh` in its own worktree for its slice S4; nobody holds a claim on `app.sh`, the card of S5 is free.

What does the agent do before step 1 of S5?

- a) It claims the card of S5 alone and goes on with the slice.
- b) It waits until the other agent merges `app.sh`, then claims the card of S5.
- c) It claims `app.sh` and the card of S5 in one `claim`.

## W3

The agent works in the worktree mode. After the executor of S3, `git -C "$WT" status --porcelain` lists ` M README.md`; `README.md` is not in the "Files" of S3, and the executor did not name it.

What does the agent do with `README.md`?

- a) It writes the path into `known.txt` and leaves the file as it is.
- b) It restores `README.md` in the shared folder from `base/` of the snapshot.
- c) It runs `git -C "$WT" checkout HEAD -- README.md`, inside its worktree only.

## W4

The step of S2 is green in the worktree. `agents.sh merge "S2: …" --base <snapshot> --topic report` exits with code 4 and prints `conflict: lib.sh`.

What does the agent do?

- a) It ends the turn with a question to the user: whose edit of `lib.sh` to keep.
- b) It opens `lib.sh` in its worktree, keeps the other agent's edit as merged and applies its own edit onto it, reruns the step check and merges again; the report names `lib.sh`.
- c) It replaces `lib.sh` with its own version from before the sync and merges again.

## W5

`agents.sh merge` of the step of S3 exits with code 0 and prints `merged: app.sh`. The agent reruns the step check in its worktree on the merged result: it is red.

What does the agent do?

- a) It restores `app.sh` in the shared folder from `base/` of the snapshot.
- b) It sets S3 to `bypassed` at once: a merged step must not be red.
- c) It fixes the failure in its worktree, merges again, and the report names the fix.

## W6

After a merge of S4 the agent runs `dups.py` on the `merged:` paths. It prints two candidates:

- `fmt_date` is defined in `lib/dates.sh`, which is already in the shared folder, and in `lib/report.sh`, which S4 wrote; both do the same;
- `usage` is defined in `bin/a.sh` and in `bin/b.sh`, two separate scripts each printing its own usage text — the agent judges it false.

What does the agent do?

- a) It keeps `fmt_date` of `lib/dates.sh`, removes its own one, reroutes its calls to the kept one, reruns the check and merges; the `usage` candidate is a line in the report.
- b) It keeps both `fmt_date` definitions and removes `usage` from `bin/b.sh`.
- c) It removes `fmt_date` from `lib/dates.sh`, keeps its own one and merges.

## W7

The main session of the agent adds its line to the journal of the wiki. `claim` on the journal file exits with code 0 and prints a diff: since the agent read the file, another agent added a line at its end.

What does the agent write?

- a) The file as it read it earlier plus its own line at the end.
- b) Its own line into the current file, keeping the other agent's line.
- c) Nothing: it waits until the other agent releases the journal for good.

## W8

`agents.sh mode` prints `auto`. Before the first slice `agents.sh wt --topic report` exits with code 5 and prints `shared: git older than 2.40`.

How does the agent go on?

- a) It ends the turn with a question to the user: update git or not.
- b) In the shared mode by `modes.md`, with the record `mode: shared — git older than 2.40`.
- c) As a single agent without claims, with the record `mode: off`.

## W9

Slice S3 of the agent merged twice into the shared folder: `.agents/log.tsv` holds its lines with the essence `S3: …`. The merged check of S3 stays red after both attempts and both card edits: S3 becomes `bypassed`. Later merges of other agents touched the same files.

What happens to the files of S3?

- a) They are restored in the shared folder from `base/` of the snapshot.
- b) The agent runs `git -C "$WT" checkout HEAD -- <its paths>` in its worktree only.
- c) The agent claims the merged files and reverses the diffs of its own `S3:` lines, newest first, with `patch -R` on a copy, then `done`.

## W10

The agent waited twice during the work: once for a slice card, once inside `merge` for the lock. It writes the "Waited" section of its report.

Where does it take the files, the holder and the length of each wait from?

- a) From its `⏳` lines in the chat, the lengths estimated from them.
- b) From the lines of this agent in `.agents/waits.tsv`.
- c) Nowhere: the waits ended by themselves, so the section is left out.

## W11

The agent works in the worktree mode with the worktree `/p/.agents/wt/4242-1761`. It starts the executor of S2 with the packet made by `packet.sh`.

Where does the executor run the commands of its check lines?

- a) In the project root given in the packet — the worktree `/p/.agents/wt/4242-1761`.
- b) In the shared folder `/p`, where the other agents see the result.
- c) In the snapshot folder `.swork/` of the topic.

## W12

A session of `swork` died in the middle of S4 in the worktree mode. A new session continues the topic and claims the card of S4; the claim prints `abandoned: docs/work/report/plan-s4-export.md by old-session` and `orphan saved: .agents/orphans/3131-1760.diff`.

What does the new session do with S4?

- a) It applies the orphan diff to the shared folder and marks S4 `done`.
- b) It ends the turn with a question to the user: apply the orphan diff or not.
- c) It names the orphan diff in the report and redoes S4 from the shared folder.

## W13

The project has a submodule at `lib/`: `git -C <root> submodule status` prints ` 3f2a… lib (v1.2)`. The agent works in the worktree mode and picks S6, whose "Files" are `lib/parse.c`.

How does the agent run S6?

- a) In its worktree as usual, then `agents.sh merge` writes `lib/parse.c` into the shared folder.
- b) In the shared mode for that slice: the packet gets the shared folder as the root, the checks run there, there is no merge, and the next `sync` refreshes the clone of `lib/` in the worktree.
- c) It sets S6 to `bypassed`: edits inside a submodule are out of scope.
