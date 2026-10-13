# S4. `saway` goes around what is forbidden and reaches the report

> One forbidden action or one stuck slice no longer stops the rest: everything independent is executed, checked, reviewed and reported, and the topic is never closed without the user.

- **Status:** done
- **Covers:** R4, R5, R6, R7, R8, R9
- **Depends on:** S3
- **Files:**
  - change: `saway/SKILL.md` ("What not to do without the user", sections 2, 3 and 5, "Traps")
- **Interfaces:**
  - takes: the item `**A `swork` stop**` of section 3 and the count of actions by `away.md` from S3
  - gives: in section 3 the item named `**Bypass**`; in `away.md` the line form `- bypassed: S<N> <title> — <reason>; depends on it: <slices | none>` under `## Waiting for the user`. S5 retells these lines in the description
- **Reuse:** the field `- **Depends on:**` and the field `- **Files:**` of a slice card, `splan/references/plan-format.md:121`; the screening of findings by the main session, `swork/references/finish.md:13` and `swork/references/review.md:53`; the step `user's choice after the report`, `swork/references/report.md:9`
- **What to do:**
  1. "What not to do", the opening paragraph: replace "If the prohibition is in the way of the work, the work is stopped; if it is not, go on. A `swork` stop on a slice is always in the way: independent slices do not start either." with — write the item into "Waiting for the user" and bypass it by section 3.
  2. The same list: add "a change of `rules.md`" to the item about the user's decisions; in that item the sentence "If the work diverges from them, that point is stopped" becomes "…bypass it by section 3"; to the item about the choice after the report add — the phase `done` is never set by `saway`: a work with every check green still ends at the user's choice.
  3. Section 3: every "that point is stopped", "the slice stays stopped" and "the work is stopped" becomes "bypass it"; remove the item "A stop remains after the item above — the work is stopped…"; its sentence about a slice awaiting a manual check moves into "Bypass". A third return to an earlier stage is a bypass.
  4. Section 3, the new item `**Bypass**` — by [part 2](plan-s4-around-2.md); section 5 and "Traps" — by [part 3](plan-s4-around-3.md).
  5. Section 2, the row "a slice is stopped": add — a bypassed slice is not a stop: `swork`.
  6. Then store the blind reading into `~/Documents/my/chain-stand/away/blind-s4` with `away-blind.sh`; lines 9–18 read its `result.txt`; after a fix of the text run it again. Measure the size with the counter of line 28, printing `$((t - b))` before the comparison, and name the number in the report.
- **Checks:** lines 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
