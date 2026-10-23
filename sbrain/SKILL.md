---
name: sbrain
description: "Personal brainstorm with a survey: turns a vague idea or a ready plan into agreed requirements and does not let code start before approval. Also sets up the project wiki and moves requirements files of the earlier form into cards. Use when the user asks for a brainstorm, to discuss an idea, to survey them, to 'grill' them or to stress-test a plan, or when the task is new and it is unclear what exactly to build. Not for work that is already spelled out and not for questions with one definite answer."
argument-hint: "[idea, task or plan] [grill — a survey: of a ready plan or of an idea without a plan]"
effort: medium
---

# Brainstorm and survey

Answers **what** to build and **why this way**; implements nothing.

Talk to the user in their language everywhere — chat, menus, reports, the plan shown, notes between tool calls — also after long English tool output. Their language is that of their own words (in a command, the words after the skill name: `count — спланируй тему` is Russian), not that of this skill, file names or tool output; translate option labels and section names given here. Files and subagent tasks are in English; subagents reply in English. No idea in the request — ask what we are discussing and go no further.

**Confirmation and choice go through a request, not through asking the user to type "yes".** Ask for approval, an option or the next step with the blocking question tool (in Claude Code — `AskUserQuestion`): options, recommended first, or "Yes", and always "Fix" (chosen — ask what exactly). At most four; a rare one the user types in. "Wait for a 'yes'", "an answer", "a choice" below mean such a request. No such tool — a numbered list in the chat. Open survey questions go as text.

**Every stop says what is needed from the user.** A consent menu names what is approved, each option what follows, and always has "Fix" and "Do nothing" (nothing changed or recorded). Nothing needed — say so in the last line.

**Subagents run at `medium`.** Set effort `medium` with the launch tool's effort parameter; without one, at the session level.

## Ban on implementation

Until the user approves the result of their path, do not write product code, create a scaffold, install dependencies or call implementation skills. Reading and running what changes nothing is allowed.

Approval covers only what was shown: "the idea is good" does not approve a design, a design does not approve a plan. A fix is not approval: show the corrected version and wait for a "yes". A short task does not lift the ban: two sentences in the chat, still a "yes".

## 1. Choose the path and name it aloud

Before the first question say which path and why.

| Path | When | Result |
|---|---|---|
| **Probe** | "Is it possible", "will it work": an answer, not code | Survey of the check → 2–3 sentences: what and how we check → consent → the check → a recommendation. All built is throwaway |
| **Small** | A clear change in existing, readable code | Survey → short design in the chat (what changes, where, how we check) → consent. No topic folder |
| **Large** | New project or subsystem, rebuilt connections, much unclear; `grill`/"grill me" on an idea without a plan | The full process, a topic folder in the wiki |
| **Grill** | A ready plan or design, in a file or the chat (`grill` on a plan, "check the plan") | Steps 2–4 over their plan, then a summary; edits where the plan lies — the topic's plan cards, its file, or the chat. No new approaches |
| **Non-software** | Outside programming: a trip, a purchase, a career, a text | `references/non-software.md` instead of steps 5–8 |

Hesitating between two — take the heavier. Complexity surfaced — stop, say so, move to a heavier path; never lighten on the go.

Several results, each useful and checkable alone — show the breakdown, agree which part we discuss now; the rest is context. Do not split what is useless in pieces (three sources for one report are one requirement).

A factual question or a one-step task — just answer. A verdict on a named external candidate ("should we move to X?"), also one the talk narrowed to — by `references/verdict.md`. Another skill or no process wanted — do not argue, offer to switch.

On "Large", start a task list if the environment can: what already exists → survey → approaches → summary → topic folder.

## Rules for all stages

`sbrain` writes to the wiki only after a confirmed summary. No topic folder — nothing in the wiki, not a card, not a line: survey answers stay in the chat.

**Several agents.** The user asks to work with several agents — switch the mode on by `references/agents-rules.md`, "Switch", before the first write.

**Before a stop — first `state.md`.** Once the topic folder exists, before any stop (waiting for an answer, a blocker, session end) write the phase and the next step into its `state.md`: one action the next session starts from.

## Stages

| Stage | File | lite |
|---|---|---|
| 2. Context first | `references/context.md` | yes |
| 3. Write down your understanding | `references/context.md` | yes |
| 4. Survey along the decision tree | `references/survey.md` | yes |
| 5. Approaches | `references/approaches.md` | yes |
| 6. Design by parts (the "Large" path) | `references/approaches.md` | |
| 7. Summary and result | `references/handoff.md` | yes |
| 8. Handoff | `references/handoff.md` | yes |

Small work reads only the files marked `lite`.

Read the stage file in full on reaching the stage, not in advance or from memory; reread it when its text is not in the context, and read what it cites in other files, on small work too.

## Project wiki

The wiki — `references/wiki-rules.md`; read it before either action. Neither is a brainstorm: no path, no survey.

- **Set up the wiki** — on request or when the rules say to set it up at the first edit: by the "Composition" section of `references/wiki-rules.md`, the root index and the current month's journal file, nothing else.
- **Move old files over** — a requirements file or plan of the earlier form, as a single file, and the user agreed to move it into cards: by `references/wiki-migrate.md`.

## Traps

| Thought | In fact |
|---|---|
| "Too simple, no design is needed" | "Small" is two sentences and a "yes", not zero |
| "The task is small, a couple of questions will do" | Front not empty — the survey is not finished |
| "The design is obvious, I will start while they are reading" | Approval is needed, not a shown design |
| "I know such applications, so it is 'Small'" | Smallness is measured by the project's code, not your experience |
| "I will call it 'Small' and do without a topic folder" | The wish for a lighter label is the doubt — take the heavier one |
| "This question is easier to ask than to look up" | Facts are your job |
| "The survey is short, no counter is needed" | From round two the counter line is mandatory |
| "A couple more rounds and it will converge" | The front grows for five rounds — split the task, do not interrogate |
| "I will ask everything in one list of ten questions" | Only the current front, at most four per round |
| "They said 'decide yourself' — I will decide and move on" | Twice in a row — the decision map, not silence |
| "They fixed a small thing, I can write" | A fix is not approval: show the corrected version and wait |
| "They already said it is on X — I will not touch it" | Challenge an unexamined instruction once; do not touch an examined one |
| "It has grown, but it is almost done" | Stop and move to a heavier path |
| "They answered in their own words, the meaning is clear" | Restate as decisions and wait for a "yes" |
| "I will write the answer into the wiki at once so as not to lose it" | No topic folder — nothing in the wiki |
| "This is a project rule, I will write it into `rules.md`" | Into `rules.md` — only in the user's words |
