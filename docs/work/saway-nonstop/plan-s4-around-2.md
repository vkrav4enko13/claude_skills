# S4. `saway` goes around what is forbidden — part 2

> The content of the item "Bypass" of section 3.

## Section 3, the item `**Bypass**`

- **When:** an action from "What not to do"; a menu without an allowed option; a slice that used its two actions; a third return to an earlier stage.
- **Record:** the line `- bypassed: S<N> <title> — <reason>; depends on it: <slices | none>` under `## Waiting for the user` of `away.md`, and the line `S<N>: bypassed without the user — <reason>` in "Progress log". A slice forbidden before its start is not given `stopped`: it stays `not started`, against the status rule of a `swork` stop; a slice that used its actions stays `stopped`. An item that is not a slice — a menu without an allowed option, a third return — is recorded as `- bypassed: <what> — <reason>; depends on it: <what is not done | none>`. When `away.md` is continued in a new part, the section lives in the last part.
- **Dependent slices:** a slice that names the bypassed one in "Depends on", directly or through a chain, or shares a file of "Files" with it. They stay `not started` and are not executed. A slice awaiting a manual check that others depend on: only its dependents stay `not started` and are named to the reviewers; the slice itself is reviewed as done and is listed under "Waiting for the user". The present sentence about a manual check without dependents moves into this item.
- **Everything else is executed:** this overrides "the next slices do not start" and "while it is red, do not start the next slice" of `swork`.
- **On every entry into `swork`,** after a compaction too, read the bypassed lines of `away.md` first: a bypassed slice is not started, not retried and not asked about, whatever its status.
- **Stages 5–7 of `swork` run** after the last slice that is neither bypassed nor dependent — also when no such slice was left. Add to the message of every reviewer, next to the values in brackets, one sentence: `Bypassed without the user, not to be reported as missing or wrong: S<N> — <files>` — the bypassed and the dependent slices.
- **Screening:** drop a finding about a bypassed or a dependent slice or about the half-made edits of a stopped one; start no executor for it, do not fix it, do not restore its files. Name what was dropped in "Deviations from the plan" of the report.
- **"Next step"** in `state.md` stays `user's choice after the report`; the sentence, word for word: "the list of bypassed items stays in `away.md`".
