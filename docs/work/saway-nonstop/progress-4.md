# Progress log of topic saway-nonstop — part 4

> The records of the end of S6 and of stages 5 and 6.

- 2026-10-13 · S6: executor returned `done` for step 5: one substitution in `tests/chain/away-check.sh:155`; no unreported edits
- 2026-10-13 · S6: done — lines 27–37 green · `checks/S6-5.txt`
- 2026-10-13 · stage 5 started; all the checks anew: lines 1–37 green · `checks/S6-5.txt`
- 2026-10-13 · stage 5: the reviewer returned 3 "wrong", 3 "beyond the plan", no "missing"; checkpoint `stage-5` taken
- 2026-10-13 · stage 5: beyond the plan — the second paragraph of the reader task in `tests/chain/away-blind.sh` removed by the main session: `plan-s2-blind.md` step 3 quotes the task as one paragraph; tested by a new final reading
- 2026-10-13 · S2: attempt 1 of 2 on the finding "B14 and B15 are two lines each" — the executor breaks the present sentences onto three lines
- 2026-10-13 · S2: attempt 1 closed the finding — B14 and B15 are three lines each, no statement changed; the new final reading on the present files gave 15 of 15; lines 5, 29 green · `checks/stage5-1.txt`
- 2026-10-13 · declined: `chat: not russian` for a chat without replies is wrong — the plan names no such case, and a run without a chat must not pass condition 10
- 2026-10-13 · declined: `perl -CSDA` instead of `-CSD` in the chat block — the flag `A` decodes the reply passed as an argument; without it line 12 cannot match
- 2026-10-13 · declined: the tolerant reading of `verdict.tsv` and the file `reader.json` are beyond the plan — they are how the comparison and the reader call of step 3 are made, at the boundary with an outside reply
- 2026-10-13 · stage 5 finished
- 2026-10-13 · stage 6 started; checkpoint `stage-6` rebuilt from `stage-5` after a failed copy command, before any check ran
- 2026-10-13 · stage 6: one batch S1+S6 — unused `phase=''` of the stage `away` in `drive.sh`; in `away-check.sh` two single-use variables, a needless `^.*` and `/m`, an empty `then` branch, a hand-written type test replaced by `[]?`, a header comment that named a list that does not exist; lines 1–4, 27–37 green · `checks/stage6-1.txt`
- 2026-10-13 · declined: take `done` of `stage.json` instead of the search in `progress*.md` — `plan-s1-stand-3.md` words condition 1 through `progress*.md`
- 2026-10-13 · stage 6 finished
- 2026-10-13 · stage 7 started; checkpoint `stage-7` taken
