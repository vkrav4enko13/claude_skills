# Check lines. Slicing

Read at steps 4 and 5.

## 4. Check lines

A plan in cards: before slicing set up **check lines**, at least one per requirement; a line may name several requirements that one command checks. A line: the requirement, the scenario "condition → what should come out", and a command with the expected result or `checked manually: <steps>`.

Direct and short: no lines; decide before slicing where and with what behaviour is checked. Below holds for any size.

- Use a way the project has: tests, a script, a launch command, a database query, a manual scenario.
- Check outside behaviour, not inner structure; fewer check points is better.
- At least one check is end-to-end: the goal as a whole, by the path a person or calling code uses, owned by the slice that reaches it. The goal: the goal phrase of the chain's journal line `state.md` points to; wiki not kept — "In brief" of `task.md`; no topic — the user's words. Manual only if the user chose to accept by eye.
- The project has no tests — do not invent them: a command with the expected result or a manual scenario is the check.
- "A failing test first" stays out of the plan.
- **Check focus — at this same step.** Write out up to five failures or kinds of input the requirements imply and no line catches; a check line for each. The count named at step 6 is final: a line is added later only if review finds a requirement without one — name it when showing the plan.

## 5. Slicing

A **slice** is a finished piece of behaviour checkable on its own.

- **From check lines.** In cards a slice groups check lines: every line in exactly one slice, no slice without lines.
- **All the way through, not in layers.** "Whole schema, then whole server, then whole interface" are not slices.
- **The first slice is the narrowest path from start to finish.** The others widen it.
- **Preparation first.** A simplifying rebuild is its own earlier slice, marked `no behavior change`.
- **A wide mechanical edit** (a rename, a type change across the code): add the new next to the old → move the uses in batches → remove the old.
- **Size.** One fresh executor session per slice. Setup, scaffolding, docs go with the slice whose result needs them. Split where one part can be accepted and the other rejected.
- **Dependencies.** Every slice names the slices needed before it; independent slices run in any order.
- **File map.** First list the files created and changed and what each does. Follow the project structure; rebuild nearby only where the goal needs it.
- **Ready-made code for every slice.** Recon finds go into each slice's "Reuse"; none — where you searched.

Nothing beyond the requirements: an unasked slice goes to "Not doing" or a question, not the plan.
