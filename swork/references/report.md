# Report and the next step

Read at step 8 — after the review, before the report.

## 8. Report and the next step

Before showing the report add to "Progress log" a line for every declined finding — "declined: <what was proposed> — <why>" — and for everything found but left untouched — "left untouched: <what> — <reason>".

Before the report write "Next step" into `state.md` — "user's choice after the report".

Show it in sections; do not show an empty section, except "Deviations from the plan":

- **Slices** — for each: the status, the commands of its check lines — each word for word, in backticks, not a description of it, the end of the output of each — quoted, not described: not "as in the card", not "as expected" — and the file with the full output. There is no output obtained in this work — there is no word "done". For a line with a manual check, instead of the output — "the check is manual".
- **Decided myself** — every `decided myself` line of "Progress log" (for a small change — every `⚠ Decided myself` line of the chat), one per item: problem — choice — why — otherwise.
- **Bypassed** — every `bypassed` slice: the reason and the dependent slices that were not executed.
- **Not checked** — every `not checked` slice and the reason the check could not be run.
- **On unchecked ground** — the slices from the `on unchecked ground` lines of "Progress log" and the manual check each one rests on.
- **Left as found** — the paths of the snapshot's `known.txt`: the reviewers did not read them, and a rollback will not restore them.
- **Rollback slices** — the slices with a "Rollback" section executed without asking: what was saved and the command that brings the earlier state back.
- **Deviations from the plan** — what you decided without the user that is not in the sections above: the minor discrepancies fixed in the plan, the files added to a slice, the findings dropped about bypassed slices. There was not a single one — say so: "the plan was executed as written".
- **Removed as beyond the plan** — what was removed and by which line of the plan.
- **Simplified** — what was replaced with ready-made code and what was deleted as redundant; how many findings were skipped.
- **Fixed after the review** — what was broken and how it was fixed; the declined findings — a line each, with the reason.
- **Found and left untouched** — every finding, and on the same line its reason: it requires going outside the plan, the check failed after the edit, it was not closed in two attempts, the check is only manual, it was found by the second round of the review, it could not be established.
- **Noticed by the executors** — the flaws outside the slices from the "noticed outside the slice" lines of "Progress log": the place and the essence of each; they were not fixed.
- **Not checked by the conformance check** — what the reviewer could not check by the changes.
- **Not read by the reviewers** — the changed and new files that are not in the READ line, and who did not read them: the checking did not cover them.
- **Awaiting a manual check** — the slice and the steps.
- **Waited** — every wait of this work by `references/agents-rules.md`, "Waiting": what files, for whom, how long, and which claims were taken over (`abandoned:`).
- **Written to the wiki** — the cards from the "Written to the wiki:" lines of "Progress log": the path and the essence of each.
- **What next** — the options below.

## Short report

An agent that finished its slices while another agent of the topic holds a live claim, or after the final report was already given — `references/finish.md`, section 5 — shows the short report instead and stops without a menu. Its first line begins with `⏸` and names the agent that will give or gave the final report. Then its own slices, each with its status and the commands of its check lines as in "Slices", and the sections above that hold its own records, "Waited" among them. "Next step" in `state.md` is not changed.

Then offer and wait for a choice:

- **accept the work** — the topic is closed in the wiki, the snapshot and the marker are deleted: the order is below; its files are written under a claim by `references/agents-rules.md`; the statuses in the plan stay as they are;
- **fix** — ask what exactly. The fix is within the plan — make it, run the checks of the affected slices and show the report anew; the fix changes the plan — do not make it, offer `splan`;
- **roll back everything** — its files are written under a claim by `references/agents-rules.md`. A file that `.agents/log.tsv` shows edited by another topic after this topic's first edit of it — reverse this topic's own logged diffs of that file, newest first: `patch -R <file> .agents/diffs/<n>.diff` on a copy, the copy put in place only when every reverse succeeded; a reverse that fails leaves the file as it is — name it in the report. The other files — by `references/snapshot.md`: the copies are put back in place, the new files are deleted. In addition — the records of this work in the wiki, by the marks in the "Written to the wiki:" lines: delete a "new" note together with its line in the `notes/` index, restore an "extended" note from the copy in the snapshot's `notes/`; remove the journal line written by this work. In the plan cards give the slices back the status `not started` — the `bypassed` and `not checked` ones too, — the check lines — the result `not run`; in `state.md` and in the topic's line in "In progress" bring back the phase `plan confirmed` and the "Next step" "execute the plan through `swork`". Name the slices with a "Rollback" section that were executed separately, with their restore command: `swork` does not roll them back itself, do not touch their status and results;
- **do nothing** — everything stays as it is, together with the snapshot.

After "roll back everything" delete the snapshot folder `.swork/` and the marker — by `references/snapshot.md`, only when `agents.sh busy --topic <topic>` finds no live claim — and the "Progress log" cards of this work together with their lines in the topic index: a repeated start will begin as the first one. A slice with a "Rollback" section was carried out — keep the snapshot and "Progress log" and say so: the rollback of that slice is up to the user.

"Good", "thanks", "great" are not a choice of step: do nothing and name the options once more.

**Accept the work** — in order:

1. **The topic's records.** Reread the notes from the "Written to the wiki:" lines and merge the repeats: two say one and the same thing — one stays, the second is deleted together with its line in the `notes/` index. A note about something that a late slice redid — fix it in place, do not set up a new one.
2. **Phase.** In `state.md` — the phase `done`, the next step — "none — work accepted".
3. **Journal.** In the chain's journal line — its file and date are named by the "Journal" line in `state.md` — replace the tail with `done: <the outcome in one phrase>`. Change nothing else in it and do not set up a second line: there is one line for the whole chain `sbrain → splan → swork`.
4. **Root index.** Remove the topic's line from "In progress". Name the check lines with the result `awaiting manual check` in a line in "Deferred": `- manual check of topic <topic>: lines <No.> — until the user says so`.
5. **The wiki check script** — run it and fix what it names: `references/wiki-rules.md`, the "Check" section.
6. **Snapshot.** Delete the topic's `.swork/` folder and the marker — by `references/snapshot.md`, only when `agents.sh busy --topic <topic>` finds no live claim.

The project is under git — offer a commit as a separate menu after the work is accepted: only the changes named by the user; the list of files, the commit title and the branch; the consent applies to this one commit; the snapshot and the marker do not go into the commit, nor `.agents/`, `.swork-*/` and a file whose last line in `.agents/log.tsv` is by another topic. The list of changed and new files — remember it before step 6: after it the snapshot and its lists are gone.
