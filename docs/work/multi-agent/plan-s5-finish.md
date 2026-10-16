# S5. swork: stages, reports and rollback with neighbours

> One agent runs stages 5–7; an earlier one leaves a short report; rollback reverses only this topic's own diffs; the executor sees others' functions.

- **Status:** done
- **Covers:** R8, R11, R12
- **Depends on:** S4
- **Files:**
  - change: `swork/references/finish.md` (lines 3, 7, 9, 15, 37, 45)
  - change: `swork/references/conformance.md` (line 3), `swork/references/review.md` (lines 62, 73)
  - change: `swork/references/report.md` (sections list; lines 34, 36, 39, 50, 52)
  - change: `swork/references/executor.md` (lines 9, 18, 51–53)
  - change: `swork/scripts/packet.sh` (lines 4, 6–11, 18, 21, 25, 115–119)
- **Interfaces:**
  - takes: `agents.sh claim|done|busy|others`, the log prefix `S<N> [<name>]:` (S4)
  - gives: the pseudo-path `<topic folder>/.stage` claimed for stages 5–7 and the report; the report sections `Waited` (what, for whom, how long, which claims were taken over) and `Short report` (own slices, the agent named for the final report); `created.txt` keeps its form `S<N>: name(signature) — file`, the topic is its folder; `packet.sh <topic folder> <slice> <root> [<created file>…]`
- **Reuse:** `patch -R` for reversing a logged diff; the existing report sections and stage order
- **What to do:**
  1. After its last slice an agent claims `<topic folder>/.stage`: code 3 — `wait` for it and claim again; claimed, but `state.md` already says "user's choice after the report" — release, give the short report with `⏸` naming the agent that gave the final one, and stop; claimed while `agents.sh busy --topic <topic>` shows another live claim — `agents.sh release --all`, then the short report, its first line beginning with `⏸` and naming that agent for the final report, then stop; claimed with no other live claim — stages 5–7 as now, then the final report; `.stage` is released after the report.
  2. Stage 5 reruns and stage 6 batches use rule 5 of S4 for a red check.
  3. "Roll back everything": for a file that the edit log shows edited by another topic after this topic's first edit — `patch -R` of this topic's logged diffs, newest first; a reverse that fails leaves the file and names it; other files — from `base/` as now. Accept and roll back write their files under a claim and delete `.swork/` only when `agents.sh busy --topic <topic>` finds no live claim.
  4. The commit file list of `report.md:52` leaves out `.agents/`, `.swork-*/` and files whose last logged edit is by another topic.
  5. `packet.sh`: several created files after the root; this topic's file printed first under `=== created earlier: <file> (this topic) ===`, the others under `=== created earlier: <file> ===`; the main session passes this topic's `created.txt`, the other topics' `created.txt` found under `<wiki>/work/*/.swork/`, and nothing else.
  6. `executor.md`: rule 8 — "a line of your own topic's block with your slice number is your own code"; the packet command line with several files.
- **Checks:** line 7
