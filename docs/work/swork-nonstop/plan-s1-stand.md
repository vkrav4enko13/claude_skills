# S1. Stand for a continuous swork

> The stand can tell whether `swork` reached its report without a question and listed its own decisions; the old `swork` fails it.

- **Status:** done
- **Covers:** R1, R2, R11
- **Depends on:** none
- **Files:**
  - create: `tests/chain/nonstop-check.sh`, `tests/chain/nonstop-run.sh`
  - change: `tests/chain/seed-away.sh` (check line 6 of the seeded topic; header lines 8–9: S5 is the irreversible slice, no longer "not done without the user")
  - create: `tests/chain/nonstop-scenarios.md`, `tests/chain/nonstop-expected.tsv`
- **Interfaces:**
  - gives: `nonstop-check.sh <project> <stage folder>` — lines `<name>: <value>`, then `nonstop run: pass` code 0 or `nonstop run: fail` code 1; `nonstop-run.sh <skills folder>` — the same last line and code; scenarios `N1`–`N9` with letters in `nonstop-expected.tsv`
- **Reuse:** `tests/chain/away-check.sh` (form of `line`, `status`, `field`, reading `chat.md` and `turns/01.json`); `stand.sh`, `seed-away.sh`, `drive.sh <project> seed <dir> medium`; `away-blind.sh` 4-argument mode; scenario form of `away-scenarios.md`
- **What to do:**
  1. `nonstop-check.sh`, header comment like `away-check.sh`. Lines and passing values: Judge turn 1 by its own reply, `.result` of `turns/01.json`; later turns are the stand's "accept" answers and are not read. `report in turn 1` — a progress card holds `stage 7 finished` and that reply holds the choice of the report ("accept" or `Принять`) → `yes`; `decided section` — that reply holds `Decided myself` or `Решил сам` → `present`; `decisions named` — the text after it contains both `S4` and `S5` → `S4 S5`; `version slice`, `irreversible slice`, `dependent slice` — statuses of S4, S5, S6 → `done`; `draft` — `notes-old.txt` in the project root → `gone`.
  2. `nonstop-run.sh`: `T=$(mktemp -d)`, `bash stand.sh $T <skills>`, `P=$T/wiki-trial/clean`, `bash seed-away.sh $P`, `bash drive.sh $P seed $T/stage medium`, then `nonstop-check.sh $P $T/stage`; pass its output and code through; print `$T` on stderr.
  3. `seed-away.sh`, line 6 of the seeded checks: command `test ! -e notes-old.txt && echo gone`, expected `gone` — `ls` of a missing file exits 1, so the line could never be green.
  4. The scenarios, each like `away-scenarios.md` (situation, one question, answers a–c), in [part 2](plan-s1-stand-2.md).
- **Checks:** line 4
