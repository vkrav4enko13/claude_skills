# Review

Read at step 6 by `references/finish.md`, at the very end. It looks only for errors.

## What to pass

The plan, the project root, the changed and new files; never the conversation, your arguments or the conclusion "it works".

## Task

```
Find the errors in the changes. Reply in English. Project root: <path>. Changed files: <paths>;
before the work: `git diff` in the project root. New files: <paths>.
The plan: <the path to the topic folder or the text>. Change nothing — only read.
Delete nothing outside the project folder, temporary folders included.

Assume there are errors; find them:
- a wrong result for an input that occurs here: empty, single, a range boundary,
  a repeat, another letter case or language;
- a crash: access to something absent, an unhandled external failure;
- loss or corruption of data, a broken order of actions;
- a security hole at the system boundary;
- what does not build or does not fit the calling code.

Check each line of the plan's "Check focus" (`plan.md` or `plan-decisions.md`), if any: what the code does then.

Do not propose style, renamings, simplifications, "it would be better", or protection
against an input that cannot occur here.
Do not check plan conformance: "done not the way the plan says" without a wrong
result is not an error.

For every finding give how to reproduce it: the input or the steps and what will come out.
A finding without a reproduction is a guess; mark it as such.

Return the findings as a list, the serious ones first:
- kind: error
- severity: serious | minor
- place: file:line
- what will break: in one or two phrases
- how to reproduce: the input or the steps and the result

Serious: a wrong result, a crash, data loss or corruption, a security hole,
code that does not build. All else is minor. No errors — say so, do not make any up.
READ: <the paths of the files you opened and read> — as one line after all the findings.
```

## Screening

Check each finding in the code yourself:

- **Whether the problem is real**, not whether the edit is plausible: reproduce it or trace it in the code.
- **A finding without a reproduction or without a place in the code** is a guess: declined.
- **Decline a serious one only by naming the line of code that refutes it.** Neither confirmed nor refuted — "could not be established", into "Found and left untouched" with what to check.
- **Decline a minor one** if the defect is unlikely in normal work and the fix adds branches, parameters or protection.

A confirmed one:

- **An error in the code of the slices** — fix it yourself by `references/finish.md`, section 7, then rerun its slices' checks; undone after a red check — report the finding. No second round.
- **It requires going outside the plan, changing the behaviour or a decision of the plan** — leave it, report it with why.

Name each declined finding in "Fixed after the review" as a line: what was proposed and why it was declined.
