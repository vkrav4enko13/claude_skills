# Technical decisions of topic swork-nonstop

> What the plan chose, instead of what and why; which failures and kinds of input it checks beyond the named ones.

## Technical decisions

- **A self-edit never touches "Expected" or the values of a scenario** — instead of free edits of the check line: otherwise `swork` makes its own work pass; it may fix a path, a command or "Files".
- **An interrupted slice with "Rollback": established by the code, bypassed when unclear, never redone** — instead of repeating the saving: a repeat overwrites the saved state or does the irreversible twice.
- **A bypassed slice gets back from `base/` the files no `done` slice names** — instead of leaving half-made edits that turn later checks red, or wiping done work; slices with "Rollback" are excluded.
- **New slice statuses `bypassed` and `not checked`** replace `stopped` — instead of a record only in `away.md`: a status survives a new session; a legacy `stopped` is read as "red after two attempts".
- **A small change keeps its decisions in the chat** — it has no cards: the "Decided myself" section goes into the chat report.
- **The plan shown by `splan` names the irreversible slices and the manual checks that others depend on** — the user's "yes" to the plan is now the only consent to them.
- **The gate is a new live check on `seed-away`, nine blind scenarios and two `seed` series** — the standard runs never meet a former stop case; the series before runs the skills of 6f6e3f4, as `b2` mixes four stages and the verdict has no stage column.
- **The `file:line` references of the `swork-*` judge rules are moved to the new lines** — no rule demands a stop; both series are judged by the same rules.

## Check focus

- An interrupted slice with "Rollback" and a "started" record without an outcome → bypassed, not redone — S3, line 6
- A done slice turns red when continuing, after two attempts → card edit, then `bypassed` — S3, line 6
- A bypassed slice left half-made edits in a shared file → its files restored, later checks unaffected — S3, line 6
- A new session meets a `bypassed` slice, also one `saway` forbade → not retried, not asked about — S3, line 6
- A plan from before the edit has a slice `stopped` → taken as red after two attempts and decided — S3, line 5
