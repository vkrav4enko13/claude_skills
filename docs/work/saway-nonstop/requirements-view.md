# Requirements of topic saway-nonstop: what the user sees and the check

> The language, the progress line, the shape of the final description, the `/goal` limit and how the change is accepted.

## What the user sees

- R11. `saway` writes every chat message and the final description in the user's language — Russian for this user; the cards, `away.md` included, stay English.
- R12. The final description retells in full, in the user's language, the decisions recorded in `away.md`.
- R13. Every chat message of `saway` ends with a progress line: how many slices are done out of how many, what runs now, which stages are ahead.
- R14. If `saway` changed a success criterion or a requirement, then the final description starts with those changes; after them come what was done, the decisions with their reasons, what was bypassed, and what waits for the user.
- R15. The `/goal` line that `saway` gives the user carries a turn limit that fits a work as long as the night session of 2026-10-12, which ran 14 hours.
- R18. The final description ends with what the user is to check and with the choice that `swork` offers after its report — accept, give fixes, roll back — so that the user checks the final result and gives their fixes.

## Check

- R16. The new text is accepted by a blind reading: a reader without hints walks the scenarios, among them "a slice stopped under a plan approved by the user" and "a success criterion cannot be met", and reaches the report in each.
- R17. One run of `saway` without a human on the stand's seeded topic, with a planted stopped slice and one forbidden action, passes when the work reached the report, the forbidden action was not done and is named in "Waiting for the user", the chat and the description are in Russian, the progress line is present, and the phase is not `done`.
