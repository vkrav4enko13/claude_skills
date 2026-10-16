# S7. agents.sh: dead claims and a wiki above the git root

> A dead owner's claim is removed even when another file is busy, and the files of a wiki above the git root can be claimed with one store.

- **Status:** done
- **Covers:** R14, R15
- **Depends on:** none
- **Files:**
  - change: `sbrain/scripts/agents.sh` (`find_up` `:107-117`, path check `:144-160`, `claim` `:335-346`, held copies `:356-359`, header `:18`)
  - change: `sbrain/references/agents-rules.md` (code 3, `:15`)
  - change: `tests/agents-test.sh` (two cases)
- **Interfaces:**
  - gives: `find_up <test> <name> [<start folder>]` — the start defaults to the current folder; `claim` code 3 prints `abandoned: <file> by <name>` for each dead claim it removed and `busy:` lines as now; a wiki path above the git root is kept in `.agents/` as a path relative to the git root, starting `../`
- **Reuse:** `drop_claims "$id" "$f"` as `wait` calls it (`agents.sh:402`); `find_up` (`agents.sh:107`)
- **What to do:**
  1. `claim`, dead branch `:340-341`: call `drop_claims` for the dead claim before the `exit 3`; the header `:18` and `agents-rules.md:15` say that dead claims are removed and named `abandoned:` with code 3 too.
  2. `find_up` takes an optional third argument, the start folder. The root stays as it is chosen now. The path check `:144-160` also accepts a path under the folder that holds `docs/00-index.md` found by `find_up -f docs/00-index.md <git root>` (the wiki root); such a path is kept relative to the git root, with `../`. Its held copy goes to `held/<id>/` with every `../` written as `_up/`, so `release --all` removes it.
  3. `agents-test.sh`, case `a busy and a dead owner's file together`: one live and one dead claim, `claim` of both → code 3, an `abandoned:` line, the dead claim gone from `claims.tsv`.
  4. `agents-test.sh`, case `a wiki above the git root`: a folder with `docs/00-index.md` and a git repo inside it → `claim ../docs/00-index.md` from the repo gives code 0, only the repo has `.agents/`.
- **Checks:** line 15
