# Context first. Write down your understanding

Read at step 2 — after the path is chosen, before the first question — and at step 3, when the context is studied.

## 2. Context first

Study the project yourself: files, documents, recent changes, instructions, the glossary; check whether something similar exists. First run `bash <skill folder>/scripts/codemap.sh <project root>` for a map of the code; it does not replace the search.

Find the project wiki by `references/wiki-rules.md`. What its `rules.md` decides is a fact: do not ask about it again.

The wiki is not kept (`references/wiki-rules.md`, section "The wiki is not kept") and the path is "Large" — say so before the survey and ask once: a folder the user names, or the chat. Recommend the folder (`splan` and `swork` start from topic cards) — the one the project's own record rules set aside, if any. Chat — the result stays there, as with "Small".

The wiki has a topic folder on this topic, or the user referred to one — first read its `state.md` and act by the phase:

| Phase in `state.md` | What you do |
|---|---|
| there is no topic folder | the usual course |
| requirements written | ask: do we approve or edit |
| requirements confirmed | offer `splan`; resume the survey only on request |
| plan written | name the phase, offer `splan` |
| plan confirmed | offer `swork` |
| execution in progress | offer `swork` |
| done | ask: a new topic or a continuation of this one |

Offering a skill — name the phase, offer, wait for a choice; no survey. Exception, "Grill" of the topic's plan at `plan written` or `plan confirmed` — survey it; editing the plan cards sets the phase back to `plan written` in `state.md` and the topic's line in "In progress". Editing or resuming — restate where we stopped, start from the topic's decisions and open questions, edit its cards; no second folder.

A single requirements file of the earlier form on the topic — call it the earlier format, offer to move it into cards by `references/wiki-migrate.md`, do not continue from it.

- **You look for the facts, the user makes the decisions.** Do not ask what the repository, the tools or the web can answer.
- **A long search does not block the survey.** Give it to a subagent if there are any and ask the questions that do not depend on it.
- **Pass what is decided to a subagent as a fact.** What was chosen and rejected — yes; the arguments — no: they anchor. Add: "if you find that this decision cannot work, report it".
- **Check before you assert.** Every "the project does not have this" is checked against the code or called an unverified guess.

## 3. Write down your understanding

Give back briefly: the result, for whom, success, constraints — what they said apart from what you assumed; let them correct it. Goal unclear — first one question about the purpose.

Before the first question name a one-sentence hypothesis — what problem, for whom — with a confidence percentage: "Hypothesis: … 60 % confident: what is missing is …". Only a percentage you can justify, always with what is missing.

Offer your own solutions only after learning what the user already thinks, tried and rejected.
