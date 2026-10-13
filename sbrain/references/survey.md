# Survey along the decision tree

Read at step 4 — after the understanding is written down, before the first round of the survey.

## 4. Survey along the decision tree

Picture the task as a tree: each decision opens the decisions that depend on it. **The front** is the decisions whose prerequisites are all already closed; they can be asked now, without guessing someone else's answers. Go from the broad (the problem, for whom, the benefit) to the narrow (constraints, exceptions, edge cases).

**The path sets the result, not the depth.** The survey goes on until the front is empty on any path: "Large", "Small", "Grill" of a plan, "Non-software". On the "Probe" path the tree is the check itself: what we count as an answer and what can be sacrificed. "Until the front is empty" does not mean "for a long time": on a clearly stated task the front may be empty at once, and then there are no questions. One thing is not allowed: closing a branch with a silent assumption instead of a question.

**A tree from a ready plan** (the "Grill" path). The nodes are the decisions of the plan: both the named ones and those it is silent about but does not work without. Start with the load-bearing ones — those on which most of the rest depends: if such a one falls, the questions below it lose their meaning. Check the plan's statements about the project against the code before the questions; name a discrepancy at once instead of asking about it.

**Round.** Ask the front as a batch of up to four questions through the blocking question tool (in Claude Code — `AskUserQuestion`). In one round — only questions that are independent of each other; a question that depends on one still open waits for the next round. If there is no such tool, ask with a numbered list in the chat:

```
❓ Q1 — <title>: <question and options>
➡️ I recommend: <answer and why>
```

If the front is larger than four, the rest goes in the next round. If the user asks for one question at a time, ask one at a time. You choose the front by eye, and it can let you down: if an answer has changed a neighbouring question of the same round, open that branch again in the next one.

**Tree counter.** From the second round on, before the questions — one line: how many decisions are closed, how many you are asking now, how many are waiting for their prerequisites, and in the same line — the updated confidence percentage from step 3. Say that this is an estimate as of now: the tree grows from the answers. In the first round there is no counter — the survey may well end with that round.

**A recommendation for every question.** Every question has one, an open question included. Put the recommended option first and mark it. The recommendation answers the question in the form in which it is asked: if your advice is "do not do this at all", rephrase the question so that agreeing with you does not mean "no" to the question itself. The options are 2–4 really different ones; if you cannot gather them without a stretch, the question is open. A "one of" choice is single-select; multi-select is only for a compatible set (goals, constraints), and if priority matters, ask next what the main thing is.

**The argument before the menu.** In a menu the argument shrinks to a line. If the choice is not obvious or is expensive to undo, write 1–2 lines on such a question before the menu: what depends on it and why the advice is exactly this. For an obvious question a line in the menu itself is enough — do not write an argument for the sake of uniformity.

**What to recommend.** What the goal cannot be reached without, and nothing beyond that. An addition that will be expensive to attach later (stored data, a shared interface, money, security) — bring it out as a separate explicit choice, with a recommendation on the merits and a named price. Everything else of the "could also" kind goes as a non-default option or into the deferred items. A recommendation never narrows what the user asked for.

**Open questions go in the chat, without a menu; one at a time — except the batch of the gap check.** A menu suggests the answer. An open question must name what counts as an answer: "What do you do now when this happens?", not "What do you think?". It has a recommendation too: the question ends with the words "my guess: …, because …".

**Gap check.** Read the original request and note to yourself which of these supports are missing. Ask only the missing ones — in one batch, in one message: as a numbered list, each question with its own guess; the question about attachment to the form does not go into the batch. The supports:

- *Evidence* — what has already been done because of this problem: time spent, a workaround, money.
- *Specifics* — for whom exactly and what will change for them.
- *What happens now* — how people get by today and what will happen if nothing is done.
- *Attachment to the form* — what the smallest version is that still gives a benefit. Ask this question last before the approaches.
- For the "Large" path also: is this a patch or a step toward where the system should go anyway; under what conditions the undertaking will fail; what neighbouring thing we may accidentally build instead of the needed one.
- For a new product also: on what present state of affairs the benefit rests and what will happen to the idea when that state predictably changes. Do not accept an answer that any competitor could give.

On a clearly stated task there may turn out to be no gaps — then do not ask. If the answer is an honest "I don't know", record it as an assumption instead of skipping it.

**Clarifying an answer.** Restate an answer given in the user's own words as the decisions that follow from it, and count it as accepted only after a "yes". A chosen ready-made option needs no restating. Turn a vague word in an answer — "faster", "as usual" — into a condition that can be checked: "is 'faster' a response in no more than a second on a thousand rows?" — and get a "yes" to it.

**Decided or only said.** A decision made with an alternative or a risk in plain view is decided: do not ask about it again and carry it forward as it is. An instruction that nobody has examined ("we do it on X") is not a decision yet: challenge it exactly once and accept the answer. Do not count as decided a proposal of your own that the user did not react to. Always name a real defect or an impossibility found in what is decided. A decision with the status "in force" from the project wiki is decided too. If what the user asks for, or the work itself, contradicts it — name the card of this decision to the user and wait for an explicit "yes": only that changes the decision. Write up the replacement when recording the result — by the "Replacement and archive" section of `references/wiki-rules.md`.

**The "decided" list.** After every third round show in the chat what is already decided: a line per decision, with a mark of whose it is — the user chose it or agreed with your proposal. This way the decisions of the early rounds will survive context compaction, and the user will see the whole before the summary. If the user has corrected an item, the branch is open again together with everything that depended on it. The list does not replace the summary of step 7: it is raw material for it.

**Terms and scenarios.** Clarify a vague or overloaded word at once: "is an 'account' a customer or a user? These are different things". If a word differs from the project glossary or from the code, or the user describes how the system works differently from how it is built in the code you have checked — say so before building further on it. Check the links between concepts with concrete made-up cases at the boundaries: "the order is partly cancelled and the payment has already gone through — what does the customer see?".

**Do not only ask.** Offer alternatives, argue with assumptions, say "what if it is the other way round".

**Nodding along.** If all your recommendations have been accepted two rounds in a row, say so once: so far the decisions are yours, not the user's. After that do not remind again: an expert agreeing with good recommendations is a normal outcome.

**The survey does not converge.** If over four or five rounds the front is not narrowing but growing, the task is too large for one brainstorm. Stop, show a breakdown into parts and agree on which one we discuss now. On the "Small" path the threshold is lower: if the front has not emptied in three rounds, the task is not "Small" — move to a heavier path.

**Show, not describe** — on any path. When the next question is about arrangement, a mock-up or a diagram and it cannot be settled in words — offer to show before the question itself: in a separate message, once per such question, not in advance. If the user agreed, read `references/visual.md` and make a sketch by it. If the user refused, describe in text and do not offer again for this question. A question about meaning, even one about the interface, stays as text. A text mock-up in the answer options does not replace the offer.

**The user cannot judge the question.** If they said at once that they do not know the area, or answered "I don't know", "whatever is best", "decide yourself" twice in a row to questions that require knowledge of the subject — read `references/blindspot.md` and offer a decision map. Do not confuse this with "has not decided yet": someone who understands the options needs an ordinary survey. Silently moving on to explanations or silently deciding for them is not allowed.

**A decision is expensive to redo, and conversation and a sketch cannot close it** — how it feels in the hands, how it moves, how it reads. Offer a throwaway prototype once — by `references/prototype.md`. For a decision that is cheap to change, do not offer one.

**Before leaving — a check of combinations.** Put the answers together and find the non-obvious consequences: "if the pause is stored in the rule and we do not warn on deletion, then deletion silently loses the pause". Each such consequence is a separate question now, not a footnote later.

**The survey is finished** when the front is empty or the user asks to move on — then everything unclosed is recorded as assumptions and goes into the summary. The following must be known or explicitly recorded as an assumption: who the user is, what result is needed, what is in scope and what is not, how we will know it worked. Nothing may be silently assumed. Before closing, name to yourself three questions you would ask next and predict the user's answers; if you cannot predict them, ask them instead of closing the survey.

Choose the technical details (schemas, libraries, file layout) yourself by the project and leave them to the plan — unless the brainstorm is about the architecture itself.
