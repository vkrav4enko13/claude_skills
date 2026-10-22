# Requirements of topic multi-agent

> R1–R15: claims, waiting, the edit log, `swork` with neighbours, the other skills, the check and the rollout.

## Claims and waiting

- R1. Before writing a file, an agent of `sbrain`, `splan`, `swork` or `saway` claims it in the project's `.agents/` folder; a claim is one line with tab-separated fields and names the agent, the process number of its session, the session name, the files and the time.
- R2. An agent claims all files of a step in one action or none of them; it never waits while holding a claim.
- R3. While a needed file is claimed by a live agent, the agent waits, without a question to the user, and writes in the chat `⏳ Waiting for <file>: held by <agent>` in the user's language; when the file is free it writes a line that it is free.
- R4. If the process of a claim's owner no longer exists, then the waiting agent takes the claim over and writes that in the chat and in the report.
- R5. A waiting agent learns of a release from a watch on the claims file run by the shell, not by the model: the watch ends when the files are free or the owner's process is gone; it runs in the foreground in pieces of at most 9 minutes, repeated until it ends. No message is sent between sessions.

## Edit log

- R6. After every write to a file, the agent's release appends to the edit log of `.agents/` one tab-separated line: agent, file, time, the changed line ranges, the essence in one phrase; and keeps the diff of that write next to it.
- R7. A claim prints, in the same call, the diffs of the claimed files that other agents edited since this agent last held them, or one line "no changes"; the agent rereads a whole file only when those diffs are longer than 100 lines. Releasing files and logging their edits — the diff computed by the script from a copy taken at the claim — is one call too.
- R8. Before writing a function, the executor of `swork` looks at what other agents created in this topic and in the edit log, and takes a ready function instead of writing a second one.

## swork with neighbours

- R9. Before a slice, `swork` claims the slice's "Files" and its card; a slice held by another agent is skipped for a free slice without unmet dependencies; with none free, it waits.
- R10. `swork` keeps its time marker per agent in the snapshot, and its search for edits outside the plan leaves out the files claimed or logged by other agents.
- R11. Several agents on one topic share its snapshot `.swork/` and write statuses, "Progress log" and `state.md` under a claim; stages 5–7 and the report are made by the agent that finds no slice left to do and no live claim of another agent in the topic; an agent that finishes its slices earlier ends with a short report of its own slices and names who makes the final one.
- The claim of a slice's "Files" in R9 and the search of R10 give way to R18 of [part 2](requirements-2.md) and R31 of [part 3](requirements-3.md); R1–R13 hold only while the multi-agent mode is on — R35.
- R12. The report of `swork` names how long and for what it waited and which claims it took over.

## Other skills, check, rollout

- R13. `sbrain`, `splan` and `saway` claim the shared wiki files — the root index, the journal, `rules.md`, `work/00-index.md` — and the cards of their topic for the time of a write.
- R14. Where the earlier stand checks — `nonstop-run.sh`, `away-check.sh`, `run-check.sh` — turn red after the edit, the edit is not accepted.
- R15. When the work is accepted and committed, the skills are installed by `install.sh --mac` to every Mac profile before the topic `quality-zero` starts.
