# Requirements of topic ponytail-lean, part 2

> The stand: trap tasks, the two series and the acceptance.

## Trap tasks

- R19. The stand has five trap tasks, each with a hidden check script that passes a known good reference and fails a known bad one before any run: reuse of an existing helper; a bug in a shared function with two callers where the task names one; a rename that must reach fixtures and tests; input with path traversal; a feature that has a native solution.
- R20. A trap task goes through `splan` and `swork` on a topic with confirmed requirements, three runs per series.
- R21. For each trap run the stand records: delivered source lines without tests, the hidden check result, whether the risky logic has a test, output tokens, time and cost.
- R22. The judge's rules file has a rule for every new skill rule of R1–R7, R9, R12 and R15–R17, citing its skill line.

## Series and acceptance

- R23. A baseline series runs the skills of commit `cda6856` on all stages and on the trap tasks; the candidate series runs the edited skills on the same stages and tasks.
- R24. The edits are accepted only when, against the baseline, all hold: judge violations not more; stages, seeds, decisions, flaws, away, nonstop and pair not lower; trap hidden checks not lower; delivered source lines lower; wall time of the series and of the traps not higher.
- R25. If any quality measure of R24 is worse, then the ideas are switched off one at a time to find the cause, and the idea that makes it worse is not taken.
- R26. Tokens, time and cost are recorded for both series, and the report shows the speed-up as a number; tokens decide only between versions of equal quality, and the code map of R13 stays only if tokens are lower at equal quality.
