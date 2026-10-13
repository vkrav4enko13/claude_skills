# Check lines. Slicing

Read at step 4 — after the recon, before the slicing — and at step 5, when it is decided how the behaviour is checked.

## 4. Check lines

For a plan in cards, set up **check lines** before the slicing: at least one for every requirement. A line names the requirement, the scenario "condition → what should come out" and what it is checked with: a command with the expected result or, if the requirement cannot be checked with a command, the words `checked manually: <steps>`.

For a direct and a short plan no lines are set up: before the slicing decide where and with what the behaviour will be checked. The rules below are for any size.

- Take a way the project already has: tests, a script, a launch command, a database query, a manual scenario.
- Check as high up as possible — by the behaviour from outside, not by the structure inside. The fewer different check points, the better.
- At least one check is end-to-end: it checks the goal as a whole, by the path by which a person or the calling code uses the result. The slices may pass their checks separately and yet not fit together. It is owned by the slice after which the goal is reached. Take the goal from the confirmed goal of the topic — the goal phrase in the chain's journal line that `state.md` points to; for a task without a topic — from the user's words. The end-to-end line may be manual only if the user themselves decided to accept the result by eye.
- The project has no tests — do not invent them: a command with the expected result or a manual scenario serves as the check.
- The order "a failing test first" does not go into the plan. The check is part of the slice, but the plan does not prescribe how the executor gets to it.
- **Check focus — at this same step.** Before the slicing write out up to five failures or kinds of input that the requirements imply but no check line catches yet, and set up a check line for each. The count of lines that you name at step 6 is final: a line is added later only if the plan review found a requirement without a line — name that line when showing the plan.

## 5. Slicing

The work is divided into **slices**. A slice is a finished piece of behaviour that can be checked on its own.

- **From check lines.** In a plan in cards a slice is a group of check lines from step 4: every line belongs to exactly one slice, there is no slice without lines.
- **All the way through, not in layers.** A slice goes through all the layers its behaviour needs. "First the whole schema, then the whole server, then the whole interface" are not slices.
- **The first slice is the narrowest path from start to finish.** It proves that the parts connect; the others widen it.
- **Preparation first.** If the change becomes simpler after a rebuild of the code — the rebuild goes as a separate slice before those that need it, and does not change behaviour. Mark such a slice in the card: `no behavior change`.
- **A wide mechanical edit** (a rename, a type change across the whole code) is not cut the way a slice is. Its order: add the new next to the old → move the places of use over in batches → remove the old.
- **Size.** A slice must fit into one fresh session of the executor. Put setup, scaffolding and documentation into the slice whose result needs them. Split where one slice can be accepted and the neighbouring one rejected.
- **Dependencies.** Every slice names which slices must be done before it. Slices without shared dependencies can be executed in any order.
- **File map.** Before the slices write out which files are created and changed and what each is responsible for. Follow the structure of the project; rebuild what is nearby only where the goal needs it.
- **Ready-made code for every slice.** Distribute what the recon found among the slices — into the "Reuse" field of the slice card. Nothing was found for a slice — write where you searched into the field.

Nothing beyond the requirements: a slice that nobody asked for goes into "Not doing" or as a question to the user, not into the plan.
