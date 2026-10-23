# Snapshot: what changed and how to restore it

Read at step 2. Do not rely on git even when it is there.

## What lies where

**The snapshot folder.** A topic plan — `<wiki folder>/work/<topic>/.swork/`. A plan from the chat or no plan — `.swork-<id>/` in the project root, `<id>` the first field of `agents.sh id`. Deleted on "accept the work"; a topic one only when `agents.sh busy --topic <topic>` finds no live claim.

| Path in the snapshot | What it is |
|---|---|
| `base/<path from the project root>` | A copy of the file before the first edit |
| `new-files.txt` | Files created in this work: a root path per line, no repeats |
| `known.txt` | Files outside the plan left as they are: a path per line |
| `created.txt` | The functions created by the slices: `S<N>: name(signature) — file` per line |
| `checks/` | Full output of every check run: `S2-1.txt` — slice and run number |
| `dirty-at-start.txt` | Only under git: `git status --porcelain` at the start |
| `removed/<path>` | Only under git: removed files outside the plan and changed versions of restored ones |
| `notes/<name>.md` | A copy of a pre-existing wiki note the work extended; not part of "the changes" |
| `stage-5/`, `stage-6/`, `stage-7/` | Checkpoints: the state before stages 5, 6, 7 |

**The time marker** is an empty file `<snapshot>/agents/<id>/marker`, one per agent, timed by the file system of the edits. A new agent creates it on joining; a continuing one copies the oldest `<snapshot>/agents/*/marker` with `cp -p` as its own (a legacy root `.swork-marker` counts), moving none. A project on another machine — marker and search there.

**The changes** — `base/` against the current files, plus `new-files.txt`; all reviewers get this set.

## Rules

- **A copy is taken before the slice** — of every "change" file of the slice; a "create" file goes into `new-files.txt`.
- **An existing copy is not overwritten.**
- **A file listed in `new-files.txt` is not copied into `base/`.**
- **Rollback** — put the copy back, delete a file listed in `new-files.txt`.
- **A slice with a "Rollback" section is not rolled back with copies:** only by its own section.

## Checkpoints

Before each of stages 5, 6, 7 copy all changed and new files into its checkpoint folder; never over an existing one. A failed stage edit rolls back to the checkpoint, not to `base/`; a file created at the stage is deleted with its batch.

## Unreported edits

After every slice build find files newer than this agent's marker and subtract:

- the snapshot folder, `.agents/`, every `.swork-*/` of the project root and the whole wiki folder — always;
- what other agents hold or logged — the output of `agents.sh others --since <own marker>`;
- the "Files" of the current, the executed and the `done` or held slices of this topic — a future slice's file changed early is outside the plan too;
- the exclusions;
- the files from `known.txt`.

**The exclusions** are what the build and the run create.

- Under git — the files for which `git check-ignore` answers with code 0.
- Without git collect it at preparation from: the project's ignore files (`.gitignore`, `.ignore` and the like); the output paths in the slices' check commands; the standard list — `build/`, `out/`, `bin/`, `obj/`, `node_modules/`, `__pycache__/`, `*.o`, `*.obj`, `*.pdb`, `*.log`, `*.tmp`.

**What the search does not see:** a deletion (under git `git status` shows it) and a move that keeps the time.

**What to do with a found file outside the plan**

| Case | Action |
|---|---|
| `agents.sh busy` finds another live agent | Into `known.txt` and a `⚠` line: never restore it |
| Under git, tracked and clean at the start (not in `dirty-at-start.txt`) | Copy the changed file into `removed/`, `git checkout -- <file>`, set its time to this agent's marker; a report line |
| Under git, new and untracked, not in `dirty-at-start.txt` | Move it into the snapshot's `removed/`, never delete it; a report line |
| Under git, in `dirty-at-start.txt` | Into `known.txt` and a `⚠` line by section 4 of `SKILL.md` |
| Without git | Into `known.txt` and a `⚠` line: do not try to restore it |

Write the path into `known.txt` at once.

After a restore or a move rerun the checks of the current and all "done" slices and the commands of "awaiting manual check" ones. One red — that slice needs the file: put it back from `removed/` and add it to the slice's "Files" with a card edit by "Decisions and bypass" of `references/slices.md`.

## Commands: bash

`ROOT` — project root, `SNAP` — snapshot folder, `AGENTS` — path of `agents.sh`, `M` — this agent's marker, `TOPIC` — topic folder name, `WIKI` — wiki folder's full path, `F` — file path from the root, `STAGE` — `stage-5`, `stage-6` or `stage-7`, `CMD` — check command, `N` — output file name (`S2-1`).

```bash
# whether the project is under git; the list at the start
git -C "$ROOT" rev-parse --is-inside-work-tree 2>/dev/null
git -C "$ROOT" status --porcelain > "$SNAP/dirty-at-start.txt"

# the marker of this agent; then ONE of the two lines: a new agent creates it, a continuing agent adopts the oldest (a legacy root .swork-marker counts)
ID=$(bash "$AGENTS" id | cut -f1); M="$SNAP/agents/$ID/marker"; mkdir -p "$SNAP/agents/$ID"
touch "$M"
cp -p "$(ls -tr "$SNAP"/agents/*/marker "$ROOT/.swork-marker" 2>/dev/null | head -n 1)" "$M"

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
find "$ROOT" -type f -newer "$M" \
  -not -path "$SNAP/*" -not -path "$WIKI/*" -not -path "$ROOT/.agents/*" -not -path "$ROOT/.swork-*" -not -path '*/.git/*'
bash "$AGENTS" others --since "$M"   # paths from the root to subtract too

# under git: whether it is ignored (code 0 — yes), whether it is tracked (code 0 — yes)
git -C "$ROOT" check-ignore -q "$F"
git -C "$ROOT" ls-files --error-unmatch "$F" >/dev/null 2>&1

# under git: restore a tracked one (keeping the changed one, the time — as the marker's) / remove a new untracked one
mkdir -p "$SNAP/removed/$(dirname "$F")" && cp -p "$ROOT/$F" "$SNAP/removed/$F" \
  && git -C "$ROOT" checkout -- "$F" && touch -r "$M" "$ROOT/$F"
mkdir -p "$SNAP/removed/$(dirname "$F")" && mv "$ROOT/$F" "$SNAP/removed/$F"

# the work is accepted: ONE of the two lines — a topic snapshot only when no live claim is left in the topic (busy: code 1) / the .swork-<id>/ of a small change
bash "$AGENTS" busy --topic "$TOPIC"; [ $? -eq 1 ] && rm -rf "$SNAP" "$ROOT/.swork-marker"
rm -rf "$SNAP"
```

PowerShell 5.1 commands: `references/snapshot-powershell.md`; read it only on Windows.
