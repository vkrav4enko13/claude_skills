# Snapshot: what changed and how to restore it

Read once per run, at step 2; reread it only if the text of the file is no longer in the context.

`swork` does not rely on git, even when it is there: the working tree may hold the user's uncommitted edits, and git will not tell them apart from the executor's edits. The mechanism is the same for all projects; git, if it is there, only helps.

## What lies where

**The snapshot folder.** For a plan in the topic folder — `.swork/` in that folder: `<wiki folder>/work/<topic>/.swork/`. The wiki rules and the check script do not see folders with a dot at the start of the name, so the snapshot does not get in their way. For a plan from the chat and a task without a plan — `.swork/` in the project root. The snapshot survives an interrupted session and is deleted when the user has chosen "accept the work".

| Path in the snapshot | What it is |
|---|---|
| `base/<path from the project root>` | A copy of the file before the first edit |
| `new-files.txt` | The files created in this work: a path from the root per line, without repeats |
| `known.txt` | The files outside the plan that the user called their own: a path from the root per line |
| `created.txt` | The functions created by the slices: `S<N>: name(signature) — file` per line; written by the main session after every run of the executor |
| `checks/` | The full output of every run of a check: `S2-1.txt`, `S2-2.txt` — the slice and the number of the run |
| `dirty-at-start.txt` | Only under git: the output of `git status --porcelain` at the start |
| `removed/<path>` | Only under git: the files outside the plan that were removed from the project, and the changed versions of the restored ones |
| `notes/<name>.md` | A copy of a wiki note that existed before the work and that the work extended; it is not part of "the changes" |
| `stage-5/`, `stage-6/`, `stage-7/` | The checkpoints: the state before the conformance check, the simplification, the review |

**The time marker** is an empty file `.swork-marker` in the project root, not in the snapshot: its time must be set by the same file system that sets the time of the edits. The project lies on another machine — both the marker and the search are done on that machine. When the work is continued the marker is not moved.

**The changes** are the comparison of `base/` with the current files plus the list `new-files.txt`. All the reviewers get this set.

## Rules

- **A copy is taken before the slice** — for every file named in the slice as "change". A "create" file is written into `new-files.txt`.
- **An existing copy is not overwritten.** A second slice edits the same file or the work is being continued — `base/` already holds the original; a new copy would replace it with the changed file.
- **A file listed in `new-files.txt` is not copied into `base/`:** it did not exist before the work started.
- **Rollback** — put the copy back in place, delete a file listed in `new-files.txt`.
- **A slice with a "Rollback" section is not rolled back with copies:** the database, the permissions and the schema are restored only by its own section.

## Checkpoints

Before the conformance check, the simplification and the review copy the current state of all the changed and new files into the checkpoint folder. A failed edit of a stage is rolled back to the checkpoint, not to `base/`: otherwise a rollback of the simplification would wipe out the slice itself. A file created at a stage is deleted when a batch is rolled back.

An existing checkpoint is not overwritten: when the work is continued it holds the state before the stage, while the project holds edits that are already half applied.

## Unreported edits

After every run of the executor find the files newer than the marker and subtract:

- the snapshot folder, the marker and the wiki folder as a whole — always: you write the statuses, the check results and the notes into the wiki after the marker is already set;
- the files from the "Files" blocks of the current slice and of the slices that have already been executed;
- the exclusions;
- the files from `known.txt`.

A file of a future slice that was changed ahead of time is the same kind of edit outside the plan: otherwise an already changed copy would go into `base/` before its slice, and a rollback would restore something other than the original.

**The exclusions** are what the build and the run create.

- Under git — the files for which `git check-ignore` answers with code 0.
- Without git collect the list during the preparation from three sources: the project's ignore files (`.gitignore`, `.ignore` and the like); the output paths in the check commands of the slices; the standard list — `build/`, `out/`, `bin/`, `obj/`, `node_modules/`, `__pycache__/`, `*.o`, `*.obj`, `*.pdb`, `*.log`, `*.tmp`.

Write the list of exclusions into "Progress log" before the first slice. Without git it is an estimate: too wide a list will hide a real edit, too narrow a list will give a needless stop.

**What the search does not see:** the deletion of a file and a move that keeps the time. Under git a deletion is shown by `git status`, without git — by nothing.

**What to do with a found file outside the plan**

| Case | Action |
|---|---|
| Under git, the file is tracked and clean at the start (it is not in `dirty-at-start.txt`) | Copy the changed file into `removed/`, then `git checkout -- <file>` and set the time of the file back to the time of the marker, otherwise it will be found again; a line into the report |
| Under git, the file is new and untracked, it is not in `dirty-at-start.txt` | Move it into the snapshot's `removed/` — do not delete it; a line into the report |
| Under git, the file is in `dirty-at-start.txt` | A stop: it holds the user's edits, there is nothing to restore it with |
| Without git | A stop: show the file, do not try to restore it |

If at the stop the user called the file their own, write the path into `known.txt`, or the file will stop the work after every following slice.

After the restoring or the move run the checks of the current slice, of all the slices with the status "done" and the commands of the slices with the status "awaiting manual check": a file outside the lists could have been needed by any of them. A check turned red — then the slice must need a file that is not in the plan: put the file from `removed/` back in place and stop with a discrepancy.

## Commands: bash

`ROOT` is the project root, `SNAP` — the snapshot folder, `WIKI` — the full path of the wiki folder, `F` — the path of a file from the root, `STAGE` — `stage-5`, `stage-6` or `stage-7`, `CMD` — the check command, `N` — the name of the output file (`S2-1`).

```bash
# whether the project is under git; the list at the start
git -C "$ROOT" rev-parse --is-inside-work-tree 2>/dev/null
git -C "$ROOT" status --porcelain > "$SNAP/dirty-at-start.txt"

# the marker
touch "$ROOT/.swork-marker"

# a check: the full output into a file, the exit code of the command itself, the end of the output.
# A command on another machine through PowerShell: ssh pc '<command>; exit $LASTEXITCODE'
mkdir -p "$SNAP/checks"
bash -o pipefail -c "$CMD" > "$SNAP/checks/$N.txt" 2>&1; echo "code: $?"; tail -n 40 "$SNAP/checks/$N.txt"

# a copy of a "change" file (does not touch an existing one)
[ -e "$SNAP/base/$F" ] || { mkdir -p "$SNAP/base/$(dirname "$F")" && cp -p "$ROOT/$F" "$SNAP/base/$F"; }

# a "create" file
grep -qxF "$F" "$SNAP/new-files.txt" 2>/dev/null || echo "$F" >> "$SNAP/new-files.txt"

# the changes
(cd "$SNAP/base" && find . -type f | sed 's|^\./||') | while read -r f; do diff -u "$SNAP/base/$f" "$ROOT/$f"; done
cat "$SNAP/new-files.txt"

# a checkpoint: for every changed and new file (does not touch an existing one)
[ -e "$SNAP/$STAGE/$F" ] || { mkdir -p "$SNAP/$STAGE/$(dirname "$F")" && cp -p "$ROOT/$F" "$SNAP/$STAGE/$F"; }

# rolling a file back to the state before the start / to the checkpoint / deleting a new one
cp -p "$SNAP/base/$F" "$ROOT/$F"
cp -p "$SNAP/$STAGE/$F" "$ROOT/$F"
rm "$ROOT/$F"

# the files newer than the marker; subtract from the output the files of the slices already gone through, the exclusions and known.txt.
# If the project has no wiki, remove the condition with WIKI: with an empty WIKI it will hide all the files
find "$ROOT" -type f -newer "$ROOT/.swork-marker" \
  -not -path "$SNAP/*" -not -path "$WIKI/*" -not -name .swork-marker -not -path '*/.git/*'

# under git: whether it is ignored (code 0 — yes), whether it is tracked (code 0 — yes)
git -C "$ROOT" check-ignore -q "$F"
git -C "$ROOT" ls-files --error-unmatch "$F" >/dev/null 2>&1

# under git: restore a tracked one (keeping the changed one, the time — as the marker's) / remove a new untracked one
mkdir -p "$SNAP/removed/$(dirname "$F")" && cp -p "$ROOT/$F" "$SNAP/removed/$F" \
  && git -C "$ROOT" checkout -- "$F" && touch -r "$ROOT/.swork-marker" "$ROOT/$F"
mkdir -p "$SNAP/removed/$(dirname "$F")" && mv "$ROOT/$F" "$SNAP/removed/$F"

# the work is accepted
rm -rf "$SNAP" "$ROOT/.swork-marker"
```

The PowerShell 5.1 commands are in `references/snapshot-powershell.md`: read it only on Windows.
