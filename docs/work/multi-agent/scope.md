# Scope of topic multi-agent

> What is out of scope, the assumptions, and the answers already given for the next topic `quality-zero`.

## Out of scope

- Agents on several machines; separate git branches or worktrees per agent.
- Merging edits of two agents in one file at the same moment: they take the file in turn.
- Fixing stand violations of the four skills — the topic `quality-zero`.
- A commit by a skill: still only at the user's request.

## Assumptions

- Every agent runs on this Mac, so the process number of a claim can be checked locally.
- Claude Code lists the local sessions and sends them messages; Codex has no such tool.
- A diff of one write is small enough to keep in `.agents/`; the plan sets how long the log is kept.

## Answers already given for quality-zero

On 2026-10-15, before this topic was split off, the user chose: zero judge violations in one full series of three runs over all four skills, each "no" checked by hand and a wrong verdict fixed in the judge rules with proof; 15/15 survey decisions, 15/15 plan flaws, all planted errors found, all stages done; the deferred review findings of the skills are fixed too, the token items below 3 % are not; `saway` gets judge rules and its stage runs in the series; at most three rounds of "fix → series", then the rest goes to the report; the stand holes (`state.sh`, `verdict.sh`, parallel runs) are fixed before the measuring.

## Open questions

None blocks the plan.
