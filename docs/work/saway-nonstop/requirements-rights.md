# Requirements of topic saway-nonstop: rights and going around

> What `saway` decides itself, what stays forbidden, and what it does when it meets a prohibition.

## What `saway` decides itself

- R1. When a slice is stopped, `saway` returns to `splan`, fixes the slice and goes on, whoever approved the plan.
- R2. When the work diverges from a requirement, a decision or a success criterion of the topic, `saway` chooses itself, edits the card and goes on.
- R3. When `saway` edits a plan or a card that the user approved, `saway` writes a line into `away.md`: what it was, what it became, why, and what would change otherwise.
- R4. `saway` does not do: deleting files or data it did not create, slices with a "Rollback" section, a commit, a push, a write outside the project folder, a change of `rules.md`, acceptance of the work.
- R5. `saway` takes at most two actions on one stopped slice and makes at most two returns to an earlier stage per work.

## Going around

- R6. If an action is forbidden by R4 or a slice has used up the limit of R5, then `saway` writes it into "Waiting for the user" and goes on with everything that does not depend on it: independent slices, the conformance check, the review and the report.
- R7. `saway` marks the slices that depend on a bypassed item as not started and names them in the final description.
- R8. When the conformance check and the review run after a bypass, `saway` gives them the list of bypassed items, so that these are not reported as defects.
- R9. `saway` never sets the phase `done`: the work ends as awaiting the user's acceptance.
- R10. The texts of `sbrain`, `splan` and `swork` stay unchanged; `saway` overrides their stop rules in its own text.
