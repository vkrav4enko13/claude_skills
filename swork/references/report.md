# Report and the next step

Read at step 8.

## 8. Report and the next step

Add to the batch, before `stage 7 finished`: "declined: <what was proposed> — <why>" per declined finding, "left untouched: <what> — <reason>" per thing found but left, and the `state.md` "Next step" "user's choice after the report". Write the batch, then report.

Sections; omit empty ones, except "Deviations from the plan":

- **Slices** — per slice: the status; each check command word for word in backticks; the end of its output quoted (not "as in the card" or "as expected"); the full output file. No output from this work — no word "done". A manual line — "the check is manual". Stages 5–7 skipped — `stages 5–7 skipped: no code` right after.
- **Decided myself** — each `decided myself` line of "Progress log" (small change: each `⚠ Decided myself` chat line): problem — choice — why — otherwise.
- **Bypassed** — each `bypassed` slice: reason, dependents not executed.
- **Not checked** — each `not checked` slice and why.
- **On unchecked ground** — the slices of those lines and the manual check each rests on.
- **Left as found** — the `known.txt` paths: unread by the reviewers, not restored by a rollback.
- **Rollback slices** — those executed: what was saved, the restore command.
- **Deviations from the plan** — other decisions without the user: minor plan fixes, files added to a slice, findings dropped about bypassed slices. None — "the plan was executed as written".
- **Removed as beyond the plan** — what, by which plan line.
- **Simplified** — replaced with ready-made code, deleted as redundant; how many skipped.
- **Fixed after the review** — what was broken and the fix; a line per declined finding with the reason.
- **Found and left untouched** — each finding with its reason: outside the plan, check failed after the edit, not closed in two attempts, manual check only, found by review round 2, could not be established.
- **Noticed by the executors** — the "noticed outside the slice" lines; not fixed.
- **Not checked by the conformance check** — what the reviewer could not check.
- **Not read by the reviewers** — changed and new files missing from a READ line, and who skipped them.
- **Awaiting a manual check** — the slice and the steps.
- **Mode** — mode and reason from the `mode:` records, and the outcome of `agents.sh off --if-last` — `mode: off` or `mode: kept — <reason>` (the mode file stays).
- **Waited** — each wait (`references/agents-rules.md`, "Waiting"): agent, files, holder, seconds from this agent's `.agents/waits.tsv` lines, claims taken over (`abandoned:`).
- **Written to the wiki** — the cards of those lines: path and essence.
- **What next** — the options below.

## Short report

Instead of the full one when `references/finish.md`, section 5, says so; then stop, no menu. First line: `⏸` and the agent that gives the final report. Then its own slices as in "Slices", the "Mode" line and the sections of its own records, "Waited" among them. "Next step" in `state.md` unchanged; the batch is written first.

After the full report offer and wait for a choice:

- **accept the work** — in the order below; plan statuses stay;
- **fix** — ask what. Within the plan — make it, rerun the affected checks, report anew; changes the plan — do not make it, offer `splan`;
- **roll back everything** — a file `.agents/log.tsv` shows edited by another topic after this topic's first edit — reverse this topic's logged diffs of it, newest first: `patch -R <file> .agents/diffs/<n>.diff` on a copy, put in place only if all succeeded; else leave it, name it in the report. Other files by `references/snapshot.md`: copies back, new files deleted. Wiki records by the "Written to the wiki:" marks: delete a "new" note with its `notes/` index line, restore an "extended" one from the snapshot's `notes/`; remove this work's journal line. Plan cards: slices back to `not started` (`bypassed`, `not checked` too), check lines to `not run`; `state.md` and the "In progress" line — phase `plan confirmed`, "Next step" "execute the plan through `swork`". Name the executed "Rollback"-section slices with their restore command: never rolled back, status and results untouched;
- **do nothing** — everything stays, the snapshot too.

After "roll back everything" delete the snapshot as in step 6 below and this work's "Progress log" cards with their topic index lines. A "Rollback"-section slice was carried out — keep the snapshot and "Progress log", say so: its rollback is up to the user.

"Accept the work" and "roll back everything" write files under a claim by `references/agents-rules.md`.

"Good", "thanks" are not a choice: do nothing, name the options again.

**Accept the work** — in order:

1. **The topic's records.** Reread the notes of the "Written to the wiki:" lines; of two saying the same, delete one with its `notes/` index line; fix in place a note on what a late slice redid, no new one.
2. **Phase.** In `state.md` — phase `done`, next step "none — work accepted".
3. **Journal.** In the chain's journal line (named by the "Journal" line in `state.md`) replace the tail with `done: <the outcome in one phrase>`; change nothing else in it, no second line.
4. **Root index.** Remove the topic's line from "In progress". Name the `awaiting manual check` lines in a "Deferred" line: `- manual check of topic <topic>: lines <No.> — until the user says so`.
5. **The wiki check script** — run it, fix what it names (`references/wiki-rules.md`, "Check").
6. **Snapshot.** Delete the topic's `.swork/` and the marker by `references/snapshot.md` (only with no live claim in the topic). Worktree mode: then `agents.sh drop` by `references/worktree.md`, "Stages and the end".

Under git — after acceptance offer a commit in a separate menu: only the changes the user names; file list, title, branch; consent covers this one commit; never the snapshot, the marker, `.agents/`, `.swork-*/` or a file whose last `.agents/log.tsv` line is another topic's. Keep the changed and new file list from before step 6.
