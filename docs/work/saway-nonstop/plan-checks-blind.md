# Check lines of topic saway-nonstop: the blind reading and the rights

> Lines 5–8: the reader fails the present text on the real case, and passes the new text on the rights of `saway`.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 5 | R16 | the stored blind reading of the text of commit `529351c` → 16 lines of result, and the scenario "a slice stopped under a plan the user approved" differs from the required answer | `cd ~/Documents/my/claude_skills && O=~/Documents/my/chain-stand/away/blind-before && git show 529351c:saway/SKILL.md > "$O/head.md" && cmp "$O/saway/SKILL.md" "$O/head.md" && echo "text before" && grep -c '' "$O/result.txt" && grep '^B1 ' "$O/result.txt"` | `text before`, `16`, then a line `B1 <letter> differs` | S2 | green 2026-10-13 |
| 6 | R1 | the user approved the plan, a slice is stopped after two failed attempts → `saway` returns to `splan`, fixes the slice and goes on; reads the reading that step 6 of S3 stored | `grep '^B1 ' ~/Documents/my/chain-stand/away/blind-s3/result.txt` | a line `B1 <letter> ok` | S3 | green 2026-10-13 |
| 7 | R2 | a success criterion the user approved cannot be met → `saway` weakens or drops it in the card itself and goes on | `grep '^B2 ' ~/Documents/my/chain-stand/away/blind-s3/result.txt` | a line `B2 <letter> ok` | S3 | green 2026-10-13 |
| 8 | R3 | the text of `saway` names the form of the record of an edit of an approved card → the line "was — became — why — otherwise" stands in it once | `cd ~/Documents/my/claude_skills && grep -c 'was: <…>; became: <…>; why: <argument>; otherwise: <what would change>' saway/SKILL.md` | `1` | S3 | green 2026-10-13 |
