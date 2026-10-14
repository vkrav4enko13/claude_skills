# Design of topic chain-tokens: levers and proof

> Sections 3 and 4 as approved on 2026-10-13.

## 3. Levers

**What the user gets:** less reading, less repeated writing, a shorter context — with the same checks.

- **Extra reading.** Reviewer tasks name what to read and give no reason to read skill files. A stage loads only its own reference files. The wiki rules — one copy per session.
- **Repeated output.** The plan overview is written once, after the plan review; the detailed show stays in one copy. A script assembles the executor's packet. `saway` does not show to an absent user along the way; its final description stays full (corrected by the user on 2026-10-13: was "refers to the report instead of retelling it"). Reply fields without a reader are removed.
- **Second round.** A repeat reviewer looks only at what changed after the first.
- **Context.** The first option of the handoff menu is to start the next skill in a clean session, with a ready command. `saway` runs each stage from a clean context.
- Not touched: the earlier protections, the trap tables, the set of reviewers, the model.

## 4. Proof and result

**What the user gets:** a saving number and a quality confirmation for each batch of edits.

- Pure deletions go as one batch and are checked by a blind reading.
- Behaviour edits go in batches by group; each batch gets a stand series against the baseline. A batch that fails the gate is reverted whole.
- The stand cannot measure the "context" lever: there every stage is a separate session already. It is checked by a run reaching the menu with the new option and the next skill starting from the cards alone.
- Result: output tokens per run at least 10 % below the baseline series, quality not worse than `en`. The report gives two numbers — against the baseline at `medium` and against `en` at `xhigh` — and the input side: cache write and read per run.
- **If 10 % is not reached:** the topic closes with the achieved number and an honest mark "threshold not met"; the edits that passed the gate stay.
- Cost of measuring: a baseline series, a series per behaviour batch, a final one. What a series at `medium` costs is unknown until the first; a series at `xhigh` cost 1.19M output tokens.
