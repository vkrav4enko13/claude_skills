# Worktree mode

Read where `references/modes.md`, "Mode", says `auto` or `worktree`; read only in this mode. Its rules replace those of `references/slices.md`, `references/snapshot.md` and `references/finish.md` where they name the same thing. The claim rule itself and how `agents.sh` is called are in `references/agents-rules.md`; `<t>` is the name of the topic folder, `<root>` the shared project folder.

## Mode

- Run `agents.sh wt --topic <t>`.
  - **Code 0** — the worktree mode: the path it prints last is `WT`; record `mode: worktree <path>` in "Progress log".
  - **Code 5** — the shared mode by `references/modes.md`, "Shared mode": its line `shared: <reason>` goes into the record `mode: shared — <reason>`, and the report names that reason.
- The mode holds for the whole work of this agent. A later code 5 from `sync` or `merge` switches it to the shared mode for the rest of the work: the record `mode: shared — <reason>` and a report line.

## Before a step

A step is a slice, a fix after a red check or a finding, and each of stages 5–7.

- Before the step starts — `agents.sh sync --topic <t>`. Never in the middle of a step: the step works on a stable tree.
- **Code 4** — resolve each `conflict:` path as in "Conflicts, red merges and duplicates" before the step starts.
- **Claims.** Claim only the slice card, and `<topic folder>/.stage` for stages 5–7, by `references/agents-rules.md`; never the slice "Files": another agent edits them in its own worktree, and the merge settles it.

## Executor and checks

- `packet.sh` gets `WT` as the project root: `bash <skill folder>/scripts/packet.sh <topic folder> <N> "$WT" …`. The executor runs its commands and edits only under that root.
- **Every check command** runs as `cd "$WT" && <command>`, by the runner of `references/snapshot.md`:

```bash
cd "$WT" && bash -o pipefail -c "$CMD" > "$SNAP/checks/$N.txt" 2>&1; echo "code: $?"; tail -n 40 "$SNAP/checks/$N.txt"
```

- The `cd` that the intro of a check card puts in front of its commands is replaced by `WT`.
- **Edits outside the plan** — `git -C "$WT" status --porcelain` minus the slice "Files". A changed path is restored with `git -C "$WT" checkout HEAD -- <path>`, a new one deleted — only inside `WT`, never in the shared folder.
- **The shared folder** — the marker search of `references/snapshot.md`, "Unreported edits", still runs on `<root>`: a file newer than the marker that no `.agents/log.tsv` line names goes into `known.txt` and the report — an executor that wrote there by mistake. It is never restored.
- **Step 5 of `references/slices.md`** looks at the changes with `git -C "$WT" diff HEAD` instead of `base/`.
- **No free slice** — wait on the held slice cards by "Picking a slice" of `references/slices.md`, never on their "Files".

## After a green step

1. `agents.sh merge "S<N>: <essence>" --base <snapshot> --topic <t>`.
2. **Code 0** — rerun the step check in `WT` on the merged result. Red — fix it in `WT`, merge again, and write a report line naming the fix.
3. Then `python3 -I <swork>/scripts/dups.py <root> <path>…` on the `merged:` paths; `merged: nothing` — no run.

## Conflicts, red merges and duplicates

- **Code 3** — call `merge` again, with a `⏳` line in the chat by `references/agents-rules.md`, "Waiting".
- **Code 4** — open each `conflict:` file in `WT` and keep both intentions: the other agent's edit as merged, this agent's own edit applied onto it. Rerun the step check, merge again. No question to the user; a report line naming the file.
- **A duplicate candidate.** Real — keep the version already in the shared folder, remove this agent's own, reroute its calls to the kept one, rerun the check, merge. False — a report line. A line `not installed:` — named once in the report.
- **The same conflict, or a red merged check, after two attempts** — "Decisions and bypass" of `references/slices.md`, then "Bypass" below.

## Submodule slice

A slice whose "Files" lie under a path of `git -C <root> submodule status` (its second field) runs in the shared mode by `references/modes.md`, "Shared mode":

- the packet gets `<root>` as the project root, and the executor message the line `AGENTS=… TOPIC=… SLICE=S<N>`;
- its checks run in `<root>`; there is no merge for it;
- record `S<N>: shared mode — inside submodule <path>` in "Progress log";
- the next `sync` refreshes the clone in `WT`.

## Bypass

Never a `base/` restore in this mode.

- **A slice that never merged** — save `git -C "$WT" diff HEAD` into the snapshot's `checks/S<N>-unmerged.diff` for the report, then `git -C "$WT" checkout HEAD -- <its paths>` and delete its new files in `WT`, so that a later merge cannot carry it.
- **A slice whose merges reached the shared folder** — claim the merged files, reverse this slice's own merge diffs from `.agents/log.tsv` (essence starting with `S<N>:`), newest first, with `patch -R` on a copy, as `references/report.md` says for a shared file in "roll back everything"; then `done`.

## Stages and the end

- The final checks and the checkpoints of stages 5–7 run in `WT` after a `sync`; the stage edits merge like a step.
- "Accept the work" and "roll back everything" end with `agents.sh drop --topic <t>`.
- **A continuing session** finds its old worktree through the `abandoned:` claim of its slice card: the line `orphan saved: .agents/orphans/<id>.diff` names the saved diff. Name that diff in the report and redo the slice from the shared folder.
