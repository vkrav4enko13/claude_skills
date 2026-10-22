# Modes of several agents

Read at step 2 and before each slice while `agents.sh mode` is not `off`; a small change reads it the same way. The claim rule itself is in `references/agents-rules.md`.

## Mode

At step 2 and again before each slice run `agents.sh mode` and record the outcome in "Progress log":

- `off` — a single agent, as without this file; record `mode: off`.
- `shared` — the shared mode below; record `mode: shared — the mode file says shared`.
- `auto` or `worktree` — `references/worktree.md`: its `wt` gives the worktree, or code 5, whose line `shared: <reason>` goes into the record `mode: shared — <reason>`, and the shared mode below.
- **The mode was `off` and is now on** — the session started without it: the shared mode from this slice on, never a worktree; record `mode: shared — switched on during the work`.

The report names the mode with its reason: `references/report.md`, "Mode".

## Shared mode

Agents write into one project folder; the executor claims each file only for its write.

- **(a) Claims of the main session.** Claim only the slice card — and `<topic folder>/.stage` for stages 5–7 — never the files of the slice "Files".
- **(b) At the start of each step** — `touch <snapshot>/agents/<id>/step` and note the number of lines of `.agents/log.tsv`.
- **(c) The executor message** gets the line `AGENTS=<full path of this skill's agents.sh> TOPIC=<topic> SLICE=S<N>`: the executor claims each file right before its write — rule 11 of its task.
- **(d) Checks** run in the project root as always.
- **(e) After a green step** — `python3 -I <swork>/scripts/dups.py <root> <paths>`, the paths being field 6 of this agent's lines of `.agents/log.tsv` past the noted number. A real candidate — keep the version that was in the project before this step, remove this agent's own, reroute its calls to the kept one and run the check again. A false one — a line in the report.
- **(f) A red check** — `agents.sh others --since <snapshot>/agents/<id>/step --topic <topic>`. It lists paths: for those another live agent holds (`busy`), `wait` on them, then run the check once more; a path listed but no longer held — run the check once more at once. Such a rerun is not an attempt; record it as `S<N> [<name>]: rerun after <name> released`, and the report names it. Red again — the failure is this agent's own: the usual attempts of `references/slices.md`, step 6.
- **(g) A bypass** never restores from `base/`. The slice's own diffs are this agent's `.agents/log.tsv` lines whose essence (field 8) starts with `S<N>:`. Claim each such file for the write and reverse those diffs of it, newest first, with `patch -R` on a copy, as `references/report.md` says for a shared file in "roll back everything"; a file the slice created and that ends empty is deleted. Then `done`.

## Switch

When the mode is switched on and off — `references/agents-rules.md`, "Switch". The order at the end: `agents.sh off --if-last` before the full report and before the short report, its outcome named in the report.
