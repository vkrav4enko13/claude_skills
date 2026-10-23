# Summary and result. Handoff

Read at step 7 — before the summary, before anything is written — and at step 8, when the result is shown.

## 7. Summary and result

Read `references/synthesis.md`.

File unavailable: show "what we build" in 1–3 sentences, the trade-offs, what is out of scope, what is worth another look; wait for a "yes"; write the result where its path says.

## 8. Handoff

The result is shown — ask approval and the next step in one request; do not implement. Options, by the situation:

- "Yes, the plan next" — `splan` with the path to the topic folder; not installed — the ordinary planning mode. Result written into the topic folder — two options instead, in this order:
  - "Yes, the plan next — in a new session" — its description gives the lines to paste: `/clear`, then `/splan <topic>`, the topic by name or folder path;
  - "Yes, the plan next — in this session" — the user types `/splan <topic>` here;
- "Yes, implementation right away" — a "Small" task with an approved design;
- "Yes, stop here";
- "Fix" — make the fix, show the corrected version, ask again;
- a prototype — a named question about how it feels remains unclosed.

Add "Do nothing": no approval recorded, the phase unchanged. Over four options — drop "Yes, stop here" first. A result in the topic folder keeps four: the two plan options, "Fix", "Do nothing"; a prototype and "implementation right away", where they apply, are named in the question for the user to type.

A "Yes" option approves and chooses the step. On "Large" first record the approval: phase `requirements confirmed` in `state.md` and in the topic's line in "In progress" of the root index (forms — `references/topic-cards.md`); then name how to start the step, without starting it: the user starts `splan` and `swork`. A prototype is not approval. A text "yes" without a step — record the approval, ask for the step.

Result only in the chat — do not advise a new session; the single option "Yes, the plan next" stays.

No plan while questions that block planning remain: name them, say the user may lift the ban (you may be overcautious). Lifted — write each as an explicit assumption or a question deferred to the plan, then offer a plan.

"Probe" ends with a recommendation. Keeping the probe's code is a new task with its own path and approval.
