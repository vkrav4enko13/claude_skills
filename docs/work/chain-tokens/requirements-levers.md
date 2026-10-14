# Requirements of topic chain-tokens: levers

> Four groups of levers; which of them enter the work is decided by R11.

## Extra reading

- R12. A reviewer's task names every file the reviewer reads; a reviewer reads a skill file only where its task names it.
- R13. The main session of a skill reads at a stage only the reference files of that stage.
- R14. A session reads the wiki rules once, however many chain skills run in it.

## Repeated output

- R15. `splan` writes the plan overview after the plan review and its fixes, not before the review.
- R16. `splan` gives the user the detailed plan as one text — the overview file — and does not emit that text a second time: the chat gets a line per slice, the decisions, what is not agreed and the path to the file.
- R17. A script assembles the executor's packet from the topic cards; the main session of `swork` does not retype card text into a launch message.
- R18. While the user is away, `saway` skips what the three skills show to the user along the way; its final description stays full.
- R19. A subagent's reply carries only the fields that its reader uses.

## Second round

- R20. When a second round of a reviewer is due, the reviewer gets a task of its own that covers only what was fixed after the first round, instead of the full first-round task with a note.

## Session context

- R21. When `sbrain` or `splan` hands off with the result in the topic folder, the first option of the handoff menu starts the next skill in a new session and gives the command to paste; going on in the same session stays as the second option.
- R22. `saway` runs each stage of the chain from a clean context: in a stage subagent that stands in for the main session of the stage.
