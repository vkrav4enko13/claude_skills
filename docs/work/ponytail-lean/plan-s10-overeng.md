# S10. Over-engineering judge and injected bugs

> Each trap run gets an over-engineering score with the construct named, by a judge proven on references, and the share of injected bugs its delivered tests catch.

- **Status:** done
- **Covers:** R42, R43
- **Depends on:** S8, S9
- **Files:**
  - create: `tests/chain/overeng.sh`, `tests/chain/overeng-prompt.md`, `tests/chain/overeng-test.sh`
  - create: `tests/chain/mutate.sh`, `tests/chain/mutate-test.sh`
  - change: `tests/chain/trap-measure.sh` (created in S9: four more keys)
- **Interfaces:**
  - takes: `traps/<name>/{project,good,over}` (S8); `trap-measure.sh` and `<box>/seeded/` (S9)
  - gives: `bash tests/chain/overeng.sh <seeded folder> <project> [<level>]` → one line `<score 0–3><TAB><construct or "none">`, code 0; no answer — code 1
  - gives: `bash tests/chain/mutate.sh <seeded folder> <project>` → `caught <k>/<n>` or `caught 0/<n> — no tests`, code 0
  - gives: new keys of `trap-<name>.json` after `gz_bytes`: `overeng`, `construct`, `caught`, `mutants`
- **Reuse:** the `claude -p` call of `tests/chain/answer.sh` (no tools); the diff of `trap-measure.sh`
- **What to do:**
  1. `overeng-prompt.md`: the judge gets the task text and the added code (the diff outside `tests/`, `docs/`, `.claude/`), scores 0 — nothing superfluous … 3 — mostly superfluous, and names the one construct it finds most unnecessary (an abstraction, an option, a config, a wrapper, a re-implemented helper or native feature) with file and line; it answers only the line of "gives". Written in our own words.
  2. `overeng.sh`: `claude -p` with no tools, `--effort medium` unless the third argument says otherwise, as in `answer.sh`.
  3. `overeng-test.sh`: for `reuse` and `native` build `project/`+`good/` and `project/`+`over/` in temp copies, score both; print `overeng <name>: over <a> > good <b>` when `a > b`, else `overeng <name>: FAIL over <a> good <b>`; last `overeng calibration: ok` or exit 1. If it fails at `medium`, run it once with level `xhigh`; pass there — make `xhigh` the default of `overeng.sh` and say so in its header.
  4. `mutate.sh`: the delivered non-test files are the new or changed files outside `tests/`, `docs/`, `.claude/`; the tests are the new or changed files under `tests/`. For each delivered file make three mutants in a temp copy of the project: the first comparison operator flipped (`-lt`↔`-ge`, `-gt`↔`-le`, `-eq`↔`-ne`, `<`↔`>=`, `>`↔`<=`, `==`↔`!=`), the first `if <condition>; then` made `if true; then`, the first integer literal plus one; a mutant that does not apply is not counted. A mutant is caught when any test, run with `bash`, exits non-zero. No tests — `caught 0/<n> — no tests`.
  5. `mutate-test.sh`: on `traversal` `project/`+`good/` (it has `tests/test_show.sh`) against `project/` → `mutate good: caught <k>/<n>` with `k` of 1 or more; on `project/`+`bad/` → `mutate bad: caught 0/<n> — no tests`; last `mutate test: all ok` or exit 1.
  6. `trap-measure.sh` runs both and writes the four keys; a failed judge writes `overeng: null`.
- **Checks:** lines 38–40
