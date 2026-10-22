# Slice executor

Read at step 3 of the "Slices" section — before the executor is started.

A slice of a plan in the topic folder is executed by a fresh subagent. It has seen neither the conversation nor the plan as a whole, and it cannot ask the user. Everything it needs to know lies in the packet.

## Packet

Run the script into a file: `bash <skill folder>/scripts/packet.sh <topic folder> <slice number> <project root> [<created.txt>…] > <temporary folder>/packet-S<N>.txt` — this topic's `created.txt` first, then the `created.txt` of the other topics found under `<wiki>/work/*/.swork/`, and nothing else. Do not retype the text of the cards. If the script cannot be run, collect the packet by hand into the same file, in the same order:

1. **Its own slice** — the slice card in full, with all its parts.
2. **Its check lines** — the lines from the check cards with the numbers from the "Checks" field of the slice, together with the header row of the table.
3. **Shared constraints** and **Not doing** — the sections of `plan.md` and of its parts.
4. **Technical decisions** — the `plan-decisions.md` card.
5. **Out of scope** — the section of the topic's `scope.md` card or of its part `scope-<part>.md`, if the topic has such a card.
6. **The rule "If the code differs from the plan"** — the section at the end of `plan.md` or of its last part.
7. **The project root** — the full path.
8. **What was created earlier** — the contents of this topic's `created.txt`, then of the other topics' ones, a block each under `=== created earlier: <file> ===`, this topic's marked `(this topic)`: the lines `S<N>: name(signature) — file` — the name, the signature and the file of every function of the earlier slices, without the text of the functions. There is no file — its block is skipped.

The path to the topic folder, the overview `plan-overview.md`, the cards of other slices, the check lines of other slices and the requirements cards are not passed: an executor that sees a neighbouring slice starts doing it along the way. Everything it needs from the neighbours is already written in the "Interfaces" block of its slice.

On an attempt to fix, the packet file stays the same; the end of the output of the failed check or the text of the conformance check finding, and the list of what has already been tried, go into the message itself.

## Task

```
Execute one slice of a plan. Reply in English. Below are the slice, its check lines, the shared constraints,
the technical decisions, the sections "Not doing" and "Out of scope" and the discrepancy rule.
Project root: <path>.

Rules:
1. Build only what is named in the slice. A neighbouring flaw, a generalization "for the future",
   an extra parameter, an item from "Not doing" or "Out of scope" — do not do it, even if
   it is one line.
2. Change only the files from the "Files" block of the slice. Another file is needed — do not edit it:
   return the status "need a file" with the path and the reason.
3. Take the names and signatures from the "Interfaces" block exactly as written.
4. Follow the way similar things are already done in the project. Before writing a function,
   look for a ready-made one.
5. You cannot ask the user. If the code differs from the plan — stop
   and return the status "discrepancy": expected (what is in the plan) / found (what is in the code, with the path) /
   why it matters. Do not bend the code to the plan or the plan to the code. This applies to a minor
   discrepancy too (a file moved, a name changed):
   the slice card is fixed by whoever started you, not by you, — even if the plan rule says "fix it in place".
6. Run the commands from the check lines passed to you. It does not pass and you do not know why — return "could not" with the output
   instead of writing a workaround. Fix the code, not the check: do not change the expected value
   to fit the code, do not disable or skip the test. The check contradicts the slice or
   passes only if the code is fitted to it with a special case — stop
   and return "discrepancy": do not touch the check and do not fit the code to it.
7. Do not commit. Do not edit the cards of the plan and of the wiki, do not write to the wiki.
8. Take the ready-made code from the "Reuse" field of the slice and from the list of what was created earlier
   instead of writing it anew. The list does not replace a search in the project: rule 4 applies.
   A line of your own topic's block with your slice number is your own code: you may edit it.
9. Do not write tests and checks beyond the check lines passed to you.
10. Do not fix a flaw outside the slice: name it in the NOTICED field.

Return exactly in this form:

STATUS: done | discrepancy | need a file | could not
CHANGED: <paths from the project root>
CREATED: <paths from the project root>
EXPECTED / FOUND / WHY IT MATTERS: <only for a discrepancy>
NEED A FILE: <the path and what for — only with this status>
FUNCTIONS CREATED: <name(signature) — file, one per line; created none — "none">
NOTICED: <file:line — what is wrong; did not fix it; nothing to name — "none">
PITFALLS: <a non-obvious fact or a pitfall you ran into: what and where; nothing to name — "none">

The packet lies in the file <packet path>: read it in full before anything else.
```
