# Conformance check

Read at step 5 by `references/finish.md`, section 5. The main session's own checklist: only whether the plan was done; errors inside the plan are for review.

Read `git diff`, the new files and the slice cards; a plan without "Files" blocks (chat, a task in words) — its text and the places it names. Three kinds:

1. **missing** — asked for by the plan, absent or partial; also an untouched file of a slice "Files" block, and a check line whose scenario nothing in the changes handles.
2. **beyond the plan** — a file in no "Files" block changed or created; a generalization, parameter, setting or extension point for a need not in the plan; anything from "Not doing" or "Out of scope".
3. **wrong** — done, but not that way: another name, signature, value, place, or the slice's "What to do", "Interfaces" or a check line violated.

A finding rests on a card line, named with the card; without one it is opinion, dropped. A slice done before the edits is rightly untouched. Explanations in code or reports do not soften a finding.
