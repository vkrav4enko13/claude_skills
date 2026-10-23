# Numbers of topic chain-speed

> The sizes of the skills and the stand numbers before and after the levers; the outcome of R15–R17.

## Sizes

- bytes of all `.md` of a skill without `wiki-rules.md`, `wiki-block.md`, `wiki-migrate.md`, at S4 (`d1d8943`): sbrain 64972, splan 45758, swork 93359, saway 18951
- after S7, first pass (30–40 % by size, replaced): sbrain 44654 (68.7 %), splan 31486 (68.8 %), swork 65281 (69.9 %), saway 13187 (69.6 %)
- after the S7 redo (bans at the point of action and ban trap rows put back) and S8: sbrain about 46.4 KB (71 %), splan 32153 (70 %), swork about 68.3 KB (73 %), saway about 13.8 KB (73 %)

## Before

- series `cs-before`, 2 runs, lanes of `tests/chain/cs-stages.txt`, skills `d1d8943`, 2026-10-22
- per run (`compare.sh` series totals / 2): wall 3538 s, output tokens 329316, cost $20.25; median per run of the measured stages: wall 1021.5 s, output tokens 99899.5, cost $6.07
- judge (`zero.sh`): violations 9 (sbrain 0, splan 2, swork 1, saway 6, sv 0); stages 16/16, seeds 10/10, decisions 10/10, flaws 10/10; away 0/2 (`progress line: missing` both runs); nonstop and pair 0/2 — dropped lanes, expected
- `count`: `count ok` in runs 1 and 2
- roles (`levers-check.sh`): work executor 2, pass 2 in both runs; seed executor 1, pass 2, round2 1; small executor 1, pass 3 / 2, reviewer 0 / 1, stage-agent 2; every `*-plan` stage reviewer 1; away stage-agent 1
- outputs: `.swork/checks/S4-series.txt`, `S4-zero.txt`, `S4-compare.txt`, `S4-levers.txt`, `S4-count.txt`

## After

- `cs-after` (first): stopped at half — run 1 `splan` started `swork` and `swork` accepted the work without the user (the S7 slimming had dropped the bans at the point of action)
- `cs-after-2`, 2 runs, after the S7 redo and S8, 2026-10-23: per run wall 2397 s (−32 %), output tokens 219748 (−33 %), cost $13.73 (−32 %); medians per stage: wall 599.5 s (ratio 0.59), output tokens 57957 (0.58), cost $3.77 (0.62); `compare.sh` `accept: pass`, speed ×1.48
- judge: violations 8 vs 9 (sbrain 0, splan 0, swork 6, saway 1, sv 1); away 2/2 vs 0/2; stages 16/16, seeds 10/10, decisions 10/10, flaws 10/10; `count ok` ×2; traps: lines median 18 vs 25, hidden 2 vs 2
- pair judge: 1 better (away), 3 equal (seed, survey, trap-reuse), 4 worse (count, grill, small, trap-native — the worse code drops the handling of a missing or unreadable input)
- roles: executor 0 everywhere, pass 1 per code stage, plan reviewer 0, small stage-agent 0

- `cs-after-3`, 2 runs, after the R13 revert and S10, S11 (all levers but R13, plus R22, R23), 2026-10-23: per run wall 2498 s (−29 %), output tokens 216834 (−34 %), cost $13.33 (−34 %); medians per stage: wall 622.5 s (0.62), output tokens 58447 (0.59), cost $3.67 (0.61); speed ×1.42
- judge: violations 8 vs 9 (swork 6, saway 1, sv 1); away 2/2; stages 16/16, seeds 10/10, decisions 10/10, flaws 10/10; `count ok` ×2; traps: lines 23.5 vs 25, hidden 2 vs 2, overeng median 0.5 vs 0 (`compare.sh` own gate: `accept: fail — overeng`)
- pair judge: 3 better (survey, grill, away), 3 equal (count, small, trap-reuse), 2 worse (seed, trap-native)
- against `cs-after-2`: wall ×1.04, output tokens ×1.01, cost ×0.97, violations 8 vs 8 — R22, R23 add no measurable speed
- roles: executor 0, pass 1 per code stage (round 2 apart), plan reviewer 0 on these plans, small stage-agent 0

## Outcome

- R15 against `cs-before` holds on `cs-after-3`: time −29 %, output tokens −34 % per run (≥ 20 %), violations 8 ≤ 9, `count ok` ×2, pair worse 2 ≤ better 3 — the saving threshold met
- reverted by R16: R13 (S8) after `cs-after-2`; extra series used: 2 of 2 (`cs-after-2`, `cs-after-3`); `cs-after` stopped at half by the user's correction
- R22, R23: kept in the text, no measurable gain (line 23 red); keeping or reverting them is the user's choice
- the acceptance itself is the user's choice after the report
