# Progress log of topic saway-nonstop — part 3

> The records of the execution from slice S5 on.

- 2026-10-13 · S5: check before the edits — lines 20–25 red: the sentences are not in the text, no reading in `away/blind-s5`, as expected; line 26 green: the four pinned strings stand before the edit too · `checks/S5-1.txt`
- 2026-10-13 · S5: decided by the main session — the executor does steps 1–5 and lines 20–22, 24–26; step 6 and line 23 are run by the main session
- 2026-10-13 · S5: started
- 2026-10-13 · S5: executor returned `done` for steps 1–5; the edit agrees with the slice card; no unreported edits; step 6 started by the main session — the reading into `chain-stand/away/blind-s5` and the size
- 2026-10-13 · S5: noticed outside the slice — `saway/SKILL.md:93`: "Decided without you" names only `away.md`, not `.saway.md` of a work without a topic; `:17`: the return rule does not mention the progress line
- 2026-10-13 · S5: the reading of the new text gave 15 of 15 ok; size 5887 tokens of 6000
- 2026-10-13 · S5: done — lines 20–26 green · `checks/S5-2.txt`
- 2026-10-13 · S6: started — run by the main session: its steps are runs and checks; an executor is started only if a red line points at the text
- 2026-10-13 · S6: lines 27, 28 green: the three other skills are unchanged, `saway fits: 5887` · `checks/S6-1.txt`; the final blind reading and the stand run "after" started
- 2026-10-13 · S6: line 29 green — the final reading 15 of 15 · `checks/S6-2.txt`
- 2026-10-13 · S6: the stand run "after" took 1934 s and 8.69 dollars, one turn; 12 of 13 conditions pass; lines 31–35 green, lines 30 and 36 red · `checks/S6-3.txt`
- 2026-10-13 · S6: stopped — expected: `cards: english, wiki: fine`; found: `cards: cyrillic` — `away-2.md:12` of the run quotes the data word of `app.txt` in backticks as the output of `longest.sh -n`, the prose is English; why it matters: condition 13 of `away-check.sh`, as the plan words it, fails any card that quotes the project data, and no edit of `saway/SKILL.md` answers it
- 2026-10-13 · S6: the user chose "Go back to `splan`" — condition 13 of `away-check.sh` is to skip Cyrillic inside backticks; the stored run `away/after` is kept for the check after the fix
- 2026-10-13 · continued after `splan`: no files outside the plan newer than the marker; the checks of the done slices S1–S5, lines 1–26, are green again · `checks/resume-1.txt`
- 2026-10-13 · S6: stop lifted by the user through `splan` — step 5 added: condition 13 skips inline code spans; check line 37 added; the attempts start anew
- 2026-10-13 · S6: check before the edits — lines 30, 36, 37 red: `cards: cyrillic`, as expected · `checks/S6-4.txt`
- 2026-10-13 · S6: started
