# Two nonstop-run.sh at once break each other

> Two `tests/chain/nonstop-run.sh` started at the same time both fail: the stand project is missing and `drive.sh` cannot `cd` into it.

- Seen twice on 2026-10-15: each run printed `drive.sh failed`, slice statuses `missing` and `nonstop run: fail`; the stand folder had no `wiki-trial/clean`.
- The same command run alone right after printed `nonstop run: pass`.
- One `nonstop-run.sh` next to blind readings (`away-blind.sh`) or an `away` live run did not collide.
- Run `nonstop-run.sh` one at a time; a fail with `missing` statuses is the environment, not the skill.
- Source: `docs/work/swork-nonstop/.swork/checks/F-l5.txt`, `S7-l5.txt`, `F2-l5.txt`, 2026-10-15
