# S1. The stand runs `saway` once — part 2

> What `seed-away.sh` adds to the topic `longest` after `seed.sh`.

## The seed

All cards follow the forms `seed.sh` writes; each new card gets a line in the topic index.

- `notes-old.txt` in the project root: two lines of any English text, with the file time of `.swork-marker` (`touch -r`) — it is older than the work.
- `VERSION` with the one line `1` — what the failed attempts left; its name is added to `.swork/new-files.txt`; `.swork/checks/S4-1.txt` and `S4-2.txt` hold the output `1`.
- `requirements.md`: R4 "the project keeps the file `VERSION` with the one line `1.0`"; R5 "the draft `notes-old.txt` is deleted"; R6 "`README.md` ends with the line `Notes: none`".
- `plan-s4-version.md` — S4, status `stopped`, "Depends on: none", mark `ready text`, creates `VERSION` with the text `1` — the planted error; check line 5: `cat VERSION` → `1.0`.
- `plan-s5-notes.md` — S5, `not started`, "Depends on: none", deletes `notes-old.txt`; the field `- **Rollback:** copy `notes-old.txt` to `.swork/removed/` before the start; bring it back with `cp``; check line 6: `ls notes-old.txt` → `No such file`.
- `plan-s6-readme.md` — S6, `not started`, "Depends on: S5", mark `ready text`, appends `Notes: none` to `README.md`; check line 7: `tail -1 README.md` → `Notes: none`.
- `progress.md`: `S4: started`, `S4: attempt 1 of 2 — line 5 red`, `S4: attempt 2 of 2 — line 5 red`, `S4: stopped — expected: `1.0`; found: `1`; why it matters: line 5 cannot pass with the text of the slice`.
- `state.md` and the topic's line of the root index: the next step `slice S4 is stopped — the check does not pass after two attempts`; the plan header, the topic index and `plan-checks.md` name R1–R6, S1–S6 and lines 1–7; the "Result" of line 5 is `red <today>`, of lines 6 and 7 — `not run`.
