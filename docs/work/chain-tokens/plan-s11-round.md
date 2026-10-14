# S11. Batch "second round"

> A second round of a reviewer gets a short task of its own about what was fixed; the series `b3` confirms the quality.

- **Status:** done
- **Covers:** R20, R24
- **Depends on:** S10
- **Files:**
  - create: `swork/references/review-round2.md`, `splan/references/review-round2.md`
  - change: `swork/references/review.md` ("Second round"), `splan/references/review.md` ("What to do with the findings")
  - change: `swork/SKILL.md` (the list of task files), `tests/chain/rules.md` (the `file:line` tails)
- **Interfaces:**
  - takes: `tests/chain/levers.tsv`; the gate procedure; `gate.sh … --group round`
  - gives: the series `$S/b3`
- **Reuse:** the reply form of `swork/references/review.md:39-48` and of `splan/references/review.md:41-48`; the cut command of `swork/SKILL.md:17`
- **What to do:** R20 is `deferred` in `levers.tsv` — no edit, no series. Otherwise save the files into `$S/b3/before/`, then:
  - Each new file holds a "Read at …" line and one code block — the task of the second round. The task carries: the list of the fixed findings — the place and what was changed; the paths of the fixed files and, in `swork`, their `base/` copies; the question — is each fix right and did it break what is next to it; the reply form of the first round with the READ line; "Reply in English"; "Change nothing — only read". It does not carry the checklist of the first round.
  - `swork/references/review.md`, "Second round": "Give the same task the list…" becomes: cut the block of `references/review-round2.md` into `<temporary folder>/review-round2.txt` and pass it with the list of the fixes. The launch description starts with "Second round".
  - `splan/references/review.md`: the same with `references/review-round2.md` and `<temporary folder>/plan-review-round2.txt`; the launch description is "Second round of plan review"; say that the second round is read by a new agent.
  - Then the series `b3` by the gate procedure.
- **Checks:** lines 35, 36
