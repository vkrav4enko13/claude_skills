# Requirements of topic chain-tokens: effort, gate and map

> The effort level of every role, the quality gate that guards it, and the cost map that ranks the levers.

## Effort

- R1. The stand runs the chain sessions of a series at the effort level named for that series; the judge always runs at `xhigh`.
- R2. Each of the four skills pins effort `medium` for the turn it is started in; in the later turns its main session runs at the session level, which the profile settings hold at `medium`.
- R3. Each subagent launched by a chain skill runs at `medium`.
- R4. `swork` launches the executor of a `ready text` slice at the same level as any other executor.

## Quality gate

- R5. The stand holds a baseline series `medium`: three runs at `medium` on the skill texts as they stood before the other edits of this topic, with only the text fixes of R7.
- R6. The quality gate passes a series only when every stage of every run is completed, the judge marks all five seeds found in every run, and `verdict.sh quality` against series `en` passes.
- R7. If a series fails the quality gate, then the skill texts behind the violated rules are fixed and the series is rerun, at most twice; no role is raised above `medium`. (Was: the failed role runs at `high`, then `xhigh` — superseded 2026-10-14 by the user.)
- R8. While no series with an edit has passed the quality gate, that edit is not installed into the Mac profiles.

## Cost map

- R9. The stand has a trace tool in `tests/` that prints, for a series, output tokens by stage, role and kind — thinking, text, tool arguments — and input by cache write and cache read.
- R10. When the baseline series has passed the gate, the trace tool's map of that series ranks the levers R12–R22 by tokens saved per run.
- R11. A lever enters the work when it deletes a duplicate or dead text, or when its expected saving on the baseline map is at least 3 % of output tokens per run; if it is smaller, then it goes to "Deferred" of the root index with its number. R21 and R22 enter without the threshold: their saving is on the input side.
