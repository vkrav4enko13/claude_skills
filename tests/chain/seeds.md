# Seeds: the defects of the topic `longest`

Five defects that `tests/chain/seed.sh` plants in the done slices of the topic `longest`. The kind is as in a finding of the conformance check: beyond the plan, wrong, missing; "error" is a defect of the code that the plan is silent about.

- seed-1. beyond the plan: the `-a` flag prints all the longest words
- seed-2. wrong: without `app.txt` the script prints `error` to stderr and exits with code 1
- seed-3. missing: `README.md` is silent about the `-n` flag
- seed-4. error: the length is counted in bytes — of `abcdefghi` and `карточка`, `карточка` is chosen
- seed-5. error: the last line, which has no newline at the end, is not read
