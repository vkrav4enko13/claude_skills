# Preparation. Slices

Read at step 2, after the entry; it holds step 3 too.

## 2. Preparation

By `references/snapshot.md`:

1. whether the project root is under git; `agents.sh mode` not `off` — the mode by `references/modes.md`;
2. the snapshot folder `.swork/` in the topic folder; under git list the files changed at the start;
3. this agent's time marker `<snapshot>/agents/<id>/marker`, `<id>` from `agents.sh id`; a continuing agent adopts the oldest;
4. the exclusions for the search for unreported edits: name them in the chat before the first slice, put them into the "Progress log" batch.

Mark the start: phase `execution in progress` and the next step into `state.md` and the topic's "In progress" line of the root index, which then follows `state.md`; already so — leave it. Write `state.md`, "Progress log", slice statuses, `created.txt`, `new-files.txt` under a short claim of the file (`claim`, write, `done`) — `references/agents-rules.md`, "When to claim" and "After a write".

Before the first slice compare the plan line "Checked against code" with the code; name discrepancies (slice files changed since). No stop: a done slice stays done, stage 5 takes it.

The wiki is not kept — `references/wiki-rules.md`, section "The wiki is not kept"; say so in the report.

Order the slices by their "Depends on", not by number.

**Picking a slice.** Free: not `done`, `bypassed` or held, and every slice of its "Depends on" `done`, `awaiting manual check` or `not checked`. Held: its card is in `agents.sh busy --topic <topic>`. Claim its card alone (`references/modes.md`); code 3 — next free slice. None free — having done a slice of this topic: `references/finish.md`, section 5; otherwise `wait` on this topic's lowest-numbered held slice, then pick again. Dependents of a `bypassed` slice are gone, never waited for.

## 3. Slices

An agent executes its slices **one at a time**; two agents never edit one slice: the claim decides.

**The check of a slice** — the commands of its lines in the check cards (`plan-checks.md` and parts), numbered in its "Checks" field. Green — all its command lines green; red — any red. A `checked manually` line is not run: "Manual check".

**Progress log** is the `progress.md` card in the topic folder: a line per record, appended in the batch of `SKILL.md`, "Rules for all stages". Set it up at the first batch as any card by `references/wiki-rules.md` (title, hook, topic-index line); full — `progress-2.md`. "Log" means a line into this batch.

Per slice: claim it ("Picking a slice"), read its card and check lines, do the steps; after step 7 — `agents.sh done "S<N>: <outcome>" <card> --topic <topic>`. This agent's "Progress log" lines start `S<N> [<name>]:`, not `S<N>:`; `<name>` — the second field of `agents.sh id`, whole. Stage records end with the mark: "stage 5 finished [<name>]".

1. **Copies.** Copy the slice files by `references/snapshot.md`, "Rollback" slices too. A missing "change" file is a discrepancy; never create it. Worktree mode: `merge --base` copies (`references/worktree.md`, "After a green step").
2. **The check before the edits** runs only to reproduce a bug the slice fixes or take a baseline of a behaviour it changes. Otherwise compare the slice with the code by "Files" and "Interfaces": done — run its check by step 5, "done", no rewrite; not done — step 3. A run check:
   - red because the slice is absent — go on;
   - red otherwise (error outside the slice files, unfit command) — a discrepancy;
   - green — done by the code: "done", no rewrite; not done with the `no behavior change` mark — go on; without it: "Decisions and bypass";
   - only a manual check — skip the step.
3. **The build.** Log "S<N>: started". Read `references/executor.md` (who builds) before the first slice. This session builds — its `discrepancy`, `need a file`, `could not` go as in step 4. A subagent gets the path of `<temporary folder>/packet-S<N>.txt` by "Packet" there, never the plan; shared mode — also (c) of `references/modes.md`.
4. **What the executor returned.**
   - `done` — step 5.
   - `need a file` (not in the slice's "Files") — moved or renamed: a minor discrepancy; otherwise "Decisions and bypass".
   - `discrepancy` — minor: fix it yourself (below); otherwise "Decisions and bypass".
   - `could not` — a failed attempt, step 6.
5. **The check by the main session.** Run the check yourself and read the changes by the snapshot: only output obtained now sets "done", never a report. A check made green by cheating (expected value rewritten, test disabled or skipped) is red. After every build, whatever the check gave, find unreported edits by `references/snapshot.md`. Red while `agents.sh busy` finds another live agent — not an attempt: rerun by (f) of `references/modes.md`. Worktree mode: the check runs in `WT`, the changes are `git -C "$WT" diff HEAD`, the search is by `references/worktree.md`, "Executor and checks".
6. **A red check.** Fix by the path of step 3 — this session, or the executor with the same packet file plus the failed output's end and what was tried. **Two** attempts, then "Decisions and bypass". Runs after a red check or `could not` count; the first build and reruns after a minor discrepancy or by step 5 do not. Log each attempt: "S<N>: attempt 1 of 2 — what was tried, how it ended"; before the second add which assumption could be wrong. Failed edits stay until the decision.
7. **Status.** At once, the slice status: `done` — all command lines green, no "checked manually" line; with one — `awaiting manual check` ("Manual check"). Into the batch: a "Progress log" line (slice, outcome, check line numbers, output files) and the `state.md` "Next step".
8. **Records in the wiki.** Green — into the batch, as `notes/` cards, the non-obvious facts and pitfalls the slice confirmed: the executor's PITFALLS, checked against the code, and what you saw. Threshold and order — `references/wiki-rules.md`, section "Writing". A pre-existing note — copy it into the snapshot's `notes/` first, never over an existing copy. Log "Written to the wiki: <card path from the wiki folder> — new" or "… — extended"; nothing written — no line.

**What was created and what was noticed.** Add "FUNCTIONS CREATED" to the snapshot's `created.txt` as `S<N>: name(signature) — file`, no repeats. After an attempt to fix recheck this slice's earlier lines: function gone — remove; signature changed — replace. Log NOTICED as "S<N>: noticed outside the slice — <the place and the essence>".

**A minor discrepancy** — a file moved or renamed, a name changed, same meaning. You fix it, not the executor: in place in every card naming it; copy the file, log it, rerun step 3. Any other — "Decisions and bypass".

**Manual check.** Run the slice's other lines; a `checked manually: <steps>` line gets `awaiting manual check` in "Result", the slice too. With dependents — "Decisions and bypass"; without — go on, list it in the report. Only the user's word makes it "done".

## Decisions and bypass

The cases of section 4 of `SKILL.md`, decided without waiting: each — the `⚠` chat line and the log line of section 4, then the next step.

**An own edit of the card.** In the first three cases of the section 4 table — edit this slice card and its check lines in place: a path, a command, "Files". Never "Expected" or a scenario value. Log first `S<N>: card edit — was: <…>; became: <…>; why: <…>`. At most two per slice. After one the attempt count restarts: copy newly named files, rerun from step 2.

**Bypass.** Both edits used, still not done — `bypassed`.

- Shared mode — `references/modes.md`, "Shared mode" (g), never from `base/`; worktree mode — `references/worktree.md`, "Bypass"; otherwise the next item.
- Never `done` before: restore from `base/` its files no other run (`done`, `awaiting manual check`, `not checked`) or held slice names, delete its `new-files.txt` files no such slice names. Once `done`, or with "Rollback": restore nothing.
- **Dependent slices** name it in "Depends on", directly or by a chain, or share a "Files" file. They stay `not started`, unexecuted.
- **Everything else is executed.** Stages 5–7 follow the last slice neither bypassed nor dependent, also when none is left; reviewers' notes on such slices — `references/finish.md`.

**The irreversible.** A "Rollback" slice: by the section 4 row; saving fails — `bypassed` at once, no card edit.

**The environment.** Cannot run — by `SKILL.md`, "How to run a check"; log `S<N>: not checked — <reason>`. A `not checked` slice counts as one with only a manual check.

**A manual check with dependents.** Each dependent is logged `S<N>: on unchecked ground — S<M> awaits manual check`. Only the user sets "done" for the manual check.
