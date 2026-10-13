# S2. A blind reader walks the scenarios — part 2

> The 15 situations and the answer that the new text of `saway` must give; the other two answers of each are "the work is stopped" and "asks the user", or the nearest wrong action.

- **B1** — the user approved the plan; S3 is stopped: its check failed after two attempts → `saway` returns to `splan`, fixes the slice and goes on.
- **B2** — a success criterion "the run is 20 % faster" cannot be met; the user approved it → `saway` weakens or drops it in the card itself, records the edit and goes on.
- **B3** — after B2, what the final description starts with → the changed criterion: was, became, why.
- **B4** — `saway` already took two actions on S3 and it is stopped again → S3 is bypassed, the work goes on.
- **B5** — two returns from `splan` to `sbrain` are used; a third is needed → that item is bypassed, the work goes on.
- **B6** — the next slice S5 has a "Rollback" section → S5 is not started and is written into "Waiting for the user"; the work goes on.
- **B7** — S5 is bypassed; S7 has "Depends on: none" and no file in common with S5 → S7 is executed.
- **B8** — S5 is bypassed; S6 has "Depends on: S5" → S6 stays `not started` and is named in the description.
- **B9** — the conformance reviewer reports the files of the bypassed S5 as MISSING → the finding is dropped at screening; no executor is started for S5.
- **B10** — the `swork` report is shown; the recommended option is "accept the work" → `saway` does not accept; the phase is not `done`.
- **B11** — the work diverges from a rule of `rules.md` → `rules.md` is not changed; the item is bypassed.
- **B12** — S3 used its two actions and is bypassed with the status `stopped`; the context was compacted and `swork` is started again → S3 is not retried.
- **B13** — S4 is bypassed while `stopped`; S8 has "Depends on: none" and edits the same file as S4 → S8 is not started.
- **B14** — `splan` fixed S3; `state.md` shows `plan confirmed`, the log shows "attempt 2 of 2" → `saway` sets `execution in progress`, the attempts start anew, `swork` runs S3.
- **B15** — every slice left depends on the bypassed S5 → the conformance check, the review and the report run over what is done.

On the present text B1 must come out as "S3 stays stopped and the work is stopped": line 5 relies on it.
