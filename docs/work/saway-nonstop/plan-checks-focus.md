# Check lines of topic saway-nonstop: the check focus

> Lines 15–19: a restart, a shared file, the phase after `splan`, no independent slices left, and the "Next step" line; lines 15–18 read the blind reading that step 6 of S4 stored.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 15 | R6 | the context was compacted, `swork` is started again and sees a bypassed slice with the status `stopped` → the slice is not retried | `grep -E '^B12 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt` | a line `B12 <letter> ok` | S4 | green 2026-10-13 |
| 16 | R6 | a slice has "Depends on: none" but edits the same file as a bypassed stopped slice → it is not started | `grep -E '^B13 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt` | a line `B13 <letter> ok` | S4 | green 2026-10-13 |
| 17 | R1 | `splan` fixed the slice, the phase is `plan confirmed`, the log holds "attempt 2 of 2" → the phase returns to `execution in progress`, the attempts start anew, `swork` runs the slice | `grep -E '^B14 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt` | a line `B14 <letter> ok` | S4 | green 2026-10-13 |
| 18 | R6 | every slice left depends on the bypassed one → the conformance check, the review and the report run over what is done | `grep -E '^B15 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt` | a line `B15 <letter> ok` | S4 | green 2026-10-13 |
| 19 | R9 | many items are bypassed → the text keeps "Next step" as `user's choice after the report` and sends the list to `away.md`: the sentence stands in it once | `cd ~/Documents/my/claude_skills && grep -c 'the list of bypassed items stays in' saway/SKILL.md` | `1` | S4 | green 2026-10-13 |
