# S14. Language and stop fixes

> The second `medium` series failed on English opening replies, a description in place of the output, and a stop on a done slice; the texts behind them are fixed.

- **Status:** done
- **Covers:** R6, R7
- **Depends on:** S13
- **Marks:** ready text
- **Files:**
  - change: `sbrain/SKILL.md`, `splan/SKILL.md`, `swork/SKILL.md`, `saway/SKILL.md` (line 11)
  - change: `swork/references/report.md` (item "Slices"), `swork/references/entry.md` ("Continuing interrupted work")
  - change: `tests/chain/rules.md` (the `file:line` tails)
- **Interfaces:**
  - gives: the texts the series `medium` of S4 runs on
- **Reuse:** nothing to reuse — searched: the four skills for "first reply", "quoted", "not a stop"
- **What to do:**
  - In the four `SKILL.md`, right after the sentence "Talk to the user in their language: chat messages, menus, reports and the plan shown for approval." add: "This holds from the very first reply, the short notes between tool calls included."
  - `report.md`, item **Slices**: replace "the end of the output of each" with "the end of the output of each — quoted, not described".
  - `entry.md`, the item "check the plan line "Checked against code" against the present code and name the discrepancies;": append to it " a discrepancy in a slice that is already done is not a stop: the slice stays done, and the conformance check of stage 5 takes the discrepancy;" — so the item ends with that clause.
  - Re-point the tails of `tests/chain/rules.md` that point into these files.
- **Checks:** line 43
