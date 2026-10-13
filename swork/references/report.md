# Report and the next step

Read at step 8 — after the review, before the report.

## 8. Report and the next step

Before showing the report add to "Progress log" a line for every declined finding — "declined: <what was proposed> — <why>" — and for everything found but left untouched — "left untouched: <what> — <reason>".

Before the report write "Next step" into `state.md` — "user's choice after the report".

Show it in sections; do not show an empty section, except "Deviations from the plan":

- **Slices** — for each: the status, the commands of its check lines, the end of the output of each and the file with the full output. There is no output obtained in this work — there is no word "done". For a line with a manual check, instead of the output — "the check is manual".
- **Deviations from the plan** — everything you decided without the user: the minor discrepancies fixed in the plan, the files added to a slice, the doubts outside the list of stops. There was not a single one — say so: "the plan was executed as written".
- **Removed as beyond the plan** — what was removed and by which line of the plan.
- **Simplified** — what was replaced with ready-made code and what was deleted as redundant; how many findings were skipped.
- **Fixed after the review** — what was broken and how it was fixed; the declined findings — a line each, with the reason.
- **Found and left untouched** — every finding with the reason: it requires going outside the plan, the check failed after the edit, it was not closed in two attempts, the check is only manual, it was found by the second round of the review, it could not be established.
- **Noticed by the executors** — the flaws outside the slices from the "noticed outside the slice" lines of "Progress log": the place and the essence of each; they were not fixed.
- **Not checked by the conformance check** — what the reviewer could not check by the changes.
- **Not read by the reviewers** — the changed and new files that are not in the READ line, and who did not read them: the checking did not cover them.
- **Awaiting a manual check** — the slice and the steps.
- **Written to the wiki** — the cards from the "Written to the wiki:" lines of "Progress log": the path and the essence of each.
- **What next** — the options below.

Then offer and wait for a choice:

- **accept the work** — the topic is closed in the wiki, the snapshot and the marker are deleted: the order is below; the statuses in the plan stay as they are;
- **fix** — ask what exactly. The fix is within the plan — make it, run the checks of the affected slices and show the report anew; the fix changes the plan — do not make it, offer `splan`;
- **roll back everything** — by `references/snapshot.md`: the copies are put back in place, the new files are deleted. In addition — the records of this work in the wiki, by the marks in the "Written to the wiki:" lines: delete a "new" note together with its line in the `notes/` index, restore an "extended" note from the copy in the snapshot's `notes/`; remove the journal line written by this work. In the plan cards give the slices back the status `not started`, the check lines — the result `not run`; in `state.md` and in the topic's line in "In progress" bring back the phase `plan confirmed`. Name the slices with a "Rollback" section separately: `swork` does not roll them back itself, do not touch their status and results;
- **do nothing** — everything stays as it is, together with the snapshot.

After "roll back everything" delete the snapshot folder `.swork/` and the marker — by `references/snapshot.md` — and the "Progress log" cards of this work together with their lines in the topic index: a repeated start will begin as the first one. A slice with a "Rollback" section was carried out — keep the snapshot and "Progress log" and say so: the rollback of that slice is up to the user.

"Good", "thanks", "great" are not a choice of step: do nothing and name the options once more.

**Accept the work** — in order:

1. **The topic's records.** Reread the notes from the "Written to the wiki:" lines and merge the repeats: two say one and the same thing — one stays, the second is deleted together with its line in the `notes/` index. A note about something that a late slice redid — fix it in place, do not set up a new one.
2. **Phase.** In `state.md` — the phase `done`, the next step — "none — work accepted".
3. **Journal.** In the chain's journal line — its file and date are named by the "Journal" line in `state.md` — replace the tail with `done: <the outcome in one phrase>`. Change nothing else in it and do not set up a second line: there is one line for the whole chain `sbrain → splan → swork`.
4. **Root index.** Remove the topic's line from "In progress". Name the check lines with the result `awaiting manual check` in a line in "Deferred": `- manual check of topic <topic>: lines <No.> — until the user says so`.
5. **The wiki check script** — run it and fix what it names: `references/wiki-rules.md`, the "Check" section.
6. **Snapshot.** Delete the topic's `.swork/` folder and the marker — by `references/snapshot.md`.

The project is under git — offer a commit as a separate menu after the work is accepted: only the changes named by the user; the list of files, the commit title and the branch; the consent applies to this one commit; the snapshot and the marker do not go into the commit. The list of changed and new files — remember it before step 6: after it the snapshot and its lists are gone.
