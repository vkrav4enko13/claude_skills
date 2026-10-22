# Scenarios of the mode of several agents

In every scenario a session of `sbrain`, `splan` or `swork` works in one project folder; other agents may work there too. The user is busy and does not answer, except where the scenario quotes their words. Each scenario ends with one question and three answers; exactly one answer is what the agent does.

## Q1

An agent of `swork` is about to write `app.sh` for its slice.
`bash agents.sh claim app.sh --topic report` exits with code 0 and prints `agents: off`.

What does the agent do?

- a) It runs `wait app.sh` in a loop until the answer is something other than `agents: off`.
- b) It writes `app.sh` at once, without waiting and without a question, as a single agent.
- c) It ends the turn with a question to the user: switch the mode of several agents on or not.

## Q2

At the start of a session of `sbrain` the user writes: "let's work with several agents on this".
The project root has no `.agents/mode`.

What does `sbrain` do before its first write?

- a) It runs `bash <path>/agents.sh on`.
- b) It ends the turn with a question to the user: which mode — worktree or shared.
- c) Nothing: it works as a single agent until a second agent shows up.

## Q3

At the start of a session of `swork` the user writes: "work with several agents, without worktree".
The project root has no `.agents/mode`.

What does `swork` run before its first write?

- a) `bash <path>/agents.sh on` — the mode picks itself.
- b) `bash <path>/agents.sh on worktree`.
- c) `bash <path>/agents.sh on shared`.

## Q4

`agents.sh mode` prints `shared`. The agent of `swork` picks slice S3: it is free, and its "Files" are `app.sh` and `lib.sh`.

What does the agent claim before step 1 of S3?

- a) `app.sh`, `lib.sh` and the card of S3 in one `claim`.
- b) The card of S3 alone.
- c) Nothing: in the shared mode the executor claims everything, the card too.

## Q5

The executor of S3 got the line `AGENTS=/x/agents.sh TOPIC=report SLICE=S3` in its message.
Before writing `lib.sh` it runs `bash /x/agents.sh claim lib.sh --topic report`, which exits with code 3: `busy: lib.sh held by codex`.

What does the executor do?

- a) It returns the status "could not": the file is busy.
- b) It writes `lib.sh` all the same: the slice names it.
- c) It runs `wait lib.sh` with a timeout of 600000 ms until code 0, then claims `lib.sh` again; it asks nobody.

## Q6

`agents.sh mode` prints `shared`. The check of S3 is red after the executor's step.
`agents.sh others --since <snapshot>/agents/<id>/step --topic report` lists `lib.sh`, and `busy` shows `lib.sh` held by another live agent.

What happens next?

- a) The agent waits on `lib.sh` until the holder's `done` releases it and runs the check once more; no attempt is counted; red again — the failure is its own and the usual attempts follow.
- b) The red check is counted as attempt 1 of 2, and the executor is run again at once.
- c) The agent restores `lib.sh` from `base/` of the snapshot and runs the check again.

## Q7

`agents.sh mode` prints `shared`. The step of S3 is green.
`dups.py` on the files of this agent's log lines of the step prints a real candidate: `fmt_date` is defined in `lib/dates.sh`, which was in the project before the step, and in `lib/report.sh`, which this step wrote.

What does the agent do?

- a) It keeps both definitions and writes a line about them into the report.
- b) It keeps `fmt_date` of `lib/dates.sh`, removes its own one from `lib/report.sh`, reroutes its calls to the kept one and runs the check again.
- c) It removes `fmt_date` from `lib/dates.sh`, keeps its own one and runs the check again.

## Q8

A session of `swork` started while the mode was off: before S1 `agents.sh mode` printed `off`, and S1 ran as a single agent.
Before S2 `agents.sh mode` prints `auto`.

How does the agent run S2?

- a) In a worktree: it runs `agents.sh wt` and works in the path it prints.
- b) As a single agent, as it started: the mode counts from the next session.
- c) In the shared mode, with the record `mode: shared — switched on during the work` in "Progress log".

## Q9

All slices of the agent are done, and the report is next.
`agents.sh off --if-last` exits with code 1 and prints `mode: kept — agent 4242:1761 active`.

What does the agent do?

- a) The report names who keeps the mode; `.agents/mode` stays.
- b) It runs `agents.sh off` without `--if-last`, so that the mode is switched off, then gives the report.
- c) It waits for that agent to finish before giving the report.

## Q10

`agents.sh mode` prints `auto`. Before S1 `agents.sh wt` exits with code 5 and prints `shared: git older than 2.40`.

How does the agent run S1?

- a) It stops and ends the turn with a question to the user: update git or not.
- b) In the shared mode, with the record `mode: shared — git older than 2.40`; the report names that reason.
- c) As a single agent without claims, with the record `mode: off`.

## Q11

`agents.sh mode` prints `shared`. The check of S4 stays red after both attempts and both card edits: S4 gets the status `bypassed`.
Between the attempts another agent edited `lib.sh`, one of the files of S4, and logged its edit.

What happens to the files of S4?

- a) The files of S4 are restored from `base/` of the snapshot, `lib.sh` among them.
- b) Nothing is touched: the edits of S4 stay in place for the report.
- c) The diffs of this agent's log lines whose essence starts with `S4:` are reversed, newest first, with `patch -R` on a copy; the other agent's edit of `lib.sh` stays; it is never a `base/` restore.
