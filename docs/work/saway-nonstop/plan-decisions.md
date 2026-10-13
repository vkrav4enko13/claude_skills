# Technical decisions of topic saway-nonstop

> What the plan chose, instead of what and why.

## Technical decisions

- **The `/goal` limit is 100 turns** — instead of 40 or a time clause: the night of 2026-10-12 took 64 turns in 14 h 22 min with 4.4 h of standstill, 85–105 without it. `saway` names the turn itself.
- **The forbidden action on the stand is a slice with "Rollback"** — instead of a deletion, a write outside the project or a commit: the stand refuses deletions itself, an outside write would be real, there is no git.
- **The stand run is one turn without an answer loop** — instead of the six answers of `drive.sh`: `saway` reads any answer as the user's return, and "accept the work" would set `done`.
- **A slice is independent when it neither depends on the bypassed one through "Depends on" nor shares a file with it** — instead of "Depends on" alone: a stopped slice keeps its half-made edits.
- **A third return to an earlier stage is a bypass** — instead of stopping the work. A return to `splan` lifts the stop of the slice and starts the attempts anew; the count of actions is read from `away.md`.
- **Findings about bypassed slices are dropped by `saway` at screening, and the reviewers get the list in one sentence** — instead of leaving stage 5 as it is: it would start the executor of a bypassed slice.
- **Both last lines of the description stay word for word**; `saway: work finished` covers a report reached with bypassed items — instead of a third line: the `/goal` condition and `map.tsv` pin them.
- **In the description the progress line stands right before the last line** — the last line is fixed word for word.
- **The progress line has a fixed form** `Progress: slices <done>/<total> · now: … · ahead: …`: the stand check finds it by `<digits>/<digits> · `.
- **The size limit of `saway/SKILL.md` is 6000 tokens, one file** — instead of 5000 or a tail moved into `references/`: the text is 4274 now and the edits add about 1300; the user chose on 2026-10-13. The file is reread before the description.
- **Checks "before" on the present text** — a blind reading and one stand run that must fail — instead of trusting new checks: they prove the checks tell the old behaviour from the new.
- **Condition 13 of `away-check.sh` skips Cyrillic inside inline code spans** — instead of any Cyrillic in `away*.md`: the acceptance run quoted a data word of the stand project in an English card. A quote in a fenced block or without backticks still counts — accepted: the cards of the run have none. The edit goes into S6, S1 stays done; lines 30–36 read the stored run, no new run.

The check focus — in [part 2](plan-decisions-2.md).
