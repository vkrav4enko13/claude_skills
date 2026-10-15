# S2. Wiki limits read by a link doubled

> Cards and topic indexes split half as often; the cost of a session start stays the same.

- **Status:** done
- **Covers:** R15, R16
- **Depends on:** none
- **Files:**
  - change: `sbrain/references/wiki-rules.md` (section "Card and limits", the table of "Check")
  - change: `sbrain/scripts/check.sh` (second pass: the `case` on `$rel` and the line-length test)
  - change: `splan/references/plan-format.md` (line 178, the overview line)
  - change: `tests/make-wiki.sh` (the broken wiki), `tests/expected-broken.txt`
- **Interfaces:**
  - gives: the messages `card is longer than 60 lines`, `card is longer than 6000 characters`, `index is longer than 100 lines`, `line is longer than 400 characters`, `line is longer than 200 characters`
- **Reuse:** `say`, `dir_of` and the `kind` variable in `check.sh`; `grow`, `stretch` in `tests/make-wiki.sh`; `tests/run-check.sh <check.sh> <stands folder>` unchanged
- **What to do:**
  1. New values: card 60 lines and 6000 characters; folder index `00-index.md` 100 lines; a line of a folder index, of an archive `00-archive.md` and of the plan overview 400 characters. Unchanged: root index 40 lines, `rules.md` 30 lines, the reading at most 80 lines, a line of the root index, of `rules.md` and of the journal 200 characters.
  2. `wiki-rules.md`: the limits table gets two line rows — 200 for the root index, `rules.md`, the journal; 400 for a folder index, an archive, the overview; the "Check" table names both line messages; nothing else in the file changes.
  3. `check.sh`: the line limit depends on the file — 400 for `*/00-index.md` other than the root, `*/00-archive.md`, `*/plan-overview.md`; 200 for the others; cards still have no line limit.
  4. `plan-format.md:178`: "a line is at most 400 characters".
  5. `make-wiki.sh`: `long-card.md` 65 lines, `fat-card.md` 6200 characters, the notes index 105 lines; cases 10 and 11 (topics index line, overview line) stretched to 450 characters; the journal line of 250 stays; add one folder index line of 300 characters, not flagged. Update `expected-broken.txt` to the new output, sorted.
- **Checks:** lines 1, 2, 3
