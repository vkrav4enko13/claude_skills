# S5. splan: tests for risky logic, map and audit in the recon

> `splan` gives a risky slice one small test, leaves a trivial one without, reads the touched code as an audit starting from the map, and names the rung of every ready-made piece.

- **Status:** done
- **Covers:** R8, R9, R10, R11, R37
- **Depends on:** S1, S2
- **Marks:** ready text
- **Files:**
  - change: `splan/references/slicing.md` (step 4, after the "Check focus" bullet `:16`; the bullet "The project has no tests" `:14`)
  - change: `splan/references/recon.md` (step 3, "What to look for" `:27`, "Ready-made code" `:32`)
  - change: `splan/references/plan-format.md` (the "Reuse" field `:129`, "Reuse — verified" `:144`)
- **Interfaces:**
  - takes: `codemap.sh` in `splan/scripts/` (S1); executor rule 8 rungs 1–6 (S2)
  - gives: the "Reuse" form `<name(signature)> — <file> — rung <2–4>`
- **Reuse:** the existing check-line rules of `slicing.md`; the subagent recon bullet of `recon.md:29`
- **What to do:**
  1. `slicing.md`, after the "Check focus" bullet:
     ```
     - **Risky logic gets one small test.** A slice that adds a branch, a loop, a parser, money,
       security or a new script gets one check line whose command is one small test of that logic:
       a test of the project's framework or, without one, a command with assertions. One test, not
       coverage. A trivial slice — a rename, a text, a setting — gets no test.
     ```
     In "The project has no tests — do not invent them" add at the end: `except the one small test of risky logic above.`
  2. `recon.md`, first bullet of step 3: `**Map first.** Run \`bash <skill folder>/scripts/codemap.sh <project root>\` and read the map before the search; it failed — search as usual.`
  3. `recon.md`, after "What to look for": `**Audit the touched part.** Read in full the risky paths the work touches — input from outside, money, access, writes to files or data, background jobs, shared state; write down the parts of the touched code you did not read, and put them in the plan header under "Assumptions" as "not read: <paths>".`
  4. `recon.md`, "Ready-made code": add `and its rung of rule 8 of the executor task (the \`swork\` skill, \`references/executor.md\`): 2 — in the project, 3 — the standard library or the platform, 4 — an installed dependency.`
  5. `plan-format.md` "Reuse": the template becomes `<the name, the signature, the file and the rung of every ready-made piece>`; "Reuse — verified" adds `each with its rung`.
- **Checks:** lines 22–25
