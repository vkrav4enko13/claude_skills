# Preparation. Slices

Read at step 2 — after the entry, before the first slice — and at step 3, when the preparation is finished.

## 2. Preparation

Read `references/snapshot.md` and do the following by it:

1. determine whether the project root is under git;
2. set up the snapshot folder — `.swork/` in the topic folder; under git write down the list of the files that are changed at the start;
3. set the time marker;
4. collect the exclusions for the search for unreported edits and write them into "Progress log" before the first slice — the user must see what the search skips.

Mark the start of the work in the wiki: in `state.md` — the phase `execution in progress` and the next step; in the topic's line in "In progress" of the root index — the same phase and the same step. From then on this line changes together with `state.md`.

Before the first slice check the plan line "Checked against code" against the present code and name the discrepancies — the slice files changed after that check. Do not wait for an answer: this is not a stop.

If the wiki is not kept in the project, write by `references/wiki-rules.md`, section "The wiki is not kept", and say so in the report.

Order the slices by the "Depends on" lines of their cards. The order of execution is set by the dependencies, not by the slice numbers.

## 3. Slices

The slices are executed **one at a time**. At the same time — never, even if they are independent.

**The check of a slice** is the commands of its lines from the check cards (`plan-checks.md` and its parts); the line numbers are named by the "Checks" field of the slice card. It is green when all the lines of the slice that have a command are green, and red when at least one is red. A line with the words `checked manually` is not run as a command — "Manual check" below is about it.

**Progress log** is the `progress.md` card in the topic folder: a line per record, a new one goes to the end. You set it up at the first record: the title, the hook line and the line about it in the topic index — as for any card by `references/wiki-rules.md`. It has filled up to the card limit — continue in `progress-2.md`.

For each slice — first read its card and its check lines, then:

1. **Copies.** Take copies of the slice files by `references/snapshot.md` — for any slice, including one with a "Rollback" section. A "change" file does not exist — this is a discrepancy with the plan, not a reason to create the file.
2. **The check before the edits.** Run the check once and read why it does not pass.
   - It is red because the slice is not there yet — that is how it should be, go on.
   - It is red for another reason — an error in the code outside the slice files, an unfit command — a discrepancy with the plan: the executor would be fixing what is not its own.
   - It is green — check the slice against the code by the "Files" and "Interfaces" blocks. The slice is already done — set "done" and do not rewrite it. It is not done, and the slice has the `no behavior change` mark — that is how it should be: for it a check that is green before the edits does not count as a stop, go on. It is not done and there is no mark — the check proves nothing: a stop.
   - The slice has only a manual check — the step is skipped.
3. **The executor.** Write "S<N>: started" into "Progress log". Read `references/executor.md` before the first slice; after that — only if its text is no longer in the context. A slice of a plan in the topic folder is executed by a fresh subagent; it gets the packet of its own slice, not the whole plan. For a slice marked `ready text`, launch the executor with effort `high`, using the effort parameter of the subagent launch tool; if there is no such parameter, at the session level. Conformance and review reviewers and all other subagents run at the session level.
4. **What the executor returned.**
   - `done` — go to step 5.
   - `need a file` — the file is not in the "Files" block of the slice. The file has moved or been renamed — this is a minor discrepancy; otherwise a stop.
   - `discrepancy` — a minor one you fix yourself, see below; otherwise a stop.
   - `could not` — a failed attempt, see step 6.
5. **The check by the main session.** Run the check yourself and look at the changes by the snapshot. The executor's report does not count as proof: "done" is set only by command output obtained now. In the changes check that the check has not turned green at its own expense: the expected value is not rewritten to fit the code, the test is not disabled and not skipped. Otherwise it is red. After every run of the executor, whatever the check turned out to be, find the unreported edits by `references/snapshot.md`.
6. **A red check.** Run the executor again: the same packet, the end of the output of the failed check and the list of what has already been tried. There are **two** attempts to fix; after the second failed one — a stop. The runs after a red check and after `could not` count; the first run of the executor and a rerun after a minor discrepancy do not count. Record every attempt in "Progress log" as a line "S<N>: attempt 1 of 2 — what was tried, how it ended"; before the second one add which assumption could have been wrong. At a stop the edits of the failed attempts stay in place: the snapshot is intact, the user decides.
7. **Status.** Write the status into the slice card: `done` — when all its lines with a command are green and it has no "checked manually" lines; there is such a line — `awaiting manual check`, see "Manual check". Write a line into "Progress log": the slice number, the outcome, the numbers of the check lines and the files with their output. Write "Next step" into `state.md`.
8. **Records in the wiki.** The check of the slice is green — write as cards in `notes/` what came to light and was confirmed in the course of the slice: non-obvious facts and pitfalls. Take them from the PITFALLS field of the executor's reply and from what you saw yourself; first check an executor's fact against the code. The threshold and the order of writing are in `references/wiki-rules.md`, section "Writing". You edit a note that existed before this work — first copy it into `notes/` of the snapshot folder; do not overwrite a copy that already lies there. In "Progress log" name what was written, as a line "Written to the wiki: <card path from the wiki folder> — new" or "… — extended". There is nothing to write — there is no such line.

**What was created and what was noticed.** Add the functions from the "FUNCTIONS CREATED" field to the snapshot's `created.txt` as lines `S<N>: name(signature) — file`; do not repeat a line that is already there. After an attempt to fix, check the earlier lines of this slice against the code: the file no longer has a function with that name — remove the line; the signature has changed — replace the line. Write what the executor noticed into "Progress log" as a line "S<N>: noticed outside the slice — <the place and the essence>".

**A minor discrepancy** — a file has moved or been renamed, a name has changed, the meaning is the same. You fix it, not the executor: you fix the plan in place in all the cards where this name or path is named, take a copy of the file, record it in "Progress log" and run the executor again. Any other discrepancy is a stop.

**Manual check.** A line `checked manually: <steps>` cannot be checked with a command: run the commands of the other lines of the slice as usual, and for this line write `awaiting manual check` into "Result". Other slices depend on the slice — a stop: set "awaiting manual check", show the steps and wait for confirmation. None depend on it — set "awaiting manual check" and go on; you will show all such checks as a list in the report. A manual check gets "done" only after the user says so.

**The irreversible.** The slice has a "Rollback" section — a stop before it starts. After consent the saving from this section is carried out first.

## Stop menu

First — the action from the table, with what will happen after it; then "Fix" and "Do nothing" — the slice status and the snapshot stay as they are.

| Stop | Action | What happens after it |
|---|---|---|
| the code differs from the plan, and not in a minor way | "Go back to `splan`" | the slice is fixed by `splan`; `swork` does not start `splan`: name the topic folder and stop |
| the check does not pass after two attempts | "Lift the stop with a hint" | the user names what to try; the count of attempts starts anew |
| a slice with an irreversible action | "Start the slice" | the saving from the "Rollback" section is carried out first |
| a manual check, other slices depend on the slice | "Checked: it passes" | the slice gets "done", the dependent slices start |
| a changed file outside the plan that there is nothing to restore with | "The file is mine, keep it" | the path goes into `known.txt`, the work continues |
| the check passes before the edits, while the slice is not done | "Go back to `splan`" | the check line is fixed by `splan`; `swork` does not start `splan`: name the topic folder and stop |
| the check cannot be run because of the environment | "The environment is fixed" | the check is run again, attempts are not spent |
