# S3. `saway` fixes a stopped slice and edits the topic cards itself

> A slice stopped under a plan the user approved, or a requirement that cannot be met, no longer stops the work: `saway` fixes it, records the edit and goes on.

- **Status:** done
- **Covers:** R1, R2, R3
- **Depends on:** S1, S2
- **Files:**
  - change: `saway/SKILL.md` (the opening paragraph, "What changes while the user is away", "What not to do without the user", sections 2, 3 and 4)
- **Interfaces:**
  - takes: `bash tests/chain/away-blind.sh <skills folder> <out folder>` from S2; from S1 nothing but the order — its run "before" must see the text before this edit
  - gives: in section 3 the items named `**A `swork` stop**` and `**A divergence from the topic cards**`; in section 4 the line form `was: …; became: …; why: …; otherwise: …`. S4 rewrites what happens after the limit of two actions; S3 leaves it as "the slice stays stopped"
- **Reuse:** the stop menu of `swork/references/slices.md:57` — the action "Go back to `splan`"; the entry table of `splan/SKILL.md:38` — the question "do we continue from it or write anew"; "Replacement and archive" of `sbrain/references/wiki-rules.md` — how a replaced decision is written
- **What to do:**
  1. Opening paragraph: replace the sentence "`saway` does not repeat the rules of these skills…" with: `saway` starts the skill that is needed and decides for the user; where its text and theirs differ about a stop, an approval or an edit of a card, `saway` is right.
  2. "What changes", the item "`saway` is stronger…": its last sentence becomes — the other rules of the three skills apply as written; their stops are answered by section 3.
  3. "What not to do", the item "What the user decided or approved themselves": keep in it only a rule from `rules.md` and the user's choice in the conversation; remove "a decision with the status in force" and "the requirements and the plan they approved". The sentences "If the work diverges from them, that point is stopped" and "Do not write your own answers into `rules.md`" stay as they are; S4 rewrites the first.
  4. Section 2: the row "a slice is stopped" becomes "the item about a stop from section 3, then `swork`"; remove the sentence "Look in the same place for who approved the requirements and the plan…".
  5. Sections 3 and 4 — by [part 2](plan-s3-rights-2.md).
  6. Then store the blind reading: `bash tests/chain/away-blind.sh . ~/Documents/my/chain-stand/away/blind-s3`. Lines 6 and 7 read its `result.txt`; after a fix of the text run it again. Measure the size with the counter of line 28, printing `$((t - b))` before the comparison, and name the number in the report.
- **Checks:** lines 6, 7, 8
