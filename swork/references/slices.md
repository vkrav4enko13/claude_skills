# Preparation. Slices

Read at step 2 — after the entry, before the first slice — and at step 3, when the preparation is finished.

## 2. Preparation

Read `references/snapshot.md` and do the following by it:

1. determine whether the project root is under git;
   read `references/modes.md` when `agents.sh mode` is not `off`, and pick the mode by it;
2. set up the snapshot folder — `.swork/` in the topic folder; under git write down the list of the files that are changed at the start;
3. create this agent's time marker — `<snapshot>/agents/<id>/marker`, `<id>` from `agents.sh id`; a continuing agent adopts the oldest marker instead: both by `references/snapshot.md`;
4. collect the exclusions for the search for unreported edits and write them into "Progress log" before the first slice — the user must see what the search skips.

Mark the start of the work in the wiki: in `state.md` — the phase `execution in progress` and the next step; in the topic's line in "In progress" of the root index — the same phase and the same step. From then on this line changes together with `state.md`. The phase is already `execution in progress` — another agent has marked it: leave it. `state.md`, "Progress log", the slice statuses, `created.txt` and `new-files.txt` are written under a short claim of that card or file: `claim`, the write, `done` — `references/agents-rules.md`, "When to claim" and "After a write".

Before the first slice check the plan line "Checked against code" against the present code and name the discrepancies — the slice files changed after that check. Do not wait for an answer: this is not a stop.

If the wiki is not kept in the project, write by `references/wiki-rules.md`, section "The wiki is not kept", and say so in the report.

Order the slices by the "Depends on" lines of their cards. The order of execution is set by the dependencies, not by the slice numbers.

**Picking a slice.** An agent takes a free slice: not `done`, not `bypassed`, not held, and every slice of its "Depends on" is `done`, `awaiting manual check` or `not checked`. A slice is held when its card is in the output of `agents.sh busy --topic <topic>`. Claim its card alone (`references/modes.md`); code 3 — try the next free slice. There is no free slice — if this agent has done a slice of this topic, go to `references/finish.md`, section 5: its claim of `.stage` decides between the short report and stages 5–7; otherwise `wait` on the card of the held slice of this topic with the lowest number, then pick again. The dependents of a `bypassed` slice count as gone, never as waiting.

## 3. Slices

An agent executes its slices **one at a time**; other agents may execute other slices at the same time. Two agents never edit one slice: the claim decides.

**The check of a slice** is the commands of its lines from the check cards (`plan-checks.md` and its parts); the line numbers are named by the "Checks" field of the slice card. It is green when all the lines of the slice that have a command are green, and red when at least one is red. A line with the words `checked manually` is not run as a command — "Manual check" below is about it.

**Progress log** is the `progress.md` card in the topic folder: a line per record, a new one goes to the end. You set it up at the first record: the title, the hook line and the line about it in the topic index — as for any card by `references/wiki-rules.md`. It has filled up to the card limit — continue in `progress-2.md`.

For each slice — claim it by "Picking a slice" before step 1, read its card and its check lines, then go through the steps below; after step 7 — `agents.sh done "S<N>: <outcome>" <card> --topic <topic>`. Every line this agent writes into "Progress log" starts with `S<N> [<name>]:` instead of `S<N>:`, `<name>` — the second field of `agents.sh id`, copied whole, never shortened. Stage records take the mark at the end: "stage 5 finished [<name>]".

1. **Copies.** Take copies of the slice files by `references/snapshot.md` — for any slice, including one with a "Rollback" section. A "change" file does not exist — this is a discrepancy with the plan, not a reason to create the file. In the worktree mode `merge --base` takes the copies: `references/worktree.md`, "After a green step".
2. **The check before the edits.** Run the check once and read why it does not pass.
   - It is red because the slice is not there yet — that is how it should be, go on.
   - It is red for another reason — an error in the code outside the slice files, an unfit command — a discrepancy with the plan: the executor would be fixing what is not its own.
   - It is green — check the slice against the code by the "Files" and "Interfaces" blocks. The slice is already done — set "done" and do not rewrite it. It is not done, and the slice has the `no behavior change` mark — that is how it should be: for it a check that is green before the edits is not a problem, go on. It is not done and there is no mark — the check proves nothing: "Decisions and bypass".
   - The slice has only a manual check — the step is skipped.
3. **The executor.** Write "S<N>: started" into "Progress log". Read `references/executor.md` before the first slice; after that — only if its text is no longer in the context. A slice of a plan in the topic folder is executed by a fresh subagent; it gets the packet of its own slice, not the whole plan. Run `scripts/packet.sh` into `<temporary folder>/packet-S<N>.txt` by the "Packet" section of `references/executor.md` and pass the path of that file. In the shared mode add the line `AGENTS=… TOPIC=… SLICE=S<N>` to the executor message by `references/modes.md`.
4. **What the executor returned.**
   - `done` — go to step 5.
   - `need a file` — the file is not in the "Files" block of the slice. The file has moved or been renamed — this is a minor discrepancy; otherwise "Decisions and bypass".
   - `discrepancy` — a minor one you fix yourself, see below; otherwise "Decisions and bypass".
   - `could not` — a failed attempt, see step 6.
5. **The check by the main session.** Run the check yourself and look at the changes by the snapshot. The executor's report does not count as proof: "done" is set only by command output obtained now. In the changes check that the check has not turned green at its own expense: the expected value is not rewritten to fit the code, the test is not disabled and not skipped. Otherwise it is red. After every run of the executor, whatever the check turned out to be, find the unreported edits by `references/snapshot.md`. The check is red while `agents.sh busy` finds another live agent — this is not an attempt: `wait` for the files that agent holds, then run the check again; record it as `S<N> [<name>]: rerun after <name> released`, the second `<name>` — that agent's. In the worktree mode the check runs in `WT`, the changes are `git -C "$WT" diff HEAD`, and the search is that of `references/worktree.md`, "Executor and checks".
6. **A red check.** Run the executor again with the same packet file; the end of the output of the failed check and the list of what has already been tried go into the message itself. There are **two** attempts to fix; after the second failed one — "Decisions and bypass". The runs after a red check and after `could not` count; the first run of the executor and a rerun after a minor discrepancy do not count. Record every attempt in "Progress log" as a line "S<N>: attempt 1 of 2 — what was tried, how it ended"; before the second one add which assumption could have been wrong. Until the decision the edits of the failed attempts stay in place: the snapshot is intact. A red check that step 5 turned into a rerun is not counted here.
7. **Status.** Write the status into the slice card: `done` — when all its lines with a command are green and it has no "checked manually" lines; there is such a line — `awaiting manual check`, see "Manual check". Write a line into "Progress log": the slice number, the outcome, the numbers of the check lines and the files with their output. Write "Next step" into `state.md`.
8. **Records in the wiki.** The check of the slice is green — write as cards in `notes/` what came to light and was confirmed in the course of the slice: non-obvious facts and pitfalls. Take them from the PITFALLS field of the executor's reply and from what you saw yourself; first check an executor's fact against the code. The threshold and the order of writing are in `references/wiki-rules.md`, section "Writing". You edit a note that existed before this work — first copy it into `notes/` of the snapshot folder; do not overwrite a copy that already lies there. In "Progress log" name what was written, as a line "Written to the wiki: <card path from the wiki folder> — new" or "… — extended". There is nothing to write — there is no such line.

**What was created and what was noticed.** Add the functions from the "FUNCTIONS CREATED" field to the snapshot's `created.txt` as lines `S<N>: name(signature) — file`; do not repeat a line that is already there. After an attempt to fix, check the earlier lines of this slice against the code: the file no longer has a function with that name — remove the line; the signature has changed — replace the line. Write what the executor noticed into "Progress log" as a line "S<N>: noticed outside the slice — <the place and the essence>".

**A minor discrepancy** — a file has moved or been renamed, a name has changed, the meaning is the same. You fix it, not the executor: you fix the plan in place in all the cards where this name or path is named, take a copy of the file, record it in "Progress log" and run the executor again. Any other discrepancy — "Decisions and bypass".

**Manual check.** A line `checked manually: <steps>` cannot be checked with a command: run the commands of the other lines of the slice as usual, and for this line write `awaiting manual check` into "Result". Other slices depend on the slice — set "awaiting manual check" and go on by "Decisions and bypass". None depend on it — set "awaiting manual check" and go on; you will show all such checks as a list in the report. A manual check gets "done" only after the user says so.

**The irreversible.** The slice has a "Rollback" section — the user's "yes" to the plan is the consent: the saving from this section is carried out first, then the slice. The saving fails — "Decisions and bypass".

## Decisions and bypass

The cases of section 4 of `SKILL.md` are decided here, without waiting. Each decision — the `⚠` chat line and the log line by section 4, then the next step.

**An own edit of the card.** The code differs from the plan not in a minor way, the check is red after two attempts, the check is green before the edits without the `no behavior change` mark, `need a file` for a file that has not moved — edit this slice card and its check lines in place: a path, a command, the "Files" block. Never "Expected" and never a value of a scenario: otherwise the work makes itself pass. Before the edit write into "Progress log" a line `S<N>: card edit — was: <…>; became: <…>; why: <…>`. At most two edits per slice. After an edit the count of attempts starts anew; take copies of the newly named files and run the slice again from step 2.

**Bypass.** Both edits are used and the slice is still not done — the status `bypassed`.

- In the shared mode — by `references/modes.md`, "Shared mode" (g), never from `base/`; in the worktree mode — by `references/worktree.md`, "Bypass"; the next item is for the other modes.
- A slice that was never `done` before: restore from `base/` its files that no other slice that ran — `done`, `awaiting manual check` or `not checked` — or a held slice names, and delete its files of `new-files.txt` that no such slice names. A slice that was `done`, or that has a "Rollback" section: nothing is restored.
- **Dependent slices** name the bypassed one in "Depends on", directly or through a chain, or share a file of "Files" with it. They stay `not started` and are not executed.
- **Everything else is executed.** Stages 5–7 run after the last slice that is neither bypassed nor dependent — also when no such slice was left; what the reviewers are told about such slices — `references/finish.md`.

**The irreversible.** A slice with a "Rollback" section: the saving, then the slice. The saving fails — `bypassed` at once, without a card edit.

**The environment.** The check cannot be run — one try to restore the environment and run it again. It still cannot be run — the status `not checked`, a line `S<N>: not checked — <reason>` in "Progress log"; the work goes on. A `not checked` slice counts as one with only a manual check.

**A manual check with dependents.** The dependents are executed; each gets a line `S<N>: on unchecked ground — S<M> awaits manual check` in "Progress log". Only the user sets "done" for the manual check.
