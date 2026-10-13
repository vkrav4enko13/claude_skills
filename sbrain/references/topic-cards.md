# Topic cards

Read at step 7 — after the confirmed summary, before the result of the "Large" path is written — and at step 8, when the user has approved the cards. Moving an old file over follows the same layout: `references/wiki-migrate.md`.

The result of the "Large" path is a topic folder `work/<topic>/` in the project wiki, by default `docs/work/<topic>/`; `<topic>` is in Latin letters, hyphenated. Where the wiki is, the limits of a card and of an index, the check script — in `references/wiki-rules.md`. Here is only what a topic adds.

## What goes where

| Section of the result | Card | What it carries |
|---|---|---|
| In brief | `task.md` | "What we build" from the summary |
| Task | `task.md` | The problem through the user's eyes: what is wrong now and for whom. Do not repeat "In brief" in other words |
| Success criteria | `task.md` | How we will know it worked |
| Requirements | `requirements.md` | Lines `- R<N>. …`: each is checkable, each is an intention and at most one refinement. The numbers are continuous, in the order of the summary. Group requirements about different things by subject under short headings |
| Acceptance examples | `examples.md` | A concrete case, what happened and what should come out, with a reference to the requirement ("checks R4"). Only when the behaviour depends on conditions: simple behaviour needs no card |
| Design | `design.md` | The approved sections of step 6 in the form in which they were approved. Only if step 6 was carried out |
| Decisions made | `decisions.md` | A line per decision: what was chosen, instead of what and why, whose it is, the status |
| Out of scope | `scope.md` | What is deferred and what we deliberately do not do |
| Assumptions and open questions | `scope.md` | Everything unconfirmed. Mark separately the questions without an answer to which planning is impossible |

Every topic has six cards: `00-index.md`, `state.md`, `task.md`, `requirements.md`, `decisions.md`, `scope.md`. The cards `examples.md`, `design.md` and `decision-<name>.md` — only when there is something to put in them.

**A card** — the title, the hook line, the line in the index and the splitting of an overgrown card — by `references/wiki-rules.md`, sections "Card and limits" and "Check". The sections inside a card go under `## …` headings. Requirements are split by groups — `requirements-<group>.md`, the numbering stays continuous.

**Decisions.** A line of `decisions.md`: `- <what was chosen>, instead of <what> — <why>; <whose decision>; <status>`. The trade-offs from the summary and your assumptions that the user agreed with go here. Whose decision it is — one of two: "user chose" — they themselves chose between the options shown or against what was proposed; "agreed" — you proposed, showing the price, and they accepted. Do not record as a decision a proposal of your own that they did not answer — it is an assumption, its place is in `scope.md`. The status is "in force", "superseded" or "withdrawn". When a decision needs a full card — `references/synthesis.md`, section "Glossary and decision records".

## Templates

Replace the words in angle brackets, carry the rest over as it is.

### Topic index — `00-index.md`

```markdown
# <Topic title>

> <the essence of the topic in one line>

## Cards

- [State](state.md) — topic phase and next step
- [Task](task.md) — what we build, for whom, and how we will know it worked
- [Requirements](requirements.md) — R1–R<N>
- [Decisions](decisions.md) — what was chosen, instead of what, and whose decision
- [Scope](scope.md) — what is out of scope, assumptions and open questions
```

### State — `state.md`

A title, a hook line and exactly three lines:

```markdown
# State of topic <topic>

> Topic phase and the step the next session starts from.

- **Phase:** <value> — YYYY-MM-DD
- **Journal:** journal/YYYY-MM.md, line of YYYY-MM-DD | none
- **Next step:** <one action that the next session will start from>
```

- **Phase** — `requirements written`, `requirements confirmed`, `plan written`, `plan confirmed`, `execution in progress` or `done`, with the date of the record. `sbrain` sets the first two: `requirements written` — when it writes the cards, `requirements confirmed` — after the user's "yes" to them.
- **Journal** — the file and the date of the chain's journal line.
- **Next step** — while the cards are not approved: the user reads the topic cards and answers whether we approve or edit. After their "yes": make a plan through `splan`.

### Requirements — `requirements.md`

```markdown
# Requirements of topic <topic>

> <what the requirements are about — in one line>

- R<N>. <a requirement by one of the five patterns>
```

Every requirement follows one of five patterns:

| Kind | Pattern | Example |
|---|---|---|
| always | `<who> <does what>` | "The shop shows the price together with the tax" |
| event | `When <event>, <who> <does what>` | "When a customer cancels an order, the shop returns the money to the same card" |
| state | `While <state>, <who> <does what>` | "While an order is not paid, the shop keeps the goods in reserve" |
| unwanted | `If <failure or prohibition>, then <who> <does what>` | "If a payment did not go through, then the shop leaves the basket as it was" |
| option | `Where <a condition that does not hold for every project>, <who> <does what>` | "Where there is delivery by courier, the shop offers to choose the hour of delivery" |

- **The pattern follows the condition.** The first pattern is only for what is always true. If a requirement has a condition, it stands at the start, by one of the other four.
- **The actor is named** — the one who does it: a script, a shop, a customer. The word "system" is not in a requirement.
- **Only new requirements.** The patterns apply to the requirements you are writing now. Do not rewrite old wordings carried over into cards to fit the patterns.

### Decision card — `decision-<name>.md`

```markdown
# <what is decided>

> <what was chosen and instead of what — in one line>

- **User's words:** «<the words of the user in English translation>» — YYYY-MM-DD
- **Reason:** <why exactly this was chosen>
- **Rejected:** <option> — <why not>
- **Status:** in force
- **Replaces:** none
```

Words of the user are given in English translation, close to the original, without retelling. "Rejected" — a line per option. "Status" — "in force", "superseded" or "withdrawn". "Replaces" — a link to the card of the decision whose place this one has taken, or `none`. How to write up a replacement — `references/wiki-rules.md`, section "Replacement and archive".

## Order of writing

1. **The topic cards** — by the layout and the templates above.
2. **The topic's line in `work/00-index.md`** — a link `[<topic>]` to `<topic>/00-index.md` and the essence of the topic.
3. **The topic's line in "In progress" of the root index** — with the phase `requirements written`; the form of the line is in `references/wiki-rules.md`, section "Composition". The phase and the next step in it are the same as in `state.md` and change together with them.
4. **A line in `rules.md`** — for every answer of the user that holds for the whole project and not for one topic; the form of the line is in the same place. The answer stays in the topic cards.
5. **The chain's journal line:** `- YYYY-MM-DD · [<topic>](../work/<topic>/00-index.md): <the goal in one phrase> — requirements written`. It is one for the whole chain `sbrain → splan → swork`: `swork` will replace the tail when the work is accepted. `sbrain` does not touch it again — neither when the cards are edited nor after the "yes" to them. The goal in one phrase is "what we build" from the summary, compressed to a phrase.
6. **The check script** — run it and fix what it names.

Set up the parts of the wiki that do not exist yet — `work/00-index.md`, `rules.md`, the journal file of the current month — by the "Composition" section of `references/wiki-rules.md` and name them in "Sections" of the root index.
