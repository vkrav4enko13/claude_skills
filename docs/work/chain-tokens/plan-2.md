# Plan of topic chain-tokens — part 2

> The gate procedure every series goes through, the assumptions, and the places the edits leave as they are.

## Gate procedure

1. **A series:** `bash tests/chain/series.sh <name> . --effort medium`, then `bash tests/chain/judge.sh <name>`, then `bash tests/chain/gate.sh en <name>`.
2. **The gate failed** — every level stays `medium`. Reply `could not` with the failed stages, the missing seeds and the `no` lines of the verdicts of the series: the texts behind those rules are fixed by a slice of their own (S13 for the baseline), then the series is rerun from step 1 — at most twice.
3. **A rerun** goes on a clean series: delete `$S/<name>`, the folders `$S/blind/<label>` and files `$S/blind/<label>.json` of its runs and their lines of `$S/blind/key.tsv`.
5. **A lever batch (S9–S11)** saves its files into `$S/<name>/before/` before the first edit. If its series fails, copy them back, run the series `<name>r` by step 1 and take it for `<name>` in the check lines; `<name>r` fails too — reply `could not`.

## Assumptions

- A slice whose group has no `taken` lever is done by its gate line alone — slices: S9, S10, S11
- The main session of `swork` carries out the line "After the slice (main session)" of a slice card — slices: S5, S12
- R14 will come out `deferred`: on the stand a session runs one skill, so a repeated read of the wiki rules does not occur — slices: S5, S9

## Kept in place

No slice edits these: the next step mirrored in the root index (`swork/references/slices.md`, step "Mark the start"); the notes after each slice (the same file, step 8); the small-path ritual (`swork/references/small.md`); `created.txt` (`swork/references/snapshot.md`, `slices.md`); the earlier formats (`swork/references/entry.md`, `splan/SKILL.md`, `sbrain/references/wiki-migrate.md`); the layers of consent ("Approval covers only what was shown" in `splan/SKILL.md`, `sbrain/SKILL.md`); the confidence percent (`sbrain/references/context.md`); the tree counter (`sbrain/references/survey.md`); the four "Traps" tables; the set of reviewers; the model.
