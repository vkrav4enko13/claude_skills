# S5. Ranking of the levers — part 2

> How the upper bound of every lever is counted from the map of the baseline; every number is per run.

- **Share of a class** below is the bytes of that class in the `reads` lines of a role divided by the bytes of all its classes.
- **R12** — over the roles `plan-review`, `plan-review-2`, `conformance`, `review`, `review-2`: the output of the role × its share of the classes `skill` and `task`.
- **R13** — the output of `main` × its share of the class `task`: the task files the main session reads in full though it only cuts their blocks out.
- **R14** — `reads session-max wiki-rules` is 1 or 0 — the number is 0, and the lever is deferred: on the stand a session runs one skill, so the repeat it removes does not occur there. Otherwise the output of `main` × its share of the class `wiki-rules`.
- **R15** — the `overview` lines: `<tokens>` minus `<first>` — the writes of `plan-overview.md` after the first one.
- **R16** — `<first>` of the `overview` lines: the same text is shown in the chat a second time.
- **R17** — `<prompt>` of the `roles` lines of `executor` and `fixer`.
- **R18** — on `away-m`: the `text` tokens of `main` in the `requests` lines, without its last request — the full description stays.
- **R19** — `tokens` is 0, the basis is `deletion: not ranked`.
- **R20** — the output of the roles `review-2` and `plan-review-2`.
- **R21, R22** — `tokens` is 0, the basis is `input side: taken without the threshold, the user's decision of 2026-10-13`.
