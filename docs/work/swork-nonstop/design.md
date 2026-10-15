# Design of topic swork-nonstop

> The four sections approved on 2026-10-15, the limits narrowed by the user's later choice.

## 1. How swork decides instead of stopping

A started `swork` goes to the report; only the report waits for the user. Former stop → own decision:

- code differs from the plan; red after two attempts; green before the edits — edits the slice card and its check lines, at most twice per slice, then bypasses the slice and its dependents — R3, R4;
- an irreversible slice — the saving of "Rollback" first, then the slice — R5;
- the environment is unreachable — restore and rerun, otherwise "not checked" — R6;
- a manual check others depend on — dependents go "on unchecked ground" — R7;
- a foreign file, the questions of continuing — `known.txt`, continue, establish by the code — R8.

## 2. How the user learns of the decisions

A highlighted chat line at the moment of the decision, without waiting; a correction of a present user is taken from the next step; a "Progress log" line; a "Decided myself" section in the report; the menu after the report stays — R2, R9, R10, R11.

## 3. saway and the rules

`saway` refers to `swork` for stops and bypass and allows the irreversible slice the same way; it stays for an absence over the whole chain. The rule in `rules.md` is replaced in the user's words — R13, R14, R17.

## 4. Wiki limits and quality

Doubled: card, folder index, line of indexes, archive and overview. Kept: root index, `rules.md`, the start reading, the line of the root index, rules and journal — the user chose not to raise the cost of a session start. Old parts are not merged. Gate — the stand — R15, R16, R18.
