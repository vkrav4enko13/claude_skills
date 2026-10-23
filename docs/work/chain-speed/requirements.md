# Requirements of topic chain-speed

> The precondition, the reduced stand, the levers of the four skills, the acceptance by one final series and the stand tools.

## Precondition

- R1. If the topic `multi-agent` is not accepted or rolled back by the user, then `swork` does not start the slices of `chain-speed`.

## Stand

- R2. A stand series of this topic runs 2 runs of the lanes `count`, `seed`, `survey`, `grill`, `away`, `trap-reuse`, `trap-native` and the small lane of R18; it drops `nonstop`, `pair`, `trap-shared-bug`, `trap-rename`, `trap-traversal`.
- R3. The rule lists of the stand cite the new `file:line` of the edited skills; a rule changes its meaning only where a lever of R6–R13 cancels it, and each such change names its lever.
- R4. Before the first skill edit, the stand runs one "before" series on the reduced stand with the current skills, and the topic records its numbers: time, tokens and cost per run, judge violations, the stand topic result, the input of the pairwise judge of R19.

## Skill edits

- R5. The skill edits go in several iterations; after each iteration only checks without a model run pass: the script of R21 and the script tests `tests/*.sh`.
- R6. Each of the four skills is slimmed the way the LGS game chain was: restatements, motivation and examples are removed, while a ban restated at the point of action (a step that decides to stop, to start another skill, to accept) and every trap row that holds a ban stay; bans, steps, stops, menus, headings, commands and paths stay; there is no size target, the saving is what the stand shows.
- R7. When the work touched code, `swork` runs conformance, simplification and review as one fresh read-only subagent pass; when it did not, `swork` skips the pass and the report says so.
- R8. `swork` builds a slice of small code (one file, up to about 20 changed lines) or without code in the main session by the rules of the executor task; a fresh executor builds a slice of larger code.
- R9. `swork` writes the slice status and the "Result" of its check lines at once; it writes "Progress log", notes and `state.md` in one batch before the report and before any stop.
- R10. When `swork` continues interrupted work, it reruns only the check lines of the slices whose files changed after their check.
- R11. `splan` starts a fresh reviewer only on a large plan: more than three slices or a slice of larger code (R8); one check line may cover several requirements that one command checks; `swork` runs no check before the edits except a bug reproduction or a baseline of a behaviour it changes.
- R12. While the work is small (the "Small" path, a plan from the chat, or a topic of at most five requirements whose plan is not large by R11), `saway` runs its stages in its own session; a stage subagent is started only for large work.
- R13. `swork` gets the ideas of `docs/work/ponytail-lean/ideas.md`, never the ponytail source: the code ladder in the executor task, a readability section in the simplification brief, an evidence bar in the review.

## Acceptance

- R14. After the last iteration the stand runs one "after" series on the reduced stand with all levers of R6–R13.
- R15. The work is accepted when the "after" series, against the "before" one, spends at least 20 % less time and tokens per run, has no more judge violations, does the stand topic right and is not worse in the pairwise judge.
- R16. If the "after" series fails a quality condition of R15, then the levers are reverted one at a time in the order R13 → R8 → R9 → the rest, each revert followed by one series, at most two extra series; then `swork` stops and shows the numbers to the user.
- R17. If quality holds and the saving is below 20 %, then the topic closes with the achieved number marked "threshold not met", and the edits stay.

## Stand tools

- R18. The stand has a small lane: a small topic at `requirements confirmed` with one requirement, which `saway` drives through `splan` and `swork`; it exercises R8, R11 and R12.
- R19. The stand has a pairwise judge: a blind reader gets the results of one lane from two series under the letters A and B and answers better, equal or worse, with a reason, for every lane.
- R20. The stand checks the result of the `count` lane: the `count.sh` it built, run on fixed inputs, prints the expected outputs.
- R21. A script checks the four skills without a model: every relative link resolves, every cited `## heading` exists, every rule citation of the stand points at a line that holds the rule, and every literal string the stand greps in a run is present in the skills.

## Ponytail speed ideas (added 2026-10-23 by the user)

- R22. When `sbrain` studies the context, `splan` makes its recon and `swork` builds a packet, each gets the code map of `sbrain/scripts/codemap.sh`: the top-level functions, classes and exports of the project by folder, at most about 2000 characters, shared folders first, tests and generated files skipped; if the script fails or the project has no code, the work goes on without the map and the search in the project stays required.
- R23. While the work is small (the "Small" path of `sbrain`, a plan from the chat or a short plan of `splan`, a small change of `swork`, small work of `saway`), each skill reads only its `SKILL.md` and the stage files its stages table marks `lite`; large work reads every stage file as today.
