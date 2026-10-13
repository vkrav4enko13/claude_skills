# Plan review

Read at step 8 — after the plan is written in cards and before it is shown to the user.

## Self-check

Reread the plan with fresh eyes, keeping the requirements in front of you, and fix in place:

1. **Coverage.** Go through the requirements by number: each has a check line, and its scenario checks exactly that requirement, not merely names its number. Go through the check lines: each has exactly one slice, and that slice names it in "Checks"; there is no slice without lines. A requirement without a line — add a line and a slice or name why it is not being done. A slice without a requirement is superfluous: remove it or ask.
2. **Unambiguity.** From every line of "What to do" the executor will write exactly one reasonable thing. A line that decides nothing is a hole.
3. **Consistency of names.** The names, signatures and types in the "takes" blocks match what the "gives" blocks of the neighbouring slices give. Nobody takes something that no slice gives and that is not in the code.
4. **Order.** The dependencies do not close into a circle; a slice does not use what will appear later; the first slice goes all the way through.
5. **Checkability.** Every check line has a command with the expected result or manual steps, and the lines check the behaviour of the slice, not "the build passed". One of the lines is end-to-end: it checks the goal of the plan as a whole, and it is owned by the slice after which the goal is reached. The command together with "Expected" would show a breakage rather than pass with any code.
6. **Check focus.** Each of its lines is assigned to a slice, and for that line a check line is set up that has this slice in the "Slice" column. An empty section means that you searched and found nothing. Name also what will break nearby and is not accounted for by the plan.
7. **Concession words.** "For now", "temporarily", "a stub", "in the first version", "simplified" where the requirements did not permit it are a silent narrowing of the scope. Either make the slice complete or bring the narrowing to the user as a question.
8. **Measure.** Code blocks do not take up most of the plan; there are no lines that retell the requirements without a decision.
9. **Slice size.** Every slice fits into one fresh session of the executor together with reading the needed code and the check. It does not fit — split where one part can be accepted without the other.
10. **Rollback.** Every slice with an irreversible action names what to save and how to bring it back.
11. **Wiki.** The wiki check script is satisfied: it prints `wiki is fine`. How to run it and how to fix what it names — `references/wiki-rules.md`, section "Check".
12. **Ready-made code.** Every slice has the "Reuse" field filled in, and the named code exists.

## Separate agent

An author who checks themselves confirms what they already believe. That is why a plan in cards is read by an agent that has not seen the conversation. If the environment has no subagents, say so to the user when showing the plan: there was no independent review.

**What to pass:** the path to the topic folder — it holds the plan cards and the requirements cards (there are no requirements there — the text of the task as well), the project root. Do not pass the conversation, your own arguments or the conclusion "the plan is good": they anchor.

**The task** is the code block below. Do not retype it and do not retell it: cut the block out with a command into a temporary file — `awk '/^\140\140\140/{f=!f; next} f' <this file> > <temporary folder>/plan-review.txt` — and write to the agent: "Read the task in the file <path> and carry it out word for word". In the message pass the path to the topic folder, the project root and, if there are no requirements, the text of the task. If there is nothing to cut with, pass the block word for word.

```
Review the work plan before it is executed. Reply in English. Topic folder: <path> — the plan and
the requirements lie in it as cards (no requirements — the task: <text>).
Project: <root>. Change nothing — only read.

Assume that the plan has flaws, and find them. Check against the code and against the requirements:

1. Claims about the code. Every path, function name, signature and command from the plan
   exists and looks as stated. Name every one that was not confirmed.
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

You got the findings — you fixed them — you show the plan to the user. A second round — only if there was a confirmed "blocking" finding: give the same task the list of the fixed places and ask to check only them — that the fix is right and did not break the neighbouring slices. There is no third round: what is left after the second, name to the user when showing the plan.

- **First check the finding.** The agent makes mistakes too: evidence without a path and a line is a guess. It is confirmed — fix it.
- **"blocking" and "worth fixing"** — fix in the plan in place. The fix touched names or dependencies — go through items 3 and 4 of the self-check once more.
- **The finding changes the scope or the behaviour** — do not decide yourself: ask the user one question before showing the plan.
- **The finding shows that the requirements do not agree with the code** — this is a discrepancy from step 6: name it to the user, the plan for such a requirement does not count as ready.
- **You disagree with the finding** — leave the plan as it is and name the finding when showing the plan, in one line: what the agent found and why you did not fix it.
- **"nit"** — fix it if it is one line; otherwise skip it without a mention.
