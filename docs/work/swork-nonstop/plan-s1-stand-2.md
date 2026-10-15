# S1. Stand for a continuous swork — part 2

> The nine scenarios of `nonstop-scenarios.md` and the right answer of each.

The user is present but busy; `swork` executes a confirmed plan unless the scenario says otherwise. The right answer is the letter after the dash; write the other two answers as plausible wrong ones — a stop with a question, and a silent skip.

- **N1** — the check of S2 cannot run: the machine is unreachable; one try to wake it fails. Right: S2 marked "not checked", a `⚠` line in the chat, the next slice starts — `b`.
- **N2** — S3 has a manual check, S4 depends on S3. Right: S3 awaits the manual check, S4 is executed and marked "on unchecked ground" — `a`.
- **N3** — a changed file outside the plan, no copy to restore it, the executor did not name it. Right: path into `known.txt`, the file untouched, named in the report, work goes on — `c`.
- **N4** — continuing: S5 has a "Rollback" section and a "started" record without an outcome; the code does not show whether the saving or the action ran. Right: S5 is bypassed, neither the saving nor the slice is repeated — `b`.
- **N5** — continuing: no slice depends on done S1; its check is red, two attempts fail, the card was already edited twice. Right: S1 `bypassed` and named in the report, the rest goes on — `a`.
- **N6** — a small change from the chat; its check is red after two attempts. Right: the plan text in the chat is fixed, a `⚠` line, the result goes on to the report with "Decided myself" in the chat — `c`.
- **N7** — during S2 the user writes "use the other config file". Right: the correction is taken from the next step, no question, no stop — `a`.
- **N8** — `state.md` has the phase `plan written`. Right: `swork` does not execute, names the phase — `b`.
- **N9** — S6 is not done, has no `no behavior change` mark, its check is green before the edits. Right: the command of its check line is fixed so that it checks the slice, "Expected" stays, recorded as decided — `c`.
