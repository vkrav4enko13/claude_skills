# S11. Rule levels: lite and full

> Small work reads only the skill's core and the stage files marked lite; large work reads everything as today.

- **Status:** done
- **Covers:** R23
- **Depends on:** S10
- **Files:**
  - change: `sbrain/SKILL.md`, `splan/SKILL.md`, `swork/SKILL.md`, `saway/SKILL.md` (the stages tables and the rule "read the stage file in full"), `tests/chain/rules.md` (citations only: no rule says "read every stage file")
- **Interfaces:**
  - gives: a column `lite` in each stages table (`yes` / empty) and one line under it: «Small work reads only the files marked `lite`.»
- **Reuse:** the existing light paths — `sbrain` "Small" path, `splan` sizes "Direct"/"Short", `swork/references/small.md`, saway "small work runs in this session"
- **What to do:**
  - `lite` marks only the files the light path needs: sbrain — `context.md`, `survey.md`, `approaches.md`, `handoff.md`; splan — all four stage files (`slicing.md` holds bans of any size); swork — `entry.md`, `small.md`, `finish.md` (stages 5–7 when code changed), `report.md`; saway has no stage files: its line says the stage skill's own `lite` holds.
  - Bans, stops, menus and the literals stay in `SKILL.md` or in a `lite` file, so a light path never loses a ban; `bash tests/skills-check.sh` after.
- **Checks:** lines 21, 22
