---
name: swork
description: "Personal execution of a plan: goes through the plan slice by slice, checks each slice with a command, then itself checks what was done against the plan, removes what is superfluous, runs a review and stops with a report. Works in a folder without git too. Use when the user asks to execute a plan, to do it by the plan, to continue after splan or to continue an interrupted execution, or gives a small clear task for one pass. Not for finding out what to build (that is sbrain) and not for planning (that is splan)."
argument-hint: "[topic, plan from the chat or small task]"
---

# Plan execution

Builds what was decided before it: **what** — in `sbrain`, **how** — in `splan`. The chain: `sbrain → splan → swork`.

Talk to the user in their language: chat messages, menus, reports and the plan shown for approval. Option labels and section names that this skill gives in English are shown to the user in their language. Everything written to files and to subagents is in English, and subagents are asked to reply in English. If there is neither a plan nor a task in the request, ask what we are executing and go no further.

**Confirmation and choice go through a request, not through asking the user to type "yes".** Ask for consent at a stop, for the choice of an option and for the step after the report with the blocking question tool (in Claude Code — `AskUserQuestion`): the options to choose from with the recommended one first, or "Yes", and always a "Fix" option — if it is chosen, ask what exactly. At most four options: a rare one the user will type in themselves. Where the text below says "wait for a 'yes'", "wait for an answer" or "wait for a choice", it means such a request. If there is no such tool, ask with a numbered list in the chat.

**Every stop says what is needed from the user.** A consent menu names what exactly is being approved; the description of each option says what will happen after it; a consent menu always has "Fix" and "Do nothing" — after the latter nothing is changed and nothing is recorded. If you stop and nothing is needed from the user, say so plainly in the last line of the message.

A task for a subagent is a code block in the task file: `references/executor.md`, `conformance.md`, `review.md`, `simplify.md`. Do not retype it and do not retell it: cut the block out with a command into a temporary file, once per run, — `awk '/^\140\140\140/{f=!f; if (f) print "=== block ==="; next} f' <task file> > <temporary folder>/<name>.txt` — and write to the subagent: "Read the task in the file <path> and carry it out word for word". `simplify.md` has three blocks: a shared header and two tasks. "Pass the task" here and in the `references/` files means exactly this; the message carries only what stands in angle brackets in the task — the paths, the texts and the packet. If there is nothing to cut with, pass the block word for word. In a retelling the "what not to touch" rules get lost.

If the environment has no subagents, carry out every task from `references/` yourself, one after another, and say so at the start of the report: there was no independent check.

Starting `swork` is a choice of all its stages: the slices, the conformance check, the simplification and the review go one after another, and no consent is needed between them. It stops only in the cases from section 4 and after the report.

## What swork does not do

- **Does not decide what to build and does not plan.** It does not survey for requirements and does not invent slices. If there is no plan for a large piece of work, offer `splan`; if it is unclear even what to build, `splan` itself will send the user back to `sbrain`.
- **Does not commit, does not create branches or merge requests** until the user has asked.
- **Does nothing beyond the plan.** A neighbouring flaw, a generalization "for the future", an item from "Not doing" — not its job, even if it is one line.
- **Does not pass the code to a model of another vendor.**
- **Does not call other skills.** Everything it needs lies within itself.

## 1. Entry

If you are started on a topic — the user named it or gave the path to its folder in the project wiki (where the wiki is — `references/wiki-rules.md`) — read its `state.md` card first and act by the phase:

| Phase in `state.md` | What you do |
|---|---|
| there is no topic folder | a plan from the chat or a small task |
| requirements written | do not execute, name the phase |
| requirements confirmed | offer `splan` |
| plan written | do not execute: the plan is not confirmed |
| plan confirmed | execute |
| execution in progress | continuing interrupted work |
| done | say that the work is done |

Where the table tells you not to execute or to offer `splan`, name the phase and wait for an answer: do not create a snapshot, do not start the slices. The phases `requirements written` and `plan written` mean that the user has not yet said "yes": the requirements are approved in `sbrain`, the plan — in `splan`.

## 4. Stops

In the middle of the work `swork` stops and waits for the user only in these cases:

- the code differs from the plan, and the discrepancy is not minor;
- the check of a slice does not pass after two attempts at a fix;
- a slice with an irreversible action — before it starts;
- a slice has a manual check, and other slices depend on it;
- a changed file outside the plan is found, and there is nothing to restore it with;
- the check of a slice passes even before the edits, while the slice is not done and it has no `no behavior change` mark;
- the check cannot be run because of the environment.

When continuing interrupted work it also asks — by `references/entry.md`: whose edits are in the files outside the plan; what managed to run in a slice with a "Rollback" section; how the manual check ended; whether to continue or to start anew when there is a snapshot but no records.

At a stop: the slice gets the status "stopped" (one awaiting a manual check — "awaiting manual check"), the next slices do not start. Before showing, write the reason into "Progress log" as a line "S<N>: stopped — expected: …; found: …; why it matters: …". Show **expected** — **found** — **why it matters** and what you have already tried. There are no other stops: a doubt that is not on this list — resolve it yourself and record it in "Progress log".

At a stop offer a menu of actions — `references/slices.md`, the "Stop menu" section.

## Rules for all stages

**How to run a check.** This is the rule for any run of a command from a check line — here and in sections 5–7.

- A line is **green** if the command finished with a success code and what the plan calls expected was obtained: for a check line this is the "Expected" column. Take the exit code from the command itself: in a pipeline (`… | tail`) and in a wrapper (`ssh`) it is lost unless it is passed on explicitly.
- Write the full output to a file in the snapshot's `checks/` folder, read its end.
- Record the result of every run in the "Result" column of the line: `green YYYY-MM-DD` or `red YYYY-MM-DD`.
- The command cannot be run because of the environment — the machine is unreachable, the service is not running, there is no login — this is not a red check but a stop: attempts are not spent, the executor is not started. Into "Result" — `not run: <reason>`.

**Who writes to the plan and to the wiki.** Only the main session: the slice statuses, the "Result" of the check lines, "Progress log", `state.md`, the notes in `notes/` and the fixes of minor discrepancies in the slices. When you change a slice status, set the same status in the overview `plan-overview.md`, if there is one: in the heading of that slice's section. Edit nothing else in the overview: `splan` rebuilds it. The executor and the reviewers do not write to the wiki. Do not write to the journal in the course of the work: the chain has one line, and its tail changes when "accept the work" is chosen. When you have written to the wiki, run the check script and fix what it names: `references/wiki-rules.md`, the "Check" section. The goal, the shared constraints and "Not doing" are edited by no one.

**Before a stop — first `state.md`.** Before any stop from section 4 first write "Next step" into `state.md` — one action that the next session will start from — and only then show where you stopped.

## Stages

| Stage | File |
|---|---|
| 1. Entry: kinds of entry and continuing interrupted work | `references/entry.md` |
| 2. Preparation | `references/slices.md` |
| 3. Slices | `references/slices.md` |
| 5. Conformance check | `references/finish.md` |
| 6. Simplification | `references/finish.md` |
| 7. Review | `references/finish.md` |
| 8. Report and the next step | `references/report.md` |
| Small change | `references/small.md` |

Read the stage file in full when you reach the stage — not in advance and not from memory.

If the text of the stage file is not in the context, reread the file before you continue the stage.

If the text refers to a section or a step from another file, read that one too.

## Traps

| Thought | In fact |
|---|---|
| "The executor said 'done' — I mark it" | You run the check, the status is set by its output |
| "It is faster to give the executor the whole plan" | Only the packet of its own slice: other slices it will start doing along the way |
| "The check is already green — so the slice is done" | First check the slice against the code; a check that is green before the edits may be checking nothing |
| "red before the edits — that is how it should be" | Only if it is red because the slice is absent; a broken build and an unreachable machine are not about the slice |
| "The output looks normal — green" | Look at the exit code of the command itself, not at the text |
| "The check is red, I will try once more" | Two attempts, then a stop — the third builds on the same wrong assumption |
| "I will adjust the expected value and it will pass" | The code is fixed, not the check |
| "The file next to it needs fixing too" | The status `need a file`; only what is named in the slice is edited |
| "This will come in handy later, I will leave it" | What was done beyond the plan is removed if the checks are green |
| "Fewer lines is better" | The goal is the absence of anything superfluous, not the number of lines |
| "This check is superfluous too" | Checks at the boundaries of the system are not touched |
| "The review suggested it — so it must be done" | First check that the problem is real |
| "I will add a guard just in case" | That will bring back what the simplification removed |
| "The slices are independent, I will start both at once" | One at a time: without git, simultaneous edits cannot be told apart |
| "A task without a plan, but I will manage" | Large work goes to `splan` |
| "It is small — there is nothing to check" | One reviewer is mandatory |
| "They liked the report — I will commit" | "Good" is not a choice of step |
| "I will write everything I learned into the wiki" | Only what cannot be recovered from the code and the cards |
| "The executor will fix the card along the way" | Only the main session writes to the wiki |
