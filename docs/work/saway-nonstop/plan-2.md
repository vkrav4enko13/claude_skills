# Plan of topic saway-nonstop — part 2

> Assumptions, deferred questions and the discrepancy rule of the plan.

## Assumptions

- A headless `claude -p` session drives `saway` to the full description in one turn, without `/goal` — slices: S1, S6
- One stand run takes 25–60 minutes and 6–15 dollars; the plan makes two: "before" in S1 and the acceptance one in S6 — slices: S1, S6
- One blind reader per text is enough for R16; it runs five times — slices: S2–S6
- The edited `saway/SKILL.md` fits into 6000 tokens: today it is 4274 by the counter of line 28, the edits add about 1300 — slices: S3, S4, S5
- "Awaiting acceptance" of R9 is the phase `execution in progress` with the next step `user's choice after the report`: the wiki has no separate phase — slices: S4, S6

- A Russian description names the options of the report with the three Russian stems of "accept", "fix" and "roll back" in its last 12 lines; another wording fails condition 12 of `away-check.sh` — slices: S1, S6

## Deferred questions

- Does the turn limit of 100 hold under a real `/goal`? — the user, at the first night under `/goal`; until answered: 100 is taken from the rate of 6.4 turns per hour of the night of 2026-10-12

## If the code differs from the plan

Stop and report: **expected** — what the plan says; **found** — what is in the code, with the path;
**why it matters** — what fails to line up because of it. Do not silently bend the code to the plan or the plan to the code.
Report a minor discrepancy too (a file moved, a name changed, the meaning is the same): the slice card is fixed by `swork`, not by you.
