# Progress log of topic ponytail-lean

> The records of `swork`: slices, attempts, own decisions, stages and what was written to the wiki.

- preparation [40cde817-9efe-4435-83a7-aad9b183ba52]: snapshot `docs/work/ponytail-lean/.swork/`, project under git, 241 paths dirty at start (`dirty-at-start.txt`), marker of agent 14562:1792268853
- preparation [40cde817-9efe-4435-83a7-aad9b183ba52]: exclusions for the unreported-edit search — files for which `git check-ignore` answers 0; the project has no `.gitignore`, so in practice none; always skipped: the snapshot, `docs/`, `.agents/`, `.swork-*`, `.git/`; stand outputs go to `~/Documents/my/chain-stand/`, outside the project
- preparation [40cde817-9efe-4435-83a7-aad9b183ba52]: "Checked against code" cda6856 — HEAD is cda6856 and no slice file is changed in the working tree; no discrepancy
- order [40cde817-9efe-4435-83a7-aad9b183ba52]: S1, S2, S6, S8 (no dependencies), then S3, S4, S5, S7, S11, S9, S10, S12, S13
- S1 [40cde817-9efe-4435-83a7-aad9b183ba52]: started — pre-edit check red: no `codemap-test.sh`, no map block in the packet, no `codemap.sh` in the stand box · checks/S1-l1-0, S1-l6-0, S1-l9-0
- S1 [40cde817-9efe-4435-83a7-aad9b183ba52]: decided myself — line 5 exits 1 because `grep -c` with no match returns 1 while printing the expected `0`; chosen: green; why: the expected output (405 characters, then `0`) can only come with that exit code; otherwise: a card edit adding `|| true`
- S1 [40cde817-9efe-4435-83a7-aad9b183ba52]: done — lines 1–9 green (map of this repo 405 characters, no `tests/` block; hung map: packet in 10 s without the block) · checks/S1-l1-1 … S1-l9-1
- S1 [40cde817-9efe-4435-83a7-aad9b183ba52]: noticed outside the slice — `swork/scripts/packet.sh` map block: `kill` stops the bash running `codemap.sh` but not its children; a hung child (`sleep 60` in line 8) keeps running until it ends
- continuation [40cde817-9efe-4435-83a7-aad9b183ba52]: the oldest marker is this agent's own (14562:1792268853), kept; HEAD still cda6856, the files changed since the marker are only S1's; no foreign edits; S1 lines 1–9 rerun green (line 5 code 1 as decided before) · checks/S1-l1-2 … S1-l9-2
- S2 [40cde817-9efe-4435-83a7-aad9b183ba52]: started — pre-edit check red: none of the rule phrases and no `LADDER:`/`GAPS:` in `swork/references/executor.md` · checks/S2-l10-0 … S2-l13-0
- S2 [40cde817-9efe-4435-83a7-aad9b183ba52]: done — lines 10–13 green · checks/S2-l10-1 … S2-l13-1
- S2 [40cde817-9efe-4435-83a7-aad9b183ba52]: noticed outside the slice — the line numbers in the "Files" block of S2 are one off after S1's packet item (rule 4 at `:39-40`, rule 8 `:52-54`, rule 10 `:56`, reply form `:60-67`); the rules were found by number, the meaning is the same
- S2 [40cde817-9efe-4435-83a7-aad9b183ba52]: gaps — no search of other skill files for text citing the old wording of rules 4 and 8; rule 8 names the code map, which needs S1's packet block at run time
- S6 [40cde817-9efe-4435-83a7-aad9b183ba52]: started — pre-edit check red: neither closing sentence in the four files · checks/S6-l26-0, S6-l27-0
- S6 [40cde817-9efe-4435-83a7-aad9b183ba52]: done — lines 26, 27 green · checks/S6-l26-1, S6-l27-1
- S8 [40cde817-9efe-4435-83a7-aad9b183ba52]: started — pre-edit check red: no `tests/chain/trap-test.sh` · checks/S8-l35-0
- S8 [40cde817-9efe-4435-83a7-aad9b183ba52]: done — line 35 green: five `trap <name>: ok`, `traps: all ok` · checks/S8-l35-1
- S8 [40cde817-9efe-4435-83a7-aad9b183ba52]: noticed outside the slice — `tests/chain/seed-pair.sh:34-46` `state()` writes the older state form (`Path:`, `Verified:`) while `sbrain/references/topic-cards.md` names three lines; `seed-trap.sh` copies it as "Reuse" says, so the trap topics carry the older form too
- S3 [40cde817-9efe-4435-83a7-aad9b183ba52]: started — pre-edit check red: `simplify.md` still has its own ladder and boundary list, no `ladder.txt`, no "Debt" · checks/S3-l14-0 … S3-l17-0
- S3 [40cde817-9efe-4435-83a7-aad9b183ba52]: decided myself — line 15 exits 1 because its second `grep -c` finds no match and returns 1 while printing the expected `0`; chosen: green; why: the expected output (`3`, then `0`) can only come with that exit code, as for S1 line 5; otherwise: a card edit adding `|| true`
- S3 [40cde817-9efe-4435-83a7-aad9b183ba52]: decided myself — line 14 exits 2 because the folder `hooks/` it greps does not exist until S7 (`2>/dev/null` hides the message, not the code), while it prints the expected `swork/references/executor.md` only; chosen: green now, rerun after S7 and at stage 5; why: the slice's content is right and the code comes from a later slice's folder; otherwise: a card edit of the command
- S3 [40cde817-9efe-4435-83a7-aad9b183ba52]: done — lines 14–17 green · checks/S3-l14-1 … S3-l17-1
- S3 [40cde817-9efe-4435-83a7-aad9b183ba52]: noticed outside the slice — `swork/references/conformance.md:13` the last bullet of "What to pass" ends with ";" as the plan worded it
- S4 [40cde817-9efe-4435-83a7-aad9b183ba52]: started — pre-edit check red: none of the new review phrases, `references/executor.md` not named · checks/S4-l18-0 … S4-l21-0
- S4 [40cde817-9efe-4435-83a7-aad9b183ba52]: decided myself — line 21 exits 1 because its second `grep -c` finds no match and returns 1 while printing the expected `0`; chosen: green; why: the expected output (`1`, then `0`) can only come with that exit code, as for S1 line 5; otherwise: a card edit adding `|| true`
