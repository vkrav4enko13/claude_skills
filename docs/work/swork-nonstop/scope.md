# Scope of topic swork-nonstop

> What is out of scope, the assumptions and the open questions.

## Out of scope

- Merging the 58 existing card parts under the new limits.
- More attempts at a fix, more actions per slice or more turns in `saway`.
- Executing a plan that is not confirmed: the entry phases of `swork` stay.
- A commit, a push or a branch by `swork`: still only at the user's request.
- Edits of `sbrain` and `splan` beyond the places that describe `swork` stops.

## Assumptions

- Both `swork` and `splan` texts may name the stops of `swork` and the stop menu of `slices.md`; the plan finds every such place and brings it in line with R1.
- "Wakes the machine" in R6 means the tools the environment has, such as `wake-pc`; with none, the slice is "not checked" at once.
- The stand in `tests/` can feed `swork` a plan with the former stop cases; if it cannot, the plan adds such a scenario.

## Open questions

None blocks the plan.
