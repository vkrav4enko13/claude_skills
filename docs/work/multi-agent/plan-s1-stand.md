# S1. Stand for two agents

> The stand runs two `swork` sessions at once in one project, each turn in its own temp folder, and tells whether both ended without losing an edit.

- **Status:** done
- **Covers:** R14, goal
- **Depends on:** none
- **Files:**
  - change: `tests/chain/drive.sh` (the argument check of line 32 and the usage of lines 6 and 29; the `claude -p` call near line 99; the stage `case` of lines 44–89; the answer loop of lines 180–185)
  - change: `tests/chain/judge.sh` (line 66, the folders left out of a copy) and `tests/chain/judge-prompt.md` (line 21)
  - change: `tests/chain/collect.sh` (the stage `case` of lines 30–39; the `done` test of lines 49–75)
  - change: `tests/chain/nonstop-run.sh` (line 21, the stand folder)
  - create: `tests/chain/seed-pair.sh`, `tests/chain/pair-run.sh`, `tests/chain/pair-check.sh`, `tests/chain/pair-scenarios.md`, `tests/chain/pair-expected.tsv`
- **Interfaces:**
  - gives: `drive.sh <project> pair <stage folder> <level> <topic>` — one turn `/swork <topic> — исполни план`, no answer turn; `seed-pair.sh <project> a|b`; `pair-run.sh a|b <skills folder>` — prints the stand path on stderr, the lines of `pair-check.sh` and its last line on stdout, its code; `pair-check.sh <project> <stage folder 1> <stage folder 2> a|b` — lines `<name>: <value>`, then `pair run: pass` code 0 or `pair run: fail` code 1; scenarios `M1`–`M9` in `pair-scenarios.md` with letters in `pair-expected.tsv`
- **Reuse:** `seed.sh` lines 20–28, 39–49, 107–125, 129–273 (variables, `README.md`, index lines, topic and plan cards); slice card forms of `seed.sh:318-341` and `seed-away.sh:119-140`; `make-wiki.sh:58-85` `state()`, `topic_index()` (copy, the file is not sourceable); `nonstop-check.sh` `line`, `status`, reading `.result` of `turns/01.json`; `away-blind.sh` 4-argument mode
- **What to do:**
  1. `drive.sh`: `mkdir -p "$dir/tmp"` once and pass `TMPDIR="$dir/tmp"` on the `claude -p` command line next to `CLAUDE_CONFIG_DIR`; a stage `pair` that takes the topic from a fifth argument, starts `/swork <topic> — исполни план` and, like `away`, has exactly one turn. `collect.sh`: the stage `pair` is done when `.result` of its `turns/01.json` holds a report — the final one or the short one.
  2. `nonstop-run.sh:21`: `B="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"; mkdir -p "$B"; T=$(mktemp -d "$B/nonstop.XXXXXX")`.
  3. `seed-pair.sh` seeds topics in the phase `plan confirmed`, with no `.swork/`, no progress card and no marker, then runs `git init -q`, `git add -A` and `git -c user.name=stand -c user.email=stand@local commit -qm seed` in the project and then writes the seed commit into the line "Checked against code" of each `plan.md` (left as an uncommitted wiki edit — the hash exists only after the commit), so that the old `swork` restores foreign files by `git checkout` as it does in a real project. Case `a`: topic `usage` — S1 creates `USAGE.md` (three fixed lines), S2 appends `Usage: see USAGE.md` to `README.md`, S2 depends on S1; topic `version` — S1 creates `VERSION` holding `1.0`, S2 appends `Version: see VERSION` to `README.md`, S2 depends on S1. Case `b`: topic `pair` — four slices, each `Depends on: none`, each creating its own file (`USAGE.md`, `VERSION`, `AUTHORS`, `CHANGES.md`) with ready text. Every check is order-free: `grep -qxF '<line>' <file> && echo ok` → `ok`.
  4. `pair-run.sh`: stand under `$CHAIN_BASE` as in step 2, `seed-pair.sh`, then `drive.sh … pair "$T/s1" medium <topic 1> & drive.sh … pair "$T/s2" medium <topic 2> & wait` — case `a`: `usage` and `version`; case `b`: `pair` twice — then `pair-check.sh`.
  5. `pair-check.sh` lines: `ended 1`, `ended 2` — `.result` of each `turns/01.json` holds the mark of a short report `⏸`, or holds the choice of the final report (`accept` or `Принять`, any case) while the progress cards of that session's topic hold a stage-7 finished record, `stage 7 finished` or `stage 7 [<session id>]: finished` with that session's own id → `yes`; `slices` — every slice of the seeded topics `done` → `all done`; `readme` (case a) — both appended lines present → `both`; `final` — at least one session's reply holds the choice of the final report → `yes`; `split` (case b) — the agents named in the progress records, printed and not judged; `claims` — `.agents/claims.tsv` has no line → `none`.
  6. `judge.sh:66` and `judge-prompt.md:21`: the copies of a stand project also leave out `.agents/` and `.swork-*/`.
  7. The scenarios — [part 2](plan-s1-stand-2.md).
- **Checks:** lines 1, 2
