# S6. splan and saway levers

> splan reviews only large plans and may cover several requirements with one line; saway runs small work in its own session.

- **Status:** done
- **Covers:** R11 (splan part), R12, R3 (splan and saway rules)
- **Depends on:** S4
- **Files:**
  - change: `splan/SKILL.md`, `splan/references/approval.md` (step 8), `splan/references/review.md`, `splan/references/slicing.md` (step 4), `splan/references/plan-format.md` (check lines)
  - change: `saway/SKILL.md` (stage launch, `:61-77`)
  - change: `tests/chain/rules.md` (splan-8, 22, 23; saway-9: each change names its requirement)
- **Interfaces:**
  - takes: `tests/skills-check.sh` (S3)
- **Reuse:** the LGS wording: `~/Documents/7rings/lgs-front-designer/lgs-wiki/skills/game/lgs-plan/references/review.md` "Fresh reviewer", `lgs-away/SKILL.md` "Lane `light` or no feature folder — run the skill here"
- **What to do:**
  - R11: a fresh reviewer only on a large plan — more than three slices or a slice of larger code (more than one file or about 20 changed lines); a small plan gets the self-check and the handoff says «no fresh reviewer: small plan». A check line may name several requirements that one command checks; every requirement is still in at least one line.
  - R12: small work runs in this session — the "Small" path, a plan from the chat, no topic folder, or a topic of at most five requirements whose plan is not large by R11; a stage subagent only for the rest.
  - Write the lever phrases of line 13 word for word; the fresh plan reviewer gets the description `Plan review of <topic>` word for word (`trace.sh` `role_of` maps "plan review" to `plan-review`).
- **Checks:** line 13
