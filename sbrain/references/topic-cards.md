# Topic cards

Read at step 7, after the confirmed summary, before writing the "Large" result, and at step 8, when the cards are approved.

The "Large" result is a topic folder `work/<topic>/` in the wiki, by default `docs/work/<topic>/`; `<topic>` in Latin letters, hyphenated. The wiki itself — `references/wiki-rules.md`.

## What goes where

| Section of the result | Card | What it carries |
|---|---|---|
| In brief | `task.md` | "What we build" from the summary |
| Task | `task.md` | The problem through the user's eyes: what is wrong, for whom; not "In brief" reworded |
| Success criteria | `task.md` | How we will know it worked |
| Requirements | `requirements.md` | Lines `- R<N>. …`, each checkable, an intention plus at most one refinement; numbers continuous in summary order; subjects grouped under short headings |
| Acceptance examples | `examples.md` | Case, what happened, what should come out, "checks R4". Only for condition-dependent behaviour |
| Design | `design.md` | The sections of step 6 as approved. Only if step 6 ran |
| Decisions made | `decisions.md` | A line per decision (form below) |
| Out of scope | `scope.md` | The deferred and the deliberately not done |
| Assumptions and open questions | `scope.md` | All unconfirmed; questions that block planning marked |

Every topic has six cards: `00-index.md`, `state.md`, `task.md`, `requirements.md`, `decisions.md`, `scope.md`. `examples.md`, `design.md`, `decision-<name>.md` — only when there is content.

**A card** — title, hook, index line, splitting — by `references/wiki-rules.md`, sections "Card and limits" and "Check"; written under a claim — `references/agents-rules.md`. Sections inside go under `## …`. Requirement groups may split into `requirements-<group>.md`, numbering continuous.

**Decisions.** A line of `decisions.md`: `- <what was chosen>, instead of <what> — <why>; <whose decision>; <status>`. Never omit "instead of" and "why": no alternative — `instead of nothing — the only option named`; no reason given — the one the choice follows from. Holds the summary's trade-offs and the assumptions the user agreed with. Whose: "user chose" (among the options or against the proposal) or "agreed" (you proposed with the price, they accepted); an unanswered proposal is an assumption for `scope.md`. Status: "in force", "superseded" or "withdrawn". A full card — `references/synthesis.md`, section "Glossary and decision records".

## Templates

Replace the words in angle brackets, keep the rest.

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

- **Phase** — `requirements written`, `requirements confirmed`, `plan written`, `plan confirmed`, `execution in progress` or `done`, with the date. `sbrain` sets the first two: `requirements written` when it writes the cards, `requirements confirmed` after the user's "yes" to them.
- **Journal** — file and date of the chain's journal line.
- **Next step** — before approval: the user reads the topic cards and answers whether we approve or edit. After their "yes": make a plan through `splan`.

### Requirements — `requirements.md`

```markdown
# Requirements of topic <topic>

> <what the requirements are about — in one line>

- R<N>. <a requirement by one of the five patterns>
```

Every requirement follows one of five patterns:

| Kind | Pattern | Example |
|---|---|---|
| always | `<who> <does what>` | "The shop shows the price with tax" |
| event | `When <event>, <who> <does what>` | "When a customer cancels an order, the shop refunds the card" |
| state | `While <state>, <who> <does what>` | "While an order is unpaid, the shop reserves the goods" |
| unwanted | `If <failure or prohibition>, then <who> <does what>` | "If a payment fails, then the shop keeps the basket" |
| option | `Where <a condition that does not hold for every project>, <who> <does what>` | "Where courier delivery exists, the shop offers a delivery hour" |

- **The pattern follows the condition.** The first pattern only for what is always true; a condition stands at the start, by one of the other four.
- **The actor is named** — a script, a shop, a customer. No word "system" in a requirement.
- **Only new requirements.** The patterns apply to what you write now; do not rewrite old wordings carried into cards.

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

User's words translated closely, not retold. "Rejected" — a line per option. "Status" — as in `decisions.md`. "Replaces" — a link to the replaced card, or `none` (`references/wiki-rules.md`, section "Replacement and archive").

## Order of writing

1. **The topic cards** — by the layout and templates above.
2. **The topic's line in `work/00-index.md`** — a link `[<topic>]` to `<topic>/00-index.md` and the essence of the topic.
3. **The topic's line in "In progress" of the root index** — phase `requirements written`, form in `references/wiki-rules.md`, section "Composition"; phase and next step match `state.md`.
4. **A line in `rules.md`** — per user answer that holds for the whole project; form in the same place; it stays in the cards too.
5. **The chain's journal line:** `- YYYY-MM-DD · [<topic>](../work/<topic>/00-index.md): <the goal in one phrase> — requirements written`. One for the chain `sbrain → splan → swork`; `swork` replaces the tail on acceptance. `sbrain` never touches it again, not on edits, not after the "yes". The goal — "what we build" in one phrase.
6. **The check script** — run it, fix what it names.

Set up missing `work/00-index.md`, `rules.md`, the current month's journal file by the "Composition" section of `references/wiki-rules.md`; name them in "Sections" of the root index.
