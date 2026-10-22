# Check lines of topic multi-agent — duplicates

> Lines 23–25: the duplicate script `swork/scripts/dups.py`, checked by `tests/dups-test.sh`.

All commands start in the project root: `cd "$HOME/Documents/my/claude_skills" && …`. `tests/dups-test.sh <case>` is created in S9: it plants files in a toy project under `$CHAIN_BASE`, runs the script on named changed paths and prints `dups <case>: ok` or what failed, with code 1.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 23 | R24 | changed `src/ui.js` defines `formatReward()` also defined in `src/utils.js`; a 6-line block of `src/a.js` repeated in `src/b.js` with renamed locals; `resources.json` with `"bonus_win"` twice in one object; `locale/en.str` with `bonus_win` given twice with different values; `assets.json` listing one image path twice; an unrelated clean file → one line each of the kinds `name`, `similar`, `key`, `value`, `resource` naming both places, nothing for the clean file, last line `dups: 5 candidates`; a run on the clean file alone ends `dups: none` | `bash tests/dups-test.sh base` | `dups base: ok` | S9 | green 2026-10-21 |
| 24 | R25 | stub `ast-grep` and `jscpd` on `PATH` that record their calls → both called on the changed paths; without them the own search runs and the line `not installed: ast-grep, jscpd` is printed once | `bash tests/dups-test.sh tools` | `dups tools: ok` | S9 | green 2026-10-21 |
| 25 | R24 | changed paths include a PNG, a Latin-1 text file and a JSON with a syntax error → each gives a `skipped: <path> — <reason>` line, the other candidates are still listed, code 0 | `bash tests/dups-test.sh odd` | `dups odd: ok` | S9 | green 2026-10-21 |
