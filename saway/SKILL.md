---
name: saway
description: "Working without the user: when the user leaves and asks to have the job seen through to the end without them, answers the questions of the `sbrain → splan → swork` chain itself, drives the chain from the stage it is at, records every decision of its own and leaves a full description at the end. Use when the user says they have left or are leaving and asks to finish without them — to decide yourself and not wait for their answers. Not for work where the user is present: their 'decide yourself' in the middle of a conversation is not an absence. The user's absence is handled by this skill, not by the autonomous plugin skills: it commits nothing and pushes nothing."
argument-hint: "[topic or task; if not named, the started one is taken]"
---

# Working without the user

The user has left and asks you to see the work through to the end. You drive it in their place: you answer the questions that `sbrain`, `splan` and `swork` would have asked them, until the work ends or runs into something that must not be done without them. `saway` does not repeat the rules of these skills: it starts the one that is needed and decides for the user.

Talk to the user in their language: chat messages, menus, reports and the plan shown for approval. Option labels and section names that this skill gives in English are shown to the user in their language. Everything written to files and to subagents is in English, and subagents are asked to reply in English.

## What changes while the user is away

- **Do not ask the user questions.** Do not call the blocking question tool and do not end a turn with a question: there is no one to answer, and the work will stall.
- **`saway` is stronger than the "wait for an answer" rules.** Where `sbrain`, `splan` or `swork` tell you to ask, to show a menu, to wait for a "yes", not to move on to the next stage without a choice, or to start the next skill in a new session, decide yourself by section 3 and go on in this same session. Of the general instructions, only the form of confirmation — a request with options — gives way; their "only with the user's consent" conditions remain prohibitions. The other rules of the three skills apply as written, and so do the `swork` stops; the exception is what the next section forbids.
- **The mode ends with the user's return.** A return is a message from the user themselves; their remark right after the mode is switched on, while they have not left yet, is a clarification, not a return. A turn started by the `/goal` command, an idle check and the result of a background task are not a return. When the user has returned, show the description from section 5, tell them to type `/goal clear` if the goal is still set, and from then on ask as usual.
- **Before starting each skill of the chain, reread this file:** after context compaction its text may be gone, while the stage texts tell you to ask.

## What not to do without the user

This is not done even if such an option is recommended. Write the item into "Waiting for the user". If the prohibition is in the way of the work, the work is stopped; if it is not, go on. A `swork` stop on a slice is always in the way: independent slices do not start either. An action from the list that the user explicitly assigned before leaving — carry it out: only that action and only once.

- Irreversible things: a slice with a "Rollback" section, deleting and moving data, changing permissions and the schema; deleting files that you did not create — even where the skill waits for a "yes" to it.
- A commit, a push, a branch, a merge request.
- Actions outside the project folder: deploying and installing into the system, messages, publications, edits, and, on another machine, restarting and shutting down. You may read anything; plan checks are run where the plan named them; dependencies are installed inside the project folder; temporary files go into the temporary folder.
- A file outside the plan that is not proven to have been created or changed by the executor of this work: do not restore it and do not move it away. There is only one proof: the executor itself named the path in its report among the changed or created files. If it is not named, write the path into the snapshot's `known.txt` and go on: such a file causes no stop and no "whose is it" question, even where `swork` calls for them. In the card from section 4 mark the path as an assumption: the user will say whose file it is.
- What the user decided or approved themselves: a decision with the status "in force", a rule from `rules.md`, their choice in the conversation, the requirements and the plan they approved. If the work diverges from them, that point is stopped. A minor discrepancy that `swork` itself fixes in the slice card — a file moved, a name changed — does not count as a replacement. Do not write your own answers into `rules.md`.
- The choice after the `swork` report: do not accept the work, do not fix it and do not roll it back — the snapshot stays, the choice is the user's.
- A manual check: only the user sets it to "done".

## 1. What you take on

In your first message give the user the `/goal` line from the section "How to leave so that the session does not stall" — in case they are still here; do not wait for an answer. In the same message say in one sentence which work you are driving. If the root holds a `.saway.md` from a previous run, append to it under a line with today's date: the whole file will go into the description.

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
| execution in progress, a slice is "stopped" — or a slice is "awaiting manual check" and other slices depend on it | do not start `swork`: the item about a stop from section 3 |
| the `swork` report has been shown: the step in `state.md` is "user's choice after the report" | section 5 with the line `saway: work finished` |
| done | section 5 with the line `saway: work finished` |

Start the skill yourself. When it has finished its stage, reread `state.md` and take the next row of the table. The approval is recorded by the skill itself, in all of its places: you choose the "Yes" option in its menu, and in the card from section 4 you record that it was given without the user. Look in the same place for who approved the requirements and the plan: if there is no record of an approval without the user, the user approved. A plan from the chat that the user did not approve — reread it before starting `swork` and record that you approved it yourself.

## 3. How to decide for the user

- **A menu with a recommendation** — take the recommended option. If there is no recommendation, take the one that reaches the goal with the smallest addition and that is easier to undo. If the recommended one is forbidden by the section above or contradicts the user's words or `rules.md`, take an option that agrees with them; if there is none, that point is stopped.
- **An open survey question and a question that blocks the plan** — answer as the user would: from their words in the conversation, from `rules.md`, from the decisions of the topics and from the code. If there is nothing to ground the answer on, take the most cautious assumption: the one with which less is built and which is easier to undo.
- **Approval** of a summary, cards, a slicing or a plan — first reread what is being approved the way the user would read it. If it contradicts their words or `rules.md`, fix it, then approve.
- **A `swork` stop** — take an action from its stop menu if the user is not needed for it: run the check again after repairing the environment, or return to `splan` and fix the slice. The second — only for a plan that you approved yourself: if the user approved the plan, the slice stays "stopped". At most two such actions per slice; after that the slice stays "stopped". If the action needs the user, the slice stays "stopped" right away.
- **A stop remains after the item above — the work is stopped:** the next slices do not start, the conformance check and the review do not run, just as `swork` says. Go straight to section 5. A slice that is "awaiting manual check" and that no other slices depend on is not a stop: `swork` goes on.
- **A return to an earlier stage** — from `splan` to `sbrain`, from approval to editing — at most twice per work; after that the work is stopped.
- **A doubt that does not keep you from going on** — record it and go on.
- **Do not pass your own decision off as the user's:** in the topic cards it is an assumption, not "user chose".

## 4. Recording decisions

Record every decision made for the user at once, not at the end: the session may break off, and the context may be compacted.

- **For a topic** — the `away.md` card in the topic folder, by the rules of the project wiki: `# Decided without the user in topic <topic>`, a hook line, lines `- <question> — chosen: <what>; why: <argument>; otherwise: <what would change>`, a section `## Waiting for the user` — what was not done without the user, questions and doubts. A line about the card goes into the topic index. When the card is full, continue in `away-2.md`. This is a `saway` card: the `sbrain` rule "while there is no topic folder, nothing goes into the wiki" does not apply to it.
- **No topic yet** — the file `.saway.md` in the project root, of the same form. It is your file: for a small change, enter its path into `known.txt` as soon as the snapshot is created, so that the `swork` search does not touch it. When the topic folder appears, move its lines into that folder's `away.md` and delete the file. If there is never going to be a topic, the file stays until the user returns: once you have shown them the description, delete it.

## 5. Full description

The work has ended, has stopped, or there is nothing to drive — the last message is written for the user who has returned. Before it, write the next step into the topic's `state.md` — what you are waiting for from the user; do not touch the phase or the step "user's choice after the report".

1. **What was done** — by stage; for execution, the checks with their output, as in the `swork` report.
2. **Where it stands** — the phase and the next step.
3. **Decided without you** — every decision: the question, what was chosen, why, what would be different otherwise.
4. **Waiting for you** — what was not done without the user, questions and doubts; after the `swork` report — the user's choice and everything from "Found and left untouched". Name the files you entered into `known.txt` separately: the reviewers did not read them, and a rollback will not restore them.
5. **How to roll back** — what to restore and with what.
6. **What is needed from you first.**

The last line of the description is one of two, word for word:

- `saway: work finished` — the work has reached the `swork` report or the report had already been shown, has reached the result of a small change, a probe or the "Non-software" path, or the topic is already "done";
- `saway: work stopped — waiting for the user` — the work stopped earlier, or by section 1 there is nothing to drive: there are several topics or none.

Start nothing after the description: there is no second round over the findings of the report.

## How to leave so that the session does not stall

A skill is text: it cannot start a new turn by itself. The session is kept going by the Claude Code command `/goal`: after every turn a separate model checks the condition and, while it is not met, starts the next turn. When leaving, the user types one line:

```
/goal work by the saway skill until it shows the full description with the last line "saway: work finished" or "saway: work stopped — waiting for the user"; or stop after 40 turns
```

`/goal` does not cancel permission requests: for the turns to run without the user, the session must be in a mode that does not ask for them. Without `/goal`, drive the work in one turn and do not end it until the description is shown. Under `/goal` with a turn limit, name the number of the turn in every turn; on the last one show the description with the line `saway: work stopped — waiting for the user`.

## Traps

| Thought | In fact |
|---|---|
| "The question is important, I will wait for the user" | There is no one to wait for: decide, record and go on; what is important will end up in "Waiting for the user" |
| "The recommended option is 'accept the work'" | Acceptance, a fix after the report, a rollback and a commit are left to the user |
| "The report is shown — I will start `swork` once more" | After the report there is nothing to drive: the description and the last line |
| "The skill tells me to wait for a 'yes'" | While the user is away, you give the "yes" — after you have reread what is being approved |
| "The slice has stalled, I will take up the neighbouring one" | A stop remains — the work is stopped, as `swork` says |
