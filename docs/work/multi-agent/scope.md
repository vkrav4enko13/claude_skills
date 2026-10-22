# Scope of topic multi-agent

> What is out of scope, the assumptions, and the answers already given for the next topic `quality-zero`.

## Out of scope

- Agents on several machines.
- Separate git branches or worktrees per agent — lifted 2026-10-21 by [requirements, part 2](requirements-2.md), R16.
- Merging edits of two agents in one file at the same moment: they take the file in turn — lifted 2026-10-21: the worktree mode merges (R19–R21), the shared mode claims a file only for a write (R31).
- An early `git merge-tree` warning against the neighbours' worktrees before a step — deferred, an addition nobody asked for.
- Installing `mergiraf`, `ast-grep`, `jscpd` — waits for the user; R25 works without them.
- Live sync of files between agents and line-range locks — an agent needs a stable tree.
- Merging edits made inside a submodule from a worktree — a slice writing there runs in the shared mode (R33).
- Fixing stand violations of the four skills — the topic `quality-zero`.
- A commit by a skill: still only at the user's request.

## Assumptions

- Every agent runs on this Mac, so the process number of a claim can be checked locally.
- Claude Code lists the local sessions and sends them messages; Codex has no such tool.
- Every agent's project lies on APFS, so `cp -cR` clones the gitignored files cheaply; elsewhere it is a plain copy.
- Cloning a large `node_modules` into a worktree takes seconds, not minutes — the plan measures it on the game project.
- The executor uses absolute paths from the worktree root it is given; nothing sets its working directory today.
- A diff of one write is small enough to keep in `.agents/`; the plan sets how long the log is kept.

## Answers already given for quality-zero

On 2026-10-15, before this topic was split off, the user chose: zero judge violations in one full series of three runs over all four skills, each "no" checked by hand and a wrong verdict fixed in the judge rules with proof; 15/15 survey decisions, 15/15 plan flaws, all planted errors found, all stages done; the deferred review findings of the skills are fixed too, the token items below 3 % are not; `saway` gets judge rules and its stage runs in the series; at most three rounds of "fix → series", then the rest goes to the report; the stand holes (`state.sh`, `verdict.sh`, parallel runs) are fixed before the measuring.

## Open questions

None blocks the plan.
