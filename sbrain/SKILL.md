---
name: sbrain
description: "Personal brainstorm with a survey: turns a vague idea or a ready plan into agreed requirements and does not let code start before approval. Also sets up the project wiki and moves requirements files of the earlier form into cards. Use when the user asks for a brainstorm, to discuss an idea, to survey them, to 'grill' them or to stress-test a plan, or when the task is new and it is unclear what exactly to build. Not for work that is already spelled out and not for questions with one definite answer."
argument-hint: "[idea, task or plan] [grill — a survey: of a ready plan or of an idea without a plan]"
effort: medium
---

# Brainstorm and survey

Answers the question of **what** to build and **why exactly this way**; how to build is a matter for the plan after it. The skill implements nothing.

Talk to the user in their language: chat messages, menus, reports and the plan shown for approval. This holds from the very first reply to the last one, the short notes between tool calls included — also after a long tool output in English. The user's language is that of their own words — in a command, the words after the skill name (`count — спланируй тему` is Russian); the English of this skill, of file names and of tool output does not change it. Option labels and section names that this skill gives in English are shown to the user in their language. Everything written to files and to subagents is in English, and subagents are asked to reply in English. If there is no idea in the request, ask what we are discussing and go no further.

**Confirmation and choice go through a request, not through asking the user to type "yes".** Ask for approval, for the choice of an option and for the next step with the blocking question tool (in Claude Code — `AskUserQuestion`): the options to choose from with the recommended one first, or "Yes", and always a "Fix" option — if it is chosen, ask what exactly. At most four options: a rare one the user will type in themselves. Where the text below says "wait for a 'yes'", "wait for an answer" or "wait for a choice", it means such a request. If there is no such tool, ask with a numbered list in the chat. Open survey questions still go as text.

**Every stop says what is needed from the user.** A consent menu names what exactly is being approved; the description of each option says what will happen after it; a consent menu always has "Fix" and "Do nothing" — after the latter nothing is changed and nothing is recorded. If you stop and nothing is needed from the user, say so plainly in the last line of the message.

**Subagents run at `medium`.** Launch every subagent of this skill with effort `medium`, using the effort parameter of the subagent launch tool; if there is no such parameter, at the session level.

## Ban on implementation

Until the user has approved the result of their path (see below), do not write product code, do not create a project scaffold, do not install dependencies and do not call implementation skills. You may read the project and run things that change nothing.

Approval covers only what was shown. "The idea is good" does not approve a design that does not exist yet; an approved design does not approve a plan. A fix is not approval: after any fix show the corrected version and wait for a "yes". A short task does not lift this ban: its result is two sentences in the chat, but a "yes" is still needed.

## 1. Choose the path and name it aloud

Before the first question, say which path is chosen and why, so that the user can correct it.

| Path | When | Result |
|---|---|---|
| **Probe** | A question of "is it possible", "will it work"; an answer is needed, not code | A survey about the check itself (what we count as an answer, what can be sacrificed) → 2–3 sentences: what we check and how → consent → the check → a recommendation. Everything built is throwaway |
| **Small** | A clear change in code that already exists and can be read | A survey until the front is empty → a short design in the chat (what changes, which places are affected, how we will check) → consent. There is no topic folder |
| **Large** | A new project or subsystem, a rebuild of the connections, much that is unclear; also a request for a survey (`grill`, "grill me") on an idea that has no ready plan | The full process below and a topic folder in the wiki |
| **Grill** | The user came with a ready plan or design — in a file or in the chat (`grill` on a plan, "check the plan") | Steps 2–4 over their plan, then a summary. If the plan lies as cards in the topic folder, the edits go into the plan cards of the topic; if the plan is in an arbitrary file, the edits go into that file; if the plan was only in the chat, the result stays in the chat. Do not invent approaches anew |
| **Non-software** | A decision or an intention outside programming: a trip, a purchase, a career, a text | `references/non-software.md` instead of steps 5–8 |

If you hesitate between two, take the heavier one. If complexity has surfaced along the way, stop, say so and move to a heavier path; making the path lighter on the go is not allowed.

If the request contains several results, each of which is useful and checkable on its own (chat, billing and analytics all at once), first show the breakdown and agree on which part we discuss now. The rest remain context, not requirements. Do not split what is useless in pieces: three data sources for one report are one requirement about coverage, not three pieces of work.

If this is not a brainstorm at all — a factual question or a one-step task — just answer. A verdict question about a named external candidate ("should we move to X?", "X or Y for this project?") is not a brainstorm either: here the decision is whether to take something ready-made, not what to build. Answer by `references/verdict.md`. The same applies if the conversation has narrowed down to such a question along the way. If the user has realized along the way that they need another skill or no process at all, do not argue: offer to switch.

On the "Large" path, start a task list if the environment can do that: what already exists → survey → approaches → summary → topic folder.

## Rules for all stages

`sbrain` writes to the wiki only after a confirmed summary. While there is no topic folder, there is nothing from it in the wiki — not a card, not a line: the survey answers stay in the chat.

**Several agents.** The user asks to work with several agents — switch the mode on by `references/agents-rules.md`, "Switch", before the first write.

**Before a stop — first `state.md`.** The rule applies only when the topic folder already exists: before any stop (you are waiting for the user's answer, you have hit a blocker, the session is ending) first write the phase and the next step into its `state.md`: one action that the next session will start from.

## Stages

| Stage | File |
|---|---|
| 2. Context first | `references/context.md` |
| 3. Write down your understanding | `references/context.md` |
| 4. Survey along the decision tree | `references/survey.md` |
| 5. Approaches | `references/approaches.md` |
| 6. Design by parts (the "Large" path) | `references/approaches.md` |
| 7. Summary and result | `references/handoff.md` |
| 8. Handoff | `references/handoff.md` |

Read the stage file in full when you reach the stage — not in advance and not from memory.

If the text of the stage file is not in the context, reread the file before you continue the stage.

If the text refers to a section or a step from another file, read that one too.

## Project wiki

The wiki is the project's records kept as cards: what is in progress, what is deferred, what is done. Where it lies, what it consists of, how to read, write and check it — in `references/wiki-rules.md`; read it before either of the two actions. Neither action is a brainstorm: no path is chosen, there is no survey.

- **Set up the wiki** — when the user asks for it or the rules tell you to set it up at the first edit. By the "Composition" section of `references/wiki-rules.md`: the root index and the journal file of the current month, nothing else.
- **Move old files over** — when a requirements file or a plan of the earlier form, as a single file, is found in the project and the user has agreed to move it into cards. By `references/wiki-migrate.md`.

## Traps

| Thought | In fact |
|---|---|
| "Too simple, no design is needed" | The "Small" path is two sentences and a "yes", not zero |
| "The task is small, a couple of questions will do" | The path changes the result, not the depth: if the front is not empty, the survey is not finished |
| "I will call it 'Small' and do without a topic folder" | The wish to pick a lighter label is itself the doubt — take the heavier one |
| "The design is obvious, I will start while they are reading" | What is needed is approval, not merely a design that was shown |
| "I know such applications, so it is 'Small'" | Smallness is measured by the code in the project, not by your experience |
| "I will ask everything in one list of ten questions" | Only the current front, and at most four per round |
| "This question is easier to ask than to look up" | Facts are your job |
| "The survey is short, no counter is needed" | From the second round on the user does not see how much is left: the counter line is mandatory |
| "They said 'decide yourself' — I will decide and move on" | Twice in a row is a signal for the decision map, not permission to stay silent |
| "They fixed a small thing, I can write" | A fix is not approval: show the corrected version and wait |
| "They already said it is on X — I will not touch it" | Challenge an unexamined instruction once; do not touch an examined one |
| "It has grown, but it is almost done" | Stop and move to a heavier path |
| "They agree with everything — so everything is right" | Two rounds of unbroken agreement are a reason to say once that so far the decisions are yours; the questions still come with a recommendation |
| "They answered in their own words, the meaning is clear" | Restate the answer as decisions and wait for a "yes" |
| "A couple more rounds and it will converge" | The front has been growing for five rounds — the task has to be split, not interrogated |
| "I will write the answer into the wiki at once so as not to lose it" | While there is no topic folder, nothing goes into the wiki: the chat holds the answers |
| "This is a project rule, I will write it into `rules.md`" | Into `rules.md` — only in the user's words |
