# Requirements of topic ponytail-lean

> The rules of writing code in the chain, and the clean room; the stand — in part 2; the extension — in part 3.

## Writing code (executor of swork)

- R1. Before writing code for a slice, the executor of `swork` lists every place the change must reach: callers, tests, fixtures, configuration and exports.
- R2. Before writing a new function, script or file, the executor goes down the ladder and takes the first rung that fully solves the slice: not needed at all → already in the project → the standard library or the platform → an installed dependency → one readable line → the minimum working code; it never adds a dependency to save a few lines.
- R3. When a slice fixes a bug in a function, the executor finds every caller of that function and fixes the shared function once, not one caller.
- R4. When the executor moves or merges code, it carries the validation and the error handling of that code with it.
- R5. The executor never cuts: validation where untrusted input enters, error handling that prevents data loss, security, accessibility, and anything the user or the plan asked for; this list overrides the ladder of R2.
- R6. When the executor knowingly accepts a limit, it leaves a comment `shortcut: <ceiling>; upgrade when <trigger>`.
- R7. The reply of the executor carries a field `LADDER:` — for each new function, script or file: the rung of R2 and why not a lower one (where it searched); and the callers found by R1 and R3.
- R8. R1–R6 and R27–R29 are written in full only in the executor task of `swork`; `splan`, the simplification and the review of `swork` refer to them, and the list of R5 replaces the own "never touch" lists of the simplification.

## Planning (splan)

- R9. When a slice adds risky logic — a branch, a loop, a parser, money, security or a new script — `splan` gives the slice a check line with one small test of that logic.
- R10. If a slice is trivial, then `splan` adds no test to it.
- R11. The recon of `splan` takes the code map of R13 and writes into the "Reuse" field of each slice the ready-made code and its rung of R2.

## Checking and reporting (swork)

- R12. The conformance check of `swork` compares the `LADDER:` field with the code; a missing field or a field that the code contradicts is a "wrong" finding.
- R13. A code-map script prints the top-level functions, classes and exports of the project by folder, at most about 2,000 characters, shared folders first, tests and generated files skipped; the packet of the executor and the recon of `splan` include its output.
- R14. If the map script fails or the project has no code, then the packet goes without the map, and the search in the project stays required.
- R15. The report of `swork` has a section "Debt" with every `shortcut:` comment in the files this work touched, each with its ceiling and trigger; a comment without a trigger is marked as a rot risk.
- R16. If a `shortcut:` comment has no trigger, then the review of `swork` names it as a finding.
- R17. The review of `swork` does not count as a finding a shortcut marked by R6 that stays within its ceiling.

## Clean room

- R18. The writer of the skill edits and the executors read only the ideas card [ideas.md](ideas.md), never the ponytail source; no skill text and no stand file copies wording from the source.
