# S7. Slim the four skills

> Every skill says the same in 30–40 % fewer bytes; nothing the stand or another file relies on is lost.

- **Status:** done
- **Covers:** R6, R5
- **Depends on:** S5, S6
- **Files:**
  - change: every `.md` of `sbrain/`, `splan/`, `swork/`, `saway/` except `sbrain/references/wiki-rules.md`, `wiki-block.md`, `wiki-migrate.md`; the license lines of `sbrain/references/verdict.md` and `prototype.md` kept
  - change: `tests/chain/rules.md`, `tests/chain/rules-survey.md` (citations moved to the new lines, never the rule text)
  - change: `tests/chain/judge-prompt.md` (`:44` "the reviewer of the conformance check or the reviewer of the review" → the one reviewer of the stage 5–7 pass, R7)
  - change: `swork/references/snapshot.md`, `modes.md`, `worktree.md` (the wording left by S5: exclusions and "Progress log" records go into the batch of R9; "after every run of the executor" also after a slice the session built, R8)
- **Interfaces:**
  - takes: `tests/skills-check.sh` (S3); the sizes of `numbers.md` `## Sizes` (S4)
- **Reuse:** the slimming of the LGS game chain on 2026-10-22 (same rules, `~/Documents/7rings/lgs-front-designer/lgs-wiki/ru/skills/game/`): the kept/removed lists are in "What to do" below
- **What to do:**
  - Redo of 2026-10-22, by R6 as changed by the user: the slimmed text stays; one subagent per skill compares it with `~/Documents/my/chain-stand/cs-snap/before/<skill>` and puts back, in short form and at the same point of action, every ban, stop and "never" the slimming removed, and the trap rows that hold a ban (e.g. `splan` step 9 "never start execution: the user starts `swork`", `swork` "accept the work only by the user's choice"), unless a lever of R7–R13 changed that rule.
  - Kept word for word as before: the literals of `plan.md`, the lever phrases of lines 12, 13 and 15, the subagent descriptions; no size target.
  - After the pass: `bash tests/skills-check.sh` and the model-free tests of the former run.
- **Checks:** line 14
