# Entry: kinds of entry and continuation

Read at step 1 — after the table of phases.

| Entry | What to do |
|---|---|
| **A plan in the topic folder** from `splan` | Read `plan.md` and its parts `plan-2.md`, `plan-decisions.md` and the check cards — `plan-checks.md` and its parts `plan-checks-<group>.md`. Read a slice card `plan-s<N>-<name>.md` in full, together with its parts `plan-s<N>-<name>-2.md`, when the slice starts; until then only the lines "Status" and "Depends on" are needed from the slice cards. For a slice without a `- **Status:**` line add `- **Status:** not started` under the hook line and go on; a part of a slice — a card with "part 2" in the title — has no such line and needs none. The topic has `scope.md` or its parts `scope-<part>.md` — find the "Out of scope" section in them and read it: its text will go to the executor and to the conformance check. Do not read the overview `plan-overview.md`: where it differs from the slice card, act by the slice card. |
| **A plan of the earlier form, as a single file** — not as cards in the topic folder | Do not execute. Call the format the earlier one and offer `splan`: it will move the plan into topic cards. Do not work from such a file |
| **A plan from the chat** (a direct or a short result of `splan`) | Go by the "Small change" section |
| **A task without a plan** | It will do only if it can be named, made and checked in one pass. Say in two sentences what you change and where and what you will check it with, and do it right away — do not wait for consent to these two sentences. Next — the "Small change" section. The task is larger — do not execute and do not plan: name what is missing, offer `splan` and stop |

Start a small change by reading `references/small.md` — before the first edit.

**Continuing interrupted work.** If the phase in `state.md` is `execution in progress`, the slices have statuses other than "not started", "Progress log" — the `progress.md` card — has records, or the snapshot folder `.swork/` already lies in the topic folder — the work is being continued. The next step in `state.md` is "user's choice after the report" — this means that the report has been shown but the choice has not been made: do not repeat the slices and the stages, show the report from the records of "Progress log" — by `references/report.md` — and ask for the choice. Otherwise — before the first slice:

- check the plan line "Checked against code" against the present code and name the discrepancies; a discrepancy in a slice that is already done is not a stop: the slice stays done, and the conformance check of stage 5 takes the discrepancy;
- find the files outside the plan that were changed since the last session, by `references/snapshot.md`: they are foreign edits — write them into the snapshot's `known.txt` and name them in one `⚠` line by section 4 of `SKILL.md`; do not ask whose they are;
- run anew the checks of the "done" slices and the lines with a command of the "awaiting manual check" slices, each different command once: between sessions what was done could have broken. A red one — an attempt to fix by step 6 of section 3 for the slice whose files the failure belongs to; still red after two attempts — a card edit by "Decisions and bypass" of `references/slices.md`, then `bypassed` without a restore; its `done` dependents stay `done` and are named in the report as built on a broken slice. Until it is decided, do not start the next slice;
- do not move the time marker, do not touch the copies and the checkpoints in the snapshot.

Next — by the statuses and "Progress log":

- read the `bypassed` statuses first: a bypassed slice is not started, not retried and not asked about; its dependents are not executed;
- do not redo a "done" slice;
- a slice with a "started" record without an outcome — its files hold the edits of the past attempts. Start from step 2 of section 3. After an interruption the attempts recorded in "Progress log" count; after an own card edit the count starts anew. Such a slice with a "Rollback" section: establish by the code what managed to run; it is unclear — `bypassed`, neither the saving nor the action is redone;
- a legacy "stopped" slice — take it as red after two attempts: "Decisions and bypass" of `references/slices.md`;
- do not execute an "awaiting manual check" slice anew; the user has not reported how the check ended — the status `not checked`;
- there is a "stage started" record without a "stage finished" one — restore the files from the checkpoint of this stage and go through the stage anew.

There is a snapshot folder, but the statuses are all "not started" and there are no records — continue with it and give a `⚠` line. Never delete the snapshot.

**Assumptions.** A slice is named in a line of the plan section "Assumptions", or the line has "all" — name this assumption before the slice starts, not earlier and not later. Do not wait for an answer: this is not a stop.
