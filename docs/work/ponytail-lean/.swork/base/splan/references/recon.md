# Choose the size and name it aloud. Recon

Read at step 2 — after the entry, before the recon — and at step 3, when the size is named.

## 2. Choose the size and name it aloud

Before the recon say which size is chosen and why, and go on: this is not a stop, do not wait for an answer. The user can correct the size at any moment.

| Size | When | Result |
|---|---|---|
| **Direct** | The change can be named, made and checked in one pass; there are no decisions that the user would weigh | Two or three sentences in the chat: what we change, where, how we will check |
| **Short** | One to three slices, at most one decision to weigh, no danger zone | A plan in the chat: the goal, the slices (what will start working, the files, the check), what we do not do |
| **Cards** | Everything else; always — if there is a topic folder, if the user asked for a plan in cards or if a danger zone is touched: login and permissions, money, data migration, external agreements | A plan in cards in the topic folder — by `references/plan-format.md` |

If you hesitate between two — take the heavier one. If the recon uncovered complexity, stop, say so and move to a heavier size; making it lighter on the way is not allowed.

The size is "Cards" but there is no topic folder — `splan` sets it up itself when it writes the plan: `00-index.md` and `state.md` — and opens the chain's journal line with the tail `plan written`. How — in `references/plan-format.md`.

The wiki is not kept in the project — keep the topic folder and the records by `references/wiki-rules.md`, section "The wiki is not kept".

For a direct and a short one do the recon yourself, by reading the named places. Step 6 is not needed for them, of step 8 — only the self-check, without a separate agent; step 9 is mandatory. No topic folder is set up for them, and `splan` writes nothing to the wiki: the result stays in the chat, the journal line is written by whoever makes the edit.

## 3. Recon

First the code, then the questions.

- **What to look for:** the places the work will touch; how similar things are already done in the project — follow that; the build, launch and check commands; the project instructions and the glossary of terms; what will break nearby.
- **You look for the facts, the user makes the decisions.** Do not ask what can be found in the repository, in the tools or on the web.
- **For a plan in cards** hand the recon to subagents if they are available and the affected places are not known in advance: at most three per plan, to each — one question and a request to return a conclusion with paths and lines, not a dump of files. Start them in one message. Pass on what is decided as a fact, without arguments in its favour, and add: "if you find that this cannot work — report it". Read the places named in the requirements or in the task yourself.
- **Check before you assert.** Any "the project does not have this" and any path or name in the plan is either checked against the code or called an unverified guess.
- **Check the user's correction about the code against the code**, do not take it on trust; name the discrepancy.
- **Ready-made code.** For the places the work will touch, find ready-made code in the project that can be taken instead of new code: a function, a class or a script. Write down the name, the signature and the file.

Questions to the user — only about what neither the code nor the requirements answer, and only blocking ones: without an answer it is impossible to choose the slicing or a technical decision that is expensive to undo. Ask them through the blocking question tool, with a recommendation for each. Decide the rest yourself and show it in the plan as a decision made.
