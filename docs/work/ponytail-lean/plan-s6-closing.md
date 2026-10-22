# S6. Every chain skill closes with gaps and explains in full

> The last message of `sbrain`, `splan`, `swork` and `saway` ends with the gaps, and a requested detailed explanation is never trimmed.

- **Status:** done
- **Covers:** R31, R32
- **Depends on:** none
- **Marks:** ready text
- **Files:**
  - change: `sbrain/references/handoff.md` (the handoff message `:11-31`)
  - change: `splan/references/approval.md` (step 9 `:36-53`)
  - change: `swork/references/report.md` (sections `:11-31`, before "What next")
  - change: `saway/SKILL.md` (section 5 `:97-115`, before the fixed last line)
- **Interfaces:**
  - gives: the sentence `Before the menu or the fixed last line, write one or two lines: what was not done, what was not verified, and any risk.` and the sentence `A detailed explanation the user asks for is given in full, without trimming it for brevity.` — S11 and line 26, 27 look for them verbatim
- **Reuse:** the "Not checked" sections of `report.md:16-17` and "Waiting for you" of `saway/SKILL.md:106` stay; the closing lines are a summary of them, not a replacement
- **What to do:**
  1. `handoff.md`, in the description of the handoff message, before its menu; `approval.md`, in step 9, before the approval request: add both sentences of "gives", verbatim, as two lines.
  2. `report.md`: add both sentences verbatim right before the bullet "**What next**".
  3. `saway/SKILL.md` section 5: add both sentences of "gives" verbatim before "The last line of the description is one of two".
- **Checks:** lines 26, 27
