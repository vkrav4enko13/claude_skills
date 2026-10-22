# S12. agents.sh: the switch of the multi-agent mode

> Without `.agents/mode` every `agents.sh` command answers "off" and writes nothing; `on`, `off` and `mode` switch it, and the last agent to end removes it.

- **Status:** done
- **Covers:** R35, R36
- **Depends on:** none
- **Files:**
  - change: `sbrain/scripts/agents.sh` (header; the command list and the argument parsing at :58–102; the unconditional `mkdir -p` at :132; new commands `on`, `off`, `mode`)
  - change: `tests/agents-test.sh` (the mode switched on in its toy projects)
  - create: `tests/switch-test.sh`
- **Interfaces:**
  - takes: the root search (`find_up`, :105–130), `alive()` (:206–209), `lock`/`unlock`, `owners` and the records `claims.tsv`, `seen/<id>.tsv` of `sbrain/scripts/agents.sh`
  - gives: `bash agents.sh on [auto|worktree|shared] [--topic <t>]` → code 0, prints `mode: <word>`, writes `<root>/.agents/mode` holding that one word (default `auto`; temp file and `mv`), under git adds the line `.agents/` to `$(git -C <root> rev-parse --git-path info/exclude)` if missing; `bash agents.sh off [--if-last] [--topic <t>]` → code 0 `mode: off` (removed or already absent), code 1 `mode: kept — <reason>` with the reason `claim of <name>`, `worktree of <id>` or `agent <id> active`; `bash agents.sh mode` → code 0 and the word, or code 1 and `off`; any other word after `on` → code 2; while `<root>/.agents/mode` is absent: `claim`, `wait`, `done`, `release` → code 0 and the one line `agents: off`, `busy` → code 1 and nothing, `others` → code 0 and nothing, `id` → as before, and none of them creates `.agents/` or writes into it; function `mode_now` printing `auto`, `worktree`, `shared` or `off`; `tests/switch-test.sh` printing `switch: ok` or `switch: <what failed>` with code 1
- **Reuse:** the root search and `find_up` (`sbrain/scripts/agents.sh:105–130`), `alive` (:206–209), the mutex (:250–286), the record names (:288–297); the test helpers `as`, `expect`, `has`, `live`, `fail` and the cleanup trap of `tests/agents-test.sh:20–55`
- **What to do:**
  1. The root search stays as it is; `on` uses it, so a project without `.agents/` gets its root from git or from `docs/00-index.md`.
  2. Replace the unconditional `mkdir -p "$A/diffs" "$A/held" "$A/seen"` (:132): `mode_now` reads `$A/mode`; when it is `off`, `claim`, `wait`, `done`, `release`, `busy`, `others` answer by the "gives" table and exit there; `mode` and `off` (with or without `--if-last`) answer and exit there too, before `touch "$CL" "$LOG"` (:294) and the lock; `id` goes on and exits right after printing (:243–245); `mode` always exits right after its answer, mode on or off; only `on` creates the folder. The `mkdir -p` runs only when the mode is on or the command is `on`.
  3. `on` — `mkdir -p "$A"`, write the word, add the exclude line; print `mode: <word>`. A second `on` overwrites the word.
  4. `off` — without `--if-last`: remove `$A/mode`, print `mode: off`. With `--if-last`, under the lock, in this order: a line of `claims.tsv` of another id that is `alive` → kept, `claim of <its name>`; a folder `$A/wt/<id>` (the id with `-` back to `:`) of another id that is `alive` → kept, `worktree of <id>`; a file `$A/seen/<id>.tsv` of another id that is `alive`, newer than `$A/mode` (`[ f -nt "$A/mode" ]`) and changed within the last 300 s → kept, `agent <id> active`; otherwise remove and print `mode: off`.
  5. The header lists `on`, `off`, `mode`, the answers while off and the record `mode`.
  6. `tests/agents-test.sh` — run `as "$A" ay on` after `:67`, once `A` and `B` are set and git is initialised, and right after `cd "$W/repo"` (:205); nothing else changes: it must still end `agents: all ok`.
  7. `tests/switch-test.sh` — `set -uo pipefail`, a toy git project under `${CHAIN_BASE:-$HOME/Documents/my/chain-stand}/switch-test.XXXXXX` removed by a trap, helpers copied from `tests/agents-test.sh:30–55` with `fail` printing `switch: …`; the cases of line 33 in its order; `echo "switch: ok"` at the end.
- **Checks:** line 33
