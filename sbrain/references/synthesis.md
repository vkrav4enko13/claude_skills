# Summary, requirements cards and check

Read at step 7 — after the approaches and before anything is written.

## Summary before writing

The user has agreed with many separate answers but has not seen the whole. The summary is their last chance to correct the understanding before it becomes a document. It is not a draft of the document and not a retelling of the conversation.

**First, to yourself,** sort everything into three piles and do not put them into the chat:

- *Said* — what the user stated themselves or chose;
- *Assumed* — what you filled the gaps with; this is where their corrections matter most;
- *Out of scope* — what you considered and deliberately left out.

**Then show the summary** — the way two people would sum up a conversation aloud:

1. **What we build** — 1–3 sentences about what will come out. Always.
2. **Trade-offs** — a choice the user would be surprised not to see named. The obvious and what has no alternative do not go here.
3. **What is out of scope** — only what the reader will ask "and why is this missing?" about.
4. **What to look at** — the forks that the conversation did not close: your silent assumptions, the consequences of the combination of answers, the bets that are cheap to correct now and expensive after the plan.

Do not show an empty section. What is already decided in the conversation goes as a separate line "We keep: X instead of Y — the reason", not as a question.

Rules:

- An item is one line, two at most. If it reads like a paragraph of a specification, it is not a summary.
- No names of files, tables, keys or error texts: that is a matter for the plan.
- Not "you said you want X" but "X means Y".
- An item that takes reading the code to judge does not go into the summary.
- For an ordinary task — 2–4 items in sections 2–4 together, for a large one — up to 7. If there are more, do not raise the ceiling but merge: several items almost always turn out to be parts of one decision.
- Do not leave questions next to the summary. If there is a question without a reasonable default answer, ask it first, then show the summary.

Ask for consent to the summary with a menu: "Yes" — with what will happen after it: writing the cards, showing the design or the check — "Fix" and "Do nothing". On the "Small" path there is no such menu — see below.

**After a fix** — make it, show the summary again, wait for a "yes". Writing right after a fix is not allowed, even if it is a minor one. If one and the same item is corrected a second time, ask directly: do we write it down as it is or discuss further.

On the "Small" path the summary and the short design are shown in one message, and there is one consent — the menu of step 8. For a "Small" task on which not a single question was asked, the summary is one paragraph of "what we do".

## Where to write

- **"Probe" and "Small"** — the result is in the chat, there is no topic folder. Only a project-wide rule that the user has named goes into `rules.md`. The journal line is written by whoever makes the edit.
- **"Large"** — a topic folder `docs/work/<topic>/` by `references/topic-cards.md`: read it before writing.
- **"Grill"** — if the plan lies as cards in the topic folder, after the confirmed summary edit the plan cards of the topic; if the user's plan lies in an arbitrary file, edit that file instead of setting up a new one next to it. Do not apply the layout from `references/topic-cards.md` to the plan — a plan has its own structure. If the plan was only in the chat, the result is a summary in the chat.

Where the project wiki is, `references/wiki-rules.md` says; if it does not lie in `docs/`, the topic folder is `work/<topic>/` in it. If there is no wiki, set it up by these rules. Do not touch someone else's folder with the same name: add `-2` to the name of your own. A resumed brainstorm edits its own topic folder.

## Sections

Which sections the result carries, what is in each and which topic card it goes into — in `references/topic-cards.md`.

**Only what was asked for.** The requirements, the decisions and the success criteria take what the user asked for or chose, and what it will not work without. An addition of your own that nobody named — an action log, a switch, a notification, an extra safeguard — write into "Out of scope" as deferred or into the open questions.

**A rule has one owner.** A check, a threshold, a limit or a condition is written in full in one place — in a numbered requirement. The other sections refer to the number and add only their own. The same rule rewritten in another section without a reference is a defect: the copies will drift apart, and it is unclear which is the main one.

Write densely: the decision or the result comes first, one thought per sentence. Do not spell a fork out in both directions — send it to the open questions. If a later decision has cancelled an earlier one, fix it in place instead of adding a layer on top. File paths are relative to the project root.

## Checking claims

If the document claims something about the project — "there are no retries", "the setting lies in such-and-such a place" — check every such claim against the code before writing. It is better to give this to a subagent that has not seen the conversation: an author checking themselves confirms what they already believe. Start it at the moment you show the summary — it will finish while the user is reading. Fix what is refuted, call what cannot be checked an assumption.

## Check before showing

Reread the written topic cards with fresh eyes and fix in place:

- **Complete** — no stubs, no "to be clarified later" and no empty sections;
- **Consistent** — the cards do not contradict each other, no rule is written in full in two places;
- **Focused** — this is one piece of work, not several under one header;
- **Fit for a plan** — the planner will not have to invent the behaviour, the boundaries or the success criteria; no requirement can be understood in two ways;
- **By the patterns** — check every requirement against the five patterns from the requirements template in `references/topic-cards.md` and fix those that do not fit.

If a fix changes the behaviour or the scope, do not decide yourself — ask one question.

Then run the wiki check script — `bash <skill folder>/scripts/check.sh <wiki folder>` — and fix everything it names; once fixed, run it again.

Then name the full path to the topic folder and its phase — `requirements written` — ask the user to read the cards and wait for an answer. Fixes — make them, reread and run the script again. Do not commit to git until asked.

## Glossary and decision records

**The glossary** — after the cards are written, not along the way: by this moment the names have settled. If the project **already has** a glossary of terms (`GLOSSARY.md`, `CONCEPTS.md`), add or refine the terms whose meaning was settled for good in the conversation. Only concepts of the subject area: not class names, not paths and not implementation decisions. Do not set up a new glossary without a request.

**A full decision card** `decision-<name>.md` is written together with the other topic cards and only when all three conditions hold: the decision is hard to undo; without an explanation it will surprise a future reader; it had real alternatives. Its template is in `references/topic-cards.md`. The other decisions go as a line in `decisions.md`.
