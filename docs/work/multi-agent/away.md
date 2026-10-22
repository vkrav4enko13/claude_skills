# Decided without the user in topic multi-agent

> The `sbrain` stage of the continuation (worktree per agent, merge, duplicate check), 2026-10-21, decided by `saway` while the user was away.

- Approach (step 5) — chosen: A, a worktree per `swork` agent from a temp-index snapshot commit, merged by `git merge-tree` under the short `.agents/lock/` mutex; why: survey decisions 4, 6, 10 and the research point to it, it is the smallest addition — git does the 3-way merge, attributes give union and optional drivers, no own merge code; otherwise: B (per-file `git merge-file` with base copies in `.agents/`) means own code for new, deleted and renamed files and no drivers.
- Approach — rejected: C, splitting hub files into per-topic parts in the project code (the user's first wording); why: it changes the user's code structure, and the user agreed to "edit in own copy, then merge" (decision 4); otherwise: every project would need a refactor before parallel work.
- Approach — rejected: D, A plus an early `git merge-tree` warning against the neighbours' worktrees before a step; why: nobody asked for it, it is my own addition; otherwise: it goes to "Out of scope" as deferred.
- Wiki writes (decision 8) — chosen: they stay in the shared folder under a claim held only for the write; the agent applies its edit to the current version the claim's diffs show, and a line of an append-only card is added to the current version; why: decision 12 keeps the wiki out of worktrees, and a claim of seconds leaves nothing to merge by git; otherwise: wiki cards would go through `merge-tree` too.
- Ignored files in a worktree (node_modules, .env, build output) — chosen: an APFS clone `cp -cR`, a plain copy elsewhere; why: a symlink would let checks write build output into the shared folder; otherwise: symlinks, cheaper on huge folders.
- Worktree place — chosen: `.agents/wt/<id>/`, with `.agents/` added to `.git/info/exclude`; why: inside the project folder (saway: nothing outside it), not committed, skipped by the wiki check and by the swork search; otherwise: a sibling folder outside the project.
- No refs in the user's repository — chosen: the worktree's detached HEAD holds the last sync snapshot, which keeps it from `git gc`; why: decision 10 says no commit into the user's branch; otherwise: hidden refs `refs/agents/*`.
- Git attributes and drivers — chosen: passed per call with `git -c core.attributesFile=<file in .agents/>` and `-c merge.<driver>.driver=…`, never written to `.git/config` or `.gitattributes`; why: the user's own merges stay as they are; probed on git 2.56: `merge=union` kept both journal lines; otherwise: `.git/info/attributes`.
- Unreported edits under worktrees — chosen: the diff of the worktree against its base, a stray file restored from the base inside the worktree; why: it cannot touch the user's or a neighbour's work; otherwise: the find-by-marker search over the shared folder.
- Duplicate script — chosen: own search with `python3` (same names, JSON keys, key-value files, repeated line windows), `ast-grep` and `jscpd` used only when installed; why: they are not on this Mac and installing is not done without the user; otherwise: those tools required.
- Requirements, design and the decision card — written as `requirements-2.md` (R16–R30), `design-2.md`, `design-3.md`, `decision-worktree-merge.md`, `examples.md`; why: the old cards are near the size limit.
- decisions.md: "An agent claims the files of its current step…" — was: in force; became: superseded under git by decisions-2.md; why: the user agreed (decision 5); otherwise: the line stays in force.
- scope.md: "separate git branches or worktrees per agent" and "merging edits … they take the file in turn" — was: out of scope; became: lifted, with a link to requirements-2.md; why: the user agreed (decision 5) and chose worktrees (decision 6); otherwise: the lines contradict R16–R18.
- A conflict or a red merged check that comes back — chosen: after two attempts the slice goes to "Decisions and bypass" of `swork`, its edit unmerged in the worktree; why: the same count as a red slice check in `swork`; otherwise: endless retries.
- The new `agents.sh merge` codes — chosen: 0 merged, 4 conflict, 2 wrong arguments; why: 1 and 3 are taken by `busy` and a busy claim; otherwise: the plan picks other codes.
- requirements.md: a line that R9's claim of "Files" and R10's search give way to R18 under git — was: R9, R10 without a note; became: the note before R12; why: R18 replaces them in worktree mode; otherwise: R9 and R18 contradict each other.
- Approval of the summary and of the topic cards (steps 7–8) — chosen: "Yes, the plan next"; given without the user on 2026-10-21 after rereading the cards against survey decisions 1–18 (each has a requirement: 4, 6 → R16, R19; 7 → R21; 8, 12 → R26; 9 → R29, R30; 10 → R16; 11 → R27; 13 → R17; 14, 15 → R24; 16 → R22; 17 → R28); why: saway section 3; otherwise: the cards wait for the user.

## Waiting for the user

- Installing `mergiraf`, `ast-grep`, `jscpd` — optional; the design works without them; not installed (an install into the system).
- The worktree mode needs git 2.38 or newer; this Mac has 2.56; an older git falls back to claims (R27).
- A doubt: cloning a huge `node_modules` into every worktree may take seconds to minutes; the plan should measure it on the game project.
