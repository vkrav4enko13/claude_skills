# Requirements of topic multi-agent, part 2

> R16–R29: a git worktree per `swork` agent, the merge into the shared folder, the duplicate check, wiki writes, the fallback and the acceptance.

## Worktree per agent

- R16. In the worktree mode (R32 of [part 3](requirements-3.md)), every `swork` agent — the `swork` stage inside `saway` too — makes its edits in its own git worktree in `.agents/`, created from a snapshot of the shared folder that holds the uncommitted and untracked files; the snapshot makes no commit, branch or ref the user's branches see, and the gitignored files are cloned into the worktree.
- R17. Before each step — a slice, a fix, stages 5–7 — the `swork` agent takes into its worktree what was merged into the shared folder since its last sync; it takes nothing in the middle of a step.
- R18. Under git with worktrees, `swork` claims only the card of a slice, not its "Files"; its search for edits outside the plan compares its worktree with its last sync, and a stray file is restored from it inside the worktree.

## Merge

- R19. When the check of a step is green in the worktree, the agent merges its edits into the shared folder by a 3-way merge whose base is its last sync, and writes into the shared folder only the files the merge changed, holding the lock of `.agents/` only for the merge and the write.
- R20. If a file of the shared folder changed between the merge's snapshot and its write, then the merge writes no file and starts again.
- R21. If both sides changed the same lines of a file, then the agent that merges second takes the current shared version with the other agent's edit, applies its own edit again in its worktree, reruns the check of the step and merges again, without a question to the user, and its report names the file of the conflict.
- R22. After every merge, the agent reruns the check of the step on the merged result in its worktree; if it is red, the agent fixes it in its worktree and merges again, and its report names the fix.
- R23. A merge logs every file it wrote into the edit log of `.agents/` with its diff and the essence, as a `done` does — R6.

## Duplicate check

- R24. After every merge — in the shared mode after every step, R31 — a script lists candidate duplicates among the files the merge changed, compared with the whole project: functions and classes of the same name; similar code with differences; in data and settings a JSON key, a locale string, a resource or a constant added twice or with different values; the agent that merged keeps one version and reruns the check of the step.
- R25. Where `mergiraf`, `ast-grep` or `jscpd` is installed, the merge and the duplicate script use it; without them the line merge and the script's own search are used.

## Wiki, fallback, dead agent, waits

- R26. `sbrain`, `splan` and the main session of `swork` write the wiki in the shared folder under a claim held only for the write; the agent applies its edit to the current version that the claim's diffs show, and a line added to an append-only card — the journal, "Progress log", an index list — is added to the current version, keeping the lines of others.
- R27. Where the project is not under git or its git is older than 2.40, `auto` picks the shared mode of R31 — R32; whole files in turn by R1–R13 are no longer used.
- R28. If the owner of a worktree is dead, then the agent that finds its claim abandoned saves the unmerged diff of that worktree into `.agents/`, removes the worktree, and the slice is free again.
- R29. `agents.sh` logs every wait in `.agents/`: the agent, the files, the holder, the start, the length and the outcome; the "Waited" section of the `swork` report takes the lengths from that log.

## Acceptance

- R30. A stand test runs two `swork` agents at once in one git project: on different lines of one file the second waits no longer than one merge — seconds — and both edits land; on the same lines the conflict is resolved with no edit lost; a duplicate the two agents add is listed by the script; the earlier stand checks stay green — R14.
