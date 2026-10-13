# Check lines of topic saway-nonstop: what the user sees

> Lines 20–26: the language, the retelling, the progress line, the order of the description, the turn limit and the pinned strings.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 20 | R11 | the text of `saway` names the language of the chat and of the description → the sentence stands in it once | `cd ~/Documents/my/claude_skills && grep -c 'Every chat message and the full description are in the language the user wrote in before leaving' saway/SKILL.md` | `1` | S5 | green 2026-10-13 |
| 21 | R12 | the text tells to retell the cards in the description in full → the sentence stands in it once | `cd ~/Documents/my/claude_skills && grep -c 'in full, not by a link' saway/SKILL.md` | `1` | S5 | green 2026-10-13 |
| 22 | R13 | the text names the form of the progress line → the form stands in it once | `cd ~/Documents/my/claude_skills && grep -c 'Progress: slices <done>/<total> · now: ' saway/SKILL.md` | `1` | S5 | green 2026-10-13 |
| 23 | R14 | `saway` weakened a success criterion → the final description starts with that change: was, became, why; reads the reading that step 6 of S5 stored | `grep '^B3 ' ~/Documents/my/chain-stand/away/blind-s5/result.txt` | a line `B3 <letter> ok` | S5 | green 2026-10-13 |
| 24 | R15 | the `/goal` line of the text → it stops after 100 turns, the limit of 40 turns is gone | `cd ~/Documents/my/claude_skills && grep -c 'stop after 100 turns' saway/SKILL.md && grep -c '40 turns' saway/SKILL.md || true` | two lines: `1`, `0` | S5 | green 2026-10-13 |
| 25 | R18 | the list of the final description → its last item is what to check and the choice after the report | `cd ~/Documents/my/claude_skills && grep -c 'What to check and your choice' saway/SKILL.md` | `1` | S5 | green 2026-10-13 |
| 26 | R15 | the four strings that the `/goal` line and `tests/translate/map.tsv` pin → each still stands in the text | `cd ~/Documents/my/claude_skills && for s in 'Waiting for the user' 'choice after the report' 'saway: work finished' 'saway: work stopped — waiting for the user'; do grep -q "$s" saway/SKILL.md && echo kept; done` | four lines `kept` | S5 | green 2026-10-13 |
