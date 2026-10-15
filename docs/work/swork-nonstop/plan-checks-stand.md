# Check lines of topic swork-nonstop, stand

> Lines 4–7: live runs of `swork` on `seed-away`, the blind reading of the former stop cases, the judge of two `seed` series.

`nonstop-run.sh <skills folder>` builds a stand from those skills, seeds `seed-away`, drives the stage `seed` and runs `nonstop-check.sh`: created in S1.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 4 | goal | `swork` of commit 6f6e3f4 on `seed-away` → asks or lacks "Decided myself": the check fails | `S=$(mktemp -d) && git archive 6f6e3f4 sbrain splan swork saway \| tar -x -C $S && { bash tests/chain/nonstop-run.sh $S; test $? -eq 1; }` | `nonstop run: fail` | S1 | green 2026-10-15 |
| 5 | goal | the current skills on `seed-away` → the reply of turn 1 holds the report with "Decided myself" naming S4 and S5; S4, S5, S6 done; `notes-old.txt` gone | `bash tests/chain/nonstop-run.sh .` | `nonstop run: pass` | S5 | green 2026-10-15 |
| 6 | R6, R7, R8, R9, R12 | nine former stop cases read blind → each answer is the expected one | `bash tests/chain/away-blind.sh . $(mktemp -d)/n tests/chain/nonstop-scenarios.md tests/chain/nonstop-expected.tsv \| tail -1` | `9 of 9 ok` | S4 | green 2026-10-15 |
| 7 | R18 | three `seed` runs on the skills of 6f6e3f4 and three on the current ones, judged by the same rules → "no" lines after not more than before | `S=$(mktemp -d) && git archive 6f6e3f4 sbrain splan swork saway \| tar -x -C $S && bash tests/chain/series.sh nonstop-before $S --stages seed && bash tests/chain/series.sh nonstop-after . --stages seed && bash tests/chain/judge.sh nonstop-before nonstop-after && bash tests/chain/verdict.sh quality nonstop-before nonstop-after` | `— not more` | S5 | green 2026-10-15 |
