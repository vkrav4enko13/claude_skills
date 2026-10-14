# Progress log of topic chain-tokens

> A line per record of the execution: slices, attempts, stages, what was written to the wiki.

- Exclusions of the search for unreported edits: files that `git check-ignore` answers 0 for (the project has no `.gitignore` — none); the stand data lies outside the project, in `~/Documents/my/chain-stand`
- Checked against code: the plan names commit `1c4f384`; HEAD is the same and `tests/`, the four skills and `install.sh` are clean — no discrepancy
- S1: started
- S1: done — lines 1,2,3 green · `checks/S1-2.txt`
- S2: started
- S2: done — lines 4,5,6,7 green · `checks/S2-2.txt`
- S3: started
- S3: done — lines 8,9,10,11 green · `checks/S3-2.txt`
- S4: started
- S4: attempt 1 of 2 — the `swork` main session raised to `high` by the gate procedure; violations 8 against 5, gate failed
- S4: attempt 2 of 2 — `swork` raised to `xhigh`; every `work` turn hit the session limit of the account, no measurement; the `away` run fails at all three levels on `progress line: missing`
- S4: stopped — expected: the baseline at `medium` passes the gate and one `away` run passes; found: violations 6 (medium) and 8 (`swork` at `high`) against 5 of `en`, the third series cut by the usage limit, `away-check.sh` wants three replies with a progress line; why it matters: no baseline, S5–S12 depend on it
- S4: stop lifted by the user 2026-10-14 — "strictly medium, reduce the errors": the raises are rolled back (`swork/SKILL.md`, `saway/SKILL.md`, `tests/chain/rules.md` from `base/`, `raised.tsv` to the header), R5 and R7 changed, slice S13 added before S4
- S13: started
- S13: done — lines 42 green · `checks/S13-2.txt`
- S13: tails of `tests/chain/rules.md` into `report.md` and `topic-cards.md` were already off by 2–6 lines; re-pointed
- S4: started again on the user's word, after S13
- S4: could not — second `medium` series: stages 11/12, seeds 10/15, violations 9 against 5; 7 of 9 are English opening replies (sbrain-13, splan-26, swork-26), one swork-20, and run 2 stopped `swork` on a discrepancy in done slices; output per run 89412 (−77 % against `en`)
- S4: the user chose 2026-10-14 — slice S14 with three text fixes, then the second and last rerun of S4
- S14: started
- S14: done — lines 43 green · `checks/S14-2.txt`
- S14: deviation — the main session added a dash before "and the file with the full output" in `swork/references/report.md:13`: the ready text left the sentence without a separator
- S4: started — the last rerun, after S14
- S4: the series `medium` passed the gate (stages 12/12, seeds 15/15, violations 4 against 5; output per run 99802); the `away` run failed on `forbidden: done` (a false match of `away-check.sh`) and `progress line: missing` — the user chose 2026-10-14 to accept the baseline and move the `away` fixes into S8; line 12 no longer asks the `away` run to pass
