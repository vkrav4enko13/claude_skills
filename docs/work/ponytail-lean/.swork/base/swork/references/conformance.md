# Conformance check

Read at step 5 — after the agent has claimed `<topic folder>/.stage` and before the edits.

The conformance check answers one question: whether what is in the plan was done, and only that. Errors in the code are looked for by the review, what is superfluous inside the plan — by the simplification.

## What to pass

- the path to the topic folder — the reviewer reads the plan cards itself; for a plan from the chat and a task without a plan — the text of the plan or of the task itself;
- the text of the "Out of scope" section from the topic's `scope.md` or from its part `scope-<part>.md`, if the topic has such a card;
- the changes: the paths of the changed and new files and the snapshot's `base/` folder for comparison;
- the project root.

Do not pass the conversation, the executors' reports or your own conclusion "everything is done": they anchor.

## Task

```
Check what was done against the plan. Reply in English. The plan: <the path to the topic folder or the text>.
Project root: <path>. "Out of scope" from the requirements: <the text or "none">.
Changed files: <paths>; their state before the work is in <the path to base/>.
New files: <paths>. Change nothing — only read.
Delete no file and no folder outside the project folder, temporary folders included.

In the topic folder the plan lies as cards: `plan.md` — the goal, the shared constraints
and "Not doing"; `plan-decisions.md` — the technical decisions; `plan-checks.md`
and its parts — the check lines; `plan-s<N>-<name>.md` — the slices.

Assume that there are discrepancies, and find them. The findings are of three kinds:

1. MISSING — the plan asked for it, but it is not in the changes or it is done in part.
   - Every file from the "Files" block of a slice must have an edit: a file is named
     but not touched — this is a finding.
   - Every check line of a slice must be answered by code: a line whose scenario
     nothing in the changes handles — this is a finding.
2. BEYOND THE PLAN — the changes have something the plan did not ask for. Check three things:
   - a file that is in no "Files" block is changed or created;
   - a generalization, a parameter, a setting or an extension point for a need
     that is not in the plan;
   - anything from the "Not doing" section or from "Out of scope".
3. WRONG — the plan asked for it, it is done, but not that way: another name, signature,
   value, place, or "What to do", "Interfaces" or a check line
   of the slice is violated.

For every finding give a quote of the card line you rely on,
and name the card.
An explanation in the code, in a comment or in anyone's report does not soften a finding:
"added for the future" remains "beyond the plan".

If the plan has no "Files" blocks (a plan from the chat, a task in words) — quote its
text, and check the files by the places that are named in this text.

Return the findings as a list:
- kind: missing | beyond the plan | wrong
- place: file:line
- plan: the card and "a quote of its line"
- what: in one or two phrases

As a separate list — what you could not check by the changes.
Found no findings of some kind — say so, do not make any up.
READ: <the paths of the files you opened and read> — as one line after all the findings.
```

## A finding without a quote

Check a finding without a quote of the plan yourself: without a plan line it is an opinion, not a discrepancy.
