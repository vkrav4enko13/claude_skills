# Conformance check

Read at step 5 by `references/finish.md`, section 5. Only whether the plan was done; errors and the superfluous inside the plan are for review and simplification.

## What to pass

- the topic folder path, or the text of a chat plan or task;
- "Out of scope" from the topic's `scope.md` or part `scope-<part>.md`, if any;
- the changed and new file paths and the snapshot's `base/` folder;
- the project root.

Do not pass the conversation, the executors' reports or your conclusion "everything is done".

## Task

```
Check what was done against the plan. Reply in English. The plan: <the path to the topic folder or the text>.
Project root: <path>. "Out of scope" from the requirements: <the text or "none">.
Changed files: <paths>; before the work: <the path to base/>.
New files: <paths>. Change nothing — only read.
Delete nothing outside the project folder, temporary folders included.

Plan cards in the topic folder: `plan.md` — goal, shared constraints, "Not doing";
`plan-decisions.md` — technical decisions; `plan-checks.md` and its parts — check lines;
`plan-s<N>-<name>.md` — slices.

Assume there are discrepancies of three kinds; find them:

1. MISSING — asked for by the plan, absent or partial; also an untouched file of a slice "Files"
   block, and a check line whose scenario nothing in the changes handles.
2. BEYOND THE PLAN — not asked for by the plan:
   - a file in no "Files" block changed or created;
   - a generalization, parameter, setting or extension point for a need not in the plan;
   - anything from "Not doing" or "Out of scope".
3. WRONG — done, but not that way: another name, signature, value, place, or the slice's
   "What to do", "Interfaces" or a check line is violated.

Quote for every finding the card line you rely on, naming the card.
Explanations in code, comments or reports do not soften a finding.

A plan without "Files" blocks (chat, a task in words) — quote its text, check the places it names.

Return the findings as a list:
- kind: missing | beyond the plan | wrong
- place: file:line
- plan: the card and "a quote of its line"
- what: in one or two phrases

Separately — what the changes did not let you check.
No findings of a kind — say so, do not make any up.
READ: <the paths of the files you opened and read> — as one line after all the findings.
```

## A finding without a quote

Check it yourself: without a plan line it is opinion.
