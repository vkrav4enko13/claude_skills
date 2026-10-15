# S3. swork decides instead of stopping — part 2

> What to do in each file; the decisions for every former stop case.

1. `SKILL.md`: section 4 becomes `## 4. Own decisions` — "`swork` does not stop and does not ask in the middle of the work; it waits only in the menu after the report and at entry by the phase table". A table: former case → decision, as in step 2. Lines 14, 16, 24, 79: drop "at a stop"; `state.md` is written before the report and before the end of a session. Line 28: "does not plan" gets the exception of the own edits of step 2. Line 75: environment → step 2. Line 77: the main session also makes the own card edits; the goal, shared constraints and "Not doing" stay edited by no one. Line 64: the status `stopped` → `bypassed`. Traps: "Two attempts, then a stop" → "then an own edit of the card, then bypass"; add "I will wait for the user" → "Flag it in the chat and go on"; keep "The code is fixed, not the check".
2. `slices.md`: replace "Stop menu" by `## Decisions and bypass`:
   - code differs not minorly, red after two attempts, green before the edits without the mark, `need a file` → edit this slice card and its check lines, at most twice per slice; write "was → became → why" into "Progress log" before the edit; never "Expected" or a scenario value; the count of attempts starts anew after an edit;
   - two edits used → status `bypassed`; a slice never `done` before: restore from `base/` the files no `done` slice names and delete its files of `new-files.txt` that no `done` slice names; a slice that was `done`, or has "Rollback": nothing is restored; dependents — "Depends on" directly or by a chain, or a shared file — not executed; everything else executed;
   - "Rollback" slice → the saving, then the slice; the saving fails → `bypassed`;
   - environment → one try to restore it, then status `not checked`, the work goes on;
   - manual check with dependents → dependents executed and marked "on unchecked ground"; only the user sets "done";
   - each decision → the `⚠` chat line and the log line, then the next step without waiting.
