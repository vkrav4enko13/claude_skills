# A decision map for unfamiliar territory

The survey assumes that the user can judge the question. In an unfamiliar area this is not so: the questions draw out guesses, not requirements. The map turns "I don't know what I don't know" into a list of decisions with options, from which one can already choose.

The map is not a textbook. Each of its items must end in something the user will decide, delegate or defer in this brainstorm. An item that leads to no decision is reference material — throw it out.

## When to offer

- The user said from the very start that they do not know the area: "I have never touched this", "I don't know what is possible here at all", "I don't know what to ask about".
- Or two answers in a row show that they **cannot judge** the substance of the question: "I don't know", "whatever is best", "decide yourself" — where a judgment about the subject is needed.

**Cannot judge is not the same as has not decided yet.** Someone who understands the options but has not chosen needs an ordinary survey. Offering the map to an expert who is simply hesitating is a mistake. If the signal is unclear, continue the survey.

The offer concerns the territory, not the whole conversation. About their own task, their own users and their own priorities the person is the chief expert; these questions go as usual.

## The offer

As a blocking question, once per territory:

> Part of the task lies in an area that is unfamiliar to you (<area>). I can first lay out the decisions that lie ahead there: the options for each and what I would choose by default — so that you choose rather than guess. Or we continue with questions, and I will close the gaps with default values and record them as assumptions.

Options: **The map first** / **Continue with questions**. If the user refused, do not offer again for this area; record the default values as explicit assumptions.

## How to build

First the grounding, then the map:

- **An area inside the project** (a module, a subsystem) — read the code. Do not build such a map from memory.
- **An outside area** (a technology, a craft, a market) — search the web. If there is nothing to search with, the model's knowledge is acceptable, but mark every such item: "not checked against current sources".

**The territory itself closes part of the questions.** Before putting an item on the map, check whether the code or the sources answer it. If they do, it is not a decision: show the question and the found answer with a reference as established, without a menu. Do not close such items silently — show them.

Separately look for dangers: what breaks quietly (wrong data by default, a filter that lets the bad through); unwritten rules that the code observes and the documents do not name; abandoned and rolled-back past attempts to do the same thing — the reason they did not survive is usually the landmine itself.

The map is **3–7 items** in the chat, each no longer than four lines:

- what this decision or danger is — in the user's words; explain a term that cannot be done without and say what it lets one decide;
- why it matters **here** — tie it to what the user said, not to the area in general;
- for a decision: 2–4 real options, one phrase each about the main trade-off. Only those you are ready to defend; mention a rejected option in "why it matters", not in the menu;
- for a decision: what you would choose by default.

A danger has no options and no default value — it is a constraint, not a vote. If it forces a choice between ways of protection, that choice is a separate decision item.

The order is by how much the answer changes the shape of the result: what changes everything goes first, the reversible and the dangers — at the end. Do not pad it up to seven: three real decisions are three items.

## Return to the survey

After the map — **one** multi-select question: "Which of these shall we work through now? What is not chosen will get the default value and will be recorded as an assumption".

- **Chosen decisions** — one at a time, a menu with the options from the map. Here a menu is appropriate even where an open question is usually better: the options no longer suggest, they remind of what has just been explained.
- **Decisions not chosen and dangers** — the default value or the constraint is recorded as an explicit assumption.
- **"I want to understand this"** — explain in detail yourself: how it is built and why so, with paths in the code and sources, separating what was found from guesses; the brainstorm will continue afterwards.

The map itself decides nothing and does not replace the survey. It is built once; after it comes the usual course: the gap check, the approaches, the summary.
