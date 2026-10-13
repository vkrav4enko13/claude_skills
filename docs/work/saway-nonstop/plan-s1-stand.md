# S1. The stand runs `saway` once

> One command seeds a topic with a stopped slice and a forbidden slice, drives `saway` over it in one turn and prints whether the run passed.

- **Status:** done
- **Covers:** R17
- **Depends on:** none
- **Files:**
  - create: `tests/chain/seed-away.sh`
  - create: `tests/chain/away-check.sh`
  - change: `tests/chain/drive.sh` (the stage `case`, the answer loop, the header comment)
  - change: `tests/chain/collect.sh` (the stage `case`, the rule of `done`, the header comment)
- **Interfaces:**
  - takes: nothing
  - gives: `bash tests/chain/seed-away.sh <project>`; `bash tests/chain/drive.sh <project> away <stage folder>`; `bash tests/chain/away-check.sh <project> <stage folder>` — 13 lines `<name>: <value>`, then `away run: pass` and code 0, or `away run: fail` and code 1
- **Reuse:** `tests/chain/stand.sh <folder> <skills folder>` — builds the project with the four skills; `tests/chain/seed.sh <project>` — the topic `longest` with S1, S2 done and S3 not started; `turn()` in `tests/chain/drive.sh:60`; `chat.md` built by `tests/chain/collect.sh:92` as `## Request` and `## Reply` blocks; `sbrain/scripts/check.sh <wiki folder>`; `perl -CSD` with `\p{Cyrillic}`, as in `tests/translate/cyr.sh:38`
- **What to do:**
  1. `seed-away.sh`: call `seed.sh "$1"`, then add to the topic `longest` what [part 2](plan-s1-stand-2.md) names.
  2. `drive.sh`: a stage `away` — `topic=longest`, the first turn `/saway longest — я ушёл, доделай без меня: решай сам и не жди моих ответов`, no answer; for this stage the loop of answers is skipped: exactly one `turn`, never `--resume`.
  3. `collect.sh`: a stage `away` — `topic=longest`; `done` is true when a `progress*.md` card holds `stage 7 finished`; the slice statuses and the phase are not looked at.
  4. `away-check.sh`: the 13 lines of [part 3](plan-s1-stand-3.md), in that order, then the line `away run: pass` or `away run: fail`.
  5. The run "before", once, on the text of commit `529351c`, with `A=~/Documents/my/chain-stand/away/before`: `stand.sh "$A/box" .`, `seed-away.sh`, `drive.sh … away "$A/away"`, then `away-check.sh … > "$A/check.txt"` — the exit code 1 is expected — and `cp saway/SKILL.md "$A/SKILL.md"`. Line 4 only reads these files; the run is not repeated.
- **Checks:** lines 1, 2, 3, 4
