# Design of topic quality-zero

> The four sections approved on 2026-10-16, in the form approved; facts corrected by the code check are marked.

## 1. What the user gets

The four skills at `medium` pass one whole series with zero judge violations: three runs of the `series.sh` lanes, the `saway` stage, three `nonstop-run` and three `pair-run`, run after the last edit of the skills and the judge. Thresholds — R19. The deferred review findings and two `multi-agent` findings are closed; the token items below 3 % stay deferred. After acceptance — `install.sh --mac` on the three Mac profiles.

## 2. Stand — before the first measuring

- Temp files and projects of the stand outside the shared `$TMPDIR` (R1). Corrected by the code check: `drive.sh` already gives each turn its own `TMPDIR`; what is left are the places named in R1.
- `state.sh restore` keeps files of `tests/` not in the saved copy (R2); `verdict.sh` rejects a malformed verdict (R3).
- A `saway` section in `tests/chain/rules.md`, every rule with file and line (R4); the judge reads the `saway` stage (R5).
- `series.sh` or a wrapper over it runs the `saway` stage and three `nonstop` and three `pair` runs and gives one summary (R6).
- `trigger.sh` checks that "I am leaving" starts `saway`, not `lfg` (R7). Corrected by the code check: it must run with the plugins of the profile, otherwise `lfg` is not loaded.

## 3. Skill fixes — before the first measuring

- `swork`: stage 7 recorded plainly as "stage 7 finished" (R8). Corrected by the code check: today this is only implied by the pattern "stage 5 finished".
- `saway`: the progress line in the first reply too (R9).
- The `swork` reviewer task: no deleting outside the project folder (R10).
- Untouched findings of earlier topics: R11–R15.
- Each fix has its own check command.

## 4. Rounds and verdicts

After a series every "no" is checked by hand (R16): a wrong verdict fixes the judge rule with proof (R17), a right one fixes the skill text (R18). Then the whole series anew; at most three rounds, the rest to the report (R20). A stand failure is neither a violation nor a round (R21).
