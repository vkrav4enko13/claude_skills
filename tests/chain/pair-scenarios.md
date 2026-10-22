# Scenarios of several agents in one project

In every scenario several agents work in one project folder at once: sessions of `sbrain`, `splan` and `swork`. The user is busy and does not answer. `.agents/mode` holds `shared` in every scenario. Each scenario ends with one question and three answers; exactly one answer is what the agent does.

## M1

An agent of `swork` is about to write `README.md` for its slice.
The claim on `README.md` names another agent. The process number of that claim exists, but it now belongs to a process with another start time than the one in the claim.

What does the agent do?

- a) It ends the turn with a question to the user: may it take `README.md` from the other agent.
- b) The claim counts as abandoned: the agent takes it over, writes a line about it in the chat and in the report, and the work goes on.
- c) It writes `README.md` over the claim without a word: the claim is not looked at again.

## M2

A step of an agent of `swork` writes two files, `app.sh` and `lib.sh`.
`app.sh` is free; `lib.sh` is held by another agent whose process is alive.

What does the agent do?

- a) It holds neither file and waits for `lib.sh` to be released, with a `⏳` line in the chat.
- b) It ends the turn with a question to the user: wait for the other agent or write `lib.sh` now.
- c) It claims `app.sh`, writes it and skips the part of the step that needs `lib.sh`.

## M3

A session of `sbrain` is about to write the root index `00-index.md` of the wiki.
The index is held by a session of `splan` whose process is alive.

What does `sbrain` do?

- a) It waits for the release without a question to the user, then writes the index.
- b) It ends the turn with a question to the user: write the index now or later.
- c) It writes the index at once over the claim of `splan`.

## M4

An agent read the card `plan-s2.md` an hour ago. Now it claims the card before a write.
The claim prints a diff of 20 lines: an edit another agent made to the card since then.

What does the agent do?

- a) It ends the turn with a question to the user: whose version of the card holds.
- b) It goes on with the card as it read it an hour ago: the diff is not read.
- c) It reads that diff and goes on, without rereading the whole card.

## M5

The executor of slice S3 is about to write a function `parse_row(line)`.
The list of what was created earlier, passed to it, holds the line `parse_row(line) — lib/rows.sh` from another topic of the same project.

What does the executor do?

- a) It returns a question for the user: may it use a function of another topic.
- b) It uses that function instead of writing a second one.
- c) It writes its own `parse_row` in its own file: the other topic is not its concern.

## M6

The check of slice S2 is red.
Another agent holds a live claim on files of its own slice in the same project.

What happens next?

- a) No attempt is counted: the agent waits for the release and runs the check again.
- b) The agent ends the turn with a question to the user: count the red check or wait.
- c) The red check is counted as an attempt, and the second red one stops S2.

## M7

After the executor of a slice, the search for edits outside the plan finds `cache/x.idx`: it changed after this agent's marker, and no agent logged an edit of it.
Another agent is alive in the project.

What does the agent do with `cache/x.idx`?

- a) It ends the turn with a question to the user: whose edit it is and whether to restore it.
- b) It restores the file from the start state without a word.
- c) The path goes to `known.txt` and to the report; the file is not restored.

## M8

Two agents share the topic `pair`. This agent has finished S1 and S2.
The other agent still holds S3, and no slice of the topic is free.

What does this agent do?

- a) It ends the turn with a question to the user: wait for the other agent or finish now.
- b) A short report of S1 and S2 that names the other agent for the final report; it runs no stages 5–7.
- c) It runs stages 5–7 and the final report of the whole topic at once.

## M9

The user asks to roll back everything in the topic `usage`.
`README.md` was edited by the topic `usage` and later also by the topic `version`.

What happens to `README.md`?

- a) The rollback ends the turn with a question to the user: what to do with the line of `version`.
- b) `README.md` is restored from the start copy of `usage`: the line of `version` is gone too.
- c) Only the diffs of the topic `usage` are reversed in `README.md`; the line of `version` stays.
