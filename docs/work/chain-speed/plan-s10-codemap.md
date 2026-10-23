# S10. Code map

> sbrain, splan and swork start from a short map of the project's code instead of search turns.

- **Status:** done
- **Covers:** R22
- **Depends on:** S9 (the series `cs-after-2` finished: no skill edit during a series)
- **Files:**
  - create: `sbrain/scripts/codemap.sh`
  - change: `install.sh` (copy `codemap.sh` next to `agents.sh` into `splan` and `swork`, Mac `:198` and PC `:228`), `sbrain/references/context.md`, `splan/references/recon.md`, `swork/scripts/packet.sh`, `swork/references/executor.md` (the packet list)
- **Interfaces:**
  - gives: `bash <skill>/scripts/codemap.sh <project root>` → at most about 2000 characters: one line per folder `<folder>: <name>, <name> …` of top-level functions, classes and exports; shared folders first; skips `tests/`, `node_modules/`, `.git/`, generated and vendored folders; exit 0 with an empty output when there is no code, exit 1 on an error
- **Reuse:** `swork/scripts/dups.py` (its name patterns per language: bash functions, JS/TS, Python); `swork/scripts/packet.sh` (its block form)
- **What to do:**
  - `codemap.sh` in bash, the patterns of `dups.py` for `.sh`, `.js`/`.ts`, `.py`; cut at 2000 characters with a last line `… <n> more`.
  - `context.md` and `recon.md`: one line — run the map first, it does not replace the search; `packet.sh`: a block `=== code map ===` after the project root; a failing map is skipped.
- **Checks:** lines 19, 20
