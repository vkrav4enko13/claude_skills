# S2. The effort level of a series

> The stand runs the sessions of a series at the level named for it; the judge stays at `xhigh`.

- **Status:** done
- **Covers:** R1
- **Depends on:** S1
- **Files:**
  - change: `tests/chain/series.sh` (the options, `lane`)
  - change: `tests/chain/drive.sh` (`turn`)
- **Interfaces:**
  - takes: `bash tests/chain/trace.sh <series> efforts` (S1)
  - gives: `bash tests/chain/series.sh <series> <skills folder> [--runs N] [--stages "<stages>"] [--effort <level>]`; `bash tests/chain/drive.sh <project> <stage> <stage folder> [<level>]`; the file `$S/<series>/effort` — one line, the level
- **Reuse:** the option loop of `tests/chain/series.sh:34-42`; the `turn` function of `tests/chain/drive.sh:66-80`
- **What to do:**
  - The levels are `low medium high xhigh max`; without the option or the fourth argument the level is `medium`. An unknown level — the usage line and code 2, before `series.sh` creates or deletes anything.
  - `series.sh`: a series folder that has `skills/` and no `effort` file was run at `xhigh` — the series made before this topic. The folder's level differs from the asked one — `series <name> was run at <level>` to stderr and code 2. Otherwise write the level into `$S/<series>/effort` and pass it to every `drive.sh` call as the fourth argument.
  - `drive.sh`: the level replaces `xhigh` in `--effort xhigh` of `turn`; nothing else in the call changes.
  - Bring the usage comments of both scripts up to date.
  - Run `bash tests/chain/series.sh smoke-m . --runs 1 --stages brain --effort medium`.
- **Checks:** lines 4, 5, 6, 7
