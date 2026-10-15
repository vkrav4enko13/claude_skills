# Check lines of topic swork-nonstop

> Lines 1–3: the wiki limits; the stand — [plan-checks-stand.md](plan-checks-stand.md); the skill texts — [plan-checks-skills.md](plan-checks-skills.md).

All commands start in the project root: `cd "$HOME/Documents/my/claude_skills" && …`.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 1 | R15 | the test wiki: a card of 65 lines, a card of 6200 characters, a folder index of 105 lines, a topics index line and an overview line of 450 characters, a journal line of 250 characters are flagged; a folder index line of 300 characters is not | `T=$(mktemp -d)/wiki-trial && bash tests/make-wiki.sh $T >/dev/null && bash tests/run-check.sh sbrain/scripts/check.sh $T` | `script is fine` | S2 | green 2026-10-15 |
| 2 | R15 | the wiki of this project by the new limits → no violation | `bash sbrain/scripts/check.sh docs` | `wiki is fine` | S2 | green 2026-10-15 |
| 3 | R16 | the text keeps root index 40, reading 80 and has the card at 60 lines and 6000 characters | `grep -cF -e '\| The root index \| 40 lines \|' -e 'at most 80 lines together' -e '\| A card \| 60 lines and 6000 characters \|' sbrain/references/wiki-rules.md` | `3` | S2 | green 2026-10-15 |
