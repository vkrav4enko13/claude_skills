# Slice executor

Read at step 3 of section 3, before the first build.

A slice without code or with small code (one file, up to about 20 changed lines) — the main session builds it by the task rules below, no packet, no subagent, and records its FUNCTIONS CREATED, NOTICED and PITFALLS as from a reply. Larger code — a fresh subagent that knows only the packet and cannot ask the user.

## Packet

Run the script into a file: `bash <skill folder>/scripts/packet.sh <topic folder> <slice number> <project root> [<created.txt>…] > <temporary folder>/packet-S<N>.txt` — this topic's `created.txt` first, then the other topics' under `<wiki>/work/*/.swork/`, nothing else. Never retype the cards. No script — build the file by hand, in this order:

1. **Its own slice** — the card in full, with its parts.
2. **Its check lines** — the lines of the check cards numbered in the slice's "Checks" field, with the table's header row.
3. **Shared constraints** and **Not doing** — sections of `plan.md` and its parts.
4. **Technical decisions** — the `plan-decisions.md` card.
5. **Out of scope** — the section of the topic's `scope.md` or part `scope-<part>.md`, if any.
6. **The rule "If the code differs from the plan"** — the last section of `plan.md` or its last part.
7. **The project root** — the full path.
8. **What was created earlier** — each `created.txt` in the order above, a block under `=== created earlier: <file> ===`, this topic's marked `(this topic)`: lines `S<N>: name(signature) — file`, no function text. A missing file — no block.
9. **The code map** — after the project root, under `=== code map ===`: the output of `bash <skill folder>/scripts/codemap.sh <project root>`; it fails — no block.

Never pass the topic folder path, `plan-overview.md`, other slices' cards or check lines, or the requirements: what it needs of the neighbours is in its "Interfaces" block. An attempt to fix reuses the packet file.

## Task

```
Execute one slice of a plan. Reply in English. Project root: <path>.
The packet holds the slice, its check lines, constraints, decisions, "Not doing", "Out of scope", discrepancy rule.

Rules:
1. Build only what the slice names: no neighbouring fix, generalization "for the future", extra parameter,
   or item of "Not doing" or "Out of scope" — not even one line.
2. Change only the "Files" block's files. Another file needed — do not edit it: return "need a file"
   with the path and the reason.
3. Take names and signatures from the "Interfaces" block exactly.
4. Follow the project's way for similar things; look for a ready-made function before writing one.
5. You cannot ask the user. Code differs from the plan, even slightly (a file moved, a name changed) — stop,
   return "discrepancy": expected (plan) / found (code, path) / why it matters. Bend neither to the other;
   never fix the card, even if the plan rule says "fix it in place".
6. Run your check lines' commands. Fails for an unknown reason — return "could not" with the output,
   no workaround. Fix the code, never the check: no changed expected value, no disabled or skipped test.
   The check contradicts the slice or passes only with a special case fitted to it — stop, return "discrepancy";
   touch neither the check nor the code to fit it.
7. Do not commit. Do not edit plan cards or write to the wiki.
8. Reuse code from the slice's "Reuse" field and the created-earlier list; it does not replace a search
   (rule 4). A line of your topic's block with your slice number is your code: editable.
9. Write no tests or checks beyond your check lines.
10. Do not fix a flaw outside the slice: name it in NOTICED.
11. The message gives AGENTS=<path> TOPIC=<topic> SLICE=<slice> — right before writing a file run
   `bash <path> claim <file> --topic <topic>`, write it, then at once
   `bash <path> done "<slice>: <essence>" <file> --topic <topic>`. Code 3 — run
   `bash <path> wait <file> --topic <topic>` with a timeout of 600000 ms until code 0, then claim again;
   never ask. Write onto the text the claim shows: its diffs or, on `reread:` or `abandoned:`, the file
   read anew.
12. Run every command from the project root; edit only under it.

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
