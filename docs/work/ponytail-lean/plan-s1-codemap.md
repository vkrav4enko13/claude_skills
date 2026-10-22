# S1. Code map in the executor packet

> The executor's packet carries a short map of the project's top-level definitions, and a failing map never stops the packet.

- **Status:** done
- **Covers:** R13, R14
- **Depends on:** none
- **Files:**
  - create: `swork/scripts/codemap.sh`
  - create: `tests/codemap-test.sh`
  - change: `swork/scripts/packet.sh` (header comment `:6-15`, after the project-root block `:113-115`)
  - change: `swork/references/executor.md` (`## Packet`, the hand-built order `:9-18`)
  - change: `install.sh` (Mac loop `:193-199`, PC loop `:223-229`: copy `codemap.sh` into `splan/scripts/`)
  - change: `tests/chain/stand.sh` (`:28-38`: the same copy into `splan/scripts/`, only when `swork/scripts/codemap.sh` exists — the baseline skills have none)
- **Interfaces:**
  - gives: `bash <skill>/scripts/codemap.sh <project root>` — prints the map to stdout, code 0 always except a usage error (code 2); empty project — empty output
  - gives: the packet block header `=== code map ===`, placed after the project root and before the `=== created earlier` blocks
  - gives: `tests/codemap-test.sh` prints one line per case `<case>: ok|FAIL …` for the cases `order`, `tests`, `nested`, `size`, `empty`, `names`, then `codemap: all ok` or exits 1
- **Reuse:** the copy lines of `check.sh`/`agents.sh` in `install.sh:193-199`, `:223-229` and `tests/chain/stand.sh:28-38`; the temp-folder and case-line style of `tests/agents-test.sh`; nothing in the repo lists definitions — searched: `scripts/`, `tests/`, words `ctags`, `def `, `map`
- **What to do:**
  1. `codemap.sh <root>`: walk the files under the root, skipping folders `.git`, `.claude`, `.agents`, `docs`, `node_modules`, `vendor`, `dist`, `build`, `__pycache__`, any folder named `tests`, `test`, `__tests__`, `spec`, and files matching `*_test.*`, `*.test.*`, `*.spec.*`, `*.min.*`, `*.lock`.
  2. Patterns, top level only (no leading spaces): bash `name() {` and `function name`; Python `def name(` and `class Name`; JS/TS `export …`, `function name`, `class Name`; Go `func name`/`func (r T) name`; Ruby `def name`, `class Name`. Print the name with its parameter list as written on that line.
  3. Output: a block per folder, the folder path relative to the root ending with `/` (the root itself is `./`), then `  <file>: name(args), name2(args)` lines. Folders named `lib`, `shared`, `common`, `core`, `util`, `utils`, `helpers` (at any depth) come first, then the rest in path order.
  4. Cap: stop before the output would pass 2,000 characters and end with the line `… (truncated)`.
  5. Names with spaces or non-ASCII letters are read safely (`find … -print0`, `while IFS= read -r -d ''`); quote every expansion.
  6. `packet.sh`: after the project-root block run `$(dirname "$0")/codemap.sh` (the script next to it) with a 10-second limit made in bash — run it in the background into a temp file, poll, `kill` it when the time is up; print `=== code map ===` and the output only when the run ended with code 0 and the output is not empty. `set -e` must not end the packet on a map failure. Update the header comment: nine items.
  7. `executor.md` `## Packet`: add a new item 8 after "The project root"; "What was created earlier" becomes item 9: `**The code map** — the output of \`bash <skill folder>/scripts/codemap.sh <project root>\`; it failed or is empty — skip it: the search in the project is required all the same.`
  8. `tests/codemap-test.sh`: builds fixtures under `mktemp -d "${CHAIN_BASE:-$HOME/Documents/my/chain-stand}/codemap.XXXXXX"` and removes them at the end. `order`: folders `app/` and `lib/` each with a function → the first block is `lib/`. `tests`: a function in `tests/t.sh` → absent. `nested`: a Python `def` inside a `def` → only the outer one. `size`: 300 functions in 30 files → at most 2,000 characters and the last line `… (truncated)`. `empty`: an empty folder → empty output, code 0. `names`: a file `my file.sh` and a folder `данные/` each with a function → both listed, code 0.
- **Checks:** lines 1–9
