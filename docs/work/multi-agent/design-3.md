# Design of topic multi-agent, part 3

> Sections 8–11 of the continuation, approved without the user on 2026-10-21: the duplicate check, the wiki and the fallback, errors, the check.

## 8. Duplicate check

A script next to `agents.sh`, run by the agent after every merge on the paths the merge changed; it prints candidates, one line each — kind, name, the two places — and changes nothing (R24):

- **Same names** — functions, classes and constants defined in a changed file whose name is defined elsewhere in the project: definitions found by `python3` with patterns per language (JS/TS, Python, shell); by `ast-grep` when installed.
- **Similar code** — windows of 6 normalized lines (spaces and names of locals dropped) added by the merge that occur elsewhere with small differences; `jscpd` on the changed files when installed.
- **Data and settings** — a JSON key repeated in one object (`json.load` with `object_pairs_hook`, plain loaders silently keep the last); a key of a key-value file (locale `.str`, `.lconf`, `.properties`) given twice or with a different value elsewhere; a resource name or path listed twice.

The agent reads each candidate: a real duplicate — keeps one version in its worktree, reruns the check of the step, merges again; a false one — a line in the report. Tools that are not installed are named in the report once, not installed.

## 9. Wiki, fallback, dead agent, waits

- **Wiki (R26).** Wiki cards are not part of a worktree merge: `sbrain`, `splan` and the main session of `swork` write them in the shared folder, claiming for the write only, as today; the claim prints the diffs since the agent's last hold and the agent applies its edit to that current version. A line of the journal, "Progress log" or an index list is added to the current file, keeping the others' lines.
- **Fallback (R27).** `agents.sh merge` and the worktree commands answer with a code that tells `swork` to work in the shared folder with whole-file claims, as by R1–R13.
- **Dead agent (R28).** When a claim is found abandoned and `.agents/wt/<id>` exists, the finder saves `git diff` of that worktree against its HEAD into `.agents/orphans/<id>.diff`, runs `git worktree remove --force`, and the slice is picked as free; its started attempt is redone from the shared folder, where nothing of it was merged.
- **Waits (R29).** `wait` appends a line to `.agents/waits.tsv`: id, name, topic, files, holder, start, seconds, outcome — free, abandoned or still busy.
- **End of the work.** At "accept the work" or "roll back everything", `swork` removes its worktrees; a rollback reverses the logged diffs by `references/report.md`, as today.

## 10. Errors

- The user edits a file during a merge — R20, the merge starts again and never overwrites the edit.
- The same conflict or a red merged check comes back after two attempts, as for a red slice check — the slice goes to "Decisions and bypass" of `swork`, its edit stays unmerged in the worktree and is named in the report.
- `git merge-tree` or `worktree add` fails — the agent falls back to whole-file claims for this work and says so in the report.
- The shared folder is red for a moment between two merges: each agent checks the merged result in its own worktree (R22); the final checks of stages 5–7 run on the result of the last merge.

## 11. Check

A stand project under git; two `swork` sessions at once by R30: different lines of one file, the same lines, a planted duplicate function and a duplicate JSON key; a merge while a file is edited by a third writer; a dead agent with an unmerged worktree; the same pair in a project without git. The earlier stand checks stay green — R14. Then the commit and `install.sh --mac` by R15.
