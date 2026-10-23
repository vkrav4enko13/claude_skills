# S2. Stand tools: result check, pairwise judge, lever counts

> The stand tells whether `count.sh` is right, which series did a lane better, and how many subagents each stage used.

- **Status:** done
- **Covers:** R19, R20, R7, R8, R11, R12 (the counting side)
- **Depends on:** S1
- **Files:**
  - create: `tests/chain/count-check.sh`, `tests/chain/fixtures/count-good/count.sh`, `tests/chain/fixtures/count-words/count.sh`
  - create: `tests/chain/pair-judge.sh`, `tests/chain/pair-judge-prompt.md`, `tests/chain/levers-check.sh`
  - change: `tests/chain/compare.sh` (`count-check.sh` on the `count` lane; the trap lines printed also when single `trap-<name>` stages are named, `:389`), `tests/chain/compare-test.sh` (a case for each change)
- **Interfaces:**
  - gives: `count-check.sh <dir with count.sh>` → `count ok` exit 0 | `count wrong: <input> → <got>, want <want>` exit 1
  - gives: `pair-judge.sh <series A> <series B>` → per lane `<lane>: better|equal|worse — <reason>` (B against A), last line `pair: <b> better, <e> equal, <w> worse`
  - gives: `levers-check.sh <series>` → per run and stage `<run>/<stage>: executor=<n> pass=<n> round2=<n> reviewer=<n> stage-agent=<n>`
- **Reuse:** `role_of` and the `roles` mode of `tests/chain/trace.sh` (`:116-127`, reads `description` of `agent-*.meta.json`); the blind label/key scheme and the session call of `tests/chain/judge.sh`
- **What to do:**
  - `count-check.sh` copies `count.sh` into a temp folder, `cd`s there (it may read `app.txt` by `$(dirname "$0")` or from the working folder) and runs it on: 3 lines holding 6 words → `3`; an empty file → `0`; `-v` on the 3 lines → `3 слов`.
  - `levers-check.sh` copies the jq `role_of` of `trace.sh:116-127`, globs every stage folder of each run itself (`small` and `trap-*` included) and reads `raw/subagents/agent-*.meta.json`; it maps the outputs: `executor` → executor, `conformance` and `review` → pass, `review-2` → round2, `plan-review` and `plan-review-2` → reviewer, `stage` → stage-agent.
  - `pair-judge.sh`, run `1` of both series, one session per lane at effort `medium`, prompt in `pair-judge-prompt.md` (quality and correctness only, not length or speed); lane → input: only the lanes present in both series, `<lane>: skipped` for the rest; the final report is the `.result` of the last `turns/*.json`; `count` (stages `brain plan work`) → `docs/work/count/` cards, `wiki-trial/clean/count.sh`, the final report; `seed` → the topic cards and the report; `survey`, `grill` → `chat.md`; `away` → `chat.md` and `awaybox/wiki-trial/clean/docs/work/longest/away.md`; `small` → `chat.md` and `count.sh`; `trap-<name>` → the changed files.
- **Checks:** lines 3, 4, 5, 6
