# Questions before writing. Writing the plan. Self-check. Showing and the next step

Read at steps 6–9, each on reaching it.

## 6. Questions before writing

A plan in cards: no stop to show the slicing — write it, the one approval is at step 9. Stop before writing only for what the plan cannot be written without, all in one request:

- **Discrepancies** — code against a requirement; a gap (a case whose answer changes the scope).
- **The plan contradicts a decision with the status "in force"** — name its card: only the user's explicit "yes" changes it; without it change the slicing. Write the replacement with the plan by the section "Replacement and archive" of `references/wiki-rules.md`.

**Do not silently close a discrepancy or a gap.** Propose: fix the requirements card in place with consent, if scope and behaviour stay; else back to `sbrain`. No plan for a requirement the code disagrees with until the user answers. Other silence of the requirements you close: decide, show it at step 9 as a line.

## 7. Writing the plan

By `references/plan-format.md`, through its "Order of writing".

## 8. Self-check

Direct and short: reread — every requirement has a slice, steps are unambiguous, names agree. Cards: `references/review.md`.

Passed — next step in `state.md`: the user reads the plan and answers whether we approve or edit.

## 9. Showing and the next step

Direct and short are already in the chat. Cards — in the chat, one line per item, no empty sections:

1. **Slices** — by logical block, per slice: what starts working, its dependencies.
2. **Checks** — the count of check lines per block, of them manual; the "Rollback" slices and manual checks others depend on: the plan's "yes" is the only consent, `swork` runs them without asking.
3. **Technical decisions** — only those the user would weigh: chosen instead of what; the cases the requirements skip that you decided.
4. **Not agreed** — rejected reviewer findings and assumptions; no review — `no fresh reviewer: small plan`, or for a larger plan `no fresh reviewer: not asked`.

Then the full path to `plan-overview.md`, the table of contents: a link per card, the cards are the plan.

One request for approval and the next step. Options:

- "Yes, execute" — `swork`; not installed — an ordinary session by this plan. For cards, two, in this order:
  - "Yes, execute — in a new session" — its description gives the lines to paste: `/clear`, then `/swork <topic>`, the topic by name or folder path;
  - "Yes, execute — in this session" — the user types `/swork <topic>` here;
- "Fix" — fix, show the corrected lines, ask again;
- "A fresh review" — one round by `references/review.md`, "Separate agent", the fixes, then this request anew — offered, never run without the choice;
- "Do nothing" — no approval recorded, phase unchanged.

Typed, named in the question: "yes, stop here"; back to `sbrain` if the requirements must change.

A "Yes" approves and picks the step. Cards: first record — `state.md` phase `plan confirmed`, same in the topic's "In progress" line of the root index (forms in `references/plan-format.md`); then say how to start. Other options are not approval. "The plan is good" without a step: record approval, ask for the step.

Recommend in one phrase with a reason from the plan. Never start the execution yourself, an answer given in advance included: "Yes, execute" means the user starts `swork`. A direct or short result lives only in the chat — no new session advice; its single option is "Yes, execute". Do not commit to git until asked.
