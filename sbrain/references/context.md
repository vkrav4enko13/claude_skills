# Context first. Write down your understanding

Read at step 2 — after the path is chosen, before the first question — and at step 3, when the context has been studied.

## 2. Context first

Study the project yourself: the files, the documents, the recent changes, the project instructions, the glossary of terms if there is one. Check whether something similar already exists.

Find the project wiki — by `references/wiki-rules.md`. What is decided in its `rules.md` is a fact, not a question: do not ask about it again.

If the wiki is not kept in the project — when that is so and what to write then is said in `references/wiki-rules.md`, section "The wiki is not kept" — and the path is "Large": say so before the survey and ask once where to keep the result — in a folder that the user will name, or in the chat. Recommend the folder: without the topic cards `splan` and `swork` have nothing to start from; if the project has its own rules for records, offer the folder they set aside for such records. If the chat is chosen, the result stays in the chat, as with a "Small" task.

If the wiki already has a topic folder on this topic or the user has referred to one — first read its `state.md` card and act by the phase:

| Phase in `state.md` | What you do |
|---|---|
| there is no topic folder | the usual course |
| requirements written | ask: do we approve or edit |
| requirements confirmed | offer `splan`; resume the survey only on request |
| plan written | name the phase, offer `splan` |
| plan confirmed | offer `swork` |
| execution in progress | offer `swork` |
| done | ask: a new topic or a continuation of this one |

Where the table tells you to offer another skill, name the phase, offer and wait for a choice: do not start the survey. The exception is the "Grill" path: if the user asks to survey the plan of the topic at the phase `plan written` or `plan confirmed`, survey it. Editing the plan cards removes the approval: in `state.md` and in the topic's line in "In progress" set the phase back to `plan written`. If we are editing, or resuming the survey, briefly restate where we stopped, start from the decisions and open questions of the topic and edit its cards instead of setting up a second folder.

If there is a requirements file of the earlier form on the topic, as a single file, or the user has referred to one — call the format the earlier one, offer to move it into cards by `references/wiki-migrate.md` and do not continue from that file.

- **You look for the facts, the user makes the decisions.** Do not ask what can be found in the repository, in the tools or on the web.
- **A long search does not block the survey.** Give it to a subagent, if there are any, and ask the questions that do not depend on it. While the user is thinking over an answer, the search goes on.
- **Pass what is decided to a subagent as a fact.** What was chosen and what was rejected — yes; the arguments for the choice — no: they anchor. Add: "if you find that this decision cannot work, report it".
- **Check before you assert.** Any "the project does not have this" is either checked against the code or called an unverified guess.

## 3. Write down your understanding

Briefly give back to the user: what result is needed, for whom, what counts as success, what the constraints are. Separately — what they said, separately — what you assumed. Let them correct it. If the goal is unclear, first one question about the purpose, and only then features and approaches: the genre of an application does not say what it is needed for.

Before the first question, name a hypothesis about the task in one sentence — what problem we are solving and for whom — and the confidence percentage in it: "Hypothesis: … 60 % confident: what is missing is …". The percentage is only one that you can justify, and always with what is missing for full confidence.

Offer your own solution options only after you have learned what the user themselves already think, have tried and have rejected — otherwise the conversation will stick to your ideas. The hypothesis about the task does not get in the way of this: it is about what is needed, not about how to do it.
