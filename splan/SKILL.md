---
name: splan
description: "Personal planning before the work: turns approved requirements or a clear task into a plan of slices that the executor goes through without questions, and writes no code. Use when the user asks for a plan, asks to break the work into steps, to plan from the requirements of a topic or to continue after sbrain. Not for finding out what to build (that is sbrain) and not for the execution itself."
argument-hint: "[topic or task]"
effort: medium
---

# Plan before the work

Answers the question of **how** to build. **What** to build and why is decided before it, in `sbrain` or in the task itself; the building is done by `swork` after it. The chain: `sbrain → splan → swork`.

Talk to the user in their language: chat messages, menus, reports and the plan shown for approval. This holds from the very first reply to the last one, the short notes between tool calls included — also after a long tool output in English. The user's language is that of their own words — in a command, the words after the skill name (`count — спланируй тему` is Russian); the English of this skill, of file names and of tool output does not change it. Option labels and section names that this skill gives in English are shown to the user in their language. Everything written to files and to subagents is in English, and subagents are asked to reply in English. If there is neither a topic nor a task in the request, ask what we are planning and go no further.

**Confirmation and choice go through a request, not through asking the user to type "yes".** Ask for approval, for the choice of an option and for the next step with the blocking question tool (in Claude Code — `AskUserQuestion`): the options to choose from with the recommended one first, or "Yes", and always a "Fix" option — if it is chosen, ask what exactly. At most four options: a rare one the user will type in themselves. Where the text below says "wait for a 'yes'", "wait for an answer" or "wait for a choice", it means such a request. If there is no such tool, ask with a numbered list in the chat.

**Every stop says what is needed from the user.** A consent menu names what exactly is being approved; the description of each option says what will happen after it; a consent menu always has "Fix" and "Do nothing" — after the latter nothing is changed and nothing is recorded. If you stop and nothing is needed from the user, say so plainly in the last line of the message.

**Subagents run at `medium`.** Launch every subagent of this skill with effort `medium`, using the effort parameter of the subagent launch tool; if there is no such parameter, at the session level.

## Ban on implementation

`splan` does not write product code, does not create a scaffold, does not install dependencies and does not call execution skills. You may read the project and run things that change nothing (a search, `git log`, command help). Changing the code to see what comes of it is not allowed: that is the job of `swork`.

## Transitions — only by choice

`splan` does not move to another stage by itself: neither back to `sbrain` nor forward to `swork`. It names what it proposes and why, and waits for an answer. This holds for a result of any size, including the smallest: "the change is obvious" does not permit starting to make it.

Approval covers only what was shown. Consent at the stop before writing approves what was shown at it, but not the plan; an approved plan does not start the execution. A fix is not approval: show the corrected version and wait for a "yes".

## 1. Entry

If you are started on a topic — the user named it or gave the path to its folder in the project wiki (where the wiki is — `references/wiki-rules.md`) — read its `state.md` card first and act by the phase:

| Phase in `state.md` | What you do |
|---|---|
| there is no topic folder | a task without a topic, or offer `sbrain` |
| requirements written | stop: the requirements are not confirmed |
| requirements confirmed | plan |
| plan written | in `state.md` the next step is independent plan review: go to step 8; otherwise — to step 9: show the plan and wait for a "yes" |
| plan confirmed | ask: do we continue from it or write anew |
| execution in progress | read "Progress log" — `progress.md` and its parts: the own decisions, the bypassed slices and the slice records; check the plan against the code, name what is done and what is outdated, and ask: do we continue from it or write anew |
| done | ask: a new topic or a continuation of this one |

Where the table tells you to stop or to ask, name the phase and wait for an answer: do not start the recon. The phase `requirements written` means that the user has not yet said "yes" to the topic cards: say so and offer `sbrain` — the requirements are approved and edited there.

- **A topic folder** (from `sbrain`) — read all the cards named in its index `00-index.md`: the task, the requirements, the examples, the design, the decisions and the scope — together with their parts. The requirements with numbers (`R1`, `R2`…), "Out of scope", the decisions with the status "in force" and what is decided in the wiki's `rules.md` are a given: do not reconsider them and do not add your own to them.
- **A task without a topic** — it will do if it is clear what should come out, for whom, and how to check it.
- **It is unclear what to build** — do not run a survey yourself. Name what is missing and offer `sbrain`.
- **You were given a requirements file of the earlier form, as a single file** — call the format the earlier one and offer `sbrain`: it will move it into topic cards. Do not plan from such a file.
- **The requirements have questions marked as blocking the plan** — stop and name them. The user may lift the block themselves; then write each such question in the "Assumptions" section of the plan header.
- **The topic already has a plan** — read its cards and act by the table. If the user answered "we continue from it", check the plan against the code, starting from the "Checked against code" line, and name what is outdated: new slices are not written on top of unverified claims of the old plan. Edit the plan cards in place, do not change the slice numbers. On such an entry take the overview `plan-overview.md` and rebuild it from the cards: where they differ, the slice card is right.
- **The topic has a plan of the earlier form, as a single file** — call the format the earlier one and ask whether we continue from it or write anew. "We continue from it" means moving it into topic cards by `references/plan-format.md`; do not work from the file itself any further.

## Rules for all stages

**Before a stop — first `state.md`.** If the topic folder already exists, before any stop (you are waiting for the user's answer, you have hit a blocker, the session is ending) first write the phase and the next step into its `state.md`: one action that the next session will start from.

## Stages

| Stage | File |
|---|---|
| 2. Choose the size and name it aloud | `references/recon.md` |
| 3. Recon | `references/recon.md` |
| 4. Check lines | `references/slicing.md` |
| 5. Slicing | `references/slicing.md` |
| 6. Stop before writing | `references/approval.md` |
| 7. Writing the plan | `references/approval.md` |
| 8. Review | `references/approval.md` |
| 9. Showing and the next step | `references/approval.md` |

Read the stage file in full when you reach the stage — not in advance and not from memory.

If the text of the stage file is not in the context, reread the file before you continue the stage.

If the text refers to a section or a step from another file, read that one too.

## Traps

| Thought | In fact |
|---|---|
| "The task is obvious, I will do it right away" | `splan` does not execute; a direct result is two sentences and a proposal of a step |
| "The requirement is inconvenient, I will fix it in the plan" | A discrepancy is named aloud; the requirements card is edited with consent |
| "It is unclear what they want — I will ask a couple of questions" | What to build is found out by `sbrain`; offer it |
| "First the database, then the server, then the screen" | Those are layers; a slice goes all the way through and is checked on its own |
| "First I will slice, I will add the checks later" | Slices are assembled from check lines: first a line for every requirement, then the slicing |
| "I reread it myself, no agent is needed" | The author confirms what they already believe; for a plan in cards the agent is mandatory |
