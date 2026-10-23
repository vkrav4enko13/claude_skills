# Modes of several agents

Read at step 2 and before each slice while `agents.sh mode` is not `off`, a small change too. Claims — `references/agents-rules.md`.

## Mode

Run `agents.sh mode` at those points and record:

- `off` — one agent, this file unused; `mode: off`.
- `shared` — shared mode below; `mode: shared — the mode file says shared`.
- `auto` or `worktree` — `references/worktree.md`, "Mode".
- **The mode was `off` and is now on** — shared mode from this slice on, never a worktree; `mode: shared — switched on during the work`.

## Shared mode

One project folder for all agents.

- **(a) Claims of the main session.** Only the slice card, and `<topic folder>/.stage` for stages 5–7; never the slice "Files".
- **(b) At the start of each step** — `touch <snapshot>/agents/<id>/step`; note the line count of `.agents/log.tsv`.
- **(c) The executor message** gets `AGENTS=<full path of this skill's agents.sh> TOPIC=<topic> SLICE=S<N>`: it claims each file right before writing it (rule 11 of its task).
- **(d) Checks** run in the project root.
- **(e) After a green step** — `python3 -I <swork>/scripts/dups.py <root> <paths>`, paths = field 6 of this agent's `.agents/log.tsv` lines past the noted count. Real — keep the pre-step version, remove this agent's, reroute its calls, rerun the check. False — a report line.
- **(f) A red check** — `agents.sh others --since <snapshot>/agents/<id>/step --topic <topic>`. A listed path held by another live agent (`busy`) — `wait`, then rerun; no longer held — rerun at once. Not an attempt; record `S<N> [<name>]: rerun after <name> released`, name it in the report. Red again — this agent's failure: attempts by `references/slices.md`, step 6.
- **(g) A bypass** never restores from `base/`. The slice's diffs: this agent's `.agents/log.tsv` lines whose essence (field 8) starts `S<N>:`. Claim each file, reverse its diffs newest first by `patch -R` on a copy, as `references/report.md` says for a shared file in "roll back everything"; delete a created file left empty; then `done`.

## Switch

On and off — `references/agents-rules.md`, "Switch". `agents.sh off --if-last` runs before any report, which names its outcome.
