# Entry: kinds of entry and continuation

Read at step 1, after the phase table.

| Entry | What to do |
|---|---|
| **A plan in the topic folder** from `splan` | Read `plan.md`, `plan-2.md`, `plan-decisions.md`, check cards `plan-checks.md`, `plan-checks-<group>.md`. Slice card `plan-s<N>-<name>.md` with parts `plan-s<N>-<name>-2.md` — in full when the slice starts, before that only "Status" and "Depends on". A slice without a `- **Status:**` line — add `- **Status:** not started` under the hook; a slice part ("part 2" in the title) needs none. `scope.md` or parts `scope-<part>.md` — their "Out of scope". Never read `plan-overview.md`. |
| **A plan of the earlier form, as a single file** — not as cards in the topic folder | Do not execute or work from it: name the format earlier, offer `splan` to turn it into cards |
| **A plan from the chat** (direct or a short result of `splan`) | By "Small change" |
| **A task without a plan** | Only if named, made and checked in one pass: say in two sentences what you change, where and what checks it, then do it at once, without consent, by "Small change". Larger — do not execute or plan: name what is missing, offer `splan`, stop |

"Small change" is `references/small.md`: read it before the first edit.

**Continuing interrupted work.** Signs: `state.md` has `execution in progress`, a slice status is not "not started", "Progress log" (`progress.md`) has records, or `.swork/` is in the topic folder. Next step "user's choice after the report" — repeat no slice or stage: show the report from "Progress log" by `references/report.md`, ask the choice. `execution in progress` and live claims in `agents.sh busy --topic <topic>` — a join, not a continuation: create this agent's marker, pick a free slice by `references/slices.md`, skip the steps below. Worktree mode: a join or continuation starts with `references/worktree.md`, "Mode"; a dead worktree — "Stages and the end" there. Otherwise, before the first slice:

- find files outside the plan changed since the last session by `references/snapshot.md`, against the adopted marker: foreign edits into `known.txt`, one `⚠` line; never ask whose;
- rerun only the checks of "done" slices and the command lines of "awaiting manual check" slices whose files changed after their check, each distinct command once; changed — a "Files" file newer than the slice's output in the snapshot's `checks/`, else than its "Result" date; a foreign edit found above counts. Others keep their "Result" until the rerun of `references/finish.md`. Red — an attempt by step 6 of section 3; red after two — a card edit by "Decisions and bypass" of `references/slices.md`, then `bypassed`, no restore; its `done` dependents stay `done`, reported as built on a broken one. No next slice until decided;
- adopt the oldest marker by `references/snapshot.md`; never move the existing markers or touch the snapshot's copies and checkpoints.

Next — by statuses and "Progress log":

- `bypassed`: never started, retried or asked about; dependents not executed;
- "done" — never redone;
- a live claim (card in `agents.sh busy --topic <topic>`) — another agent's: skip;
- a "started" record without an outcome, claim dead or none — its files hold past edits: step 2 of section 3; logged attempts count; an own card edit restarts the count. A "Rollback" section: find by the code what ran; unclear — `bypassed`, redo neither saving nor action;
- a legacy "stopped" slice — red after two attempts: "Decisions and bypass" of `references/slices.md`;
- an "awaiting manual check" slice is not rerun; its check unreported by the user — `not checked`;
- "stage started" without "stage finished", no live claim in `agents.sh busy --topic <topic>` — restore that stage's checkpoint, redo the stage.

A snapshot, all statuses "not started", no records — continue with it, a `⚠` line. Never delete the snapshot.

**Assumptions.** A slice named in a line of the plan's "Assumptions", or a line with "all" — name the assumption just before the slice; not a stop: do not wait for an answer.
