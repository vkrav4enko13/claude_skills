# Plan review

Read at step 8, before the plan is shown.

## Self-check

Reread the plan against the requirements; fix in place:

1. **Coverage.** Each requirement has a check line whose scenario checks exactly it (one line may name several requirements that one command checks); each line has one slice naming it in "Checks"; no slice without lines. A requirement without a line — add line and slice or say why not; a slice without a requirement — remove or ask.
2. **Unambiguity.** No "What to do" line that decides nothing.
3. **Consistency of names.** "takes" matches the neighbours' "gives"; nothing taken that no slice gives and the code lacks.
4. **Order.** No dependency cycle, no use of what comes later; the first slice goes all the way through.
5. **Checkability.** Lines check slice behaviour, not "the build passed"; one is end-to-end, owned by the slice reaching the goal; command plus "Expected" would catch a breakage.
6. **Check focus.** Each line has a slice and its check line; empty means searched, nothing found. Name what breaks nearby unaccounted for.
7. **Concession words.** "For now", "temporarily", "a stub", "in the first version", "simplified" where the requirements did not permit it: complete the slice or ask the user.
8. **Measure.** Code blocks do not dominate; no lines retell requirements without a decision.
9. **Slice size.** Each fits one fresh session with code reading and check; else split.
10. **Rollback.** Every irreversible slice has save and restore commands that run as written.
11. **Wiki.** The check script prints `wiki is fine` (`references/wiki-rules.md`, section "Check").
12. **Ready-made code.** "Reuse" filled in everywhere, the named code exists.

## Separate agent

A large plan in cards — more than three slices or a slice of larger code (more than one file or about 20 changed lines) — is read by a fresh agent that has not seen the conversation, described `Plan review of <topic>`. Small: self-check only, shown with: no fresh reviewer: small plan. No subagents — tell the user there was no independent review.

**What to pass:** the topic folder path, the project root, the task text if there are no requirements. Never the conversation, your arguments or the conclusion "the plan is good".

**The task** is the code block below; never retype or retell it: `awk '/^\140\140\140/{f=!f; next} f' <this file> > <temporary folder>/plan-review.txt`, then tell the agent "Read the task in the file <path> and carry it out word for word", with what to pass. Nothing to cut with — pass the block word for word.

```
Review the work plan before execution. Reply in English. Topic folder: <path> — plan and
requirements as cards (no requirements — the task: <text>).
Project: <root>. Change nothing — only read.
Delete no file and no folder outside the project folder, temporary folders included.

Assume the plan has flaws; find them against the code and the requirements:

1. Claims about the code: every path, function name, signature and command exists
   as stated. Name each one not confirmed.
2. Where the executor will have to guess.

Return the findings as a list, the most serious first. For each:
- severity: "blocking" (following the plan will give something wrong or something
  that does not build), "worth fixing", "nit";
- the place in the plan (the section, the slice number);
- the evidence: a path and a line in the code or a requirement number;
- what to change.
Found no flaws in some item — say so, do not make any up.
Mark separately everything you could not check.
```

## What to do with the findings

Fix, then show. A second round only after a confirmed "blocking": the same task with the fixed places, checking only them and their neighbours. No third round: name the rest when showing the plan.

- **First check the finding.** No path and line — a guess.
- **"blocking" and "worth fixing"** — fix in the plan in place. The fix touched names or dependencies — redo self-check items 3 and 4.
- **The finding changes the scope or the behaviour** — do not decide: ask the user one question before showing the plan.
- **The finding shows that the requirements do not agree with the code** — a discrepancy from step 6: name it; the plan for that requirement is not ready.
- **You disagree with the finding** — keep the plan; one line when showing it: the finding, why not fixed.
- **"nit"** — fix if one line; otherwise skip silently.
