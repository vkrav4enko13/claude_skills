# Decisions of topic multi-agent, part 2

> The continuation of 2026-10-21: per-agent copies merged into the shared folder — a line per decision.

- A continuation of topic `multi-agent` with requirements R16+, instead of a new topic — the mechanism is the same `agents.sh` and rules; user chose; in force
- Both parts at once, code and wiki records, instead of one of them — the waits are on both; user chose; in force
- The reason is the long waits seen in practice (43 minutes on one slice), instead of a guess; user chose; in force
- An agent edits its own copy and merges it, instead of claiming whole files in turn — see [the decision card](decision-worktree-merge.md); agreed; in force
- The scope line "they take the file in turn" is lifted and the claim of a step's files is superseded under git, instead of keeping them — they contradict the merge; agreed; in force
- Every `swork` agent works in its own git worktree; after a green step check its edits merge 3-way into the shared folder, then the merged result is checked — instead of edits in the shared folder; agreed; in force
- A same-lines conflict is resolved by the agent merging second: the current shared version with the other diff, its edit applied again, the step check rerun, no question, a line in the report — instead of asking the user; agreed; in force
- Shared wiki files go through the same merge, and append-only files keep both added lines — instead of claims in turn; agreed; superseded by [part 3](decisions-3.md)
- Acceptance: a stand where two `swork` editing different lines of one file wait no longer than a merge, the same lines resolve with no lost edit, the earlier checks stay green, wait lengths are logged — instead of scenarios alone; agreed; in force
- A worktree is created from the current state of the shared folder, uncommitted changes included, as a snapshot without a commit into the user's branch, and that snapshot is the merge base — instead of HEAD; agreed; in force
- Without git the whole-file claims in turn stay, instead of a merge of own making; agreed; superseded by [part 3](decisions-3.md)
- Only `swork`, inside `saway` too, uses a worktree; `sbrain` and `splan` write the wiki in the shared folder under a claim of seconds plus the merge — instead of worktrees for all; agreed; in force
- A worktree takes in the others' merges before each step and at its own merge, instead of live mid-step — an agent needs a stable tree; agreed; in force
- After a merge the check looks for same functions and classes, diverged versions and duplicates in data and settings, instead of one of them; user chose; in force
- A cheap script finds the candidates after each merge and the agent that merged second keeps one version and reruns the step check, instead of a reviewer subagent; agreed; in force
- A red check after a merge is fixed in the agent's own copy and merged again, with a line in the report — instead of a rollback of the merge; agreed; in force
- A dead agent's worktree with an unmerged edit: the next agent saves the diff into `.agents/`, removes the worktree, the slice is free — instead of keeping it; agreed; in force
- Nothing deferred: everything in the first round, instead of a staged rollout; agreed; in force
- The merge by `git merge-tree` over snapshot commits under the `.agents/lock/` mutex, instead of per-file `git merge-file` with own base copies or splitting hub files in the project code — git merges new, deleted and renamed files and takes drivers by attributes; assumption — decided without the user ([away](away.md)); in force
- Wiki writes stay in the shared folder under a claim held for the write, the claim's diffs applied to the current version, instead of a git merge of wiki cards — decision 12 keeps the wiki out of worktrees; assumption — decided without the user; superseded by [part 3](decisions-3.md)
- `mergiraf`, `ast-grep`, `jscpd` optional, used when installed, instead of required — they are not on this Mac and installing waits for the user; assumption — decided without the user; in force
