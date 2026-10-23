# Survey along the decision tree

Read at step 4 — after the understanding is written down, before the first round.

## 4. Survey along the decision tree

**The front** is the decisions whose prerequisites are all closed. Go from broad (problem, for whom, benefit) to narrow (constraints, exceptions, edge cases).

**The path sets the result, not the depth.** Survey until the front is empty on every path (on "Probe" the tree is the check: what counts as an answer, what can be sacrificed); it may be empty at once. Never close a branch with a silent assumption.

**A tree from a ready plan** (the "Grill" path). Nodes are the plan's decisions, named and silently needed. Start with the load-bearing ones. Check the plan's statements about the project against the code before the questions; name a discrepancy at once, do not ask.

**Round.** Ask the front as a batch of up to four questions through the blocking question tool (in Claude Code — `AskUserQuestion`). Open questions and items put for confirmation (an assumption, a decision taken on "decide yourself") count toward the four; a round with a menu holds no open question. Only mutually independent questions in one round. No such tool — a numbered list in the chat:

```
❓ Q1 — <title>: <question and options>
➡️ I recommend: <answer and why>
```

The rest waits for the next round. Asked for one at a time — one at a time. An answer changed a neighbour in the round — reopen it next round.

**Tree counter.** From the second round on, before the questions, one line: decisions closed, asked now, waiting, and the updated confidence percentage from step 3, called an estimate as of now. Not in the first round; in every later one, also while the design or the summary is shown.

**A recommendation for every question.** An open question included; a second question inside an item gets its own or waits. Recommended option first, marked, answering the question as asked (advice "do not do this at all" — rephrase so agreeing is not "no"). 2–4 really different options, else the question is open. "One of" is single-select; multi-select only for a compatible set (goals, constraints), then ask the main one if priority matters.

**The argument before the menu.** A non-obvious or costly-to-undo choice gets 1–2 lines before the menu: what depends on it, why this advice. Otherwise the menu line suffices.

**What to recommend.** What the goal needs, nothing more. An addition costly to attach later (stored data, a shared interface, money, security) — a separate explicit choice, recommended on the merits, priced. Other "could also" — non-default or deferred. Never narrow what the user asked for.

**Open questions go in the chat, without a menu; one at a time — except the batch of the gap check.** Name what counts as an answer ("What do you do now when this happens?", not "What do you think?"); end with "my guess: …, because …".

**Gap check.** Ask only the supports the original request lacks — one message, a numbered list, each with its guess; attachment to the form is not in the batch:

- *Evidence* — what was already spent on the problem: time, a workaround, money.
- *Specifics* — for whom exactly, what changes for them.
- *What happens now* — how people get by, what if nothing is done.
- *Attachment to the form* — the smallest version still of benefit. Ask last before the approaches.
- "Large" also: a patch or a step where the system should go anyway; when it fails; what neighbouring thing we may build instead.
- New product also: what present state the benefit rests on, what happens when it changes. Reject an answer any competitor could give.

No gaps — do not ask. An honest "I don't know" is recorded as an assumption.

**Clarifying an answer.** Restate a free-worded answer as decisions; accepted after a "yes". A chosen ready option needs none. Turn a vague word ("faster") into a checkable condition ("within a second on a thousand rows?") and get a "yes".

**Decided or only said.** Made with an alternative or risk in plain view — decided: do not ask again. An unexamined instruction ("we do it on X") — challenge exactly once, accept the answer. Your proposal left unanswered is not decided. Always name a real defect or impossibility found in a decision. A wiki decision "in force" is decided; contradicted by the request or the work — name its card and wait for an explicit "yes"; write up the replacement with the result by the "Replacement and archive" section of `references/wiki-rules.md`.

**The "decided" list.** After every third round show a line per decision, marked "user chose" or "agreed". A corrected item reopens its branch and dependants. It feeds the summary of step 7.

**Terms and scenarios.** Clarify a vague or overloaded word at once ("an 'account' — customer or user?"). A word or a described behaviour differs from the glossary or the checked code — say so before building on it. Test concept links with made-up boundary cases ("partly cancelled, already paid — what does the customer see?").

**Do not only ask.** Offer alternatives, argue with assumptions, ask "what if it is the other way round".

**Nodding along.** All recommendations accepted two rounds in a row — say once that so far the decisions are yours. Not again.

**The survey does not converge.** The front grows over four or five rounds — stop, show a breakdown, agree which part we discuss. "Small" with the front not empty in three rounds — move to a heavier path.

**Show, not describe** — on any path. Arrangement, a mock-up or a diagram that words cannot settle — offer to show before the question, in a separate message, once, not in advance; agreed — sketch by `references/visual.md`; refused — text, no second offer. Meaning stays text; a text mock-up in options is not the offer.

**The user cannot judge the question.** They said they do not know the area, or twice in a row answered "I don't know", "whatever is best", "decide yourself" where subject knowledge is needed — read `references/blindspot.md` and offer a decision map. Not "has not decided yet": someone who understands the options gets an ordinary survey. Never silently switch to explanations or decide for them.

**A decision is expensive to redo, and conversation and a sketch cannot close it** — how it feels, moves, reads. Offer a throwaway prototype once by `references/prototype.md`; cheap to change — do not offer one.

**Before leaving — a check of combinations.** Combine the answers, find non-obvious consequences; each is a question now.

**The survey is finished** when the front is empty or the user asks to move on; the unclosed become assumptions for the summary. Known or an assumption, nothing silently assumed: who the user is, the result, in and out of scope, how we know it worked. Before closing, name to yourself three next questions and predict the answers; cannot — ask them.

Technical details (schemas, libraries, file layout) — choose by the project and leave to the plan, unless the brainstorm is about the architecture.
