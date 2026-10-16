# S2. The series judges every stage

> One series runs the lanes, the `saway` stage, `nonstop` and `pair`, judges `saway` too and gives one `zero:` summary.

- **Status:** done
- **Covers:** R4, R5, R6, R21
- **Depends on:** S1, S4, S5, S6
- **Files:**
  - change: `tests/chain/rules.md` (new section `## saway`)
  - change: `tests/chain/judge.sh` (packing `:77-95`, the `away` loop `:87`, labels)
  - change: `tests/chain/judge-prompt.md` (the stage table `:7-12`, the paths `:21`, the sections `:27`)
  - change: `tests/chain/series.sh` (stage list `:57-62`, `lane()` `:93-125`, `run()` `:128-143`, header)
  - create: `tests/chain/zero.sh`
- **Interfaces:**
  - takes: `tally_label` of `tests/chain/tally.sh` (S1); the record `stage 7 finished [<name>]` (S4)
  - gives: stages `away`, `nonstop`, `pair` of `series.sh --stages`; `bash tests/chain/zero.sh <series>` — the ten lines below, code 0 on `zero: pass`, 1 otherwise; rule ids `saway-<N>`
- **Reuse:** `stand.sh <folder> <skills>`, `seed-away.sh <project>`, `seed-pair.sh <project> a|b`, `drive.sh <project> <stage> <dir> [effort]`, `drive.sh <project> pair <dir> <effort> <topic>`, `away-check.sh <project> <dir>`, `nonstop-check.sh <project> <dir>`, `pair-check.sh <project> <d1> <d2> a|b`, `stage_done` (`series.sh:88`), `label_of` and `project` (`judge.sh:57,63`)
- **What to do:**
  1. `rules.md`: a section `## saway` after `## swork`, lines `- saway-<N>. <rule> — saway/SKILL.md:<line>`, in the form of the other sections — at least 8 rules, each one statement seen in the traces of the away stage: the chat language, the progress line on every message, no question to the user, no commit and no push, the decision record, the bypass, the last line of the description, the entry by `state.md`. After S4 and S5, move every citation of `rules.md` to the current line of its source — `rules.md:66` to the line of the stage records in `swork/references/finish.md`.
  2. `judge.sh`: a run gets a key line `<label>⇥<series>⇥<run>` for brain, plan, work, seed, away and `<label>⇥<series>⇥<run>-survey` for survey and grill — each only when the run has such stages; a run with survey lanes only gets the `-survey` line alone; add `away` to the stage loop and `project "$R/awaybox/wiki-trial/clean" "$D/project-away"`.
  3. `judge-prompt.md`: rules have four sections; a row `away` → `saway` in the stage table; `project-away/` in the path mapping; check `saway-<N>` against the away chat and `agents-away/`.
  4. Continued in [part 2](plan-s2-series-2.md).
- **Checks:** lines 5, 6, 7
