# Worktree mode

Read only in worktree mode; it wins over `references/slices.md`, `references/snapshot.md`, `references/finish.md` where they overlap. Claims and `agents.sh` calls — `references/agents-rules.md`. `<t>` — topic folder name, `<root>` — shared project folder.

## Mode

- Run `agents.sh wt --topic <t>`.
  - **Code 0** — worktree mode, `WT` is the last printed path; record `mode: worktree <path>`.
  - **Code 5** — shared mode by `references/modes.md`, "Shared mode"; record its `shared: <reason>` as `mode: shared — <reason>`.
- A later code 5 from `sync` or `merge` switches to shared mode for the rest, recorded alike; else the mode holds.

## Before a step

A step: a slice, a fix after a red check or a finding, each of stages 5–7.

- `agents.sh sync --topic <t>` before the step, never mid-step.
- **Code 4** — first resolve each `conflict:` path by "Conflicts, red merges and duplicates".
- **Claims.** As (a) of `references/modes.md`, "Shared mode": never the slice "Files", the merge settles them.

## Executor and checks

- `packet.sh` gets `WT` as project root: `bash <skill folder>/scripts/packet.sh <topic folder> <N> "$WT" …`; the executor works only there.
- **Every check command** runs in `WT` by the runner of `references/snapshot.md`, `WT` replacing a check card's `cd`:

```bash
cd "$WT" && bash -o pipefail -c "$CMD" > "$SNAP/checks/$N.txt" 2>&1; echo "code: $?"; tail -n 40 "$SNAP/checks/$N.txt"
```

- **Edits outside the plan** — `git -C "$WT" status --porcelain` minus slice "Files": restore a changed path by `git -C "$WT" checkout HEAD -- <path>`, delete a new one — in `WT` only, never the shared folder.
- **The shared folder** — the search of `references/snapshot.md`, "Unreported edits", runs on `<root>`: a newer file named in no `.agents/log.tsv` line goes into `known.txt`, never restored.
- **Step 5 of `references/slices.md`** reads changes by `git -C "$WT" diff HEAD`, not `base/`.
- **No free slice** — wait on held slice cards by "Picking a slice" of `references/slices.md`, never on their "Files".

## After a green step

1. `agents.sh merge "S<N>: <essence>" --base <snapshot> --topic <t>`.
2. **Code 0** — rerun the step check in `WT` on the merge. Red — fix in `WT`, merge again; a report line names the fix.
3. `python3 -I <swork>/scripts/dups.py <root> <path>…` on the `merged:` paths; not on `merged: nothing`.

## Conflicts, red merges and duplicates

- **Code 3** — `merge` again, a `⏳` chat line by `references/agents-rules.md`, "Waiting".
- **Code 4** — in each `conflict:` file in `WT` keep the other agent's merged edit, apply this agent's onto it; rerun the step check, merge again. Ask nothing; a report line names the file.
- **A duplicate candidate.** As (e) of `references/modes.md`, keep the shared folder's version; then merge. `not installed:` — named once in the report.
- **The same conflict, or a red merged check, after two attempts** — "Decisions and bypass" of `references/slices.md`, then "Bypass" below.

## Submodule slice

A slice with "Files" under a path of `git -C <root> submodule status` (second field) runs in shared mode by `references/modes.md`, "Shared mode":

- the packet gets `<root>` as project root, the executor message `AGENTS=… TOPIC=… SLICE=S<N>`;
- checks run in `<root>`; no merge;
- record `S<N>: shared mode — inside submodule <path>`;
- the next `sync` refreshes the clone in `WT`.

## Bypass

Never a `base/` restore here.

- **A slice that never merged** — save `git -C "$WT" diff HEAD` to the snapshot's `checks/S<N>-unmerged.diff` for the report; `git -C "$WT" checkout HEAD -- <its paths>`, delete its new files in `WT`.
- **A slice whose merges reached the shared folder** — reverse its merge diffs as (g) of `references/modes.md`, "Shared mode".

## Stages and the end

- Final checks and the checkpoints of stages 5–7 run in `WT` after a `sync`; stage edits merge like a step.
- "Accept the work" and "roll back everything" end with `agents.sh drop --topic <t>`.
- **A continuing session** finds its old worktree by the `abandoned:` claim on its slice card; `orphan saved: .agents/orphans/<id>.diff` names the saved diff — report it, redo the slice from the shared folder.
