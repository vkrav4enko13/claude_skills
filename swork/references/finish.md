# Conformance check. Simplification. Review

Read at step 5, after this agent's last slice; sections 6 and 7 apply its findings in order before the report. Worktree mode: `references/worktree.md`, "Stages and the end".

## 5. Conformance check

**Who runs stages 5–7** — the agent that claims `<topic folder>/.stage` by `references/agents-rules.md`, "When to claim":

- code 3 — `wait` by "Waiting", claim again;
- claimed, "Next step" in `state.md` is "user's choice after the report" — `release`, the short report of `references/report.md`, stop;
- claimed, another live claim in `agents.sh busy --topic <topic>` — `agents.sh release --all`, a short report naming that agent, stop;
- claimed, no other live claim — stages 5–7 and the final report; release `.stage` just before it.

Record "stage 5 started", "stage 5 finished" and so on for stages 5–7 ("stage 7 finished [<name>]" where agents are marked); `stage 7 finished` is the batch's last line. In this form, not as free text.

**First — all the checks anew.** Run the checks of all "done" slices and the command lines of "awaiting manual check" ones, each distinct command once. Red — steps 5 and 6 of section 3 of `references/slices.md` for its slice; red after two — "Decisions and bypass" there. `not checked` counts as manual-check only.

**Only when the work changed code.** Code: scripts, programs, source files; not texts, documents, cards, settings. No code changed — after the checks skip stages 5–7 and the subagent; write `stages 5–7 skipped: no code`, then `stage 7 finished`.

**Bypassed and dependent slices.** Add to the stage 5–7 and review round 2 messages: `Bypassed, not to be reported as missing or wrong: S<N> — <files>`. Drop findings on them or a bypassed one's half-made edits, no fix or restore; name them in "Deviations from the plan".

**One fresh read-only subagent** that has not seen the conversation gets in one message the tasks of `references/conformance.md` and `references/review.md`, and the header and both tasks of `references/simplify.md`; description `Conformance, simplify and review of <topic>`. Add: each task's rules hold only inside it; one list, findings tagged `missing`, `beyond the plan`, `wrong` (stage 5), `reuse`, `redundant` (stage 6) or `error` (stage 7); read the changes and what they refer to, no wider (duplicate and redundancy tasks search the whole project).

Check each finding in the code yourself; a slice done before the edits is rightly untouched. Checkpoint `stage-5` by `references/snapshot.md`; each edit under a claim of its files by `references/agents-rules.md`. In order:

1. **"missing" and "wrong"** — an attempt for the owning slice by step 6 of section 3, by its build path; an executor gets the finding text, not the failed output. Recheck in the code. Not closed in two — report it unclosed; edits stay while the slice check is green. No stop.
2. **"beyond the plan"** — revert only the superfluous file or piece; run the affected slices' checks.
   - Passed — removed, a report line.
   - Failed — restore from `stage-5`, report it.
   - An affected slice manual-check only or `not checked` — keep it, report it.

A file outside all lists affects every "done" and "awaiting manual check" slice; no copy in `base/` — the table "What to do with a found file outside the plan" from `references/snapshot.md`.

What the reviewer could not check goes to the report as is.

Check the READ line against the changed and new files: a missing one goes into "Not read by the reviewers" with who skipped it — the stage 5–7 pass or review round 2 (checked only against the fixed files).

## 6. Simplification

Findings: `reuse` and `redundant` of the stage 5 pass. No own subagent, no efficiency or style. A finding on a place the conformance edits changed — recheck in the code.

Findings lost (interrupted after stage 5) — before editing give one fresh subagent the header and both tasks of `references/simplify.md` and the task of `references/review.md`, same description; its READ line is not checked against the full list.

Checkpoint `stage-6`; a red batch check while another agent has a live claim — rerun by step 5 of section 3 of `references/slices.md`, no restore. Edit within "What not to touch" of `references/simplify.md`.

**Batches.** Findings of slices sharing files, also by a chain, form one batch; then its slices' checks. Red — restore the batch files from `stage-6`, report the findings as untouched. A batch slice manual-check only or `not checked` — apply nothing, report the findings.

Skip, without asking, a false finding or one "What not to touch" forbids; count them in the report.

## 7. Review

Reread `references/review.md` if out of context: screening, "Second round" (a new subagent, only after a fixed serious finding). Findings: `error` of the same stage 5 pass, made before the stage 5 and 6 edits — recheck one on a changed place. Checkpoint `stage-7`; batches and a red check as in section 6.
