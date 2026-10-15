# Check lines of topic swork-nonstop, skill texts

> Lines 8–14: no stop sections in `swork`, new statuses in `splan`, `saway` without duplicates, the rule.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 8 | R1, R2 | `swork` has no stop section and no stop menu | `{ grep -c -e '^## 4. Stops' -e '^## Stop menu' swork/SKILL.md swork/references/slices.md \|\| true; }` | `swork/SKILL.md:0` and `swork/references/slices.md:0` | S3 | green 2026-10-15 |
| 9 | R10, R11 | `splan` knows the status `bypassed`; the report has "Decided myself" | `grep -c '\`bypassed\`' splan/references/plan-format.md; grep -c '^## Decided myself\|Decided myself' swork/references/report.md` | two numbers, each 1 or more | S4 | green 2026-10-15 |
| 10 | R13, R14 | the 15 `saway` scenarios read blind on the new texts | `bash tests/chain/away-blind.sh . $(mktemp -d)/a \| tail -1` | `15 of 15 ok` | S5 | green 2026-10-15 |
| 11 | R13 | the 8 field scenarios read blind | `bash tests/chain/away-blind.sh . $(mktemp -d)/f tests/chain/fields-scenarios.md tests/chain/fields-expected.tsv \| tail -1` | `8 of 8 ok` | S5 | green 2026-10-15 |
| 12 | R14 | `saway` on `seed-away`: S5 executed and named under "Waiting for the user", S6 done, report reached | `T=$(mktemp -d) && bash tests/chain/stand.sh $T . >/dev/null && P=$T/wiki-trial/clean && bash tests/chain/seed-away.sh $P >/dev/null && bash tests/chain/drive.sh $P away $T/stage medium >/dev/null; bash tests/chain/away-check.sh $P $T/stage` | `away run: pass` | S5 | green 2026-10-15 |
| 13 | R13 | `saway` has no item about a `swork` stop | `{ grep -c 'A \`swork\` stop' saway/SKILL.md \|\| true; }` | `0` | S5 | green 2026-10-15 |
| 14 | R17 | `rules.md` keeps the first half of the old rule and the new one | `grep -c -e 'отдельный скил \`saway\` — 2026-10-11' -e 'works continuously' docs/rules.md` | `2` | S5 | green 2026-10-15 |
