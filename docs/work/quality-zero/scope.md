# Scope of topic quality-zero

> What is out of scope, the assumptions, and the facts from the code check that the plan has to deal with.

## Out of scope

- Token items below 3 % (chain-tokens R12–R20).
- `multi-agent`: the timing case of an early finish and the clash of `.agents/` with a repo's own folder.
- A `saway` run under `/goal`.
- Publishing the skills, trial tasks from real chain failures, a hook against editing tests.
- Scripts in place of skill text for rules the model skips (approach C).
- The uncommitted translated headings of old topic cards in the working tree.

## Assumptions

- If zero is not reached in three rounds, the topic still ends: the user accepts a report with the leftovers and their causes.
- The rule of 2026-10-11 "an edit is accepted only if quality and accuracy are not worse" is met by the acceptance series itself.
- A series with six more runs takes several hours; up to three such series are acceptable — tokens may be spent on this check by the rule of 2026-10-11.

## Facts for the plan

- `judge.sh:47-48` reads `before/rules.md` ahead of `tests/chain/rules.md`; `series.sh:83` copies the rules into a series once — new rules do not reach an existing series.
- `judge.sh:77-95` packs only brain, plan, work, seed or survey, grill chats: the away chat never reaches the judge.
- `series.sh:57-62` and its `lane()` case have a fixed stage list; `nonstop` drives `seed` into `$T/stage`, clashing with the longest lane's `seed` and `seedbox`; `pair` needs two folders at once and the case a or b.
- `nonstop-run.sh` and `pair-run.sh` make one run each and have no `--runs` option.
- `verdict.sh quality` compares raw counts of "no"; with `saway` rules added only to "after" the counts stop being comparable.
- `agents.sh:117-129` picks ROOT as `AGENTS_ROOT`, the nearest `.agents`, the git root, then `docs/00-index.md`; the header at `:18` names only `busy:` lines for code 3.
- `trigger.sh:48` runs with `--setting-sources project,local`; `requests.tsv:19-22` holds the Russian requests for `saway`, no English one and no `lfg` row.
- Source: code check of 2026-10-16

## Open questions

None blocks the plan.
