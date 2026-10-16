# S4. swork: own slices next to other agents

> Each agent of `swork` takes a free slice under a claim, keeps its own marker and never treats a neighbour's work as foreign.

- **Status:** done
- **Covers:** R9, R10, R11
- **Depends on:** S2, S3
- **Files:**
  - change: `swork/SKILL.md` (lines 24 and 52 — the wait as an exception; trap of line 119 "One at a time: without git")
  - change: `swork/references/slices.md` (lines 11, 13–14, 20, 24, 30, 44–46, 65)
  - change: `swork/references/snapshot.md` (lines 9, 23, 43–50, 63–72, 84, 111–112, 120, 124)
  - change: `swork/references/snapshot-powershell.md` (lines 11, 37, 40, 48, 55)
  - change: `swork/references/entry.md` (lines 14, 17, 19, 25, 28)
  - change: `swork/references/small.md` (lines 8, 13)
- **Interfaces:**
  - takes: `agents.sh claim|wait|done|busy|others|id` (S2)
  - gives: the marker path `<snapshot>/agents/<id>/marker`; the small-change snapshot `.swork-<id>/` in the project root; the log line prefix `S<N> [<name>]:` in "Progress log"; the slice pick rule "a free slice" — not `done`, not `bypassed`, not held, every "Depends on" slice `done`, `awaiting manual check` or `not checked`
- **Reuse:** the snapshot rules of `snapshot.md`; `agents.sh others` for the subtraction
- **What to do:**
  1. Marker: per agent, created at join; a continuing agent copies the oldest `<snapshot>/agents/*/marker` with `cp -p` as its own, and a legacy root `.swork-marker` counts as such a marker; `find -newer` uses it; `touch -r` on a restore uses this agent's marker; the snapshot is deleted only when `agents.sh busy --topic <topic>` finds no live claim. A new agent calls `agents.sh id` before it creates its marker.
  2. Slice pick: claim a free slice's "Files" and card in one `claim`; code 3 — try the next free slice; none — if this agent has done a slice of the topic, go to stages by S5 step 1; otherwise `wait` on the files of the held slice of this topic with the lowest number, then pick again; the dependents of a `bypassed` slice count as gone, never as waiting.
  3. Per slice: claim before step 1, `done` after step 7 with the essence `S<N>: <outcome>`; statuses, "Progress log", `state.md`, `created.txt`, `new-files.txt` are written under a short claim of that card or file.
  4. Search for edits outside the plan: always subtract `.agents/` and every `.swork-*/` of the project root; subtract `agents.sh others --since <own marker>` and the "Files" of slices `done` or held in this topic; an unlogged file while `agents.sh busy` finds another live agent — `known.txt` and a `⚠` line, never restored.
  5. A red check while `agents.sh busy` finds another live agent — not an attempt: `wait` for that agent's files, then run the check again; recorded as `S<N> [<name>]: rerun after <name> released`.
  6. Entry: a live claim on a slice — not continued work, skip it; a dead claim with a "started" record — the old rule; joining a topic whose phase is `execution in progress` and whose claims are live is a join, not a continuation.
  7. The trap "One at a time: without git…" becomes "Two agents never edit one slice: the claim decides".
- **Checks:** line 6
