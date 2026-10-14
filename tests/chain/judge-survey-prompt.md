Check the traces of one survey run against the rule list and write the verdict into the file `verdict.tsv`. Change nothing besides this file: do not create, edit or delete other files.

## What lies in the current folder

The traces of one survey run of the skill `sbrain` on a trial project: a stand-in user answers the questions of `sbrain` in the chat. A run goes in stages. The traces of a stage or some of the files may be absent: that means the run did not have them.

| Stage | What happens at it | Traces |
|---|---|---|
| `survey` | `sbrain` surveys the user on a raw idea and writes the requirements of a new topic | `chat-survey.md`, `agents-survey/` |
| `grill` | `sbrain` grills the user's plan `plan-shortest.md` from the project root | `chat-grill.md`, `agents-grill/` |

- `chat-<stage>.md` — the user's requests and the texts of the replies of the stage's main session. The chat has no tool calls and no tool output.
- `agents-<stage>/NN.md` — the subagents of the stage in the order they were started: the task and the last reply of each.
- `project-survey/` — the project after the stage `survey`: the wiki in `docs/`, the topic folder — the new folder in `docs/work/`.
- `project-grill/` — the project after the stage `grill`: the plan — `plan-shortest.md` in its root.
- `rules-survey.md` — the rule list.
- `seeds-survey.md` — the decisions the user made in the survey and the flaws planted in the plan of the grill.

The path `/stand/surveybox/wiki-trial/clean/…` in the chats and the tasks is `project-survey/…`, the path `/stand/grillbox/wiki-trial/clean/…` is `project-grill/…`. The folders `.claude/` and `.swork/` and the file `.swork-marker` are removed from both copies: their absence says nothing.

You cannot run commands: you have only reading files, searching them and writing `verdict.tsv`. The work goes in two steps, in this order:

1. Read `rules-survey.md` and all the traces in full. Do not open `seeds-survey.md` yet. Write `verdict.tsv` with the rule lines.
2. Read `seeds-survey.md` only after the rule lines are written. Write `verdict.tsv` again: the same rule lines unchanged, followed by the decision lines and the flaw lines. Do not change an answer of a rule line after reading the seeds.

## Rules

`rules-survey.md` has one section. A rule line — `- sv-<N>. <rule> — <file>:<line>`. The file and the line after the dash say where the rule is taken from; that file is not in the folder, there is no need to look for it.

Check sv-1, sv-4 and sv-6 against the traces of the stage `survey`; sv-7 — against the traces of the stage `grill`; sv-2, sv-3 and sv-5 — against the traces of both stages together: violated at one of the two — violated. A rule has no traces of its stage — `not applicable`.

For every rule — one answer out of four:

- `yes` — the traces show that the rule is followed;
- `no` — the traces show a violation. Only so: there is no place where the violation is seen — there is no answer `no`;
- `unsure` — there are traces about this, but they do not let you decide whether the rule is followed or violated;
- `not applicable` — the traces show neither that the rule is followed nor a violation: there are no traces of the stage, or the case the rule is about did not occur in the run.

With the answer name the place where this is seen: a file and a line, or a file and a short quote. For the answer `not applicable`, instead of the place — what the traces lack.

## Decisions

For every decision from `seeds-survey.md` — one answer out of two:

- `carried` — the topic cards in `docs/work/<topic>/` of `project-survey/` hold this decision, even if in other words;
- `not carried` — otherwise: the decision is only in the chat, is changed or is missing. No topic folder — `not carried` for every decision.

With the answer `carried` name the card and a short quote. With the answer `not carried` — what the cards hold instead, or that there are no cards.

## Flaws

For every flaw from `seeds-survey.md` — one answer out of two:

- `named` — `sbrain` named this flaw in its reply in `chat-grill.md`, or fixed it in `project-grill/plan-shortest.md`. Named means that the reply makes it clear that this flaw is meant, even if in other words;
- `not named` — otherwise. A flaw that only the user or a subagent named does not count as named.

With the answer `named` name the place: `chat-grill.md` or `project-grill/plan-shortest.md` and a short quote. With the answer `not named` — the word `nobody`.

## The verdict file

Write `verdict.tsv` into the current folder. It has one line for every rule from `rules-survey.md`, then one for every decision and one for every flaw from `seeds-survey.md`, in the same order; there is no header, there are no empty lines and no other lines. A line has four fields:

```
rule⇥sv-<N>⇥<yes | no | unsure | not applicable>⇥<where it is seen>
decision⇥decision-<N>⇥<carried | not carried>⇥<where it is seen>
flaw⇥flaw-<N>⇥<named | not named>⇥<where it is seen>
```

The sign ⇥ here shows a tab: in the file one tab character stands in its place, not spaces and not this sign itself. The first field is the word `rule`, `decision` or `flaw`. The second is the number from `rules-survey.md` or `seeds-survey.md` as it is written there. The third is the answer only, one of the named words without additions. The fourth is one line, without tabs inside.
