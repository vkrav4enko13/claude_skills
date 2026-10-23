# Small change

## Small change

- The main session executes, no executor subagent.
- Several agents: `references/modes.md`; shared mode — claim each file only for its write; worktree mode — the whole change is one step in `WT`.
- Snapshot `.swork-<id>/` in the project root (`<id>` — first field of `agents.sh id`), with the marker by `references/snapshot.md`. No topic folder and none set up: statuses, check results, progress and search exclusions go in the chat.
- The check before the edits (step 2 of section 3 of `references/slices.md`), two attempts and the decisions of section 4 apply; a decision edits the plan text in the chat — no cards, no "Progress log".
- Code changed — one stage 5–7 pass by `references/finish.md`, section 5, description `Conformance, simplify and review of <the task in a few words>`; "the plan" is the chat plan or your two sentences on the task; findings by sections 5–7. No code changed — as section 5 says.
- After the work — a journal line and other records by `references/wiki-rules.md`, section "Writing", then the wiki check script. The report's "Written to the wiki" names them, marked "new" or "extended", with the snapshot copy of step 8 of section 3.
- The report — by section 8. No topic, no `state.md`; of the "Accept the work" order only the last item: the snapshot `.swork-<id>/` with its marker.
- Before the first edit name in the chat the ready-made code you take (name, file) or where you searched in vain, and the files to edit and create. This list is the slice's "Files" for the copies, `new-files.txt` and the unreported-edits search. Another file needed — name it, copy it first.
