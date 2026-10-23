# Plan format

Read at steps 7 and 9.

The executor has not seen the conversation or recon. Write what it cannot know: files, names and signatures, exact values, how each slice is checked; leave it the rest.

## Where the plan lies

Cards in the topic folder `work/<topic>/` of the project wiki; no separate plan file. Wiki location, limits, check script — `references/wiki-rules.md`. Paths are relative to the project root.

**There is no topic folder** — set up `00-index.md` and `state.md` by `references/topic-cards.md` of the `sbrain` skill; `<topic>` Latin, hyphenated; the index lists only existing cards. Never touch someone else's folder of that name: add `-2` to yours.

## Plan cards

| Card | What it carries |
|---|---|
| `plan.md` | Header: goal, "Checked against code", "Shared constraints", "Not doing", "Assumptions", "Deferred questions", discrepancy rule |
| `plan-decisions.md` | "Technical decisions" and "Check focus" |
| `plan-checks.md` | Check lines as a table |
| `plan-s<N>-<name>.md` | One card per slice |
| `plan-overview.md` | The whole plan as one file, for a person |

**A card** — title, hook, index line, splitting — by `references/wiki-rules.md`, sections "Card and limits" and "Check"; written under a claim (`references/agents-rules.md`); inner sections under `## …`. Splits: check lines by group into `plan-checks-<group>.md`, numbering continuous; `plan.md` into `plan-2.md`; `plan-s<N>-<name>.md` into `plan-s<N>-<name>-2.md` — the continuation of "What to do", titled `# S<N>. <title> — part 2`, no "Status" line.

No empty sections except "Check focus", where empty means "checked and found nothing", written so. In templates replace the angle-bracket words, copy the rest.

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

- **Shared constraints** — requirements for all slices (versions, platform, prohibitions, naming), a line each, values verbatim.
- **Not doing** — what the executor would "fix while at it": neighbouring flaws, generalizations, unasked rebuilds. Refer to "Out of scope" in `scope.md` or `scope-<part>.md`, do not copy it.
- **Assumptions** — all assumed without the user's confirmation, lifted blocking questions included, with the dependent slices.
- **Deferred questions** — only those whose answer changes neither slices, approach nor check; one the slicing depends on — ask it.
- **The discrepancy rule** — "If the code differs from the plan" — goes into every plan verbatim.

### Technical decisions and check focus — `plan-decisions.md`

```markdown
# Technical decisions of topic <topic>

> What the plan chose, instead of what and why; which failures and kinds of input it checks beyond the named ones.

## Technical decisions

- **<what was chosen>** — instead of <what>: <why>

## Check focus

- <condition> → <the behaviour a reasonable person expects> — S<N>, line <No.>
```

- **Technical decisions** — two or three sentences each, only `splan`'s own; a requirements value the executor needs goes in words into "Shared constraints" or the slice.
- **Check focus** — the step 4 lines, most likely first. Silence of the requirements never permits breaking on an input.

### Check lines — `plan-checks.md`

```markdown
# Check lines of topic <topic>

> How each requirement is checked: scenario, command, expected result and the owning slice.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 1 | R2 | <condition → what should come out> | `<command>` | <the output or the state that means success> | S1 | not run |
| 2 | R5 | <condition → what should come out> | checked manually: <steps> | <what to see> | S2 | not run |
```

- **No.** — continuous; slices refer to it.
- **Requirement** — its number(s); a "Check focus" line names the requirement implying its input; no requirements cards — "task"; an end-to-end line checking the plan's goal as a whole — the word "goal".
- **Scenario** — exact values in words, not requirement numbers: not "an error on wrong input" but "an empty name → a refusal with the text 'Enter a name'".
- **Command** — prints the result, no comparison inside (`swork` compares by "Expected"); else `checked manually: <steps>`.
- **Expected** — success output, verbatim or a part; manual — what to see.
- **Slice** — exactly one.
- **Result** — written by `swork`: `not run`, `green YYYY-MM-DD`, `red YYYY-MM-DD`, `awaiting manual check`, `not run: <reason>`. `splan` always writes `not run`.

### Slice — `plan-s<N>-<name>.md`

`<N>` — slice number; `<name>` — short, Latin, hyphenated: `plan-s1-login.md`.

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

- **Status is written by `swork`.** Values: `not started`, `done`, `awaiting manual check`, `not checked`, `bypassed`; `splan` writes `not started`.
- **The numbers are permanent.** Never reuse a removed number; a new slice takes the next.
- **Interfaces — exact.** The executor sees only its slice: neighbours' names and types come from here; a name differing between `S3` and `S7` is a plan error. In a shared file too, what a neighbour takes is in "gives" of the slice introducing it.
- **Files — verified.** Existing paths checked; new ones "create"; created earlier — "change: `path` (created in S<N>)": "create" in one slice only.
- **"What to do" — decisions, not a retelling.** "Add the needed check", "handle the edge cases", "write tests for this" decide nothing.
- **Every slice has check lines.** The card holds no scenarios or commands: "Checks" names the `plan-checks.md` lines with this slice in "Slice".
- **The irreversible — with a rollback.** Moving or deleting data, changing permissions or the schema: what to save and the restore command; saving is this slice's first step; both run as written — `swork` runs them without asking.
- **Reuse — verified.** Names exist at the paths; never empty: a list or "nothing to reuse — searched: …".
- **Marks — only where they apply.** `no behavior change` — a rebuild slice, green before the edits; `ready text` — "What to do" gives every edit verbatim. No mark — no line.

### Overview — `plan-overview.md`

For a person, never the executor: written after the cards, rewritten in full after every card edit. Prose in the user's language; numbers, statuses, field names, paths, commands as in the cards.

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

No size limit; lines at most 400 characters: wrap items onto an indented line, commands at `&&`.

## Order of writing

1. **The topic folder.** None — set it up by "Where the plan lies".
2. **The plan cards** — by the templates above.
3. **The overview** — `plan-overview.md` by "Overview"; its topic index line: `- [Plan overview](plan-overview.md) — the plan as one file; the source is the slice cards`.
4. **Lines in the topic index** — a line for every new card:

   ```markdown
   - [Plan](plan.md) — goal, shared constraints, what we do not do, and the discrepancy rule
   - [Technical decisions](plan-decisions.md) — what was chosen, instead of what, and the check focus
   - [Check lines](plan-checks.md) — lines 1–<last>: how each requirement is checked
   - [S<N>. <slice title>](plan-s<N>-<name>.md) — <what will start working>
   ```

5. **`state.md`** — the lines below.
6. **The topic's line in "In progress" of the root index** — phase `plan written`, forms in `references/wiki-rules.md`, section "Composition"; phase and next step always as in `state.md`.
7. **You set up the topic** — in `work/00-index.md` a link `[<topic>]` to `<topic>/00-index.md` with its essence; in the current month's journal the chain's line `- YYYY-MM-DD · [<topic>](../work/<topic>/00-index.md): <the goal in one phrase> — plan written`. A topic from `sbrain` has it already (one line for `sbrain → splan → swork`): do not touch it.
8. **The wiki check script** — run it and fix what it names: `references/wiki-rules.md`, section "Check".

The wiki or a part of it is missing — set it up by `references/wiki-rules.md`.

**The lines of `state.md` that `splan` writes:**

- **Phase** — `plan written` after the cards; `plan confirmed` after the user's "yes" to the plan; dated.
- **Journal** — from `sbrain`: untouched; you set up the topic: file and date of the chain's line.
- **Next step** — plan review (step 8); then the user reads the plan and answers whether we approve or edit; after "yes": execute the plan through `swork`. Stopped before writing — phase unchanged, only the step: what you wait for.

## Code in the plan

Code only where more exact than words:

- **signatures and types** — always;
- **checks with exact values** — with tests: test name and assertions;
- **an algorithm** — only if two reasonable ones give different scenario output;
- **text that the requirements fix verbatim** — messages, names, queries.

No function body that follows from signature and scenarios.

## Level of detail

No plan size limit. Measure: usefulness to the executor —

- **too little** — it must invent a behaviour, a name or a boundary;
- **too much** — code blocks take most of the plan.

## Working on the plan after it is written

- A later decision cancels an earlier one — fix in place, no layer on top.
- Slice status, check line results and "Progress log" are written by `swork`, never by the slice's executor.
- Nobody edits the goal, the constraints or "Not doing".
