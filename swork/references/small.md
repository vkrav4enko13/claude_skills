# Small change

Read when there is a plan from the chat or a task without a plan.

## Small change

- The main session executes, an executor subagent is not needed.
- The snapshot is the folder `.swork/` in the project root. There is no topic folder and none is set up, so name the statuses, the check results, the progress and the search exclusions in the chat.
- The check before the edits, the two attempts and the decisions from section 4 apply in the same way; a decision edits the text of the plan in the chat — there is no card and no "Progress log" card.
- The conformance check and the review are done by **one** fresh subagent that has not seen the conversation. Pass it two tasks in one message — the conformance check from `references/conformance.md` and the review from `references/review.md`, each separate from the other, — and the "plan": the text of the plan from the chat or your two sentences about the task. If the edit added new code — a function, a class, a script, a new file with code — add both tasks from `references/simplify.md`; texts, settings and separate lines of existing code are not checked by the simplification. Add for the reviewer: the prohibitions and rules of each task apply only inside it; return the findings as a separate list for each task; read the changes and what they refer to directly, do not explore the project more widely — except for the task about duplicates and the task about what is redundant: they search across the whole project, not only in the changes.
- What to do with the findings — by sections 5–7, the rules are the same. The reviewer read the code before your edits made on the conformance check and the simplification: check a review finding about a place that has changed since then against the present code.
- After the work — one journal line and the other records by `references/wiki-rules.md`, section "Writing"; then the wiki check script. In the report, in "Written to the wiki", name what was written, with the same marks "new" and "extended" and the same copy into the snapshot as in step 8 of section 3.
- The report — by section 8. There is no topic, so `state.md` is not written before the report, and of the "Accept the work" order only the last item applies: the snapshot and the marker.
- Before the edit name in the chat the ready-made code that you take — the name and the file — or where you searched and did not find any.
- Before the first edit name in the chat the files that you will edit and create. This list replaces the "Files" block of a slice: by it the copies are taken, `new-files.txt` is written and the files are subtracted in the search for unreported edits. Another file is needed — first name it and take a copy. Make the snapshot, the marker and the copies by `references/snapshot.md`.
