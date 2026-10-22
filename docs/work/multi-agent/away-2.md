# Decided without the user in topic multi-agent, part 2

> The `splan` stage of the continuation (R16–R30), 2026-10-21, decided by `saway` while the user was away; part 1 is [away.md](away.md).

- Plan size — chosen: cards; why: a topic folder exists and the work touches four skills and the stand; otherwise: none.
- Where the new plan lies — chosen: the same plan of the topic extended by part-2 cards (`plan-2.md`, `plan-decisions-2.md`, `plan-checks-<group>.md` with lines 13–33, slices S7–S11), the cards of S1–S6 untouched; why: `swork` and `packet.sh` find the plan only by the names `plan.md`, `plan-[0-9]*.md`, `plan-checks*.md`, `plan-decisions*.md` — a `plan2-` prefix would be invisible to them, and moving the old cards away is not done without the user; otherwise: a separate plan swork cannot read.
- Old plan overview — chosen: `plan-overview.md` keeps the S1–S6 text as it is and gets the part-2 sections appended; why: nothing of the old overview is lost, and the overview is the one file `check.sh` exempts from the card limit; otherwise: a second overview card over 60 lines.
- The discrepancy rule — chosen: not repeated in `plan-2.md`; why: `packet.sh` prints the section from every header part, `plan.md` already holds it; otherwise: the executor reads it twice.
- Clone cost of gitignored files (doubt of part 1) — measured: the game project has no `node_modules`, its ignored files are ~14 MB, ~1370 files; `cp -cR` of the nearby 43 MB `node_modules` (2212 files) into the scratchpad took 0.62 s, a plain copy 1.09 s; why: the doubt is closed with no plan change; otherwise: none.
- Mixed modes (one agent in a worktree, another fallen back to whole-file claims) — chosen: `agents.sh merge` waits while another live agent claims a path it is about to write, and logs that wait; why: design §10 lets one agent fall back alone, and a merge must never write over a whole-file claim mid-edit; otherwise: a mode fixed per project in a file.
- A slice merged and then red twice — chosen: its bypass reverses this slice's own merge diffs from `.agents/diffs/` with `patch -R`, in the shared folder under the lock; why: restoring `base/` copies would wipe later merges of others; otherwise: the bypass wipes neighbours' work.
- Small change — chosen: works in a worktree too under git 2.38+, its whole change being one step merged once; why: R16 says every `swork` agent; otherwise: small changes keep whole-file claims.
- Snapshot content — chosen: `.agents/` and every `.swork*` folder are left out by a pathspec, and `.agents/` also goes to `.git/info/exclude` (part-1 decision); why: the probe showed a worktree inside `.agents/` enters `git add -A` as an embedded repo, and `.swork/` copies would be hashed into every snapshot; otherwise: snapshots carry gitlinks and snapshot copies.
- The away check (flaky `progress line`, 1 green of 3 in part 1) — chosen: line 32 runs it up to three times and passes on the first `away run: pass`; why: the flake is a known part-1 leftover outside this topic; otherwise: line 32 red for a reason this work does not touch.
- New agents.sh code — chosen: 5 "use whole-file claims" for `wt`, `sync`, `merge` when there is no git, git is older than 2.38, the root is not the git top level or a wiki path lies above it; why: 0–4 are taken, design §9 asks for a fallback code; otherwise: a message parsed by text.
- A test-only hook — chosen: `AGENTS_BEFORE_WRITE=<command>` run by `merge` after its snapshot and before the write, used only by `tests/merge-test.sh` to edit a file in that gap; why: R20 cannot be hit reliably by timing; otherwise: a flaky race test.
- The wait limit of the stand — chosen: every line of `.agents/waits.tsv` in cases c, d, e at most 30 s; why: R30 says "seconds", a merge with two snapshots takes a few; otherwise: another number.
- The duplicate script — chosen: `swork/scripts/dups.py`, run as `python3 -I`; why: only `swork` runs it, the installed `swork/scripts/` already holds `agents.sh`, so it lies "next to agents.sh" as design §8 says; otherwise: `sbrain/scripts/` plus copy lines in `install.sh` and `stand.sh`.

## Waiting for the user

- A doubt: decisions-2.md keeps in force "Shared wiki files go through the same merge…", while R26 and the later assumption line keep the wiki under a short claim; the plan follows R26 (the claim applies the edit onto the current version, append-only lines kept).
- `install.sh --mac` and the commit — line 33, manual, after the user accepts the work.
- The plan was not approved: the user returned during the independent review; the review's 2 blocking and 15 worth-fixing findings were fixed in the cards, no second round.
- A discrepancy: `git merge-tree --merge-base` needs git 2.40, R16 and R27 say 2.38; the plan gates on 2.40.
- A decision for the user: a repository with submodules (the game project has two) gets code 5, whole-file claims.
- A risk for the user: worktrees in `.agents/wt/` with cloned `node_modules` are seen by project tools that ignore `.git/info/exclude`.
