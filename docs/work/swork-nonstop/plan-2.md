# Plan of topic swork-nonstop — part 2

> Assumptions of the plan and the discrepancy rule for the executor.

## Assumptions

- `docs/rules.md` already holds R17: written by `sbrain` on 2026-10-15 — slices: S5
- Under `saway`, an irreversible slice that acts outside the project folder is still bypassed: the `saway` ban on actions outside the project wins — slices: S3, S5

## If the code differs from the plan

Stop and report: **expected** — what the plan says; **found** — what is in the code, with the path;
**why it matters** — what fails to line up because of it. Do not silently bend the code to the plan or the plan to the code.
Report a minor discrepancy too (a file moved, a name changed, the meaning is the same): the slice card is fixed by `swork`, not by you.
