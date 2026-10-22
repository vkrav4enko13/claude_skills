# Each swork agent edits its own worktree and merges it

> Under git, an agent's own copy merged 3-way into the shared folder after a green step, instead of claiming whole files in turn.

- **User's words:** «maybe split the parts into different files so they can work in parallel and not get in each other's way, and edit the shared part only when it is needed, or combine at the end? this is when several agents work in one folder»; «here they wait for the classes to be freed»; «and we also need to run checks that the code is not duplicated, or that there is no other version with differences, and so on»; «they will need to track and update»; «search the web for what solutions there are to do this better» — 2026-10-21
- **Reason:** in the game project edits of two topics in one hub file rarely overlap (lines 321–350 and 860–882 of `GameView.js`), but a claim takes the whole file for a whole slice run — a 43-minute wait was seen. A merge makes the wait the length of a merge. The research found the same pattern in Sculptor: git merges what does not overlap, the agent resolves the rest.
- **Rejected:** whole-file claims in turn — the waits the user saw; they stay only as the fallback without git (R27).
- **Rejected:** splitting hub files into per-topic parts in the project code — a refactor of the user's project before parallel work.
- **Rejected:** per-file `git merge-file` with own base copies — own code for new, deleted and renamed files, no drivers.
- **Rejected:** live sync (CRDT) and line-range locks — an agent needs a stable tree; ranges shift.
- **Status:** in force
- **Replaces:** the line "An agent claims the files of its current step…" of [decisions](decisions.md), under git
