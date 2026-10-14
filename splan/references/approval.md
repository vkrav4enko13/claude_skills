# Stop before writing. Writing the plan. Review. Showing and the next step

Read at step 6 — after the slicing, before the plan is written, — at step 7, when the slicing is agreed, at step 8, when the plan is ready, and at step 9, before the plan is shown to the user.

## 6. Stop before writing

For a plan in cards, once. Show in the chat and wait for a "yes":

1. **Slicing** — a line per slice: what will start working and which slices it depends on.
2. **Check points** — where and with what the behaviour will be checked (step 4), and as a separate line the final count, which includes the lines of "Check focus": how many check lines there are and how many of them are checked manually.
3. **Technical decisions** — only those the user would weigh: what was chosen and instead of what. Here too go the cases that the requirements are silent about but for which there is a reasonable expectation: decide yourself and show the decision as a line.
4. **Discrepancies** — where the code contradicts a requirement, where the requirements have a gap — a case whose answer changes the scope, and where the plan contradicts a decision with the status "in force" — with the card of that decision named.

An item is one line, two at most. Do not show an empty section.

"Yes" at this stop approves everything shown at it: the slicing, the check points and the decisions.

**Do not silently close a discrepancy or a gap.** Name it and propose what to do: fix the requirements card (you make the edit, with the user's consent, in place) — if the clarification does not change the scope or the behaviour; go back to `sbrain` — if it does. The plan for a requirement that the code does not agree with is not written until the user has answered. A gap is only a case whose answer changes the scope: the rest of the requirements' silence you close yourself.

**The plan contradicts a decision with the status "in force"** — name the card of that decision to the user and wait for an answer: only their explicit "yes" changes the decision. Without it change the slicing, not the decision. Write up the replacement when writing the plan — by the section "Replacement and archive" of `references/wiki-rules.md`.

## 7. Writing the plan

Read `references/plan-format.md` and write the plan by it. It holds: where the plan lies, the composition of the cards, the check lines, the slice fields, what code is allowed in the plan and the order of writing.

After the cards are written: in `state.md` — the phase `plan written` and the next step "independent plan review"; in the topic index — a line for every new card; in the topic's line in "In progress" of the root index — the same phase; then the wiki check script. The forms of the lines are in the same file.

## 8. Review

Reread a direct and a short result yourself: every requirement has a slice, every step is unambiguous, the names are consistent between the slices.

For a plan in cards read `references/review.md`. It holds the self-check by a list, the task for a separate agent that has not seen the conversation, and what to do with its findings.

The review is passed — write the next step into `state.md`: the user reads the plan and answers whether we approve or edit.

## 9. Showing and the next step

A direct and a short result is already shown in the chat. Show a plan in cards in the chat in full, with the same text as in the overview `plan-overview.md`: for every slice — what will start working, the files, the steps, the checks with the command and the expected output, the dependencies; then the technical decisions, "Not doing" and what is not agreed — both the reviewer's findings that you disagreed with and the assumptions. After the plan name the full path to the overview and to the topic folder.

Ask for the approval of the plan and the next step with one request. The options, by the situation:

- "Yes, execute" — `swork`; if it is not installed — an ordinary session by this plan. For a plan in cards this option becomes two, in this order:
  - "Yes, execute — in a new session" — its description gives the lines to paste: `/clear`, then `/swork <topic>`, the topic by its name or by the path to its folder;
  - "Yes, execute — in this session" — the user types `/swork <topic>` here;
- "Yes, stop here";
- "Fix" — make the fix, show the corrected version and ask again;
- go back to `sbrain` — if it turned out during the planning that the requirements have to be changed.

Add "Do nothing" to the menu: the approval is not recorded, the phase does not change. If there are more than four options, "Yes, stop here" is the first to be dropped. For a plan in cards the menu keeps four options — the two options of the execution, "Fix" and "Do nothing"; going back to `sbrain`, when it applies, is named in the question for the user to type.

An option with "Yes" is both the approval of the plan and the choice of the step. For a plan in cards first record the approval: in `state.md` — the phase `plan confirmed`, in the topic's line in "In progress" of the root index — the same phase (the forms of the lines are in `references/plan-format.md`); then name how to start what was chosen. The other options do not count as approval. "The plan is good" as text, without a choice of the step, is approval but not a step: record the approval and ask for the step.

Give the recommendation in one phrase with a reason from the plan itself. Do not start the execution yourself: "Yes, execute" means that `swork` is started by the user. A direct or a short result lies only in the chat — do not advise a new session: the plan will not be in it; for it the single option "Yes, execute" stays. Do not commit to git until you are asked.
