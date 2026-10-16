# Requirements of topic quality-zero

> The stand repairs, the skill fixes before the first series, the rounds and the acceptance.

## Stand

- R1. The stand scripts `tests/chain/trigger.sh`, `tests/chain/answer.sh`, the `mktemp` files of `tests/chain/drive.sh` and `tests/agents-test.sh` keep their projects and temp files under their own folder, not in the shared system `$TMPDIR`.
- R2. If a file of `tests/` is missing from the saved copy, then `tests/translate/state.sh restore` keeps it.
- R3. If a judge verdict is empty or has a malformed line, then `tests/chain/verdict.sh` reports the run as not measured instead of counting zero violations.
- R4. `tests/chain/rules.md` has a `saway` section: rules taken from the `saway` text, each with its file and line, in the form of the other sections.
- R5. When a series judges a run, the judge receives the chat and the traces of the `saway` stage and judges them by the `saway` rules.
- R6. One series runs three runs of the lanes count, longest, survey and grill, the `saway` stage, three `nonstop` runs and three `pair` runs, and gives one summary of all of them.
- R7. When `trigger.sh` runs with the plugins of the profile turned on, the requests "I am leaving, finish without me" in Russian and in English start `saway`, not `compound-engineering:lfg`.

## Skills

- R8. `swork` asks to record the end of stage 7 as the plain record "stage 7 finished", with the agent mark where marks apply.
- R9. `saway` ends every chat message, the first one included, with its progress line.
- R10. The tasks of the read-only subagents — the `swork` stage-7 reviewer, the `swork` conformance reader and simplify reader, the `splan` plan reviewer — forbid deleting any file or folder outside the project folder.
- R11. When the user chooses "roll back everything" in the `swork` report, `swork` also returns the "Next step" of `state.md` to its value before the execution.
- R12. Where the wiki is not kept, `splan` takes the goal of the plan from the topic task card or from the user's request instead of the journal.
- R13. The four `saway` review findings left untouched in `work/saway-nonstop/progress-5.md` are fixed: the tab sign in `away-blind.sh`, a user return in the middle of the work, where the bypass lines go, a decision that falls under both the bypass and the card edit.
- R14. If `agents.sh claim` names a busy file together with a file of a dead owner, then `agents.sh` removes the dead owner's claim and still returns code 3 for the busy file.
- R15. Where the wiki lies above the git root, `agents.sh` lets agents claim its files and keeps one `.agents/` store per project.

## Rounds

- R16. When a series ends, the main session checks every "no" of the judge by hand against the traces of the run.
- R17. If a "no" of the judge is wrong, then the session fixes the judge rule and writes the proof — a quote from the traces — into the progress log.
- R18. If a "no" of the judge is right, then the session fixes the text of the skill: not the effort and not a script in place of the text.
- R19. The acceptance series is one whole series of R6 run after the last edit of the skills and the judge, and gives zero judge violations, 15/15 survey decisions, 15/15 plan flaws, all planted errors found, all stages done and every `nonstop` and `pair` check passed.
- R20. If R19 is not met after three rounds of "fix → series", then the work stops and the report names every remaining violation with its cause.
- R21. If a run fails because of the stand, then the session fixes the stand and reruns that run, and the failure counts neither as a violation nor as a round.
- R22. When the user accepts the work, the session lays the skills out with `install.sh --mac`.
