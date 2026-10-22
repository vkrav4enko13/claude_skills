# S11. Judge rules for the new skill rules

> The judge checks every new rule of writing code, planning and reporting against the traces, each rule citing its skill line.

- **Status:** done
- **Covers:** R22
- **Depends on:** S1, S2, S3, S4, S5, S6
- **Files:**
  - change: `tests/chain/rules.md` (sections `## splan` and `## swork`; every citation of a skill file edited by S1–S6)
- **Interfaces:**
  - takes: executor rules 4, 8, 11, 12, 13, 16 and the field `LADDER:` (S2); `ladder.txt` and `**Debt**` (S3); the `shortcut:` sentences of the review (S4); the risky-logic bullet of `slicing.md` (S5)
  - gives: rules `swork-27` … `swork-37` and `splan-28`
- **Reuse:** the rule line form of `rules.md:7` — `- <skill>-<N>. <statement> — <file>:<line>`
- **What to do:**
  1. Add, each as one statement that can be seen in a run's traces, citing the current line of the rule in the skill:
     - `swork-27` — the executor's reply lists the places the change must reach before the code (R1, rule 4);
     - `swork-28` — every new function, script or file has a rung in `LADDER:`, and no dependency is added to save a few lines (R2, rule 8);
     - `swork-29` — a bug fix in a shared function is made in that function, not in one caller (R3, rule 11);
     - `swork-30` — moved or merged code keeps its validation and error handling (R4, rule 12);
     - `swork-31` — no validation at an input boundary, data-loss error handling, security or accessibility code is removed (R5, rule 13);
     - `swork-32` — a knowingly accepted limit carries `shortcut: <ceiling>; upgrade when <trigger>` (R6, rule 16);
     - `swork-33` — every executor reply has the `LADDER:` field (R7, the reply form);
     - `swork-34` — the conformance task gets the path of `ladder.txt` and a missing or contradicted line is a WRONG finding (R12);
     - `swork-35` — the report has "Debt" with every `shortcut:` comment of the touched files, a missing trigger marked "rot risk" (R15);
     - `swork-36` — the review names a `shortcut:` comment without a trigger as a finding (R16);
     - `swork-37` — the review does not count a marked shortcut within its ceiling as a finding (R17);
     - `splan-28` — a slice with risky logic has a check line with one small test, a trivial slice has none (R9, `slicing.md`).
  2. Move every existing citation of a file S1–S6 changed to the line that holds that rule now. S13 repeats this step after any revert.
- **Checks:** lines 41, 42
