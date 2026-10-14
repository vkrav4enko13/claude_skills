# Check lines of topic chain-tokens: pin and deletions

> Lines 17–21: the level pinned in the skills and the reply fields without a reader.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 17 | R2 | a session at `high` starts a skill pinned at `medium` → the requests of its first turn ran at `medium` | `bash tests/chain/trace.sh pin efforts` | a line `efforts first medium <n>`; no line `efforts first high` | S6 | green 2026-10-14 |
| 18 | R3 | the same run → every request of every subagent ran at `medium`, in the later turns too | `grep -c 'Subagents run at' sbrain/SKILL.md splan/SKILL.md swork/SKILL.md; bash tests/chain/trace.sh pin efforts` | three lines that end in `:1`; a line `efforts agents medium <n>` and no other `efforts agents` line | S6 | green 2026-10-14 |
| 19 | R4 | the executor of the `ready text` slice of stage `seed` → at `medium`, as any other executor | `jq -r .seed_first_agent_effort "$HOME/Documents/my/chain-stand/pin/1/metrics.json"` | `medium` | S6 | green 2026-10-14 |
| 20 | R23 | a blind reader walks eight scenarios on the texts before and after the deletion → the same actions | `tail -qn 1 "$HOME/Documents/my/chain-stand/fields/old/result.txt" "$HOME/Documents/my/chain-stand/fields/new/result.txt"` | `8 of 8 ok` twice | S7 | green 2026-10-14 |
| 21 | R19 | the executor's reply form → no `CHECK` field, which nobody reads | `grep -c '^CHECK:' swork/references/executor.md; true` | `0` | S7 | green 2026-10-14 |
