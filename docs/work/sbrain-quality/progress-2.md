# Progress log of topic sbrain-quality — part 2

> The continuation of the progress log.

- stage 6: skipped — a shared `texts`/lookup helper for `drive.sh` and `collect.sh`, two redundant `topic`/`phase` assignments, the merged case arm of `collect.sh` and the merged loop of `judge.sh`: each needs a stand run to check, for no change in behaviour
- stage 6 finished
- stage 7 started
- stage 7: fixed — `replies()` lost the summary behind a `<task-notification>` record (serious); the survey persona held the grill part (serious); second round: both right
- stage 7: declined — the persona prompt takes the recommended option on an uncovered menu (by the plan's design); an `error` run counts as measured (by the plan); a mixed chain-and-survey run packs as a survey (not used); `measure.sh` zeros (known)
- S5: attempt 1 of 2 after stage 7 — the baseline was measured on a stand with the two errors: `sv-base` is run anew on the fixed stand
- stage 7 finished
- S5: the new baseline on the fixed stand — violations 2 (run 1: sv-3 five questions in a round, sv-4 the counter after the questions), decisions 14/15 (run 2: decision-5 "several files out of scope" not carried), flaws 15/15; 37447 output tokens per run; lines 11, 12, 14 green · `checks/S5-3.txt`
- S6: still no miss in two runs or more — no fix; `sv-final.current` stays `sv-base`
