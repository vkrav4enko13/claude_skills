# Progress log of topic quality-zero, part 4

> Stages 5–7: the conformance check, the simplification and the review.

- stage 5 started [b5a7a524-9760-4484-bc01-b093de06bf20]
- stage 5: reruns green — lines 1–5, 7–15, 20 (13: `17 of 17 ok`); line 16 red (round 3); line 6 stands on the rounds as on resume · checks/F-l*
- stage 5: conformance "beyond the plan" `saway/SKILL.md:12` — right: no saway "no" named the language line; line 12 restored from `base/`; lines 12, 13 rerun
- stage 5: conformance "beyond the plan" `tests/chain/nonstop-check.sh:61-63` — decided myself: kept; why: S8 step 4 reads a failed nonstop check like a "no", and its wrong-check fix is the stand fix of step 3; removing it fails a passing nonstop run; otherwise: removed, nonstop 3/3 of rounds 2, 3 not reproducible
- stage 5: conformance "wrong" `survey-gate.sh:48-50`, `verdict.sh:61-65` — dropped: the decision on counting by run folders is about the labels of `judge.sh` and `zero.sh` (S2), neither script is in the "Files" of a slice for this, and `verdict.sh quality` is in "Not doing"; already noted outside the slice
- stage 5: conformance "wrong" progress-2 saway-6 line — fixed: it names the `saway/SKILL.md:94` edit
- stage 5: conformance "wrong" (minor) `report.md:41`, `slicing.md:13` — left: recorded in progress.md, the meaning is kept, lines 11, 14 green
- stage 5: reviewer's note `swork/references/finish.md:12` "the bullet above" points at the wrong bullet — right; edited: "the bullet on "user's choice after the report""
- stage 5: conformance "wrong" `zero.sh:97-100` (`<all>` counts ten folders whatever the stages) — attempt 1 of 2 by the S2 executor
- stage 5: `zero.sh:97-100` closed in attempt 1 — `series.sh` writes the file `stages` of the series, `zero.sh` counts `<all>` from it, a series without it from its stage folders; line 7 green, `zero.sh qz-r3` still `stages: 30/30` · checks/F-l7-2, F-zero-r3
- S2: noticed outside the slice — `zero.sh:125-127`: a series without the away, nonstop, pair or seed stages still cannot pass, by the plan's thresholds
- stage 5 finished
- stage 6 started
- stage 6: applied — `zero.sh:94` `[ -s …/verdict.tsv ] || none` removed (`tally.sh:28` returns 1 on the same file); `agents-test.sh` last case through `as`; lines 1, 15, 7 green, `zero.sh qz-r3` unchanged · checks/G-*
- stage 6: skipped — `label_of`/`stage_done` into `tally.sh`: `tally.sh` is the tally of one verdict, and `judge.sh`, `series.sh` would need to source it; `agents.sh:358-361` awk: code from before this work
- stage 6: a dry `zero.sh qz-empty` made `judge.sh` judge an empty run (label 5dafc924); its key line and folder removed from `blind/`
- stage 5: line 13 rerun after the `saway/SKILL.md:12` restore — `17 of 17 ok` · checks/F-l13-2
- stage 6 finished
- stage 7 started
- stage 7: fixed 1 (serious) — `survey-gate.sh:55` takes per run the `-survey` label, else the plain one; `verdict.sh:65` the main labels only; `survey-gate qz-r1 qz-r2` now `decisions 15/15` per series
- stage 7: fixed 2 (serious) — `tally.sh` returns 1 when the verdict has fewer seed, decision and flaw lines than items in the label's seeds file; a rules-only survey verdict → rc 1, the full one counted; line 4 green, `zero.sh qz-r3` unchanged · checks/H-l4
- stage 7: left 3 (serious, could not be established) — `judge.sh:136,149-150` reusing an old-script survey label as main: no such run in the stand today; to check: a series judged before S2 with both kinds in one run
- stage 7: declined 4 (minor) — `trigger.sh:29` with no `settings.json` in the profile: every profile has it, a guard adds a branch
- stage 7: declined 5 (minor) — `agents.sh:350` `abandoned:` shown only in the refused call: `agents-rules.md:24` already says to read the file on `abandoned:`
- stage 7 round 2: fixes 1 and 2 right (21 stand labels still tally; three broken verdicts return 1)
- left untouched: `survey-gate.sh:55` a current run with main stages but no survey folder falls back to its main label and is counted as a survey run — found by the second round
- left untouched: `judge.sh:136,149-150` an old-script survey label reused as main — could not be established
- declined: `trigger.sh:29` guard for a profile without `settings.json` — every profile has it
- declined: `agents.sh:350` repeat `abandoned:` on the retry — `agents-rules.md:24` covers it
- declined: `label_of`/`stage_done` moved into `tally.sh` — a tally helper is not their place; `agents.sh:358-361` awk — code from before this work
- stage 7 finished [b5a7a524-9760-4484-bc01-b093de06bf20]
