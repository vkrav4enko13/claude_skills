# Plan of topic chain-speed

> Plan header: goal, shared constraints, what we do not do, and the rule for the executor.

- **Goal:** the LGS speed levers in the chain, quality not worse
- **Requirements:** [requirements.md](requirements.md) R1–R21, [design.md](design.md), [decisions.md](decisions.md), [scope.md](scope.md)
- **Checked against code:** `cda6856` on `main` with the uncommitted edits of topic `multi-agent`, 2026-10-22 20:34; every line number in the slices is re-verified after R1, when `multi-agent` is closed
- **Execution:** slices in dependency order; the discrepancy rule is at the end of the card

## Shared constraints

- Skills, cards, scripts and subagent tasks are in English; replies to the user in Russian (`docs/rules.md`).
- Every model session of the stand runs at effort `medium`; no `/fast`.
- Bash scripts in `tests/`, in the style of `tests/chain/*.sh` (`set -u`, a usage line, exit 0 / 1).
- Stand series of this topic are named `cs-<name>` under `~/Documents/my/chain-stand/`; the existing series there are never overwritten or deleted.
- Model runs only in S1 (one small-lane run), S2 (the judge on two old series), S4 and S9; S5–S8 are checked without a model (R5).
- The literal strings and templates the stand greps in a run stay in the skills: `stage 7 finished`, `- **Status:** not started`, the status words `done` and `awaiting manual check`, `S<N>: attempt`, `saway: work finished`, `saway: work stopped — waiting for the user`, `Progress: slices`, `- bypassed:`, `## Waiting for the user`, `execution in progress`, `user's choice after the report`, `Phase:**` with `requirements confirmed`, `plan confirmed` and `done`, the progress separator ` · `; and the lever phrases of `plan-checks-2.md` lines 12, 13 and 15 once S5, S6 and S8 have written them.
- The headings other files cite stay word for word (`references/*` sections, the plan-card headings `packet.sh` reads, saway sections 3–5).
- No commit, no push; `install.sh` is not run.

## Not doing

- Out of scope: [scope.md](scope.md).
- No edit of `docs/rules.md` or of the topic `multi-agent` cards; `sbrain/references/wiki-rules.md`, `wiki-block.md` and `wiki-migrate.md` are not slimmed (installed into the profiles and into `CLAUDE.md`).
- No new lever beyond R6–R13, R22, R23, no new stand lane beyond the small lane of R18, no change of the dropped lanes' scripts.
- No rename of `swork/references/{executor,conformance,simplify,review}.md` (`tests/chain/trace.sh:130` matches them).

## Assumptions

- The user closes `multi-agent` before S1 (R1); S1 checks it first — slices: all.
- A series of 2 runs costs about $50 and takes about 1 hour (runs in parallel) — slices: S4, S9.
- Nested subagents work in Claude Code (a stage subagent of `saway` can start the skill's subagents; seen in a live LGS run 2026-10-22) — slices: S6, S9.

## Deferred questions

- none

## If the code differs from the plan

Stop and report: **expected** — what the plan says; **found** — what is in the code, with the path;
**why it matters** — what fails to line up because of it. Do not silently bend the code to the plan or the plan to the code.
Report a minor discrepancy too (a file moved, a name changed, the meaning is the same): the slice card is fixed by `swork`, not by you.
