# Entry: kinds of entry and continuation

Read at step 1, after the phase table.

| Entry | What to do |
|---|---|
| **A plan in the topic folder** from `splan` | Read `plan.md` and its parts, `plan-decisions.md` if any, check cards `plan-checks.md`, `plan-checks-<group>.md`. Slice card `plan-s<N>-<name>.md` with parts `plan-s<N>-<name>-2.md` — in full when the slice starts, before that only "Status" and "Depends on". A slice without a `- **Status:**` line — add `- **Status:** not started` under the hook; a slice part ("part 2" in the title) needs none. `scope.md` or parts `scope-<part>.md` — their "Out of scope"; no `scope.md` — the `## Scope` section of `requirements.md`. Never read `plan-overview.md`. |
| **A plan of the earlier form, as a single file** — not as cards in the topic folder | Do not execute or work from it: name the format earlier, offer `splan` to turn it into cards |
| **A plan from the chat** (direct or a short result of `splan`) | By "Small change" |
| **A task without a plan** | Only if named, made and checked in one pass: say in two sentences what you change, where and what checks it, then do it at once, without consent, by "Small change". Larger — do not execute or plan: name what is missing, offer `splan`, stop |

"Small change" is `references/small.md`: read it before the first edit.

**Continuing interrupted work.** Signs: `state.md` has `execution in progress`, a slice status is not "not started", "Progress log" (`progress.md`) has records, or `.swork/` is in the topic folder. Next step "user's choice after the report" — repeat no slice or stage: show the report from "Progress log" by `references/report.md`, ask the choice. Otherwise continue from the first slice (by "Depends on") not done: `done`, `bypassed`, `awaiting manual check` and `not checked` slices stand, not rerun; dependents of a `bypassed` one are not executed; no slice left — stage 5.

**Assumptions.** A slice named in a line of the plan's "Assumptions", or a line with "all" — name the assumption just before the slice; not a stop: do not wait for an answer.
