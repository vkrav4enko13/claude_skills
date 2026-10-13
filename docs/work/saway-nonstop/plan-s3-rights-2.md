# S3. `saway` fixes a stopped slice and edits the topic cards itself — part 2

> The content of the two items of section 3 and of the new line form of section 4.

## Section 3, the item `**A `swork` stop**`

Replace the present item. It says, in this order:

- The cause is in the environment — repair it and run the check again. The cause is in the plan — the code differs from the plan, the check is red after two attempts, or it is green before the edits — return to `splan` and fix the slice, whoever approved the plan and whatever action the stop menu of `swork` offers for that stop.
- The return: `swork` only names the topic folder — start `splan` on the topic yourself. Answer its entry question with "we continue from it". Fix the cards of that one slice and its check lines in place; the slice numbers do not change. The stop before writing is skipped for such a fix; a question of the plan review is answered by this section; the shown fix is approved by the item "Approval".
- After `splan`: set the phase in `state.md` and in the topic's line of the root index back to `execution in progress`; set the status of the slice to `not started`; add to "Progress log" the line `S<N>: stop lifted without the user — <what was fixed>`. The attempts of `swork` on this slice start anew, as after a stop the user lifted. Then start `swork`.
- At most two such actions per slice. Count them by the lines of `away.md`, not by the status of the slice. Such a return is an action on the slice; it is not one of the two returns to an earlier stage per work.
- After the second action, or if the action needs the user: the slice stays "stopped" — keep the present wording; S4 replaces it.

## Section 3, the new item `**A divergence from the topic cards**`

Put it right after the item about a stop:

- When the work cannot agree with a requirement, a decision with the status "in force" or a success criterion of the topic, choose yourself by the items above, edit the card in place and go on. A success criterion may be weakened or dropped.
- This overrides: "edited by no one" of `swork` for the goal, the shared constraints and "Not doing" of the plan; "edited with consent" and "only their explicit yes" of `splan`.
- A replaced decision is written by "Replacement and archive" of the wiki rules: the old line gets the status "superseded", the new one is marked `assumption — decided without the user`, never "user chose".
- A rule of `rules.md` is not such a card: it is not edited.

## Section 4, the line form

Add after the present line form: an edit of a plan or of a card that the user approved is recorded as `- <card>: <what> — was: <…>; became: <…>; why: <argument>; otherwise: <what would change>`. Write it before the edit is made.
