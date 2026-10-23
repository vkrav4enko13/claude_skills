# Summary, requirements cards and check

Read at step 7 — after the approaches and before anything is written.

## Summary before writing

The user's last chance to correct the whole; not a draft, not a retelling.

**First, to yourself,** sort into *Said* (stated or chosen), *Assumed* (your gap fillers) and *Out of scope* (considered, left out); not shown.

**Then show the summary** — as two people sum up a talk aloud:

1. **What we build** — 1–3 sentences. Always.
2. **Trade-offs** — choices the user would expect named; not the obvious or the alternative-free.
3. **What is out of scope** — only what the reader would ask "why is this missing?" about.
4. **What to look at** — unclosed forks: silent assumptions, consequences of combined answers, bets cheap to fix now and costly after the plan.

No empty sections. The already decided goes as "We keep: X instead of Y — the reason", not a question.

Rules:

- An item is one line, two at most.
- No names of files, tables, keys or error texts.
- Not "you said you want X" but "X means Y".
- No item that takes reading the code to judge.
- Sections 2–4 together: 2–4 items, up to 7 for a large task; more — merge.
- No questions beside the summary: ask one without a reasonable default first.

Consent menu: "Yes" — saying what follows (writing the cards, the design or the check) — "Fix", "Do nothing". Not on "Small" — see below.

**After a fix** — make it, show the summary again, wait for a "yes"; never write right after a fix. The same item corrected twice — ask: write it as it is or discuss further.

On "Small" the summary and the short design go in one message with one consent — the menu of step 8; with no question asked, the summary is one paragraph of "what we do".

## Where to write

- **"Probe" and "Small"** — the chat, no topic folder. Only a project-wide rule the user named goes into `rules.md`. The journal line is written by whoever makes the edit.
- **"Large"** — a topic folder `docs/work/<topic>/` by `references/topic-cards.md`: read it before writing.
- **"Grill"** — where the plan lies, by the path table of `SKILL.md`; an arbitrary file is edited, no new file beside it; the layout of `references/topic-cards.md` does not apply to a plan.

The wiki's place — `references/wiki-rules.md`; outside `docs/` the topic folder is `work/<topic>/` in it; no wiki — set it up by those rules. Someone else's folder of the same name stays untouched: add `-2` to yours. A resumed brainstorm edits its own topic folder.

## Sections

Sections and their cards — `references/topic-cards.md`.

**Only what was asked for.** The requirements, the decisions and the success criteria take what the user asked for or chose, and what it will not work without. An addition of your own that nobody named — an action log, a switch, a notification, an extra safeguard — write into "Out of scope" as deferred or into the open questions.

**A rule has one owner.** A check, threshold, limit or condition is written in full once, in a numbered requirement; other sections cite the number. A copy without a reference is a defect.

Write densely: decision first, one thought per sentence. Forks go to the open questions. A later decision cancelling an earlier one is fixed in place. File paths are relative to the project root.

## Checking claims

Check every claim about the project against the code before writing, preferably by a subagent that has not seen the conversation, started with the summary. Fix the refuted; the uncheckable is an assumption.

## Check before showing

Reread the written cards with fresh eyes and fix in place:

- **Complete** — no stubs, no "to be clarified later", no empty sections;
- **Consistent** — no contradictions, no rule written in full twice;
- **Focused** — one piece of work;
- **Fit for a plan** — the planner invents no behaviour, boundaries or criteria; no requirement reads two ways;
- **By the patterns** — every requirement fits one of the five patterns in `references/topic-cards.md`.

A fix that changes behaviour or scope — do not decide yourself, ask one question.

Then run `bash <skill folder>/scripts/check.sh <wiki folder>`, fix what it names, run it again.

Then name the full path to the topic folder and its phase — `requirements written` — ask the user to read the cards and wait for an answer. Fixes — make, reread, rerun the script. Do not commit to git until asked.

## Glossary and decision records

**The glossary** — after the cards are written, only if the project **already has** one (`GLOSSARY.md`, `CONCEPTS.md`): add or refine subject-area terms the conversation settled — not class names, paths or implementation decisions. No new glossary without a request.

**A full decision card** `decision-<name>.md` is written with the other cards only when all three hold: hard to undo; surprising without an explanation; real alternatives existed. Template — `references/topic-cards.md`. Other decisions are a line in `decisions.md`.
