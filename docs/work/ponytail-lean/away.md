# Decided without the user in topic ponytail-lean

> What `saway` decided in the user's place during the `swork` stage, and what waits for the user.

- S13 step 1, `git worktree add --detach "$CB/base-src" cda6856` writes outside the project folder — chosen: run it as the plan says; why: `$CB` is the plan's stand folder, the worktree is a detached read-only copy of a commit, no branch, no commit, removable with `git worktree remove`; otherwise: the baseline series could not run and S13 would be bypassed
- S13 live series (`pl-base`, `pl-cand`, `pl-nomap`, ablation) spend paid `claude -p` runs for hours — chosen: run them; why: the approved plan names them and the user chose "execute in this session"; otherwise: lines 47–51 stay not run

## Waiting for the user

- S13 step 10 and line 53 — `./install.sh --mac` writes the hooks into `~/claude/personal` and `~/claude/work`: an install outside the project folder, and the plan puts it after the user accepts the work; not done
- line 52 (clean room) and line 51 (ablation) are manual checks: only the user sets them to done
