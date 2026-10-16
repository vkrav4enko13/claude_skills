# Review

Read at step 7 — after the simplification and before the report.

The review looks for errors. Conformance to the plan is the business of the conformance check, what is superfluous — of the simplification; not of the review.

## What to pass

The path to the topic folder (for a plan from the chat — its text), the changes and the project root — as in the conformance check. Do not pass the conversation, your own arguments or the conclusion "it works".

## Task

```
Find the errors in the changes. Reply in English. Project root: <path>. Changed files: <paths>;
their state before the work is in <the path to base/>. New files: <paths>.
The plan this was written by: <the path to the topic folder or the text>. Change nothing —
only read.
Delete no file and no folder outside the project folder, temporary folders included.

Assume that there are errors, and find them. Look for:
- a wrong result for an input that occurs here: empty, a single value,
  a boundary of a range, a repeat, another letter case or language;
- a crash: access to something absent, an unhandled failure of an external call;
- loss or corruption of data, a broken order of actions;
- a security hole at the boundary of the system;
- what does not build and what is inconsistent with the calling code.

If the plan has "Check focus" (in the topic folder it lies in the card
`plan-decisions.md`), check each of its lines deliberately: what the code does
under this condition.

Do not propose: style, renamings, simplifications, "it would be better", protection
against an input that cannot occur here.
Do not check conformance to the plan: "done not the way the plan says" without a wrong
result is not an error, that is the business of the conformance check.

For every finding give how to reproduce it: the input or the steps and what will come out.
A finding without a reproduction is a guess; mark it as such.

Return the findings as a list, the serious ones first:
- severity: serious | minor
- place: file:line
- what will break: in one or two phrases
- how to reproduce: the input or the steps and the result

A serious one is a wrong result, a crash, loss or corruption of data,
a security hole, code that does not build. Everything else is minor.
Found no errors — say so, do not make any up.
READ: <the paths of the files you opened and read> — as one line after all the findings.
```

## Screening

The reviewer makes mistakes too. Check every finding against the code yourself:

- **Whether the problem is real** — not whether the edit is plausible. Reproduce it or trace it through the code.
- **A finding without a reproduction or without a place in the code** is a guess: it was not confirmed — it is declined.
- **Decline a serious one only by naming the line of code that refutes it.** "This is handled above" without a place is not an argument. It could be neither confirmed nor refuted — there is a third outcome: "could not be established". The finding goes into the report, into "Found and left untouched", together with what needs to be checked.
- **Decline a minor one** if the defect is unlikely to be met in ordinary work, while the edit adds branches, parameters or protection. Otherwise the review will bring back what the simplification removed.

What to do with a confirmed one:

- **An error in the code of the slices** — fix it yourself: the checkpoint `stage-7`, the edits in batches, the checks of the slices of the batch. A red one while another agent holds a live claim — a rerun by step 5 of section 3 of `references/slices.md`; otherwise restore from the checkpoint, the finding goes into the report.
- **It requires going outside the plan, changing the behaviour or a decision of the plan** — do not touch it, name it in the report with the reason.

Name the declined findings in the report, in the "Fixed after the review" section, one line each: what was proposed and why it was declined.

## Second round

Only if a **serious** finding was fixed. Give the same task the list of the findings and your fix and ask to check only them: that the fix is right and did not break what is next to it.

The second round is read by a new subagent: the previous one has already seen its own findings.

There is no third round. Do not fix a new finding of the second round — there is no one to recheck the fix: it goes into the report, into "Found and left untouched". Keep your first fix if the checks of the slices are green — a red one while another agent holds a live claim is rerun first, as above; if the second round showed that it was the fix that introduced the error — restore the files from `stage-7` and name both findings in the report.
