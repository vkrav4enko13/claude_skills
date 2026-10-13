# Design of topic saway-nonstop: rights and going around

> Sections 1 and 2 as approved on 2026-10-13.

## 1. What `saway` decides itself

**What the user gets:** the work does not stop because the user once approved a decision.

- A slice stopped — `saway` returns to `splan`, fixes the slice and continues, whoever the plan belongs to.
- The work diverged from a requirement, a decision or a success criterion of the topic — `saway` chooses itself, edits the card and goes on.
- Every such edit is recorded in `away.md` as a line "was — became — why — what would change otherwise".
- **Stays forbidden:** the irreversible (deleting others' files and data, slices with a rollback), commit and push, a write outside the project folder, the rules of `rules.md`, acceptance of the work.
- **The limits stay:** at most two actions per slice and two returns to an earlier stage — so that a stuck slice does not burn the limit in a loop.

## 2. Met a prohibition — goes around

**What the user gets:** one forbidden point does not stop everything else.

- A forbidden action or a slice that used up its limit is written into "Waiting for the user".
- Everything that does not depend on it goes on: independent slices, the conformance check, the review, the report. Slices that depend on the bypassed item are marked as not started and named in the description.
- The conformance check and the review get the list of what was bypassed, so as not to count it as a defect.
- Without the user the topic does not get the phase `done`: the work ends at "awaiting acceptance" even when everything is green.
- Only the text of `saway` is edited: by the user's rule `sbrain`, `splan` and `swork` are not changed for absence; `saway` overrides their rule "nothing starts while a slice is stopped" in its own text.
