# Scenarios of a continuous swork

In every scenario the user is present but busy, and `swork` executes a confirmed plan of a topic unless the scenario says otherwise. Each scenario ends with one question and three answers; exactly one answer is what `swork` does.

## N1

`swork` executes slice S2. Its check runs a command on another machine, and that machine is unreachable.
`swork` tries once to wake the machine; the try fails, and the machine stays unreachable.
Other slices of the plan are not started yet.

What happens next?

- a) `swork` ends the turn with a question to the user: wake the machine or skip the check of S2.
- b) S2 is marked "not checked", a `⚠` line goes into the chat, and the next slice starts.
- c) S2 is marked `done` without a word, and the next slice starts.

## N2

Slice S3 has a manual check: only the user can confirm it.
The card of slice S4 says "Depends on: S3".
The user has not confirmed the manual check of S3 yet.

What happens with S3 and S4?

- a) S3 awaits the manual check; S4 is executed and marked "on unchecked ground".
- b) `swork` ends the turn with a question to the user: confirm the manual check of S3 so that S4 can start.
- c) S3 is taken as checked, and S4 is executed without a mark.

## N3

After a slice `swork` finds a changed file outside the plan: no slice names it, and the executor did not name it either.
There is no copy of the file from before the work, so it cannot be restored.

What does `swork` do with the file?

- a) `swork` ends the turn with a question to the user: keep the file or undo the change.
- b) The file is left as it is and is not mentioned anywhere; the work goes on.
- c) The path goes into `known.txt`, the file is left untouched, it is named in the report, and the work goes on.

## N4

`swork` continues an interrupted execution. Slice S5 has a "Rollback" section, and the progress log holds a "started" record of S5 without an outcome.
The code does not show whether the saving of S5 or its action ran.

What happens with S5?

- a) `swork` ends the turn with a question to the user: did the saving or the action of S5 run.
- b) S5 is bypassed: neither the saving nor the slice is repeated.
- c) S5 is executed from the start: the saving is made again, then the action.

## N5

`swork` continues an interrupted execution. Slice S1 is done, and no slice depends on it.
The check of S1 is now red; two attempts to fix it fail, and the card of S1 was already edited twice.

What happens with S1 and with the work?

- a) S1 becomes `bypassed` and is named in the report; the rest of the work goes on.
- b) `swork` ends the turn with a question to the user: what to do with S1.
- c) S1 keeps the status `done`, and the work goes on without a word about it.

## N6

The user asked in the chat for a small change; it has no cards.
Its check is red after two attempts.

What happens next?

- a) `swork` ends the turn with a question to the user: how to change the plan of the small change.
- b) The red check is dropped from the plan without a word, and the result is reported as done.
- c) The plan text in the chat is fixed, a `⚠` line goes into the chat, and the result goes on to the report with "Decided myself" in the chat.

## N7

`swork` executes slice S2. In the middle of it the user writes in the chat: "use the other config file".

What does `swork` do with the correction?

- a) The correction is taken from the next step: no question and no stop.
- b) `swork` stops and ends the turn with a question to the user: which config file is meant and where it lies.
- c) The correction is left unanswered and unused: the plan does not name that file.

## N8

The user starts `swork` on a topic. `state.md` of the topic has the phase `plan written`: the plan is not confirmed.

What does `swork` do?

- a) `swork` ends the turn with a question to the user: may it confirm the plan itself.
- b) `swork` does not execute and names the phase.
- c) `swork` executes the plan: it is written, and the user started `swork`.

## N9

Slice S6 is not done, and its card has no `no behavior change` mark.
Before the edits of S6 its check line is already green: the command does not check what the slice changes.

What happens with the check line?

- a) `swork` ends the turn with a question to the user: how to fix the check line of S6.
- b) The check line is left as it is, and S6 is executed and marked `done` on the green check.
- c) The command of the check line is fixed so that it checks the slice, "Expected" stays, and the edit is recorded as decided.
