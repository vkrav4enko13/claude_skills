# S8. Rounds to zero and acceptance

> Whole series after the last edit until `zero: pass`, at most three rounds; every "no" read by hand; the rollout after the user's acceptance.

- **Status:** awaiting manual check
- **Covers:** R16, R17, R18, R19, R20, R21, R22, goal
- **Depends on:** S1, S2, S3, S4, S5, S6, S7
- **Files:**
  - change: `tests/chain/rules.md`, `tests/chain/rules-survey.md` (only for a wrong verdict, with its proof)
  - change: the skill texts of `sbrain/`, `splan/`, `swork/`, `saway/` that a right "no" names
- **Interfaces:**
  - takes: `series.sh` stages `<all stages>` and `zero.sh` (S2)
- **Reuse:** `zero.sh`, `series.sh`, `judge.sh`, `trace.sh <series>` as they are
- **What to do:**
  1. Round 1: run line 16 with `qz-r1`. Before a round, the skill texts and `rules.md` hold every edit made so far.
  2. For every "no" in the verdicts of the round — line 17: read the trace the verdict cites. A wrong "no": edit the rule wording in `tests/chain/rules.md` and write the quote from the trace into the progress log. A right "no": edit the skill text where the rule is written, in the form of the neighbouring lines; no effort change and no script in place of the text.
  3. A run failed by the stand (`drive.sh failed`, a lane not passed for a stand reason): fix the stand, delete that run's key lines from `blind/key.tsv` and its label folders under `blind/`, and rerun with `series.sh` on the same series — passed lanes are kept, the run is judged anew; it is not a round.
  4. A stage that is not done, a seed not found, decisions or flaws under 15, a failed `away`, `nonstop` or `pair` check — read its trace like a "no" in step 2.
  5. After an edit the next round is a new series, `qz-r2`, then `qz-r3`. At `zero: pass` stop the rounds; after round 3 without it, the report names every remaining violation, its rule and its cause.
  6. Line 19 waits for the user's acceptance; no slice depends on it.
- **Checks:** lines 16, 17, 18, 19
