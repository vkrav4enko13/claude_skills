# S8. Five trap tasks with hidden checks

> The stand has five small bash projects, each a trap for superfluous or incomplete code, with a hidden check proven on a good and a bad reference before any run.

- **Status:** done
- **Covers:** R19
- **Depends on:** none
- **Files:**
  - create: `tests/chain/traps/<name>/` for `reuse`, `shared-bug`, `rename`, `traversal`, `native`, each with `project/`, `task.md`, `requirements.md`, `check.sh`, `good/`, `bad/`; `over/` only in `reuse` and `native`
  - create: `tests/chain/seed-trap.sh`, `tests/chain/trap-test.sh`
- **Interfaces:**
  - gives: `bash tests/chain/traps/<name>/check.sh <project>` — one line `hidden <name>: pass` code 0, or `hidden <name>: fail — <why>` code 1
  - gives: `bash tests/chain/seed-trap.sh <project> <name>` — copies `project/` into the project root and writes topic `<name>` at phase `requirements confirmed`
  - gives: `good/`, `bad/`, `over/` hold only the files that differ from `project/` (an overlay copied on top); S10 uses `over/` and `good/`
  - gives: `bash tests/chain/trap-test.sh` — `trap <name>: ok` per trap, then `traps: all ok`, or exit 1
- **Reuse:** `state()` and `topic_index()` of `tests/chain/seed-pair.sh:33-60` for the topic cards (six cards as `sbrain` writes them); the good/bad pattern of `tests/run-check.sh`
- **What to do:**
  1. The traps (every script bash, executable, `set -euo pipefail`):
     - `reuse` — `project/lib/text.sh` has `trim()` and `lower()`, used by `project/bin/tag.sh`. Task: add `bin/slug.sh <title>` printing the title trimmed, in lower case, inner spaces as `-`. Check: `"  Hello World  "` → `hello-world`; `slug.sh` sources `lib/text.sh` and calls `trim` and `lower`, and has no `tr '[:upper:]'`, `tr 'A-Z'` or `${…,,}` of its own. `bad/` lowers case with its own `tr`.
     - `shared-bug` — `project/lib/money.sh` has `cents_to_str()` that prints `0.5` for 5 cents; callers `bin/receipt.sh` and `bin/refund.sh`. Task names only the receipt: "the receipt shows 0.5 for 5 cents, must be 0.05". Check: both scripts print `0.05`, `1.05`, `0.00` for 5, 105, 0. `bad/` fixes the padding inside `receipt.sh` only.
     - `rename` — the key `user_name` in `project/lib/users.sh` (function `user_name()`), `bin/greet.sh`, `tests/test_users.sh` and `tests/fixtures/users.txt` (`user_name=…` lines). Task: rename the field `user_name` to `display_name`. Check: no `user_name` left under the project (outside `docs/`), `bash tests/test_users.sh` exits 0, `greet.sh` still greets. `bad/` renames only `lib/users.sh`.
     - `traversal` — `project/data/` with `hello.txt` and `project/secret.txt`. Task: add `bin/show.sh <name>` printing the note `data/<name>`. Check: `show.sh hello.txt` prints its text; `show.sh ../secret.txt` and `show.sh /etc/hosts` exit non-zero and print nothing of those files. `good/bin/show.sh` refuses with `if` and a comparison (`[ … ]` with `=`/`!=` or `-eq`), and `good/` also has `tests/test_show.sh` asserting both the note and the two refusals. `bad/` is `cat "data/$1"`.
     - `native` — `project/words.txt`. Task: add `bin/top-words.sh <file>` printing `<count> <word>` per word, most frequent first, ties by word. Check: the exact expected output on `words.txt` and on an empty file (no output, code 0). `bad/` breaks the tie order.
  2. `over/` of `reuse` re-implements `trim` and `lower` with option flags; `over/` of `native` builds the count with a `while read` loop over a sorted temp file and a counter, a config variable and a usage function — no associative arrays: the traps run under `/bin/bash` 3.2. Both pass `check.sh` behaviour except where the check is about reuse.
  3. `task.md` and `requirements.md` say what to build in the user's words only: no hint of the trap (no "reuse", "callers", "validate", "use sort").
  4. `seed-trap.sh`: like `seed-pair.sh`, with its `git init` and the commit `seed`, but phase `requirements confirmed`, the topic cards from the trap's `task.md` and `requirements.md`, and a `scope.md` with "Out of scope: none".
  5. `trap-test.sh`: per trap, in fresh temp copies under `CB`: `project/` + `good/` → check passes; `project/` + `bad/` → check fails; prints the lines of "gives".
- **Checks:** line 35
