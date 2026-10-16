# S4. swork: stage-7 record, no deletion, full rollback

> `swork` records stage 7 plainly, its read-only subagents and the `splan` reviewer delete nothing outside the project, and "roll back everything" also returns "Next step".

- **Status:** done
- **Covers:** R8, R10, R11
- **Depends on:** none
- **Files:**
  - change: `swork/references/finish.md` (`:14`)
  - change: `swork/references/slices.md` (`:32`, the agent mark)
  - change: `tests/chain/pair-check.sh` (`:51`, header `:11`)
  - change: `swork/references/review.md` (`:16-17`), `swork/references/conformance.md` (`:22`), `swork/references/simplify.md` (`:12`), `splan/references/review.md` (`:33`)
  - change: `swork/references/report.md` (`:41-44`, "roll back everything")
- **Interfaces:**
  - gives: the record forms `stage <N> finished` and `stage <N> finished [<name>]`; `bash tests/chain/pair-check.sh --record "<line>"` — prints `record: <id>` for a stage-7 record with a mark, `record: plain` without one, `record: none` otherwise, code 0
- **Reuse:** the regex of `pair-check.sh:51`; the phase return of `report.md:41`
- **What to do:**
  1. `finish.md:14`: after the example, add: `Stage 7 ends with the record "stage 7 finished"; where agents are marked, "stage 7 finished [<name>]". Write it in this form, not as free text.`
  2. `slices.md:32`: after the `S<N> [<name>]:` form, add: `Stage records take the mark at the end: "stage 5 finished [<name>]".`
  3. `pair-check.sh:51`: accept `stage 7 finished [<id>]` besides the two forms it takes now, and bind the id from it the same way; keep the match in one place and add the option `--record "<line>"` that runs it on one line and prints the result as in Interfaces; update the header line `:11`.
  4. The four tasks: after "Change nothing — only read." add `Delete no file and no folder outside the project folder, temporary folders included.`
  5. `report.md`, "roll back everything": next to bringing back the phase `plan confirmed`, add: `and the "Next step" "execute the plan through \`swork\`" — in \`state.md\` and in the topic's line in "In progress".`
- **Checks:** lines 9, 10, 11, 20
