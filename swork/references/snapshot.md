# Snapshot: what changed and how to restore it

Read at step 2.

## What lies where

**The snapshot folder.** A topic plan — `<wiki folder>/work/<topic>/.swork/`. A plan from the chat or no plan — `.swork/` in the project root. Deleted on "accept the work".

| Path in the snapshot | What it is |
|---|---|
| `new-files.txt` | Files created in this work: a root path per line, no repeats |
| `known.txt` | Files outside the plan left as they are: a path per line |
| `dirty-at-start.txt` | Only under git: `git status --porcelain` at the start |
| `removed/<path>` | Only under git: files outside the plan moved away or their diffs before a restore |
| `notes/<name>.md` | A copy of a pre-existing wiki note the work extended; not part of "the changes" |

**The changes** — under git `git diff` of the files tracked and clean at the start, plus `new-files.txt`; without git — the slices' "Files".

## Rules

- **No copies of files**: a "create" file goes into `new-files.txt`.
- **Rollback** — under git: `git checkout -- <file>` for a file tracked and clean at the start (not in `dirty-at-start.txt`), delete a file listed in `new-files.txt`; a file without git or in `dirty-at-start.txt` is not rolled back — the report names it.
- **A slice with a "Rollback" section is not rolled back with git:** only by its own section.

## Files outside the plan

Found once, at stage 5: under git `git status --porcelain` minus `dirty-at-start.txt`, the "Files" of the executed slices, `new-files.txt`, the snapshot and the wiki folder, and the files `git check-ignore` ignores. Without git — none are searched for.

| Case | Action |
|---|---|
| Tracked and clean at the start | Its diff into `removed/<path>.diff`, `git checkout -- <file>`; a report line |
| New and untracked | Move it into the snapshot's `removed/`, never delete it; a report line |
| In `dirty-at-start.txt` | Into `known.txt` and a `⚠` line by section 4 of `SKILL.md` |

The stage 5 rerun of the changed blocks' checks follows. One red that the restore caused — put the file back from `removed/` and add it to the slice's "Files" with a card edit by "Decisions and bypass" of `references/slices.md`.

## Commands: bash

`ROOT` — project root, `SNAP` — snapshot folder, `F` — file path from the root, `CMD` — check command.

```bash
# whether the project is under git; the list at the start
git -C "$ROOT" rev-parse --is-inside-work-tree 2>/dev/null
git -C "$ROOT" status --porcelain > "$SNAP/dirty-at-start.txt"

# a check: the exit code of the command itself, the end of the output; no output file.
# A command on another machine through PowerShell: ssh pc '<command>; exit $LASTEXITCODE'
bash -o pipefail -c "$CMD" 2>&1 | tail -n 40; echo "code: ${PIPESTATUS[0]}"

# a "create" file
grep -qxF "$F" "$SNAP/new-files.txt" 2>/dev/null || echo "$F" >> "$SNAP/new-files.txt"

# the changes; the files changed now
git -C "$ROOT" diff
git -C "$ROOT" status --porcelain

# rolling a file back: a tracked file clean at the start / a new one
git -C "$ROOT" checkout -- "$F"
rm "$ROOT/$F"

# a file outside the plan: whether it is ignored (code 0 — yes); restore a tracked one / move a new one away
git -C "$ROOT" check-ignore -q "$F"
mkdir -p "$SNAP/removed/$(dirname "$F")" && git -C "$ROOT" diff -- "$F" > "$SNAP/removed/$F.diff" && git -C "$ROOT" checkout -- "$F"
mkdir -p "$SNAP/removed/$(dirname "$F")" && mv "$ROOT/$F" "$SNAP/removed/$F"

# the work is accepted
rm -rf "$SNAP"
```

PowerShell 5.1 commands: `references/snapshot-powershell.md`; read it only on Windows.
