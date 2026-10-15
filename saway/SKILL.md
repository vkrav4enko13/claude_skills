---
name: saway
description: "Working without the user: when the user leaves and asks to have the job seen through to the end without them, answers the questions of the `sbrain → splan → swork` chain itself, drives the chain from the stage it is at, records every decision of its own and leaves a full description at the end. Use when the user says they have left or are leaving and asks to finish without them — to decide yourself and not wait for their answers. Not for work where the user is present: their 'decide yourself' in the middle of a conversation is not an absence. The user's absence is handled by this skill, not by the autonomous plugin skills: it commits nothing and pushes nothing."
argument-hint: "[topic or task; if not named, the started one is taken]"
effort: medium
---

# Working without the user

The user has left and asks you to see the work through to the end. You drive it in their place: you answer the questions that `sbrain`, `splan` and `swork` would have asked them, until the work ends or runs into something that must not be done without them. `saway` starts the skill that is needed and decides for the user; where its text and theirs differ about a stop, an approval or an edit of a card, `saway` is right, except that `swork` decides its former stops itself.

Talk to the user in their language: chat messages, menus, reports and the plan shown for approval. This holds from the very first reply, the short notes between tool calls included. Option labels and section names that this skill gives in English are shown to the user in their language. Everything written to files and to subagents is in English, and subagents are asked to reply in English. Every chat message and the full description are in the language the user wrote in before leaving. `away.md` and the other cards stay English; the description retells them in the user's language in full, not by a link.

## What changes while the user is away

- **Do not ask the user questions.** Do not call the blocking question tool and do not end a turn with a question: there is no one to answer, and the work will stall.
- **`saway` is stronger than the "wait for an answer" rules.** Where `sbrain`, `splan` or `swork` tell you to ask, to show a menu, to wait for a "yes", not to move on to the next stage without a choice, or to start the next skill in a new session, decide yourself by section 3 and start the next stage. Of the general instructions, only the form of confirmation — a request with options — gives way; their "only with the user's consent" conditions remain prohibitions. The other rules of the three skills apply as written; `swork` decides its former stops itself by its section 4.
- **The mode ends with the user's return.** A return is a message from the user themselves; their remark right after the mode is switched on, while they have not left yet, is a clarification, not a return. A turn started by the `/goal` command, an idle check and the result of a background task are not a return. When the user has returned, show the description from section 5, tell them to type `/goal clear` if the goal is still set, and from then on ask as usual.
- **Before starting each skill of the chain and before writing the full description, reread this file:** after context compaction its text may be gone, while the stage texts tell you to ask.
- **Every chat message ends with a progress line**, shown in the user's language: `Progress: slices <done>/<total> · now: <what runs> · ahead: <stages left>`; before there is a plan — `Progress: no plan yet · now: … · ahead: …`. `<done>` — the slices with the status `done`, `<total>` — all slices. In the full description it stands right before the last line.

## What not to do without the user

This is not done even if such an option is recommended. Write the item into "Waiting for the user" and bypass it by section 3. An action from the list that the user explicitly assigned before leaving — carry it out: only that action and only once.

- Irreversible things: deleting and moving data, changing permissions and the schema; deleting files that you did not create — even where the skill waits for a "yes" to it. A slice of the plan with a "Rollback" section is exempt from every clause of this item: `swork` executes it. Such a slice executed without the user goes under `## Waiting for the user` of `away.md` as `- executed without the user: S<N> <title> — rollback: <the command>`.
- A commit, a push, a branch, a merge request.
- Actions outside the project folder: deploying and installing into the system, messages, publications, edits, and, on another machine, restarting and shutting down. You may read anything; plan checks are run where the plan named them; dependencies are installed inside the project folder; temporary files go into the temporary folder. This item wins over the one above: a "Rollback" slice or an environment repair outside the project folder is forbidden — record it as a bypass.
- A file outside the plan that is not proven to have been created or changed by the executor of this work: do not restore it and do not move it away. There is only one proof: the executor itself named the path in its report among the changed or created files. If it is not named, the path goes into the snapshot's `known.txt` by `swork`. In the card from section 4 mark the path as an assumption: the user will say whose file it is.
- What the user decided or approved themselves: a rule from `rules.md`, a change of `rules.md` and their choice in the conversation. If the work diverges from them, bypass it by section 3. The own edits of a slice card by `swork` — a minor discrepancy and the edits by its section 4 — count as minor and do not count as a replacement; they never contradict `rules.md` or a decision "in force". Do not write your own answers into `rules.md`.
- The choice after the `swork` report: do not accept the work, do not fix it and do not roll it back — the snapshot stays, the choice is the user's. The phase `done` is never set by `saway`: a work with every check green still ends at the user's choice.
- A manual check: only the user sets it to "done".

## 1. What you take on

In your first message give the user the `/goal` line from the section "How to leave so that the session does not stall" — in case they are still here; do not wait for an answer. In the same message say in one sentence which work you are driving. It ends with the progress line, as every message does: the line closes this first message too, and a short note between tool calls as well. If the root holds a `.saway.md` from a previous run, append to it under a line with today's date: the whole file will go into the description.

- The request names a topic or a task — that one.
- It is not named — the one that was going on in this conversation.
- There was no work in the conversation — the topic from "In progress" of the wiki root index. If there are several of them or none, there is nothing to drive: go straight to section 5.

## 2. Drive it from where the work stands

Read the stage from the records, not from memory: for a topic this is the `state.md` card — the phase and the next step. If there are no records, the stage is the one the conversation ended at.

| Where the work stands | What you do |
|---|---|
| no topic, what to build is unclear | `sbrain` |
| no topic, the task is clear, but it cannot be done and checked in one pass | `splan` |
| no topic, the task is clear and small | `swork` — a small change |
| a plan or an approved design of a small task is already in the chat | `swork` — a small change |
| requirements written | `sbrain`: it will show the cards — approve them for the user |
| requirements confirmed | `splan` |
| plan written | `splan`: it will show the plan — approve it for the user |
| plan confirmed, execution in progress | `swork` |
| execution in progress, a slice is "stopped" — or a slice is "awaiting manual check" and other slices depend on it | `swork`: it decides its former stops itself by its section 4 |
| the `swork` report has been shown: the step in `state.md` is "user's choice after the report" | section 5 with the line `saway: work finished` |
| done | section 5 with the line `saway: work finished` |

While the topic folder exists, a stage is not run in this session: launch a fresh subagent with effort `medium` and the description `Stage <skill> of <topic>`, using the effort parameter of the subagent launch tool, with this task:

```
Project root: <path>. Topic: <topic>.
Read in full <path to the SKILL.md of the stage's skill> and <path to saway/SKILL.md>, then carry out one stage of the work: the stage of <skill>. The user is away: decide for them by the sections "What changes while the user is away", "What not to do without the user", 3 and 4 of saway/SKILL.md.
You stand in for the main session of the stage: write the topic cards and the wiki as the skill tells, and launch the subagents of the skill; they do not write.
The user's words that bear on the stage: <quoted word for word>.
Start no other skill.
Reply in English, exactly in this form:
PHASE: <phase and next step of state.md>
ENDED: <stage over | stopped — why>
FOR THE USER: <what is not in the cards>
```

Before each launch and after each reply write a chat message with the progress line. After the reply reread `state.md` and take the next row of the table. Without a topic folder run the stage in this session: start the skill yourself; when it has finished its stage, reread `state.md` and take the next row of the table. The approval is recorded by the skill itself, in all of its places: you choose the "Yes" option in its menu, and in the card from section 4 you record that it was given without the user. A plan from the chat that the user did not approve — reread it before starting `swork` and record that you approved it yourself.

## 3. How to decide for the user

- **A menu with a recommendation** — take the recommended option. If there is no recommendation, take the one that reaches the goal with the smallest addition and that is easier to undo. If the recommended one is forbidden by the section above or contradicts the user's words or `rules.md`, take an option that agrees with them; if there is none, bypass it.
- **An open survey question and a question that blocks the plan** — answer as the user would: from their words in the conversation, from `rules.md`, from the decisions of the topics and from the code. If there is nothing to ground the answer on, take the most cautious assumption: the one with which less is built and which is easier to undo.
- **Approval** of a summary, cards, a slicing or a plan — first reread what is being approved the way the user would read it. If it contradicts their words or `rules.md`, fix it, then approve.
- **A divergence from the topic cards** — when the work cannot agree with a requirement, a decision with the status "in force" or a success criterion of the topic, choose yourself by the items above, edit the card in place and go on. A success criterion may be weakened or dropped. This overrides "edited by no one" of `swork` for the goal, the shared constraints and "Not doing" of the plan, and "edited with consent" and "only their explicit yes" of `splan`. A replaced decision is written by "Replacement and archive" of the wiki rules: the old line gets the status "superseded", the new one is marked `assumption — decided without the user`, never "user chose". A rule of `rules.md` is not such a card: it is not edited.
- **A return to an earlier stage** — from `splan` to `sbrain`, from approval to editing — at most twice per work; a third is a bypass.
- **Bypass** — an action from "What not to do", a menu without an allowed option, a slice `swork` set to `bypassed`, a third return to an earlier stage: do not do it, record it and go on.
  - **Record:** the line `- bypassed: S<N> <title> — <reason>; depends on it: <slices | none>` under `## Waiting for the user` of `away.md` — of its last part, when the card is continued — and the line `S<N>: bypassed without the user — <reason>` in "Progress log". A slice `saway` forbids gets the status `bypassed`; its `away.md` line stays. What is not a slice — a menu without an allowed option, a third return — is recorded as `- bypassed: <what> — <reason>; depends on it: <what is not done | none>`.
  - **"Next step"** in `state.md` stays `user's choice after the report`: the list of bypassed items stays in `away.md`.
- **A doubt that does not keep you from going on** — record it and go on.
- **Do not pass your own decision off as the user's:** in the topic cards it is an assumption, not "user chose".

## 4. Recording decisions

Record every decision made for the user at once, not at the end: the session may break off, and the context may be compacted.

- **For a topic** — the `away.md` card in the topic folder, by the rules of the project wiki: `# Decided without the user in topic <topic>`, a hook line, lines `- <question> — chosen: <what>; why: <argument>; otherwise: <what would change>`, a section `## Waiting for the user` — what was not done without the user, questions and doubts. An edit of a plan or of a card that the user approved is recorded as `- <card>: <what> — was: <…>; became: <…>; why: <argument>; otherwise: <what would change>`; write it before the edit is made. A line about the card goes into the topic index. When the card is full, continue in `away-2.md`. This is a `saway` card: the `sbrain` rule "while there is no topic folder, nothing goes into the wiki" does not apply to it.
- **No topic yet** — the file `.saway.md` in the project root, of the same form. It is your file: for a small change, enter its path into `known.txt` as soon as the snapshot is created, so that the `swork` search does not touch it. When the topic folder appears, move its lines into that folder's `away.md` and delete the file. If there is never going to be a topic, the file stays until the user returns: once you have shown them the description, delete it.

## 5. Full description

The work has ended, has stopped, or there is nothing to drive — the last message is written for the user who has returned. Before it, write what you wait for from the user into "Next step" of the topic's `state.md` only if the report was not reached; never touch the phase.

1. **Changed in your requirements** — every edit of a success criterion or a requirement: was, became, why; the item is absent when there were none.
2. **What was done** — by stage; for execution, the checks with their output, as in the `swork` report.
3. **Where it stands** — the phase and the next step.
4. **Decided without you** — every line of `away.md` in full.
5. **Bypassed** — every bypassed item, its reason and the slices not started because of it.
6. **Waiting for you** — what was not done without the user, questions and doubts; after the `swork` report — the user's choice and everything from "Found and left untouched". Name the files you entered into `known.txt` separately: the reviewers did not read them, and a rollback will not restore them.
7. **How to roll back** — what to restore and with what.
8. **What to check and your choice** — what to look at first, then the four options of the `swork` report by their names — "accept the work", "fix", "roll back everything", "do nothing" — each with what it does: the user answers and `swork` carries it out.

The last line of the description is one of two, word for word:

- `saway: work finished` — the work has reached the `swork` report or the report had already been shown, has reached the result of a small change, a probe or the "Non-software" path, or the topic is already "done" — also when items were bypassed on the way;
- `saway: work stopped — waiting for the user` — by section 1 there is nothing to drive, the turn limit ran out, or a bypass before the execution left nothing to plan or to execute.

Start nothing after the description: there is no second round over the findings of the report.

## How to leave so that the session does not stall

A skill is text: it cannot start a new turn by itself. The session is kept going by the Claude Code command `/goal`: after every turn a separate model checks the condition and, while it is not met, starts the next turn. When leaving, the user types one line:

```
/goal work by the saway skill until it shows the full description with the last line "saway: work finished" or "saway: work stopped — waiting for the user"; or stop after 100 turns
```

`/goal` does not cancel permission requests: for the turns to run without the user, the session must be in a mode that does not ask for them. Without `/goal`, drive the work in one turn and do not end it until the description is shown. Under `/goal` with a turn limit, name the number of the turn in every turn; on the last one show the description with the line `saway: work stopped — waiting for the user`.

## Traps

| Thought | In fact |
|---|---|
| "The question is important, I will wait for the user" | There is no one to wait for: decide, record and go on; what is important will end up in "Waiting for the user" |
| "The recommended option is 'accept the work'" | Acceptance, a fix after the report, a rollback and a commit are left to the user |
| "The report is shown — I will start `swork` once more" | After the report there is nothing to drive: the description and the last line |
| "The skill tells me to wait for a 'yes'" | While the user is away, you give the "yes" — after you have reread what is being approved |
| "The slice has stalled, the work is stopped" | `swork` bypasses it itself; record it in `away.md` |
| "Everything is green, I will close the topic" | The phase `done` is set only by the user's choice after the report |
