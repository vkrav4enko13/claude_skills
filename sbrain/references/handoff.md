# Summary and result. Handoff

Read at step 7 — before the summary, before anything is written — and at step 8, when the result has been shown.

## 7. Summary and result

Read `references/synthesis.md`. It holds: the summary that the user confirms before writing; where the result is written; the check before showing. What goes into which topic card and in what order it is written — in `references/topic-cards.md`: read it before writing the result of the "Large" path. Without these files the summary turns into a retelling of the conversation, and the cards into a draft with stubs.

In short, if the file is unavailable: show "what we build" in 1–3 sentences, the trade-offs made, what is out of scope and what is worth another look; wait for a "yes"; for a "Probe" and a "Small" task the result stays in the chat, for a "Large" one it is a topic folder that the user reads and approves, for a "Grill" — edits to the plan cards of the topic or to the plan file, and if the plan was only in the chat, the result is in the chat.

## 8. Handoff

The result has been shown — ask for the approval and the next step with one request; do not start the implementation yourself. The options, by the situation:

- "Yes, the plan next" — `splan` with the path to the topic folder; if it is not installed — the ordinary planning mode. If the result is written into the topic folder, this option becomes two, in this order:
  - "Yes, the plan next — in a new session" — its description gives the lines to paste: `/clear`, then `/splan <topic>`, the topic by its name or by the path to its folder;
  - "Yes, the plan next — in this session" — the user types `/splan <topic>` here;
- "Yes, implementation right away" — for a "Small" task with an approved design;
- "Yes, stop here";
- "Fix" — make the fix, show the corrected version and ask again;
- a prototype — if a named question about how it feels remains that the conversation did not close.

Add "Do nothing" to the menu: the approval is not recorded, the phase does not change. If there are more than four options, "Yes, stop here" is the first to be dropped. For a result written into the topic folder the menu keeps four options — the two options of the plan, "Fix" and "Do nothing"; a prototype and "implementation right away", where they apply, are named in the question for the user to type.

An option with "Yes" is both the approval of what was shown and the choice of the step. On the "Large" path first record the approval: in `state.md` — the phase `requirements confirmed`, in the topic's line in "In progress" of the root index — the same phase (the forms of the lines are in `references/topic-cards.md`); then name how to start what was chosen and do not start it yourself: `splan` and `swork` are started by the user. A prototype does not count as approval. An answer "yes" or "fine" as text, without a choice of the step, is approval but not a step: record the approval and ask for the step.

If the result stayed in the chat, do not advise a new session: the result will not be in it; for it the single option "Yes, the plan next" stays.

Do not offer a plan while the document still has questions without an answer to which planning is impossible. Name these questions and say that the user can lift the ban themselves: it was you who judged them blocking, and you may have been overcautious. If they have lifted it, first write each such question in the document as an explicit assumption or as a question deferred to the plan, and only then offer a plan.

The "Probe" path ends with a recommendation. Keeping the probe's code is a new task with its own path and its own approval.
