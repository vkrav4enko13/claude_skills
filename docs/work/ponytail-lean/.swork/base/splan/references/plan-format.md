# Plan format

Read at step 7 — after the agreed slicing and before the plan is written — and at step 9, when the user has approved the plan.

The plan is read by an executor that has seen neither the conversation nor the recon. It can write code in the project's language and will itself make a reasonable choice wherever the plan left the choice to it. What it cannot know is what you decided: which files, which names and signatures, which exact values from the requirements, how each slice is checked. Write exactly that down.

## Where the plan lies

In the topic folder `work/<topic>/` of the project wiki, next to the requirements cards. The plan is cards; there is no separate plan file. Where the wiki is, the limits of a card and of an index, the check script — in `references/wiki-rules.md`; here is only what the plan adds. Paths inside the plan are relative to the project root.

**There is no topic folder** — a task without a topic, the size "Cards". Set it up yourself: `00-index.md` and `state.md` by the templates from `references/topic-cards.md` of the `sbrain` skill; `<topic>` is in Latin letters, hyphenated. The topic index holds lines only for the cards that exist. Do not touch someone else's folder with the same name: add `-2` to the name of yours.

## Plan cards

| Card | What it carries |
|---|---|
| `plan.md` | The header: the goal, "Checked against code", "Shared constraints", "Not doing", "Assumptions", "Deferred questions", the discrepancy rule |
| `plan-decisions.md` | "Technical decisions" and "Check focus" |
| `plan-checks.md` | The check lines — as a table |
| `plan-s<N>-<name>.md` | A slice: a card for each |
| `plan-overview.md` | The overview: the same plan as one file, for a person |

**A card** — the title, the hook line, the line in the index and the splitting of an overgrown card — by `references/wiki-rules.md`, sections "Card and limits" and "Check"; a card is written under a claim — `references/agents-rules.md`. The sections inside a card go under `## …` headings. Check lines are split by groups — `plan-checks-<group>.md`, the numbering stays continuous. An overgrown header is split into `plan.md` and `plan-2.md`, a slice card — into `plan-s<N>-<name>.md` and `plan-s<N>-<name>-2.md`: the slice fields stay in the first part, the continuation of "What to do" goes into the second; the title of the part is `# S<N>. <title> — part 2`, it has no "Status" line.

Do not write an empty section, except "Check focus": there emptiness means "checked and found nothing" and is written down just so.

In the templates replace the words in angle brackets, carry the rest over as it is.

### Header — `plan.md`

```markdown
# Plan of topic <topic>

> Plan header: goal, shared constraints, what we do not do, and the rule for the executor.

- **Goal:** <the confirmed goal of the topic in one phrase; for a task without a topic — what will come out>
- **Requirements:** <the requirements cards of this topic; if there are none — the task in the user's words>
- **Checked against code:** <the commit and the branch; if the project is not under git — the date and time of the check>
- **Execution:** slices in dependency order; the discrepancy rule is at the end of the card

## Shared constraints

- <constraint>

## Not doing

- <what the executor does not touch>

## Assumptions

- <what is assumed> — slices: S<N>, S<M> | all

## Deferred questions

- <question> — <who will answer and when>; until answered: <what is assumed>

## If the code differs from the plan

Stop and report: **expected** — what the plan says; **found** — what is in the code, with the path;
**why it matters** — what fails to line up because of it. Do not silently bend the code to the plan or the plan to the code.
Report a minor discrepancy too (a file moved, a name changed, the meaning is the same): the slice card is fixed by `swork`, not by you.
```

- **Shared constraints** — the requirements that apply to all slices: versions, the platform, prohibitions, naming rules. A line for each, the exact values copied from the requirements verbatim. Every slice implies them.
- **Not doing** — what the executor will think "I will fix it while I am at it" about: neighbouring flaws, generalizations, a rebuild that nobody asked for. Do not copy "Out of scope" from the topic's `scope.md` or from its part `scope-<part>.md` here — refer to that card.
- **Assumptions** — everything the plan assumed without the user's confirmation, including the blocking questions that the user lifted. A line for each: what is assumed and which slices depend on it.
- **Deferred questions** — only questions whose answer does not change the slices, the approach or the check. A line for each: the question, who will answer and when, what is assumed until the answer. A question that the slicing depends on cannot stay in the plan — ask it.
- **The discrepancy rule** — the section "If the code differs from the plan" — is written into every plan verbatim.

### Technical decisions and check focus — `plan-decisions.md`

```markdown
# Technical decisions of topic <topic>

> What the plan chose, instead of what and why; which failures and kinds of input it checks beyond the named ones.

## Technical decisions

- **<what was chosen>** — instead of <what>: <why>

## Check focus

- <condition> → <the behaviour a reasonable person expects> — S<N>, line <No.>
```

- **Technical decisions** — what was chosen, instead of what and why, two or three sentences each. Only the decisions that `splan` made: do not repeat what is decided in the requirements. Write a value from the requirements that the executor needs in words in "Shared constraints" or in the slice.
- **Check focus** — up to five failures or kinds of input that the requirements imply but no check line catches yet — in order of likelihood. A line for each: the condition and the behaviour a reasonable person expects. The requirements' silence about an input does not permit the program to break on it. Assign to every line the slice that owns this code, and set up a check line for that line. These lines were set up back at step 4, before the stop before writing: here they are only written down.

### Check lines — `plan-checks.md`

```markdown
# Check lines of topic <topic>

> How each requirement is checked: scenario, command, expected result and the owning slice.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 1 | R2 | <condition → what should come out> | `<command>` | <the output or the state that means success> | S1 | not run |
| 2 | R5 | <condition → what should come out> | checked manually: <steps> | <what to see> | S2 | not run |
```

- **No.** — the continuous number of the line. The slices and the executor refer to it.
- **Requirement** — the number of the requirement that the line checks. A line from "Check focus" names the requirement that implies its input. For a topic without requirements cards the column holds the word "task". For an end-to-end line that checks the goal of the plan as a whole — the word "goal".
- **Scenario** — "condition → what should come out", with the exact values from the requirements. Not "an error on wrong input" but "an empty name → a refusal with the text 'Enter a name'": write the value in words, not as a reference to the requirement number — the executor does not get the requirements cards.
- **Command** — a command that prints the result of the scenario; do not write a comparison with the expected result into it: `swork` makes the comparison by the "Expected" column. If the scenario cannot be checked with a command — the words `checked manually: <steps>`.
- **Expected** — the command output that means success, verbatim or a part of it; for a manual line — what to see.
- **Slice** — the slice the line belongs to: exactly one.
- **Result** — written by `swork`: `not run`, `green YYYY-MM-DD`, `red YYYY-MM-DD`, `awaiting manual check`, `not run: <reason>`, `not checked: <reason>`. `splan` always writes `not run`.

### Slice — `plan-s<N>-<name>.md`

`<N>` is the slice number; `<name>` is short, in Latin letters, hyphenated: `plan-s1-login.md`.

```markdown
# S<N>. <Slice title>

> <what will start working — in one phrase, from the user's point of view>

- **Status:** not started
- **Covers:** R2, R5
- **Depends on:** none | S1, S3
- **Marks:** no behavior change; ready text
- **Files:**
  - create: `path/to/file`
  - change: `path/to/file` (<function or area>)
- **Interfaces:**
  - takes: <what it uses from the slices already done — exact names and signatures>
  - gives: <what the next slices rely on — names, parameters, result types>
- **Reuse:** <the name, the signature and the file of every ready-made piece: a function, a class or a script> | nothing to reuse — searched: <the folders and the search words>
- **What to do:** <the decisions the executor will not make itself: the approach, the exact values, the place in the code, the example in the project to follow>
- **Checks:** lines 1, 2
- **Rollback:** <what to save before the start and how to bring it back> — only for a slice with an irreversible action
```

Slice rules:

- **Status is written by `swork`.** The values: `not started`, `done`, `awaiting manual check`, `not checked`, `bypassed`. `splan` always writes `not started`.
- **The numbers are permanent.** A slice is removed — its number is not reused; one is added — it gets the next number. Other slices and the executor refer to the numbers.
- **Interfaces — exact.** The executor of a slice can see only its own slice; from this block it learns the names and the types of the neighbours. A function named one way in `S3` and another way in `S7` is a plan error. This holds also when the slices edit one file — one script or one text: the name of a function, a variable, a key or a section that a neighbouring slice takes is named in "gives" of the slice that introduces it.
- **Files — verified.** The path to an existing file is checked against the code. A new file does not exist yet — it is marked just so: "create". A file is created by an earlier slice — write "change: `path` (created in S<N>)": a file has "create" in only one slice.
- **"What to do" — decisions, not a retelling.** From every line the executor must write exactly one reasonable thing. "Add the needed check", "handle the edge cases", "write tests for this" are lines that decide nothing.
- **Every slice has check lines.** The slice card has no scenarios and no commands: they lie as lines in `plan-checks.md`, and "Checks" names the numbers of the lines that have this slice in the "Slice" column. A slice that there is nothing to check with is not a slice: merge it with the one where checkable behaviour appears.
- **The irreversible — with a rollback.** A slice that moves or deletes data, changes permissions or the schema names what to save before the start and which command brings the earlier state back. The saving is the first step of that same slice, not a separate slice. The saving and the restore command are runnable as written: `swork` runs them without asking.
- **Reuse — verified.** Every name named is in the code at the named path. The field is never empty: either a list or "nothing to reuse — searched: …".
- **Marks — only where they apply.** `no behavior change` — for a rebuild slice: its checks are green even before the edits. No mark — no line. `ready text` — for a slice whose "What to do" gives the text of every edit verbatim.

### Overview — `plan-overview.md`

The same plan as one file, for a person. It is written after the cards and is rewritten in full after every edit of the plan cards. The source is the slice cards: where they differ, the card is right. The overview is not passed to the executor. Write the prose of the overview in the language of the user; slice numbers, statuses, field names, paths and commands stay exactly as in the slice cards.

````markdown
# Plan overview of topic <topic>

> The plan as one file for reading; the source is the slice cards: where they differ, the card is right.

- **Goal:** <the goal from `plan.md`>

## S<N>. <title> — <status>

<what will start working>

- **Files:** <create and change>
- **Depends on:** <slices | none>
- **Steps:** <the items of "What to do", each on a new line>
- **Checks:** line <No.> — <scenario>; expected: <expected>

  ```
  <command>
  ```

## Technical decisions

## Not doing

## Not agreed
````

The overview has no limit on the number of lines or on the total size; a line is at most 400 characters: wrap a long item onto the next line with an indent, a long command — onto new lines of the block at `&&`.

## Order of writing

1. **The topic folder.** If there is none — set it up by the section "Where the plan lies".
2. **The plan cards** — by the templates above.
3. **The overview** — `plan-overview.md` by the section "Overview"; the line in the topic index: `- [Plan overview](plan-overview.md) — the plan as one file; the source is the slice cards`.
4. **Lines in the topic index** — a line for every new card:

   ```markdown
   - [Plan](plan.md) — goal, shared constraints, what we do not do, and the discrepancy rule
   - [Technical decisions](plan-decisions.md) — what was chosen, instead of what, and the check focus
   - [Check lines](plan-checks.md) — lines 1–<last>: how each requirement is checked
   - [S<N>. <slice title>](plan-s<N>-<name>.md) — <what will start working>
   ```

5. **`state.md`** — the phase `plan written` and the next step; what `splan` writes into each line is below.
6. **The topic's line in "In progress" of the root index** — with the phase `plan written`; the forms of the index lines are in `references/wiki-rules.md`, section "Composition". The phase and the next step in it are the same as in `state.md` and change together with them.
7. **You set up the topic** — two more lines. In `work/00-index.md` — the topic's line: a link `[<topic>]` to `<topic>/00-index.md` and the essence of the topic. In the journal of the current month — the chain's line: `- YYYY-MM-DD · [<topic>](../work/<topic>/00-index.md): <the goal in one phrase> — plan written`. A topic from `sbrain` already has the chain's line: it is one for the whole chain `sbrain → splan → swork`, do not touch it.
8. **The wiki check script** — run it and fix what it names: `references/wiki-rules.md`, section "Check".

If the wiki or a part of it does not exist yet — set it up by `references/wiki-rules.md`.

**The lines of `state.md` that `splan` writes:**

- **Phase** — `plan written` when the plan cards are written; `plan confirmed` — after the user's "yes" to the plan. With the date of the record.
- **Journal** — for a topic from `sbrain` do not touch it; if you set up the topic — the file and the date of the chain's line that you opened.
- **Next step** — after the cards are written: independent plan review; after it: the user reads the plan and answers whether we approve or edit. After their "yes": execute the plan through `swork`. If you stopped before you wrote the plan — do not change the phase, write only the step: what you are waiting for from the user.

## Code in the plan

The plan is not a program. Code is allowed where it is more exact than words:

- **signatures and types** — always;
- **checks with exact values** — in a project that has tests: the name of the test and its assertions;
- **an algorithm** — only when the result of the scenarios depends on its choice: two reasonable algorithms would give different output on them; otherwise the executor chooses it;
- **text that the requirements fix verbatim** — messages, names, queries.

A function body that follows unambiguously from the signature and the scenarios does not go into the plan: the executor will write it.

## Level of detail

The plan has no size limit: a big piece of work gets a big plan. A card has a limit: an overgrown one is split. There is one measure — usefulness to the executor. Two signs that the measure is broken:

- **too little** — the executor will have to invent a behaviour, a name or a boundary;
- **too much** — code blocks take up most of the plan, that is, the program is already written in it.

## Working on the plan after it is written

- A later decision cancelled an earlier one — fix it in place, do not add a layer on top.
- The slice status, the result of a check line and "Progress log" are written by `swork`, not by the executor of the slice; nobody edits the goal, the constraints or "Not doing".
