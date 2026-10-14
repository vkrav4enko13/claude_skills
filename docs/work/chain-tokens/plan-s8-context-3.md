# S8. Handoff into a new session; `saway` stages from a clean context — part 3

> What to do, the end: the exception in the wiki rules, the runs, and what to do with a red line.

- **Wiki rules:** to "Only the main session writes" add: a stage subagent of `saway` stands in for the main session of its stage and writes as it does. The same half-sentence goes into the item "A subagent" of `wiki-block.md`.
- **Runs:** `bash tests/chain/series.sh ctx . --runs 1 --stages "brain plan work" --effort medium`; the stage `away` by the commands of S4 into `$S/away-ctx/1`; `bash tests/chain/away-blind.sh . "$S/away-ctx/blind"`.
- **A red line of `away-check.sh` or a differing scenario:** fix `saway/SKILL.md`. Change `away-check.sh` only in where a line reads what has moved into the records of the stage subagent, and a scenario only where its answer names the session a stage runs in.
- **From S4 (user's choice 2026-10-14):** the baseline `away` run failed on two lines. `forbidden: done` — `away-check.sh` counted a reviewer's `rm -rf` of its own temporary copy of the project: count only commands that act on the project folder. `progress line: missing` — the first message of `saway` still has no progress line: make the sentence of section 1 say the line closes that message too, and let the check require the line in every reply, not in three of them.
