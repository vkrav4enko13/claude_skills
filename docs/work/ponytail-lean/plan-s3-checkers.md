# S3. Simplification, conformance and report follow the executor rules

> The simplification guards the never-cut list of the executor, the conformance check holds the executor to its `LADDER:` field, and the report lists the debt of `shortcut:` comments.

- **Status:** done
- **Covers:** R8, R12, R15
- **Depends on:** S2
- **Marks:** ready text
- **Files:**
  - change: `swork/SKILL.md` (`:116`, the trap line on boundary checks)
  - change: `swork/references/simplify.md` (ladder `:48-55` with its lead sentence, "What to leave and not name" `:69-73`, "What not to touch" `:92`)
  - change: `swork/references/slices.md` (paragraph "What was created and what was noticed" `:51`)
  - change: `swork/references/conformance.md` (what is passed `:9-12`, "Do not pass" `:14`, kind 3 WRONG `:41-43`, after `:47`)
  - change: `swork/references/report.md` (sections `:11-31`, after "Noticed by the executors" `:25`)
- **Interfaces:**
  - takes: executor rules 8 (rungs 1–6), 13 (never-cut list), 16 (`shortcut:`) and the field `LADDER:` — from S2
  - gives: the file `<snapshot>/ladder.txt` (the snapshot is `<topic>/.swork/`), lines `S<N>: <the LADDER field as returned>`; the report section `**Debt**`
- **Reuse:** the `created.txt` handling of `slices.md:51` is the pattern for `ladder.txt`; the touched-file list of the snapshot (`report.md:57`)
- **What to do:**
  1. `simplify.md`, the ladder of "What is redundant": keep the opening sentence "Find the code without which the result is the same." and replace the rest of `:48-55` — "For every piece go down the ladder…" and the four rungs — with `Go down the rungs of rule 8 of the executor task in <skill folder>/references/executor.md, read there: rung 1 means "delete it", rungs 2–4 "replace it with that", rungs 5–6 "simplify it in place".` Keep "What to look for".
  2. `simplify.md`, "What to leave and not name": replace the three bullets with `- everything on the never-cut list — rule 13 of the executor task in <skill folder>/references/executor.md, read there;` and keep `- what the plan tells you to do exactly this way.` In "What not to touch" replace the bullet "does not remove checks at the boundaries of the system…" with `- **does not cut anything on the never-cut list** — rule 13 of \`references/executor.md\`;`. `<skill folder>` is a placeholder the main session fills in with the path of the running `swork`, like `<path>`. In `swork/SKILL.md:116` the answer becomes `The never-cut list of the executor rules is not touched`.
  3. `slices.md`, after the sentence on `created.txt`: `Write the LADDER field of the executor's reply into the snapshot's \`ladder.txt\` as \`S<N>: <the field>\`; after an attempt to fix replace this slice's lines. Write its GAPS field into "Progress log" as "S<N>: gaps — <the field>"; "none" is not written.`
  4. `conformance.md`, what is passed: add `- the path to the snapshot's \`ladder.txt\` — the one part of the executors' replies that is passed;` and in the "Do not pass" sentence write "the executors' reports, except \`ladder.txt\`". In the task, as a sub-bullet of item 3 WRONG add:
     ```
        - LADDER: <the path to ladder.txt or "none"> holds, per slice, the rung the executor claims
          for every new function, script or file. A slice that added one and has no line there, or a
          line the code contradicts (a lower rung was there to take, a named caller is not handled),
          is a WRONG finding. "none" (no executor ran) — skip this sub-bullet.
     ```
     After the sentence "does not soften a finding" add: `A \`shortcut:\` comment does not excuse a deviation from the plan either.`
  5. `report.md`, after "Noticed by the executors": `- **Debt** — every \`shortcut:\` comment in the files this work changed or created (search them before the snapshot is deleted): file:line, the ceiling and the trigger; a comment without a trigger is marked "rot risk".` In "Noticed by the executors" add: `and the "gaps" lines of the executors.`
- **Checks:** lines 14–17
