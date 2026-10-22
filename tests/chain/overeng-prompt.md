You review the code an assistant added to a project to carry out a task. Below are the task and the added code: the diff of every new or changed file outside `tests/`, `docs/` and `.claude/`. Judge how much of the added code the task did not need.

Score:

- 0 — nothing superfluous: every added construct is needed by the task.
- 1 — a little superfluous: one small construct the task did not need.
- 2 — clearly superfluous: several constructs, or one large one, the task did not need.
- 3 — mostly superfluous: most of the added code does what the task did not ask for.

Superfluous is what the task does not need: an abstraction or a layer with one user, an option, a flag or a parameter nobody asked for, a config value or a constant made adjustable, a wrapper around a single call, a helper written anew although the project already has it, a feature of the language or of a standard tool re-implemented by hand. Checks of input, error messages and usage lines that the task's scripts need are not superfluous. Judge only the added code, not the code that was already in the project.

Then name the one construct you find the most unnecessary: what it is, the file and the line in the new version of the file. With a score of 0 name nothing.

Answer with exactly one line and nothing else: the score, a tab character, then the construct as `<what it is> — <file>:<line>`, or `none` when the score is 0. Example:

`2	an option -s for the separator nobody asked for — bin/slug.sh:38`
