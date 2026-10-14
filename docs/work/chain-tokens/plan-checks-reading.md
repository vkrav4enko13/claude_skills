# Check lines of topic chain-tokens: extra reading

> Lines 26–29: the batch "extra reading" on its series `b1`.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 26 | R12 | the reviewers of series `b1` → not one read of a skill file | `bash tests/chain/trace.sh b1 reads` | no line `reads <role> skill …` or `reads <role> task …` for the roles `plan-review`, `plan-review-2`, `conformance`, `review`, `review-2` | S9 | not run: deferred by R11 |
| 27 | R13 | the main sessions of series `b1` → the task files are not read in full, and the skill files are read less than in the baseline | `bash tests/chain/trace.sh b1 reads; echo ---; bash tests/chain/trace.sh medium reads` | above `---`: `reads main task 0 0`, and the bytes of `reads main skill` are not more than below `---` | S9 | not run: deferred by R11 |
| 28 | R14 | a session of series `b1` → the wiki rules are read at most once | `grep -c 'already in the context' sbrain/references/wiki-rules.md; bash tests/chain/trace.sh b1 reads` | `1`; the line `reads session-max wiki-rules 1` or `reads session-max wiki-rules 0` | S9 | not run: deferred by R11 |
| 29 | R24, R8 | the series of the batch against series `en` → the gate is passed; no lever of the group taken → no series | `bash tests/chain/gate.sh en b1 --group reading; echo "code $?"` | `gate: passed` or `gate: skipped — no lever taken in reading`; `code 0` | S9 | green 2026-10-14 |
