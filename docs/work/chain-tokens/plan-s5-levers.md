# S5. Ranking of the levers

> The levers R12–R22 are sorted by what the chain spends at `medium`; the small ones are deferred with their numbers.

- **Status:** done
- **Covers:** R10, R11
- **Depends on:** S4
- **Files:**
  - create: `tests/chain/levers.tsv`
- **Interfaces:**
  - takes: `bash tests/chain/trace.sh medium <sections>` and `bash tests/chain/trace.sh away-m <sections>` (S1, S4)
  - gives: `tests/chain/levers.tsv` — tab-separated, the header row `lever⇥group⇥kind⇥tokens⇥percent⇥verdict⇥basis`, then eleven rows `R12`…`R22` in descending order of `tokens`. Groups: `reading` — R12, R13, R14; `output` — R15, R16, R17, R18; `deletion` — R19; `round` — R20; `context` — R21, R22. Kinds: `deletion` — R19; `input` — R21, R22; `behaviour` — the rest.
- **Reuse:** the sections `total`, `roles`, `kinds`, `reads`, `overview`, `requests` of `tests/chain/trace.sh`
- **What to do:**
  - `tokens` is the upper bound of what the lever can save per run of the baseline — the whole sink it addresses, by the rules of part 2, a whole number. `percent` is `tokens` / `total output_per_run` of `medium` × 100, one decimal.
  - `verdict` is `taken` when the kind is not `behaviour` or `percent` is 3.0 or more; otherwise `deferred`.
  - `basis` is one phrase: the numbers of the map the row was counted from.
- **After the slice (main session):** for every `deferred` row add to "Deferred" of `docs/00-index.md` the line `- chain-tokens R<N>: <the lever in a few words> — <percent> % of a run's output, below 3 %`.
- **Checks:** line 15
