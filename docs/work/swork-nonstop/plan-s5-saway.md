# S5. saway without duplicates, and the gate

> `saway` refers to `swork` for its stops; the stand proves the continuous `swork` and no loss of quality.

- **Status:** done
- **Covers:** R13, R14, R17, R18, goal
- **Depends on:** S2, S3, S4
- **Files:**
  - change: `saway/SKILL.md` (lines 10, 17, 26, 29, 30, 56, 81, 84–91, 140)
  - change: `tests/chain/rules.md` (`file:line` references of `swork-1`…`swork-26`)
  - change: `tests/chain/away-check.sh` (the 13 lines), `tests/chain/away-scenarios.md`, `tests/chain/away-expected.tsv`, `tests/chain/fields-scenarios.md`, `tests/chain/fields-expected.tsv`
- **Interfaces:**
  - takes: section `## 4. Own decisions` of `swork/SKILL.md` and `## Decisions and bypass` of `slices.md` (S3); `nonstop-run.sh` (S1)
- **Reuse:** `drive.sh … away`, `away-blind.sh`, `series.sh --stages seed`, `judge.sh`, `verdict.sh quality`
- **What to do:** in [part 2](plan-s5-saway-2.md)
- **Checks:** lines 5, 7, 10, 11, 12, 13, 14
