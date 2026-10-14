# S13. Text fixes for the rules that failed at `medium`

> The skill texts behind the violations of the first `medium` series are fixed, so the chain passes the gate at `medium` without a raise.

- **Status:** done
- **Covers:** R6, R7
- **Depends on:** S3
- **Marks:** ready text
- **Files:**
  - change: `swork/references/report.md` (section "Slices", item "Found and left untouched")
  - change: `sbrain/references/topic-cards.md` (paragraph "Decisions")
  - change: `saway/SKILL.md` (section 1, the first paragraph)
  - change: `tests/chain/rules.md` (the `file:line` tails)
- **Interfaces:**
  - gives: the texts the series `medium` of S4 runs on
- **Reuse:** nothing to reuse — searched: the four skills for "word for word", "never left out", "first message"
- **What to do:**
  - `report.md`, item **Slices**: replace "the commands of its check lines" with "the commands of its check lines — each word for word, in backticks, not a description of it".
  - `report.md`, item **Found and left untouched**: replace "every finding with the reason:" with "every finding, and on the same line its reason:".
  - `topic-cards.md`, paragraph **Decisions**, right after the line form: add the sentence "The "instead of" and the "why" are never left out: with no alternative write `instead of nothing — the only option named`, and with no reason given write the reason the choice follows from."
  - `saway/SKILL.md`, section 1, after "say in one sentence which work you are driving.": add "It ends with the progress line, as every message does."
  - Re-point the tails of `tests/chain/rules.md` that point into these files.
- **Checks:** line 42
