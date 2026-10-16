# Design of topic multi-agent

> The four sections approved on 2026-10-15; then the diff in the edit log, the shell watch instead of messages and one-line tab-separated records were chosen.

## 1. Mechanism

A folder `.agents/` in the project root (the wiki and its check skip dot folders); every record is one tab-separated line: the claims — agent, process number, session name, files, time, who waits; the edit log — a line per write with the essence and the line ranges, the diff kept next to it. One script `agents.sh` serves all four skills: claim (all or nothing, atomic by creating a lock folder; prints the diffs others made to these files since this agent last held them), done (computes the diffs from the copies taken at the claim, logs them with the essence, releases), wait (a shell watch on the claims file, no model tokens; free — go; owner's process gone — take over and record), two calls per step in all. The rule is written once, in a rules file next to `wiki-rules.md`, installed into every skill like it — R1–R7.

## 2. swork

Before a slice it claims the slice "Files" and the card; statuses, "Progress log" and `state.md` are written under a short claim. A slice held by another — take a free one; none — wait. The time marker is per agent, in the snapshot. The search for edits outside the plan subtracts the files claimed or logged by others. Stages 5–7 and the report — by the agent that sees no slice left and no live claim — R9–R12.

## 3. Other skills and notices

`sbrain`, `splan`, `saway` claim the shared wiki files and their topic cards for a write. Before editing a file read earlier, every skill checks the edit log and reads the diffs. No messages between sessions: the shell watch wakes the waiter, in Claude Code as a background task. In the chat — `⏳` lines, "free", "took over an abandoned claim"; in the report — the waits. No question to the user over a busy file — R3, R5, R7, R13.

## 4. Check and rollout

A live stand test of two `swork` at once — two topics with a shared file, and slices of one topic; blind scenarios — abandoned claim, mutual block, a shared wiki file, a reread after another's edit, a function another agent created; the earlier stand checks stay green. Then a commit and `install.sh --mac`; only then `quality-zero` — R14, R15.
