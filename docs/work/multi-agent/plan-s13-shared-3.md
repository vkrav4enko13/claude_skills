# S13. Skills: the switch and the shared mode — part 3

> What to do in S13, items 9–11: the report, the pair premise and the blind scenarios.

## What to do

9. **`report.md`** — a "Mode" item before "Waited", naming `references/modes.md`: the mode and its reason from the `mode:` records, and the outcome of `off --if-last`; in the short report the same line.
10. **`pair-scenarios.md`** — its intro gets: "`.agents/mode` holds `shared` in every scenario."
11. **Scenarios Q1–Q11** in `tests/chain/modes-scenarios.md` — the eleven cases of line 36 in that order, in the form of `pair-scenarios.md`, each with three answers, one right, the right letters shuffled; the right answers: Q1 write without waiting and without a question; Q2 `agents.sh on` before the first write; Q3 `agents.sh on shared`; Q4 claim the card alone; Q5 `wait` in a loop, claim again, no question; Q6 wait for the holder's `done`, rerun once, a red again is its own; Q7 keep the version that was there before, remove its own, rerun; Q8 the shared mode from the next slice with a record; Q9 the report names who keeps the mode, the file stays; Q10 the shared mode, the report names the reason; Q11 reverse its own logged diffs, never a `base/` restore. `modes-expected.tsv` — `Q<N>⇥<letter>`.
