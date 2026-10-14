# Seeds: the decisions of the persona and the flaws of the grill plan

The decisions D1–D5 of `tests/chain/persona.md` that the requirements of a survey run must carry, and the five flaws planted in `tests/chain/grill-plan.md` that a grill run must name.

- decision-1. N is the first argument of the script; without an argument N = 5.
- decision-2. The length of a word is counted in letters, not in bytes: a Cyrillic word of six letters is six, not twelve.
- decision-3. The output is only the number, on one line, without explanations.
- decision-4. No file `app.txt` — the line `no file app.txt` to stderr, exit code 2.
- decision-5. Several files are out of scope: the script reads only `app.txt`.

- flaw-1. wrong: the plan reuses a function `word_length` of `longest.sh` — the script has `length`
- flaw-2. contradiction: the requirement says an empty file prints an empty line, the step of slice 1 prints `0`
- flaw-3. missing: the plan is silent on which word wins a tie of the shortest length
- flaw-4. vague: the step "handle the errors properly" decides nothing
- flaw-5. order: the check of slice 1 needs the `README.md` line that slice 2 writes
