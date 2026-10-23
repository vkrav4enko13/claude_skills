---
name: saway
description: "Working without the user: the user leaves and asks to finish the job without them — answers the questions of the `sbrain → splan → swork` chain itself, drives the chain from its stage, records every own decision and leaves a full description at the end. Use when the user says they have left or are leaving and asks to finish without them — decide yourself, do not wait for answers. Not when the user is present: 'decide yourself' mid-conversation is not an absence. The user's absence is handled by this skill, not by the autonomous plugin skills: it commits and pushes nothing."
argument-hint: "[topic or task; if not named, the started one is taken]"
effort: medium
---

# Working without the user

The user has left: answer for them what `sbrain`, `splan` and `swork` would ask, until the work ends or hits what needs them.

Every chat message (from the first reply, notes included), menu, report, plan for approval and the full description: in the language the user wrote in before leaving; translate labels and section names given here. Files, subagent tasks and replies: English; the description retells the cards in full, not by a link.

## What changes while the user is away

- **Do not ask the user questions.** No blocking question tool, no turn ending with a question.
- **`saway` is stronger than the "wait for an answer" rules.** A stage skill says ask, show a menu, wait for a "yes", do not go on without a choice, or start the next skill in a new session — decide by section 3 and start the next stage. Of the general instructions only the form of confirmation gives way; "only with the user's consent" stays a prohibition. The other rules of the three skills apply as written.
- **The mode ends with the user's return.** A return is the user's own message — not their remark right after switching the mode on, a `/goal` turn, an idle check or a background result. Then show the section 5 description with its return line, say to type `/goal clear` if the goal is set, and ask as usual.
- **A busy file is waited for** by "Waiting" of the stage skill's `references/agents-rules.md`: not bypassed, not asked about.
- **Before starting each skill of the chain and before writing the full description, reread this file.**
- **Every chat message ends with a progress line**, in the user's language: `Progress: slices <done>/<total> · now: <what runs> · ahead: <stages left>` (`<done>` — slices `done`, `<total>` — all); before a plan `Progress: no plan yet · now: … · ahead: …`. In the full description: right before the last line.

## What not to do without the user

Not even when recommended: bypass by section 3. One the user explicitly assigned before leaving — do only that, once.

- Irreversible things: deleting or moving data, changing permissions or the schema, deleting files you did not create — even where the skill waits for a "yes". Exempt: a plan slice with a "Rollback" section — `swork` runs it; add under `## Waiting for the user` of `away.md` `- executed without the user: S<N> <title> — rollback: <the command>`.
- A commit, a push, a branch, a merge request.
- Actions outside the project folder: deploying and installing into the system, messages, publications, edits, restarting or shutting down another machine. Allowed: reading anything, plan checks where the plan names them, dependencies in the project, temp files in the temp folder. Beats the item above: a "Rollback" slice or environment repair outside the project is a bypass.
- A file outside the plan not proven this work's: do not restore or move it. Only proof — the executor's report names it among changed or created files; otherwise `swork` puts it into the snapshot's `known.txt` and `away.md` marks it an assumption. Restoring inside the agent's own worktree under `.agents/wt/` is allowed.
- What the user decided or approved: a `rules.md` rule, a change of `rules.md`, their choice in the conversation — bypass a divergence by section 3. `swork`'s own slice-card edits by its section 4 are minor, not a replacement, and never contradict `rules.md` or a decision "in force". Never write your answers into `rules.md`.
- The choice after the `swork` report: do not accept, fix or roll back; the snapshot stays. `saway` never sets the phase `done`, even all green.
- A manual check: only the user sets it to "done".

## 1. What you take on

Before the first message read the topic's `state.md` and plan, so its progress line has numbers; nothing in the chat before that. The first message: the `/goal` line from "How to leave so that the session does not stall" (do not wait) and one sentence on which work you drive. A `.saway.md` in the root from a previous run: append under a line with today's date; all of it goes into the description.

- The request names a topic or a task — that one.
- Not named — the one going on in this conversation.
- No work in the conversation — the topic in "In progress" of the wiki root index; several or none — section 5.

## 2. Drive it from where the work stands

Take the stage from `state.md` (phase, next step); without records, where the conversation ended.

| Where the work stands | What you do |
|---|---|
| no topic, what to build is unclear | `sbrain` |
| no topic, clear task too big to do and check in one pass | `splan` |
| no topic, clear small task | `swork` — a small change |
| a plan or approved design of a small task in the chat | `swork` — a small change |
| requirements written | `sbrain`: approve the cards it shows |
| requirements confirmed | `splan` |
| plan written | `splan`: approve the plan it shows |
| plan confirmed, execution in progress | `swork` |
| execution in progress, a slice `bypassed` or `awaiting manual check` with dependants | `swork`: its section 4 decides |
| `swork` report shown: step "user's choice after the report" | section 5 with the line `saway: work finished` |
| done | section 5 with the line `saway: work finished` |

The "Small" path of `swork`, a plan from the chat, no topic folder, or at most five requirements and a plan that is not large (large: over three slices, or a slice over one file or about 20 changed lines; without a plan the requirement count decides) — small work runs in this session. Otherwise each stage runs in a fresh subagent, effort `medium` (the launch tool's parameter), description `Stage <skill> of <topic>`:

```
Project root: <path>. Topic: <topic>.
Read in full <path to the SKILL.md of the stage's skill> and <path to saway/SKILL.md>; do only the stage of <skill>. The user is away: decide by "What changes while the user is away", "What not to do without the user", 3 and 4 of saway/SKILL.md.
As the stage's main session, write the topic cards and the wiki as the skill tells and launch its subagents; they do not write.
The user's words on the stage: <quoted word for word>.
Start no other skill.
Reply in English, exactly in this form:
PHASE: <phase and next step of state.md>
ENDED: <stage over | stopped — why>
FOR THE USER: <what is not in the cards>
```

Small work reads only the files marked `lite` — `saway` has no stage files: the stage skill's own `lite` column holds.

**Several agents.** Asked for by the user — quote their words in every stage task; before the full description run `agents.sh off --if-last` of the stage skill and name the outcome in it.

A progress message before each launch and after each reply. After each stage reread `state.md` and take the next row. Approve by choosing "Yes" in the skill's menu and note in `away.md` that it was without the user. An unapproved plan from the chat: reread it before `swork`, record that you approved it.

## 3. How to decide for the user

- **A menu with a recommendation** — take it; without one, the smallest addition that is easier to undo. Recommended one forbidden or against the user's words or `rules.md` — one that agrees; none — bypass.
- **An open survey question and a question that blocks the plan** — answer as the user would, from their words, `rules.md`, topic decisions, the code; else the most cautious assumption: less built, easier to undo.
- **Approval** of a summary, cards, a slicing or a plan — reread it as the user would; fix what contradicts their words or `rules.md`, then approve.
- **A divergence from the topic cards** — the work cannot agree with a requirement, a decision "in force" or a success criterion: choose by the items above, edit the card in place, go on; a criterion may be weakened or dropped. Overrides `swork`'s "edited by no one" (goal, shared constraints, "Not doing") and `splan`'s "edited with consent", "only their explicit yes". Replace a decision by "Replacement and archive" of the wiki rules: old line "superseded", new `assumption — decided without the user`. Never edited: a `rules.md` rule and a decision "user chose" — bypass by "What not to do without the user".
- **A return to an earlier stage** (`splan` to `sbrain`, approval to editing) — at most twice per work; a third is a bypass.
- **Bypass** — an action from "What not to do", a menu without an allowed option, a slice `swork` set to `bypassed`, a third return: skip it, record it, go on.
  - **Record:** `- bypassed: S<N> <title> — <reason>; depends on it: <slices | none>` under `## Waiting for the user` of `away.md` (its last part) and `S<N>: bypassed without the user — <reason>` in "Progress log". A slice `saway` forbids gets status `bypassed`, its `away.md` line stays. Not a slice: `- bypassed: <what> — <reason>; depends on it: <what is not done | none>`.
  - **"Next step"** in `state.md` stays `user's choice after the report`; the bypasses stay in `away.md`.
- **A doubt that does not keep you from going on** — record it and go on.
- **Do not pass your own decision off as the user's:** in the topic cards it is an assumption, not "user chose".

## 4. Recording decisions

Record every decision for the user at once.

- **For a topic** — `away.md` in the topic folder, by the wiki rules: `# Decided without the user in topic <topic>`, a hook, lines `- <question> — chosen: <what>; why: <argument>; otherwise: <what would change>`, and `## Waiting for the user` — not done, questions, doubts. Before editing a plan or a user-approved card (by `saway` or its stage) write `- <card>: <what> — was: <…>; became: <…>; why: <argument>; otherwise: <what would change>`; `swork`'s own slice-card edits by its section 4 stay in its "Progress log" and report. Link it in the topic index; when full, go on in `away-2.md`. `sbrain`'s "no topic folder — nothing in the wiki" does not apply.
- **No topic yet** — `.saway.md` in the project root, same form; for a small change put its path into `known.txt` once the snapshot exists. When a topic folder appears, move the lines into its `away.md` and delete the file; with no topic ever, delete it after showing the description.

## 5. Full description

The last message, for the returned user, when work ended, stopped or there is nothing to drive. Report not reached — first put what you wait for into "Next step" of `state.md`; never touch the phase.

1. **Changed in your requirements** — every edit of a success criterion or requirement: was, became, why; omitted if none.
2. **What was done** — by stage; for execution, checks with output, as in the `swork` report.
3. **Where it stands** — the phase and the next step.
4. **Decided without you** — every line of `away.md` in full.
5. **Bypassed** — each item, its reason, the slices it held back.
6. **Waiting for you** — not done, questions, doubts; after the `swork` report — the user's choice and all of "Found and left untouched". The `known.txt` files separately: unreviewed, a rollback will not restore them.
7. **How to roll back** — what to restore and with what.
8. **What to check and your choice** — what to look at first, then the four `swork` report options — "accept the work", "fix", "roll back everything", "do nothing" — each with its effect; the user answers, `swork` does it.

The last line, word for word, one of:

- `saway: work finished` — reached the `swork` report (or it was shown), the result of a small change, a probe or the "Non-software" path, or the topic is "done" — bypasses included;
- `saway: work stopped — waiting for the user` — nothing to drive by section 1, the user returned mid-work, the turn limit ran out, or a bypass before execution left nothing to plan or execute.

Start nothing after the description: no second round over the report findings.

## How to leave so that the session does not stall

Claude Code's `/goal` starts the next turn until its condition is met. Leaving, the user types:

```
/goal work by the saway skill until it shows the full description with the last line "saway: work finished" or "saway: work stopped — waiting for the user"; or stop after 100 turns
```

`/goal` does not cancel permission requests: use a mode that does not ask. Without `/goal`, drive the work in one turn and do not end it before the description. With a turn limit, name the turn number each turn; on the last, show the description with `saway: work stopped — waiting for the user`.

## Traps

| Thought | In fact |
|---|---|
| "The question is important, I will wait for the user" | Decide, record, go on; it goes to "Waiting for the user" |
| "The recommended option is 'accept the work'" | Acceptance, a fix after the report, a rollback, a commit — the user's |
| "The report is shown — I will start `swork` once more" | Nothing to drive: the description and the last line |
| "The skill tells me to wait for a 'yes'" | You give the "yes" — after rereading what is approved |
| "The slice has stalled, the work is stopped" | `swork` bypasses it; record it in `away.md` |
| "Everything is green, I will close the topic" | `done` only by the user's choice after the report |
