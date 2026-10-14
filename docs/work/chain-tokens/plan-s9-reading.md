# S9. Batch "extra reading"

> Reviewers read only what their task names, the main session reads a reference file once and at its stage, the wiki rules — once per session; the series `b1` confirms the quality.

- **Status:** done
- **Covers:** R12, R13, R14, R24, R8
- **Depends on:** S5, S6, S7, S8
- **Files:**
  - change: `splan/references/review.md` ("What to pass", the task block), `swork/references/conformance.md`, `swork/references/review.md`, `swork/references/simplify.md` (the task blocks, line 3)
  - change: `sbrain/SKILL.md`, `splan/SKILL.md`, `swork/SKILL.md` (the sentence after the "Stages" table), `swork/references/slices.md` (step 3), `swork/references/finish.md` (stages 5 and 7), `splan/references/approval.md` (section 9)
  - change: `sbrain/references/wiki-rules.md` (line 3), `tests/chain/rules.md` (the `file:line` tails)
- **Interfaces:**
  - takes: `tests/chain/levers.tsv` (S5), the gate procedure, `gate.sh … --group reading` (S3), `trace.sh <series> reads` (S1)
  - gives: the series `$S/b1`
- **Reuse:** the READ line every reviewer task already ends with; the sentence "Read the stage file in full when you reach the stage" of the three `SKILL.md`
- **What to do:** make only the edits of the levers that `levers.tsv` marks `taken`; none of the group is taken — make no edit and run no series. Before the first edit save the files into `$S/b1/before/`.
  - **R12.** Every reviewer task block gets, right after its paths: "Do not open the files of the skills — `SKILL.md` and `references/` of `sbrain`, `splan`, `swork`, `saway` — unless the plan or the changed files name them." The search across the project code stays as the tasks order it. The plan reviewer is told which cards to read: every card of the topic index except `plan-overview.md`, `progress*.md` and `away*.md`; "What to pass" says the same. The code reviewer's task names `plan-decisions.md` in place of the topic folder.
  - **R13.** The sentence "If the text refers to a section or a step from another file, read that one too" becomes: read that section when you reach the action that needs it, not the file ahead of its stage. The task files `executor.md`, `conformance.md`, `simplify.md`, `review.md`: the main session cuts the blocks out as now and reads the rest by a command that prints the file without its code blocks — `awk '/^\140\140\140/{f=!f; next} !f' <file>` — at the stage that needs it; the "Read …" orders of `slices.md` step 3, `finish.md` stages 5 and 7 and `simplify.md:3` say so. `approval.md`, section 9: of `plan-format.md` only the paragraph "The lines of `state.md` that `splan` writes".
  - **R14.** To line 3 of `wiki-rules.md` add: "If this text is already in the context of the session — from the copy of any chain skill — do not read it again."
  - Then the series `b1` by the gate procedure.
- **Checks:** lines 26, 27, 28, 29
