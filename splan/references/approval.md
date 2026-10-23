# Stop before writing. Writing the plan. Review. Showing and the next step

Read at steps 6–9, each on reaching it.

## 6. Stop before writing

A plan in cards, once. Show in the chat and wait for a "yes":

1. **Slicing** — per slice: what starts working, its dependencies.
2. **Check points** — where and with what (step 4); on its own line the final count with "Check focus": check lines, of them manual. Name the "Rollback" slices and manual checks others depend on: the plan's "yes" is the only consent, `swork` runs them without asking.
3. **Technical decisions** — only those the user would weigh: chosen instead of what; plus cases the requirements skip but a reasonable expectation exists — decide, show as a line.
4. **Discrepancies** — code against a requirement; a gap (a case whose answer changes the scope); the plan against a decision "in force" — name its card.

One line per item, two at most; no empty sections. "Yes" approves all shown.

**Do not silently close a discrepancy or a gap.** Propose: fix the requirements card in place with consent, if scope and behaviour stay; else back to `sbrain`. No plan for a requirement the code disagrees with until the user answers. Other silence of the requirements you close.

**The plan contradicts a decision with the status "in force"** — name its card and wait: only the user's explicit "yes" changes it; without it change the slicing. Write the replacement with the plan by the section "Replacement and archive" of `references/wiki-rules.md`.

## 7. Writing the plan

By `references/plan-format.md`, through its "Order of writing".

## 8. Review

Direct and short: reread — every requirement has a slice, steps are unambiguous, names agree.

Cards: `references/review.md`.

Passed — next step in `state.md`: the user reads the plan and answers whether we approve or edit.

## 9. Showing and the next step

Direct and short are already in the chat. Cards: show the plan in full, as in `plan-overview.md` — per slice what starts working, files, steps, checks with command and expected output, dependencies; then "Rollback" slices and manual checks others depend on, as at step 6; then technical decisions, "Not doing" and the not agreed — rejected reviewer findings and assumptions; a small plan — `no fresh reviewer: small plan`. Then full paths to the overview and topic folder.

One request for approval and the next step. Options:

- "Yes, execute" — `swork`; not installed — an ordinary session by this plan. For cards, two, in this order:
  - "Yes, execute — in a new session" — its description gives the lines to paste: `/clear`, then `/swork <topic>`, the topic by name or folder path;
  - "Yes, execute — in this session" — the user types `/swork <topic>` here;
- "Yes, stop here";
- "Fix" — fix, show the corrected version, ask again;
- back to `sbrain` — if the requirements must change.

Add "Do nothing": no approval recorded, phase unchanged. Over four — drop "Yes, stop here" first. Cards keep four: two execution options, "Fix", "Do nothing"; back to `sbrain` is named in the question, typed by the user.

A "Yes" approves and picks the step. Cards: first record — `state.md` phase `plan confirmed`, same in the topic's "In progress" line of the root index (forms in `references/plan-format.md`); then say how to start. Other options are not approval. "The plan is good" without a step: record approval, ask for the step.

Recommend in one phrase with a reason from the plan. Never start the execution yourself, an answer given in advance included: "Yes, execute" means the user starts `swork`. A direct or short result lives only in the chat — no new session advice; its single option is "Yes, execute". Do not commit to git until asked.
