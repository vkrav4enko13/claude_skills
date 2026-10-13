# S2. A blind reader walks the scenarios

> One command gives a reader without hints 15 situations and the skill texts, and prints for each whether `saway` acts as required.

- **Status:** done
- **Covers:** R16
- **Depends on:** none
- **Files:**
  - create: `tests/chain/away-scenarios.md`
  - create: `tests/chain/away-expected.tsv`
  - create: `tests/chain/away-blind.sh`
- **Interfaces:**
  - takes: nothing
  - gives: `bash tests/chain/away-blind.sh <skills folder> <out folder>` — writes `<out folder>/result.txt`: a line `B<N> <letter> ok|differs` per scenario and the last line `<k> of 15 ok`; prints the file; code 0 when the reader answered all 15, whatever the answers
- **Reuse:** the `judge()` call in `tests/chain/judge.sh:93` — the flags of a reader session: `--setting-sources project,local --permission-prompts none --permission-mode acceptEdits --allowedTools Read Glob Grep Write --restricted --model claude-opus-5-5 --effort xhigh`; `$HOME/.local/bin/claude`, as there
- **What to do:**
  1. `away-scenarios.md`: 15 sections `## B<N>`, each a situation in three to six lines and one question with the answers `a`, `b`, `c`. The situations and the right answers — in [part 2](plan-s2-blind-2.md). The order of the letters differs between scenarios; nothing in the file marks the right one. No scenario quotes `saway/SKILL.md`.
  2. `away-expected.tsv`: `B<N>⇥<letter>`. The reader never gets this file.
  3. `away-blind.sh`: erase and create `<out folder>`; copy into it `saway`, `sbrain`, `splan`, `swork` from the skills folder and `away-scenarios.md`; start one reader session in it with the task: "The user has left and `saway/SKILL.md` drives the work. For every scenario of `away-scenarios.md` decide by the skill texts alone what happens and write `verdict.tsv`: `B<N>⇥<letter>⇥<the sentence of the text you rely on>`." Then compare with `away-expected.tsv` and write `result.txt`.
  4. Fewer than 15 answers — print `reader gave <k> answers` and exit with code 1.
  5. The reading "before", once, on the text of commit `529351c`: `bash tests/chain/away-blind.sh . ~/Documents/my/chain-stand/away/blind-before`. Line 5 only reads its folder.
- **Checks:** line 5
