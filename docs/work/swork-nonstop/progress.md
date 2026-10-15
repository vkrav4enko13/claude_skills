# Progress log of topic swork-nonstop

> The slice records of the execution: starts, attempts, outcomes and decisions.

- Start 2026-10-15: git, snapshot `docs/work/swork-nonstop/.swork/`; all 238 changed paths at the start lie in `docs/`
- Exclusions of the search: what `git check-ignore` reports (no `.gitignore` in the project); the wiki folder `docs/` as a whole
- "Checked against code" 6f6e3f4: no slice file changed since — `git diff 6f6e3f4 -- sbrain splan swork saway tests` is empty
- Order: S1, S2, S3, S4, S5
- S1: started
- S1: done — line 4 green: the old `swork` stops at S4 in turn 1, no "Decided myself"; output `.swork/checks/S1-1.txt`
- S2: started
- S2: done — lines 1, 2, 3 green; output `.swork/checks/S2-1-l1.txt` … `S2-1-l3.txt`
- S2: noticed outside the slice — `tests/translate/map.tsv:197,199` keeps the old limit messages; a translation record, not touched
- S3: started
- S3: done — line 8 green; output `.swork/checks/S3-1.txt`
- S3: noticed outside the slice — `report.md:14` still names "the list of stops" (S4); `saway/SKILL.md` 56, 81, 84–91 still hold the moved rules (S5); "this is not a stop" phrases in `slices.md:16`, `entry.md:16,32`, `finish.md:17` are still true, left
- S4: started
- S4: decided myself — the check before the edits; chosen: line 9 only, line 6 (blind reading, 10–60 min) not run before; why: line 9 already shows the slice is absent; otherwise: an hour spent to learn the same
- S4: done — lines 6, 9 green: `9 of 9 ok`, `1`/`1`; output `.swork/checks/S4-1-l6.txt`, `S4-1-l9.txt`
- S4: noticed outside the slice — `report.md` "Found and left untouched" still names "not closed in two attempts", which may overlap "Bypassed"; not reworded
- S5: started
- S5: decided myself — the check before the edits; chosen: lines 13, 14 only, the live and blind lines (5, 7, 10, 11, 12; hours) not run before; why: line 13 already shows the slice is absent, line 7 runs its own "before" series; otherwise: hours spent to learn the same
- S5: lines 5, 10, 11, 12, 13, 14 green — `nonstop run: pass` (report in turn 1, decided S4 S5), `15 of 15 ok`, `8 of 8 ok`, `away run: pass`, `0`, `2`; line 7 running
- S5: done — line 7 green: `violations: before 3, after 3 — not more` (swork-20 ×2 and swork-26 on both sides); output `.swork/checks/S5-1-l7.txt`
