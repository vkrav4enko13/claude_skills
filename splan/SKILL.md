---
name: splan
description: "Personal planning before the work: turns approved requirements or a clear task into a plan of slices that the executor goes through without questions, and writes no code. Use when the user asks for a plan, asks to break the work into steps, to plan from the requirements of a topic or to continue after sbrain. Not for finding out what to build (that is sbrain) and not for the execution itself."
argument-hint: "[topic or task]"
effort: medium
---

# Plan before the work

Decides **how** to build; **what** is decided in `sbrain` or the task; `swork` builds. The chain: `sbrain → splan → swork`.

Talk to the user in their language everywhere — messages, menus, reports, the plan shown, short notes between tool calls, after English tool output too. It is the language of their own words (in a command, those after the skill name: `count — спланируй тему` is Russian), not of this skill, file names or tool output; translate this skill's labels and section names. Files and subagent tasks are in English; subagents reply in English. No topic and no task — ask what we are planning and stop.

**Confirmation and choice go through a request, not through asking the user to type "yes".** Use the blocking question tool (`AskUserQuestion`): options with the recommended first, or "Yes", and always "Fix" (then ask what exactly); at most four, a rare one typed. "Wait for a 'yes'", "an answer", "a choice" mean this. No such tool — a numbered list.

**Every stop says what is needed from the user.** A consent menu names what is approved, each option says what follows it, and it always has "Fix" and "Do nothing" (nothing changed, nothing recorded). A stop needing nothing says so in its last line.

**Subagents run at `medium`.** Via the launch tool's effort parameter; without one, at the session level.

## Ban on implementation

No product code, scaffold, dependency install or execution skills. Read the project and run only what changes nothing (search, `git log`, command help). Never change code to see what happens: that is `swork`.

## Transitions — only by choice

Never move to another stage by yourself — back to `sbrain` or on to `swork`: name the proposal and why, and wait. Any size, the smallest too: "the change is obvious" does not permit making it.

Approval covers only what was shown: consent before writing is not plan approval; plan approval does not start execution. A fix is not approval: show the fixed version and wait for a "yes".

## 1. Entry

On a topic (named, or its wiki folder given; wiki location — `references/wiki-rules.md`) read its `state.md` first and act by the phase:

| Phase in `state.md` | What you do |
|---|---|
| there is no topic folder | a task without a topic, or offer `sbrain` |
| requirements written | stop: not confirmed; offer `sbrain`, where requirements are approved and edited |
| requirements confirmed | plan |
| plan written | next step in `state.md` is plan review: step 8; else step 9: show the plan, wait for a "yes" |
| plan confirmed | ask: do we continue from it or write anew |
| execution in progress | read "Progress log" (`progress.md` and parts), check the plan against the code, name what is done and outdated, ask: do we continue from it or write anew |
| done | ask: a new topic or a continuation of this one |

On stop or ask, name the phase and wait; no recon.

- **A topic folder** (from `sbrain`) — read every card `00-index.md` names, with parts. Numbered requirements (`R1`, `R2`…), "Out of scope", decisions "in force" and the wiki's `rules.md` are given: never reconsider or add to them.
- **A task without a topic** — enough if what should come out, for whom and how to check it are clear.
- **It is unclear what to build** — no survey: name what is missing, offer `sbrain`.
- **You were given a requirements file of the earlier form, as a single file** — call it the earlier format, offer `sbrain` to move it into cards; never plan from it.
- **The requirements have questions marked as blocking the plan** — stop and name them. The user may lift a block; write each lifted one into "Assumptions" of the plan header.
- **The topic already has a plan** — on "continue", check it against the code from "Checked against code" and name what is outdated: no new slices on unverified claims. Edit cards in place, never change slice numbers, rebuild `plan-overview.md` from them.
- **The topic has a plan of the earlier form, as a single file** — call it the earlier format, ask: continue or write anew. "Continue" = move it into cards by `references/plan-format.md`; never work from the file.

## Rules for all stages

**Several agents.** Asked for several agents — switch on by `references/agents-rules.md`, "Switch", before the first write.

**Before a stop — first `state.md`.** With a topic folder, before any stop (waiting, blocker, session end) write the phase and the next step — one action to start from — into `state.md`.

## Stages

| Stage | File | lite |
|---|---|---|
| 2. Choose the size and name it aloud | `references/recon.md` | yes |
| 3. Recon | `references/recon.md` | yes |
| 4. Check lines | `references/slicing.md` | yes |
| 5. Slicing | `references/slicing.md` | yes |
| 6. Stop before writing | `references/approval.md` | yes |
| 7. Writing the plan | `references/approval.md` | yes |
| 8. Review | `references/approval.md` | yes |
| 9. Showing and the next step | `references/approval.md` | yes |

Small work reads only the files marked `lite`.

Read the stage file in full on reaching the stage, never in advance or from memory; reread it if it is out of context; read any section or step it cites, on small work too.

## Traps

| Thought | In fact |
|---|---|
| "The task is obvious, I will do it right away" | `splan` does not execute; a direct result is two sentences and a proposed step |
| "The requirement is inconvenient, I will fix it in the plan" | Name the discrepancy; the requirements card is edited with consent |
| "I reread it myself, no agent is needed" | Mandatory for a large plan in cards; small — self-check and `no fresh reviewer: small plan` |
| "It is unclear what they want — I will ask a couple of questions" | What to build is found out by `sbrain`; offer it |
| "First the database, then the server, then the screen" | Layers are not slices; a slice goes all the way through |
| "First I will slice, I will add the checks later" | Check lines first, then the slicing |
