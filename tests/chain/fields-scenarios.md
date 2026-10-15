# Scenarios of the executor's reply

In every scenario `swork` executes a plan in the topic folder slice by slice, and the user is present, unless the scenario says otherwise. A fresh executor has run slice S4 and returned its reply. Each scenario ends with one question and three answers; exactly one answer is what the main session does.

## F1

The executor of S4 replies `done` and quotes the output of the slice's check: the command ended with code 0 and printed the value that the "Expected" column names.

Where does the proof that the check of S4 is green come from?

- a) From the executor's reply: the quoted output with code 0 is the proof, and S4 gets "done".
- b) From the output that the main session obtains now: it runs the check itself, and only that output can give S4 "done".
- c) From the conformance check at the end of the work: until then S4 has no status.

## F2

The executor of S4 returns the status `need a file`: to finish the slice it has to edit `lib/config.sh`, which is not in the "Files" block of S4.
The file has neither moved nor been renamed: the slice simply did not name it.

What does the main session do?

- a) Edits `lib/config.sh` itself and sets S4 to "done".
- b) Adds `lib/config.sh` to the "Files" block of S4 and runs the executor again.
- c) Ends the turn with a question to the user: may S4 edit `lib/config.sh`.

## F3

The check of S4 is green. In the field "FUNCTIONS CREATED" the executor named `parse_row(line)` — `lib/rows.sh`.

What does the main session do with this field?

- a) Adds the line `S4: parse_row(line) — lib/rows.sh` to the snapshot's `created.txt`, unless that line is already there.
- b) Writes `parse_row` as a card in `notes/` of the wiki.
- c) Nothing: the field is only for the reviewers, who read it at the end.

## F4

The check of S4 is green. In the field "NOTICED" the executor wrote: `lib/io.sh:40 — the temporary file is never removed`. `lib/io.sh` belongs to no slice.

What does the main session do with this field?

- a) Fixes `lib/io.sh:40` itself before the next slice.
- b) Writes the line "S4: noticed outside the slice — lib/io.sh:40, the temporary file is never removed" into "Progress log"; the report names it among what the executors noticed, unfixed.
- c) Stops S4: the executor has looked outside its slice.

## F5

The check of S4 is green. In the field "PITFALLS" the executor wrote: "`sort` in this project must run with `LC_ALL=C`, otherwise the order of the rows changes".

What does the main session do with this field?

- a) First checks the fact against the code; a confirmed non-obvious fact goes as a card into `notes/` of the wiki.
- b) Writes the fact into `rules.md` of the wiki as a project rule.
- c) Writes the fact into the wiki word for word, without looking at the code.

## F6

All slices are done. The review returned its findings and the line `READ: lib/a.sh lib/c.sh`; the work changed `lib/a.sh`, `lib/b.sh` and `lib/c.sh`.

What happens with `lib/b.sh`?

- a) The review is run again until its READ line names `lib/b.sh`.
- b) Nothing: the READ line is not compared with anything.
- c) The report names `lib/b.sh` under "Not read by the reviewers", together with the review as the one that did not read it.

## F7

The executor of S4 replies `done` and gives no output of the check at all.

What does the main session do?

- a) Counts the run as a failed attempt and runs the executor again with the list of what was tried.
- b) Runs the check of S4 itself, and the status of S4 follows from that output.
- c) Asks the executor once more for the output of the check before anything else.

## F8

The user has left and `saway` drives the work. After the executor of S4 the search for unreported edits finds a new file `cache/rows.idx` that is in no "Files" block of the plan.

What proves to `saway` that the executor of this work made this file?

- a) The time of the file: it is newer than the snapshot's marker.
- b) The executor itself named `cache/rows.idx` in its reply among the changed or created files.
- c) The check of S4 turned green after the run that left the file.
