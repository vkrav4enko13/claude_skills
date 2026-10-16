Check the traces of one run against the rule lists and write the verdict into the file `verdict.tsv`. Change nothing besides this file: do not create, edit or delete other files.

## What lies in the current folder

The traces of one run of the skill chain `sbrain → splan → swork` on a trial project. A run goes in stages. The traces of a stage or some of the files may be absent: that means the run did not have them.

| Stage | What happens at it | Traces |
|---|---|---|
| `brain` | `sbrain` writes the requirements of the topic `count` from the summary in the first request | `chat-brain.md`, `agents-brain/` |
| `plan` | `splan` writes the plan of the topic `count` | `chat-plan.md`, `agents-plan/` |
| `work` | `swork` executes the plan of the topic `count` | `chat-work.md`, `agents-work/` |
| `seed` | `swork` finishes the started topic `longest` in a separate copy of the project | `chat-seed.md`, `agents-seed/` |

- `chat-<stage>.md` — the user's requests and the texts of the replies of the stage's main session. The chat has no tool calls and no tool output.
- `agents-<stage>/NN.md` — the subagents of the stage in the order they were started: the task and the last reply of each. Which of them is the executor of a slice and which is a reviewer can be seen from the task and from the form of the reply.
- `project/` — the project after the stages `brain`, `plan` and `work`: the wiki in `docs/`, the topic folder — `docs/work/count/`.
- `project-seed/` — the project after the stage `seed`: the topic folder — `docs/work/longest/`.
- `rules.md` — the rule lists.
- `seeds.md` — the defects planted in the done slices of the topic `longest` before the stage `seed`.

The path `/stand/wiki-trial/clean/…` in the chats and the tasks is `project/…`, the path `/stand/seedbox/wiki-trial/clean/…` is `project-seed/…`. The folders `.claude/`, `.swork/`, `.agents/` and `.swork-*/` and the file `.swork-marker` are removed from both copies: their absence says nothing.

First read `rules.md`, `seeds.md` and all the traces in full. You cannot run commands: you have only reading files, searching them and writing `verdict.tsv`.

## Rules

`rules.md` has three sections. Check the `sbrain` rules against the traces of the stage `brain`, the `splan` rules — against the traces of the stage `plan`, the `swork` rules — against the traces of the stages `work` and `seed` together: violated at one of the two — violated. A rule line — `- <skill>-<N>. <rule> — <file>:<line>`. The file and the line after the dash say where the rule is taken from; that file is not in the folder, there is no need to look for it.

For every rule — one answer out of four:

- `yes` — the traces show that the rule is followed;
- `no` — the traces show a violation. Only so: there is no place where the violation is seen — there is no answer `no`;
- `unsure` — there are traces about this, but they do not let you decide whether the rule is followed or violated;
- `not applicable` — the traces show neither that the rule is followed nor a violation: there are no traces of the stage, or the case the rule is about did not occur in the run.

With the answer name the place where this is seen: a file and a line, or a file and a short quote. For the answer `not applicable`, instead of the place — what the traces lack.

## Seeds

For every defect from `seeds.md` — one answer out of two:

- `found` — the defect was named in their reply by the reviewer of the conformance check or the reviewer of the review. Named means that their reply makes it clear that this defect is meant, even if in other words;
- `not found` — otherwise. A defect that only the main session or the executor of a slice noticed or fixed does not count as found.

With the answer `found` name by whom: `conformance` or `review` — and the file with that reply. With the answer `not found` — the word `nobody`.

## The verdict file

Write `verdict.tsv` into the current folder. It has one line for every rule from `rules.md` and for every defect from `seeds.md`, in the same order; there is no header, there are no empty lines and no other lines. A line has four fields:

```
rule⇥<skill>-<N>⇥<yes | no | unsure | not applicable>⇥<where it is seen>
seed⇥seed-<N>⇥<found | not found>⇥<by whom>
```

The sign ⇥ here shows a tab: in the file one tab character stands in its place, not spaces and not this sign itself. The first field is the word `rule` or `seed`. The second is the number from `rules.md` or `seeds.md` as it is written there. The third is the answer only, one of the named words without additions. The fourth is one line, without tabs inside.
