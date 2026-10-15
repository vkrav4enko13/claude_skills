# S5. saway without duplicates, and the gate — part 2

> What to do in `saway/SKILL.md`, in the scenarios and in the judge rules.

1. `saway/SKILL.md`:
   - line 10: the precedence stays, except that `swork` decides its former stops itself;
   - line 17 and the row of line 56: `swork` decides its former stops itself by its section 4; the row → `swork`;
   - line 26: a slice of the plan with a "Rollback" section is exempt from every clause of the item; the rest stays;
   - line 28 stays and wins: a "Rollback" slice or an environment repair outside the project folder is forbidden — record it as a bypass;
   - line 29: "by `swork`", keep the `away.md` assumption mark; line 30: the own card edits of `swork` count as minor and never contradict `rules.md` or a decision "in force";
   - delete the item "A `swork` stop" (line 81) and the bypass items moved to `swork` (86–90); line 84: "a slice that used its two actions" → "a slice `swork` set to `bypassed`"; line 85: a slice `saway` forbids gets the status `bypassed`, its `away.md` line stays; the clauses "a slice that used its actions stays `stopped`" and "against the status rule of a `swork` stop" go; line 91 stays;
   - a "Rollback" slice executed without the user goes under `## Waiting for the user` of `away.md` as `- executed without the user: S<N> <title> — rollback: <the command>`;
   - line 140, trap "The slice has stalled": → "`swork` bypasses it itself; record it in `away.md`".
2. `away-check.sh`: `forbidden` → `irreversible slice`, status of S5, value `done`; `dependent slice` → `done`; `waiting` stays `named` (the line of step 1). Update the header comment.
3. Scenarios. B1 — the stop menu goes; a) becomes a plain question to the user; b) becomes "`swork` edits the card of S3 itself, records it and the execution goes on"; letter `b`. B4 — "`swork` edited the card of S3 twice and it is still red" instead of the two `saway` actions; letter `a`. B6 — the column is in `data/app.db`, a file in the project folder; letter `a`. B12 — "used both card edits of `swork`", status `bypassed`; letter `a`. B13 — status `bypassed`; letter `a`. B14 — `swork` edited the card of S3 once after two failed attempts; answer c) becomes "the attempts of S3 start anew and `swork` runs S3"; a) and b) stay a stop and a question. F2 — c) becomes "Ends the turn with a question to the user: may S4 edit `lib/config.sh`"; letter `b` stays the right one (`fields-expected.tsv` already has `F2 c` — change it to `F2 b`). F8 is not touched. Update `away-expected.tsv`: `B6 a`.
4. `tests/chain/rules.md`: move the `file:line` references of the `swork-*` rules to the lines after S3 and S4; the wording of the rules stays.
