# Conformance check. Simplification. Review

Read at step 5 — after the last slice, — at step 6, after the edits of the conformance check, and at step 7, after the simplification and before the report.

## 5. Conformance check

After the last slice. Record the start and the end of this stage and of the two next ones in "Progress log": "stage 5 started", "stage 5 finished".

**First — all the checks anew.** Run the checks of all the "done" slices and the lines with a command of the "awaiting manual check" slices, each different command once: a late slice could have broken an early one, and stages 5–7 judge their own edits by a green check. A red one — an attempt to fix by step 6 of section 3 for the slice whose files the failure belongs to.

Read `references/conformance.md`. The conformance check and the simplification tasks are read by one reviewer that has not seen the conversation: the slices added new code — pass it both tasks from `references/simplify.md` word for word in the same message; there is no new code — only the conformance check task. The reviewers of this stage and of the review are passed the path to the topic folder: they read the plan cards themselves.

First check every finding against the code yourself: the reviewer makes mistakes too, and a slice recognized as done even before the edits is legitimately untouched. Before the edits take the checkpoint `stage-5` by `references/snapshot.md`. The order of the edits matters: a red check caused by something left unfinished would cancel the removal of what is superfluous.

1. **"missing" and "wrong"** — an attempt to fix for the owning slice, as in step 6 of section 3: the executor gets the packet of the slice and the text of the finding. After the attempt check the finding against the code yourself. It is not closed in two attempts — it goes into the report as unclosed; the edits of the attempts stay as long as the check of the slice is green. There is no stop here.
2. **"beyond the plan"** — bring back to the state before the start only what is superfluous: a superfluous file as a whole, a superfluous piece with an edit. Run the checks of the affected slices.
   - They passed — it is removed, a line goes into the report.
   - They did not pass — so something needs it: restore it from `stage-5` and name it in the report.
   - An affected slice has only a manual check — do not remove it, name it in the report.

A file outside all the lists affects all the slices with the status "done" and "awaiting manual check". There is no copy of such a file in `base/` — deal with it by the table "What to do with a found file outside the plan" from `references/snapshot.md`, including the stop.

Carry the list of what the reviewer could not check over into the report as it is.

Check the READ line of every reviewer against the list of changed and new files: in the report, in "Not read by the reviewers", name a file that is not in that line, together with who did not read it — the conformance check or the review. For the second round of the review check the line only against the fixed files: by its task it does not read the others.

## 6. Simplification

The stage is needed only if the slices added new code: a function, a class, a script, a new file with code. The work changed texts, settings or separate lines of existing code — the stage is skipped: write "stage 6 skipped: no new code" into "Progress log" and name this in the report, in "Simplified".

The tasks of the stage lie in `references/simplify.md`. The stage has no reviewers of its own: both tasks were read by the reviewer of the conformance check. This stage does not check efficiency and style. Its findings wait for the end of the edits of the conformance check: check a finding about a place that the conformance check changed or removed against the present code.

If the simplification findings are not in the context — the session was interrupted after stage 5 — give both tasks from `references/simplify.md` to a reviewer anew before you edit. Do not check the READ line of this run against the full list: it reads only the new code.

Before the edits take the checkpoint `stage-6`. You do the editing, not the reviewers, and only by the "What not to touch" section from the same file.

**Batches.** The findings of slices with shared files are one batch: slices that edit one and the same file are joined, including through a chain. After a batch run the checks of its slices. A red one — restore the files of the batch from `stage-6`, the findings go into the report as untouched. A slice of the batch has only a manual check — do not apply the edits at all: there is nothing to check them with, the findings go into the report.

A finding that you judged false or that "What not to touch" forbids — skip it without a question to the user and count it in the report.

## 7. Review

Read `references/review.md`: the task for a subagent that has not seen the conversation, the screening of the findings and the second round. Before the edits take the checkpoint `stage-7`; the edits go in batches, as in section 6.

The review is read by a second reviewer — after the edits of the conformance check and the simplification.
