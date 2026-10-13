# Check lines of topic saway-nonstop: going around

> Lines 9–14: the limits, the prohibitions, the independent and the dependent slices, the reviewers and the phase — by the blind reading that step 6 of S4 stored.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 9 | R5 | `saway` took two actions on a slice and it stopped again; two returns to an earlier stage are used and a third is needed → both are bypassed, the work goes on | `grep -E '^B[45] ' ~/Documents/my/chain-stand/away/blind-s4/result.txt` | two lines: `B4 <letter> ok`, `B5 <letter> ok` | S4 | green 2026-10-13 |
| 10 | R4 | the next slice has a "Rollback" section; the work diverges from a rule of `rules.md` → the slice is not started and is written into "Waiting for the user", `rules.md` is not changed, the work goes on | `grep -E '^B(6|11) ' ~/Documents/my/chain-stand/away/blind-s4/result.txt` | two lines: `B6 <letter> ok`, `B11 <letter> ok` | S4 | green 2026-10-13 |
| 11 | R6 | a slice is bypassed, another has "Depends on: none" and no file in common with it → that slice is executed | `grep -E '^B7 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt` | a line `B7 <letter> ok` | S4 | green 2026-10-13 |
| 12 | R7 | a slice is bypassed, another names it in "Depends on" → that slice stays `not started` and is named in the description | `grep -E '^B8 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt` | a line `B8 <letter> ok` | S4 | green 2026-10-13 |
| 13 | R8 | the conformance reviewer reports the files of a bypassed slice as missing → the finding is dropped, no executor is started for the slice | `grep -E '^B9 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt` | a line `B9 <letter> ok` | S4 | green 2026-10-13 |
| 14 | R9 | the report is shown and the recommended option is "accept the work" → `saway` does not accept and the phase is not `done` | `grep -E '^B10 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt` | a line `B10 <letter> ok` | S4 | green 2026-10-13 |
