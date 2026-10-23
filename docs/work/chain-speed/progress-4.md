# Progress log of topic chain-speed, part 4

> S10–S12, stages 5–7 and the report; part 3 is [progress-3.md](progress-3.md).

- S10 [3be4b49f-ed7d-4634-98c8-2669e189b19c]: check before the edits red — no `sbrain/scripts/codemap.sh` (`S10-L19-pre.txt`); started
- S10: card edit — was: line 20 `grep -c '=== code map ==='`; became: `grep -cx`; why: the packet copies the slice card and the check line, which hold the same string; Expected unchanged
- S10 [3be4b49f-ed7d-4634-98c8-2669e189b19c]: done — lines 19 (the map of this project, 520 B, no `tests/`) and 20 (`exit 0` on an empty folder, one `=== code map ===` block in the packet) green 2026-10-23 (`.swork/checks/S10-L19.txt`, `S10-L20.txt`); `skills ok`; `bash -n install.sh` ok; install.sh not run; citation swork-2 moved to `executor.md:21`
- S10: noticed outside the slice — `sbrain/scripts/agents.sh` is not executable (always run with `bash`)
- S11 [3be4b49f-ed7d-4634-98c8-2669e189b19c]: check before the edits red — the line is in none of the four (`S11-L21-pre.txt`); started
- S11 [3be4b49f-ed7d-4634-98c8-2669e189b19c]: lines 21 (`1` in each `SKILL.md`) green; line 22 — a fresh read-only subagent listed 3 bans a light path no longer reads: sbrain approaches (show all, then recommend), swork entry (task without a plan only if one pass; a single-file plan of the earlier form not executed); fixed by marking `sbrain/references/approaches.md` and `swork/references/entry.md` `lite` (the bans are in them); `skills ok` (`.swork/checks/S11-L21.txt`)
- S11: decided myself — the second run of the line-22 subagent; chosen: the 3 places checked by grep in the now-`lite` files; why: the subagent gave the full list and the fix only widens what a light path reads; otherwise: about 170k tokens more
- S11 [3be4b49f-ed7d-4634-98c8-2669e189b19c]: done — lines 21, 22 green 2026-10-23; lite: sbrain context, survey, approaches, handoff; splan all four (slicing holds bans of any size); swork entry, finish, report, small; "read the stage file in full" now says ", on small work too" for cited sections; saway citations 87→89, 90→92, 96→98, 114→116
- S11: noticed — the slice's "a rule that says read every stage file" does not exist in `rules.md`; nothing changed there but citations
- S12 [3be4b49f-ed7d-4634-98c8-2669e189b19c]: started — series `cs-after-3`, the second and last extra series of R16
- S12 [3be4b49f-ed7d-4634-98c8-2669e189b19c]: `cs-after-3` done — against `cs-before` R15 holds: wall −29 %, output tokens −34 %, cost −34 % per run, violations 8 vs 9, count 2/2, away 2/2, pair 3 better / 3 equal / 2 worse (line 16 green on cs-after-3); `compare.sh` own gate `accept: fail — overeng` (median 0.5 vs 0 in the traps); line 23 red — against `cs-after-2` wall ×1.04, tokens ×1.01, cost ×0.97 (`.swork/checks/S12-*.txt`)
- S12: bypassed — line 23 red, no series left by R16; R22, R23 stay in the text (quality not worse, no gain measured); S9 done (lines 16, 17 green on `cs-after-3`); `numbers.md` not restored (S4 created it)
- stage 5 started [3be4b49f-ed7d-4634-98c8-2669e189b19c]
- stage 5: decided myself — the rerun of all checks; chosen: every command line rerun except line 2 (live small lane), lines 14 and 22 (subagent checks); why: the small lane passed in both after series on these skills, lines 14 and 22 were closed by phrase checks; otherwise: about $5 and 350k tokens with no new evidence; the rerun green (`.swork/checks/F5-rerun.txt`)
- S11: card edit — was: Files name "a rule that says read every stage file" and the lite lists without `approaches.md`, `slicing.md`, `entry.md`; became: citations only, and the lite lists as built; why: no such rule exists, and the three files hold bans a light path needs (line 22)
- stage 5: findings taken — the lever phrases of lines 12, 13 added to the literals of `tests/skills-check.sh`; swork-3 now names R8 (a packet only for larger code); the 240-character line cut of `codemap.sh` removed as beyond the plan (line 19: 617 B); the S11 card fixed above
- declined: usage errors exit 2 instead of 0 / 1 — every stand script does so (`series.sh`, `trace.sh`); the root "In progress" edit — swork keeps that line by its rules
- stage 5 finished [3be4b49f-ed7d-4634-98c8-2669e189b19c]
- stage 6 started [3be4b49f-ed7d-4634-98c8-2669e189b19c]
- stage 6: simplified — `compare.sh` uses `any` for the trap gate; deleted: the no-op `ext` line of `codemap.sh`, the `-f` test before the map in `packet.sh`, the `.swork*` skip of `pair-judge.sh` `changed()`, the `[ -d ]` of `levers-check.sh`, the one-caller `md_files()` of `skills-check.sh`; skipped 6: the shared `role_of` module, `links()` of `check.sh`, the judge call, the path mask, the trap walk and the seed heredocs — the plan asked for copies, a shared module rebuilds the stand; lines 3, 5–9, 19, 20 and `compare-test` green after (`.swork/checks/F5-after-edits.txt`)
- stage 6 finished [3be4b49f-ed7d-4634-98c8-2669e189b19c]
- stage 7 started [3be4b49f-ed7d-4634-98c8-2669e189b19c]
