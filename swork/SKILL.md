---
name: swork
description: "Personal execution of a plan: goes through the plan slice by slice, checks each slice with a command, then itself checks what was done against the plan, removes what is superfluous, runs a review and stops with a report. Works in a folder without git too. Use when the user asks to execute a plan, to do it by the plan, to continue after splan or to continue an interrupted execution, or gives a small clear task for one pass. Not for finding out what to build (that is sbrain) and not for planning (that is splan)."
argument-hint: "[topic, plan from the chat or small task]"
effort: medium
---

# Plan execution

Builds what `sbrain` decided and `splan` planned: `sbrain → splan → swork`.

Talk to the user in their language everywhere — messages, menus, reports, notes between tool calls, also after English tool output: the language of their own words (in a command, those after the skill name), not of this skill, file names or tool output; translate this skill's labels and section names. Files and subagent tasks are in English; subagents reply in English. Neither a plan nor a task in the request — ask what we are executing, go no further.

**Confirmation and choice go through a request, not through asking the user to type "yes".** Use the blocking question tool (`AskUserQuestion`): options with the recommended first, or "Yes", and always "Fix" (then ask what exactly); at most four, a rare one typed. "Wait for a 'yes'", "an answer", "a choice" mean this. No such tool — a numbered list.

**Every question says what is needed from the user.** A consent menu names what is approved, each option says what follows it, and it always has "Fix" and "Do nothing" (nothing changed or recorded). A message needing nothing says so in its last line.

**Subagents run at `medium`.** Via the launch tool's effort parameter; without one, at the session level.

A task for a subagent is a code block in `references/executor.md`, `conformance.md`, `review.md`, `simplify.md` (three blocks: a header and two tasks). "Pass the task": never retype or retell it; cut it into a temporary file once per run — `awk '/^\140\140\140/{f=!f; if (f) print "=== block ==="; next} f' <task file> > <temporary folder>/<name>.txt` — and write "Read the task in the file <path> and carry it out word for word"; the message carries only the task's angle-bracket values. Nothing to cut with — pass the block word for word.

No subagents — carry out every `references/` task yourself in turn; open the report with: there was no independent check.

## What swork does not do

- **Does not decide what to build and does not plan.** No survey, no invented slices beyond its own card edits by section 4. Large work without a plan — offer `splan`.
- **Does not commit, does not create branches or merge requests** until the user has asked.
- **Does nothing beyond the plan.** A neighbouring flaw, a generalization "for the future", an item from "Not doing" — not its job, even one line.
- **Does not pass the code to a model of another vendor.**
- **Does not call other skills.**

## 1. Entry

On a topic (named, or its wiki folder given; wiki location — `references/wiki-rules.md`) read its `state.md` first and act by the phase:

| Phase in `state.md` | What you do |
|---|---|
| there is no topic folder | a plan from the chat or a small task |
| requirements written | do not execute, name the phase |
| requirements confirmed | offer `splan` |
| plan written | do not execute: the plan is not confirmed |
| plan confirmed | execute |
| execution in progress | continuing interrupted work |
| done | say that the work is done |

Not executing or offering `splan` — name the phase and wait for an answer: no snapshot, no slices.

## 4. Own decisions

Stages run without consent between them and without a stop before the report. Wait only at entry by the phase table, for files another agent holds (`references/agents-rules.md`, "Waiting": ends by itself, asks nothing) and in the menu after the report. Elsewhere decide yourself:

| Former case | Decision |
|---|---|
| the code differs from the plan, not in a minor way; `need a file` for an unmoved file | own card edits, then `bypassed` — `references/slices.md`, "Decisions and bypass" |
| the check is red after two attempts at a fix | the same |
| green before the edits, the slice not done, no `no behavior change` mark | the same |
| a slice with a "Rollback" section | its saving, then the slice: the "yes" to the plan is the consent; saving fails — `bypassed` |
| a slice with a manual check has dependents | they run "on unchecked ground"; only the user sets "done" |
| a changed file outside the plan, nothing to restore it with | into `known.txt` — `references/snapshot.md` |
| the environment blocks the check | `not checked` by "How to run a check"; the work goes on |
| continuing: foreign edits, an interrupted "Rollback" slice, an unreported manual check, a snapshot without records | `references/entry.md`, "Continuing interrupted work" |

Flag each decision in the chat as `⚠ Decided myself — S<N>: <problem> → <choice> → <why>`; log it as `S<N>: decided myself — <problem>; chosen: <what>; why: <reason>; otherwise: <what would change>`. Then go on. A doubt not in the table — decide alike.

A user message during the run — apply it from the next step, without a menu.

## Rules for all stages

**How to run a check.** Any run of a check-line command.

- **Green**: success exit code and the check line's "Expected". Take the exit code from the command itself: a pipeline (`… | tail`) or a wrapper (`ssh`) loses it unless passed on.
- Full output to a file in the snapshot's `checks/`; read its end.
- Every run into the line's "Result": `green YYYY-MM-DD` or `red YYYY-MM-DD`.
- Cannot run because of the environment (machine unreachable, service down, no login) — not red, no attempt spent. Restore it once, rerun; still cannot — `not checked`, "Result" `not run: <reason>`, the work goes on.

**Who writes to the plan and to the wiki.** Only an agent's main session, under a claim by `references/agents-rules.md`: slice statuses, check-line "Result", "Progress log", `state.md`, `notes/`, minor-discrepancy fixes and section 4 card edits. Set a changed slice status also in that slice's heading in `plan-overview.md`, if any; nothing else there. The executor and the reviewers do not write to the wiki. No journal writes during the work: the chain's one line changes on "accept the work". Fix what the wiki check script names in this topic's cards only (`references/wiki-rules.md`, the "Check" section). No one edits the goal, the shared constraints or "Not doing".

**Several agents.** Asked for several agents — switch on by `references/agents-rules.md`, "Switch", before the first write.

**Records: at once and in one batch.** At once, per slice: its status and the "Result" of its check lines. "Progress log" lines, `notes/` and `state.md` with its "Next step" (the one action the next session starts from) gather and are written in one batch before the report and before any stop, then the wiki check script; a stage file's "write into Progress log" means this batch, `stage 7 finished` its last line (`references/finish.md`). Only the start mark in `state.md` (`references/slices.md`, "2. Preparation") is written at once.

## Stages

| Stage | File | lite |
|---|---|---|
| 1. Entry and continuing interrupted work | `references/entry.md` | yes |
| 2. Preparation | `references/slices.md` | |
| 3. Slices | `references/slices.md` | |
| 5–7. Conformance check, simplification and review | `references/finish.md` | yes |
| 8. Report and the next step | `references/report.md` | yes |
| Small change | `references/small.md` | yes |
| Modes, while `agents.sh mode` is not `off` | `references/modes.md` | |
| Worktree mode: overrides the stage rules | `references/worktree.md` | |

Small work reads only the files marked `lite`.

Read the stage file in full on reaching the stage, never in advance or from memory; reread it if out of context; read any section or step it cites, on small work too.

## Traps

Who builds a slice — `references/executor.md`; removing what is beyond the plan and when stages 5–7 run — `references/finish.md`.

| Thought | In fact |
|---|---|
| "The executor said 'done' — I mark it" | You run the check; its output sets the status |
| "Faster to give the executor the whole plan" | Only its own slice's packet |
| "The check is already green — the slice is done" | First check the slice against the code |
| "Red before the edits — as it should be" | Only if red because the slice is absent |
| "The output looks normal — green" | The command's own exit code, not the text |
| "Red, I will try once more" | Two attempts, then a card edit, then bypass |
| "I will adjust the expected value" | Fix the code, never the check |
| "I will wait for the user" | Flag it in the chat and go on |
| "The file next to it needs fixing too" | `need a file`; edit only what the slice names |
| "This will come in handy later" | Beyond the plan is removed if the checks stay green |
| "This check is superfluous too" | Checks at the system boundaries are never touched |
| "The review suggested it — so it must be done" | First check that the problem is real |
| "I will add a guard just in case" | That brings back what the simplification removed |
| "The slices are independent, I will start both" | Two agents never edit one slice: the claim decides |
| "A task without a plan, but I will manage" | Large work goes to `splan` |
| "It is small — there is nothing to check" | Code changed — the stage 5–7 pass runs |
| "They liked the report — I will accept or commit" | "Good" is not a choice of step: wait for the menu choice |
| "I will write everything I learned into the wiki" | Only what the code and the cards cannot give back |
| "The executor will fix the card along the way" | Only the main session writes to the wiki |
