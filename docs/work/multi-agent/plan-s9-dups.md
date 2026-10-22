# S9. The duplicate script

> After a merge one command lists candidate duplicates among the changed files against the whole project: same names, similar code, data keys and resources.

- **Status:** done
- **Covers:** R24, R25
- **Depends on:** none
- **Files:**
  - create: `swork/scripts/dups.py`
  - create: `tests/dups-test.sh`
- **Interfaces:**
  - takes: nothing from other slices
  - gives: `python3 -I <swork>/scripts/dups.py <project root> <changed path>…` — paths relative to the root; stdout lines `<kind>\t<name>\t<path>:<line>\t<path>:<line>` with kind `name` | `similar` | `key` | `value` | `resource`, lines `skipped: <path> — <reason>`, at most one line `not installed: <tools>`, the last line `dups: none` or `dups: <n> candidates`; code 0, code 2 on wrong arguments; changes no file
- **Reuse:** nothing to reuse — searched: `sbrain/scripts`, `swork/scripts`, `tests/` for `duplicate`, `jscpd`, `ast-grep`, `object_pairs_hook`
- **What to do:**
  1. The project's files: `git ls-files -co --exclude-standard` when the root is under git, else a walk; always skip `.git/`, `node_modules/`, every dot-folder except the wiki folder (`docs/` or the `.wiki-path` target), and files over 1 MB.
  2. **Names** — definitions in the changed files: JS/TS `function X`, `class X`, `const|let|var X =` at line start (top level only: methods of classes are not compared); Python `def X`, `class X`; shell `X() {`. A name defined in a changed file and also elsewhere (another file, or twice in one file) → `name`. When `ast-grep` is installed, take JS/TS definitions from `ast-grep run --pattern 'function $NAME($$$) { $$$ }' --json` and `--pattern 'class $NAME { $$$ }'` instead of the patterns.
  3. **Similar** — windows of 6 lines of the changed files, normalized: spaces dropped, only the names declared inside the window (`let`, `const`, `var`, parameters) replaced by `_`, empty and comment-only lines dropped; a window found elsewhere → `similar` with both start lines; adjacent hits merged into one line. When `jscpd` is installed, run `jscpd --reporters json --output <temp folder>` on the changed files in addition, read `<temp folder>/jscpd-report.json` and add its pairs as `similar`.
  4. **Data** — `.json`: load with `object_pairs_hook`; a key twice in one object → `key`; the line is found by searching the text for `"<key>"\s*:`. Key-value files `.str`, `.lconf`, `.properties` (`key = value` or `key: value` lines): a key twice in one file or in another file of the same extension with a different value → `value`, with the same value → `key`. A JSON string value that looks like a path (has `/` and an extension) listed twice in one array or object → `resource`.
  5. Binary (a NUL byte in the first 8 KB), not UTF-8, invalid JSON → `skipped:` line, go on.
  6. Each unordered pair of places is reported once, whichever side is the changed file. With `ast-grep` installed, both the changed files and the rest of the project take their JS/TS definitions from it; its stub prints `[]`.
  7. `tests/dups-test.sh <case>|all` — cases `base`, `tools`, `odd` as lines 23–25 say; `base` passes the changed paths `src/ui.js src/a.js resources.json locale/en.str assets.json` and plants `formatReward` with a body of at most 3 lines, so it gives no `similar` line; stubs on a temp `PATH`; a project per case under `${CHAIN_BASE:-$HOME/Documents/my/chain-stand}/dups-test.XXXXXX` removed by a trap.
- **Checks:** lines 23–25
