# S7. Reply fields without a reader

> Subagents stop writing what nobody reads; a blind reading shows the main session acts on their replies as before.

- **Status:** done
- **Covers:** R19, R23
- **Depends on:** S4, S6
- **Files:**
  - change: `tests/chain/away-blind.sh` (the arguments, the prompt)
  - create: `tests/chain/fields-scenarios.md`, `tests/chain/fields-expected.tsv`
  - change: `swork/references/executor.md` (rule 6 of the task, the reply form)
  - change: `tests/chain/rules.md` (the `file:line` tails)
- **Interfaces:**
  - gives: `bash tests/chain/away-blind.sh <skills folder> <out folder> [<scenarios file> <expected file>]`
- **Reuse:** `tests/chain/away-blind.sh` as a whole — the copy of the skills, the reader session, the comparison; `tests/chain/away-scenarios.md` — the form of a scenario
- **What to do:**
  - `away-blind.sh`: with the two extra arguments it copies that scenarios file in place of `away-scenarios.md`, compares with that expected file, and gives the reader the prompt ``For every scenario of `<the file name>` decide by the skill texts alone what the main session does and write `verdict.tsv`: `<id>⇥<letter>⇥<the sentence of the text you rely on>`.`` Without them it behaves as now.
  - Write eight scenarios `## F1`–`## F8`, three answers `a`–`c` each, on what the main session does with a reply: F1 — where the proof of a green check comes from; F2 — the executor names a file outside "Files"; F3 — "FUNCTIONS CREATED"; F4 — "NOTICED"; F5 — "PITFALLS"; F6 — a changed file is missing from a READ line; F7 — the executor replies `done` and gives no check output; F8 — `saway` proves that the executor made a file. `fields-expected.tsv` holds `F<N>⇥<letter>`.
  - Old reading: `bash tests/chain/away-blind.sh "$S/medium/skills" "$S/fields/old" tests/chain/fields-scenarios.md tests/chain/fields-expected.tsv`. It must end with `8 of 8 ok`; a scenario that differs is ambiguous — rewrite the scenario, not the skill, and read again.
  - `executor.md`: delete the `CHECK:` line of the reply form, and in rule 6 of the task the words that order to give the exit code and the end of the output of each check; the order to run the checks stays. First search the four skills for a reader of the `CHECK` field of a reply (`{{CHECK}}` of `wiki-block.md` is another thing); one is found — a discrepancy.
  - New reading: the same command with `.` and `"$S/fields/new"`.
- **Checks:** lines 20, 21
