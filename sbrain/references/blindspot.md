# A decision map for unfamiliar territory

The map turns "I don't know what I don't know" into decisions with options. Every item ends in something the user decides, delegates or defers in this brainstorm; drop an item leading to no decision.

## When to offer

- The user said from the start they do not know the area ("I have never touched this", "I don't know what to ask about").
- Or two answers in a row ("I don't know", "whatever is best", "decide yourself") show they **cannot judge** a question needing subject judgment.

**Cannot judge is not the same as has not decided yet.** A hesitating expert gets an ordinary survey, not the map. Unclear signal — continue the survey.

The offer covers the territory only; their own task, users and priorities go as usual.

## The offer

As a blocking question, once per territory:

> Part of the task lies in an area new to you (<area>). I can first lay out the decisions ahead there, with options and my defaults, so you choose rather than guess. Or we continue with questions, and I fill the gaps with defaults recorded as assumptions.

Options: **The map first** / **Continue with questions**. Refused — do not offer again for this area; record the defaults as explicit assumptions.

## How to build

First the grounding, then the map:

- **An area inside the project** (a module, a subsystem) — read the code; never from memory.
- **An outside area** (a technology, a craft, a market) — search the web. Nothing to search with — model knowledge, every such item marked "not checked against current sources".

**The territory itself closes part of the questions.** An item the code or sources answer is no decision: show it with the answer and a reference as established, without a menu, never silently.

Look separately for dangers: what breaks quietly (wrong defaults, a leaky filter); unwritten rules the code keeps; abandoned or rolled-back past attempts and why they died.

The map is **3–7 items** in the chat, each at most four lines:

- what the decision or danger is, in the user's words, with any unavoidable term explained;
- why it matters **here**, tied to what the user said;
- for a decision: 2–4 options you would defend, a phrase each on the trade-off (a rejected one goes in "why it matters"), and your default.

A danger is a constraint without options or default; a choice between protections is a separate decision item.

Order by how much the answer reshapes the result; the reversible and the dangers last. Do not pad to seven.

## Return to the survey

After the map — **one** multi-select question: "Which of these shall we work through now? What is not chosen will get the default value and will be recorded as an assumption".

- **Chosen decisions** — one at a time, a menu with the map's options.
- **Decisions not chosen and dangers** — the default or the constraint is recorded as an explicit assumption.
- **"I want to understand this"** — explain how it is built and why, with code paths and sources, facts apart from guesses; then continue.

The map is built once and replaces no survey; then the gap check, the approaches, the summary.
