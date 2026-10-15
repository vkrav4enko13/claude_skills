# Plan of topic swork-nonstop

> Plan header: goal, shared constraints, what we do not do, and the rule for the executor.

- **Goal:** `swork` without stops, decisions in the report; wiki limits read by a link doubled
- **Requirements:** [requirements.md](requirements.md), [requirements-2.md](requirements-2.md)
- **Checked against code:** 6f6e3f4, branch main, 2026-10-15
- **Execution:** slices in dependency order; assumptions and the discrepancy rule are in [plan-2.md](plan-2.md)

## Shared constraints

- Skill texts and everything they write are English; only the chat line `⚠ …` and the report are shown in the user's language.
- The chain runs strictly at effort `medium`; stand runs too.
- Edit the skills only in this repository (`sbrain/`, `splan/`, `swork/`, `saway/`, `tests/`); the profiles are not touched.
- A rule is written in full in one place; other places refer to it. What moves from `saway` to `swork` is removed from `saway`.
- Stand outputs go under `$HOME/Documents/my/chain-stand/` or a `mktemp -d` folder, never into the repository.

## Not doing

- Out of scope — [scope.md](scope.md).
- `install.sh --mac`, a commit, a push: the user's choice after the report.
- The check lines of finished topics (`saway-nonstop`, `chain-tokens`) are not edited.
- No rewording of skill text that the slice does not name.
