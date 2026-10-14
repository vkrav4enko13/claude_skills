# Rule lists for checking the traces of a survey run

> A rule is one statement that can be seen in the traces of a survey run: in the chat, in the tasks and replies of subagents, in the topic cards, in the project files.

A rule line: the number, the rule itself and, after the dash, the place in the skill text it is taken from: the file and the line.

## sbrain survey

- sv-1. Before the first question `sbrain` names a hypothesis about the task with a confidence percentage — sbrain/references/context.md:38
- sv-2. Every question has a recommendation, an open question included — sbrain/references/survey.md:24
- sv-3. A round has at most four questions — sbrain/references/survey.md:13
- sv-4. From the second round on, before the questions, there is the tree counter line: decisions closed, asked now, waiting, and the confidence percentage — sbrain/references/survey.md:22
- sv-5. No question asks what can be found in the project files or the wiki — sbrain/references/context.md:29
- sv-6. No requirement, decision or success criterion that nobody named has got into the topic cards — sbrain/references/synthesis.md:51
- sv-7. On the grill, the plan's statements about the project are checked against the code before the questions, and a discrepancy is named at once — sbrain/references/survey.md:11
