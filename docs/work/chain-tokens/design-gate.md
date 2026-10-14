# Design of topic chain-tokens: gate and map

> Sections 1 and 2 as approved on 2026-10-13.

## 1. Effort and the quality gate

**What the user gets:** the chain runs at `medium`, and the stand has proven it before anything reached the working profiles.

- The stand stops hardcoding `xhigh`: the level of the sessions becomes a parameter of a series. The judge stays at `xhigh`.
- The four skills pin `medium` themselves and do not rely on the session setting. The line "the executor of ready text runs at `high`" is removed.
- A baseline series of three runs goes on the present texts. The gate: all stages completed, every planted defect found on the seed, the judge's verdict not worse than series `en`.
- **If the gate is not passed:** the traces show the role that failed; it is raised to `high` and only its stage is rerun. If that does not help, the role returns to `xhigh`. The main session of a skill counts as such a role.
- The skills are installed into the Mac profiles only after the gate is passed.

Assumption: the level pinned in a skill also applies to the subagents that skill launches. If not, the level is set at each subagent launch; the plan checks this.

## 2. A new cost map

**What the user gets:** a list of levers sorted by what the chain spends at `medium`, not at `xhigh`.

- The trace scripts written on 2026-10-13 move from the temporary folder into `tests/` and become part of the stand.
- They run on the baseline series and give the same table of sinks.
- The selection rule: a lever enters the work if it is a pure deletion of a duplicate or dead text, or if its expected saving is at least 3 % of a run's output — the run total varies by 2 %, anything smaller cannot be told from noise. The rest goes to the deferred items with its number.
