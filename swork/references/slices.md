# Preparation. Slices

Read at step 2, after the entry; it holds step 3 too.

## 2. Preparation

By `references/snapshot.md`: whether the project root is under git; the snapshot folder `.swork/` in the topic folder; under git the list of files changed at the start.

Mark the start: phase `execution in progress` and the next step into `state.md`; already so — leave it.

The wiki is not kept — `references/wiki-rules.md`, section "The wiki is not kept"; say so in the report.

Order the slices by their "Depends on", not by number. **Picking a slice.** Free: not `done` or `bypassed`, and every slice of its "Depends on" `done`, `awaiting manual check` or `not checked`. Dependents of a `bypassed` slice are gone. None free — `references/finish.md`, section 5.

## 3. Slices

**The check of a slice** — the commands of its lines in the check cards (`plan-checks.md` and parts), numbered in its "Checks" field. Green — all its command lines green; red — any red. A `checked manually` line is not run: "Manual check".

**Progress log** is the `progress.md` card in the topic folder: a line per record, appended in the batch of `SKILL.md`, "Rules for all stages". Set it up at the first batch as any card by `references/wiki-rules.md` (title, hook, topic-index line); full — `progress-2.md`. "Log" means a line into this batch.

Per slice: read its card and check lines, do the steps.

1. **"Create" files** go into `new-files.txt` by `references/snapshot.md`. A missing "change" file is a discrepancy; never create it.
2. **The check before the edits** runs only to reproduce a bug the slice fixes, or as a baseline when the slice changes a behaviour on purpose; otherwise skipped. Red because the slice is absent — go on; red otherwise (error outside the slice files, unfit command) — a discrepancy; green — "Decisions and bypass".
3. **The build.** Read `references/executor.md` (who builds) before the first slice. This session builds — its `discrepancy`, `need a file`, `could not` go as in step 4. A subagent gets the path of `<temporary folder>/packet-S<N>.txt` by "Packet" there, never the plan.
4. **What the executor returned.**
   - `done` — step 5.
   - `need a file` (not in the slice's "Files") — moved or renamed: a minor discrepancy; otherwise "Decisions and bypass".
   - `discrepancy` — minor: fix it yourself (below); otherwise "Decisions and bypass".
   - `could not` — a failed attempt, step 6.
5. **The check by the main session** — when the block closes (`references/executor.md`), for each slice: run the check yourself; only output obtained now sets "done", never a report. A check made green by cheating (expected value rewritten, test disabled or skipped) is red.
6. **A red check.** Fix by the path of step 3 — this session, or the executor with the same packet file plus the failed output's end and what was tried. **Two** attempts, then "Decisions and bypass". Runs after a red check or `could not` count; the first build and reruns after a minor discrepancy do not. Log each attempt: "S<N>: attempt 1 of 2 — what was tried, how it ended"; before the second add which assumption could be wrong. Failed edits stay until the decision.
7. **Status** — into the block batch: `done` — all command lines green, no "checked manually" line; with one — `awaiting manual check` ("Manual check"); a "Progress log" line (slice, outcome, check line numbers) and the `state.md` "Next step".

**Last batch.** Into `notes/`, as cards, only the non-obvious facts and pitfalls the work confirmed: the executors' PITFALLS, checked against the code. Threshold and order — `references/wiki-rules.md`, section "Writing". A pre-existing note — copy it into the snapshot's `notes/` first. Log "Written to the wiki: <card path from the wiki folder> — new" or "… — extended"; NOTICED as "S<N>: noticed outside the slice — <the place and the essence>".

**A minor discrepancy** — a file moved or renamed, a name changed, same meaning. You fix it, not the executor: in place in every card naming it; log it, rerun step 3. Any other — "Decisions and bypass".

**Manual check.** Run the slice's other lines; a `checked manually: <steps>` line gets `awaiting manual check` in "Result", the slice too. With dependents — "Decisions and bypass"; without — go on, list it in the report. Only the user's word makes it "done".

## Decisions and bypass

The cases of section 4 of `SKILL.md`, decided without waiting: each — the `⚠` chat line and the log line of section 4, then the next step.

**An own edit of the card.** In the cases of the section 4 table — edit this slice card and its check lines in place when that settles it: a path, a command, "Files". Never "Expected" or a scenario value. Log first `S<N>: card edit — was: <…>; became: <…>; why: <…>`. Allowed, not counted; the attempt count goes on.

**Bypass.** Red after two attempts, or a discrepancy no card edit settles — `bypassed`.

- Never `done` before: restore by `git checkout` its tracked files no other run (`done`, `awaiting manual check`, `not checked`) slice names, delete its `new-files.txt` files no such slice names. Once `done`, or with "Rollback": restore nothing.
- **Dependent slices** name it in "Depends on", directly or by a chain, or share a "Files" file. They stay `not started`, unexecuted.
- **Everything else is executed.** Stage 5 follows the last slice neither bypassed nor dependent, also when none is left.

**The irreversible.** A "Rollback" slice: by the section 4 row; saving fails — `bypassed` at once, no card edit.

**The environment.** Cannot run — by `SKILL.md`, "How to run a check"; log `S<N>: not checked — <reason>`. A `not checked` slice counts as one with only a manual check.

**A manual check with dependents.** Each dependent is logged `S<N>: on unchecked ground — S<M> awaits manual check`. Only the user sets "done" for the manual check.
