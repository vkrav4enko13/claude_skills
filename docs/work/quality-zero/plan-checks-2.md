# Check lines of topic quality-zero, part 2

> Lines 11–20: the skill texts, `agents.sh` and the acceptance.

The same start and the same `CB` as in [part 1](plan-checks.md).

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 11 | R11 | the "roll back everything" branch of the report sets "Next step" back in `state.md` and in the topic's line of "In progress" | `grep -n 'execute the plan through' swork/references/report.md` | a line inside the "roll back everything" branch that names `state.md` and the topic's line in "In progress" | S4 | green 2026-10-16 |
| 12 | R9 | `saway` reads `state.md` before the first message | `grep -n 'before the first message' saway/SKILL.md` | one line that names `state.md` | S5 | green 2026-10-16 |
| 13 | R13 | the blind reader on the 15 old and 2 new scenarios: a user return mid-work, a decision "user chose; in force" | `bash tests/chain/away-blind.sh . "$CB/qz-blind" \| tail -1` | `17 of 17 ok` | S5 | green 2026-10-16 |
| 14 | R12 | where the wiki is not kept, `splan` takes the goal from the topic task card or the user's request | `grep -n 'task.md' splan/references/slicing.md` | a line that names the wiki not kept, `task.md` and the user's request | S6 | green 2026-10-16 |
| 15 | R14, R15 | `agents-test.sh` with two new cases: a busy and a dead owner's file together; a wiki above the git root | `bash tests/agents-test.sh \| tail -1; grep -cE 'busy and a dead\|wiki above the git root' tests/agents-test.sh` | `agents: all ok` then a number of 2 or more | S7 | green 2026-10-16 |
| 16 | goal | round N: a whole series after the last edit → zero violations and every threshold | `bash tests/chain/series.sh qz-r<N> . --stages "brain plan work seed survey grill away nonstop pair"; bash tests/chain/zero.sh qz-r<N>` | `zero: pass` | S8 | red 2026-10-16 |
| 17 | R16, R17, R18 | every "no" of the judge in a round | checked manually: read the trace the verdict cites; a wrong "no" — fix the rule in `tests/chain/rules.md` and write the quote; a right "no" — fix the skill text | the progress log has a line per "no": label, rule, wrong or right, the quote or the edited skill line | S8 | awaiting manual check |
| 18 | R20, R21 | the rounds and stand failures | checked manually: count the series `qz-r1`…; a run failed by the stand is rerun and recorded as such | at most three rounds; no stand failure counted as a round; without `zero: pass` after round 3 the report names every remaining violation with its cause | S8 | awaiting manual check |
| 19 | R22 | after the user accepts the work, the three Mac profiles hold the new texts | checked manually: `./install.sh --mac`, then `grep -l 'outside the project folder' "$HOME/claude/personal/skills/swork/references/review.md" "$HOME/claude/work/skills/swork/references/review.md" "$HOME/.codex/skills/swork/references/review.md" \| wc -l \| tr -d ' '` | `3` | S8 | green 2026-10-16 |
| 20 | R8 | the stage-7 record in its three forms → the marked one gives its id, the old marked one too, the plain one is plain | `for l in '- 2026-10-16 · stage 7 finished [s1]' '- 2026-10-16 [s2]: stage 7 [s2]: finished' '- 2026-10-16 · stage 7 finished'; do bash tests/chain/pair-check.sh --record "$l"; done` | `record: s1`, `record: s2`, `record: plain` | S4 | green 2026-10-16 |
