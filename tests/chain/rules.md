# Rule lists for checking the traces of a run

> A rule is one statement that can be seen in the traces of a run: in the chat, in the tasks and replies of subagents, in the topic cards, in the project files.

A rule line: the number, the rule itself and, after the dash, the place in the skill text it is taken from: the file and the line.

## sbrain

- sbrain-1. The topic folder holds six cards: `00-index.md`, `state.md`, `task.md`, `requirements.md`, `decisions.md` and `scope.md` — sbrain/references/topic-cards.md:21
- sbrain-2. The requirements are written in `requirements.md` as lines `- R<N>. …` with continuous numbers in the order of the summary — sbrain/references/topic-cards.md:14
- sbrain-3. The condition of a requirement stands at its start: "When", "While", "If" or "Where" — sbrain/references/topic-cards.md:85
- sbrain-4. The requirements do not have the word "system": the actor is named — sbrain/references/topic-cards.md:86
- sbrain-5. No addition of its own that nobody named has got into the requirements, the decisions and the success criteria: an action log, a switch, a notification, an extra safeguard — sbrain/references/synthesis.md:47
- sbrain-6. Every line of `decisions.md` names what was chosen, instead of what, why, whose decision it is and the status — sbrain/references/topic-cards.md:25
- sbrain-7. "Out of scope" from the summary is written into `scope.md` — sbrain/references/topic-cards.md:18
- sbrain-8. `work/00-index.md` has the topic's line: a link to `<topic>/00-index.md` and the essence of the topic — sbrain/references/topic-cards.md:108
- sbrain-9. The user's words that hold for the whole project are written as a line in the wiki's `rules.md` — sbrain/references/topic-cards.md:110
- sbrain-10. The journal has one line of the topic's chain: `sbrain` writes it once and does not touch it after the "yes" to the cards — sbrain/references/topic-cards.md:111
- sbrain-11. After the user's "yes" to the cards `sbrain` sets the phase of the topic to `requirements confirmed` — sbrain/references/topic-cards.md:61
- sbrain-12. `sbrain` does not write product code and does not call implementation skills — sbrain/SKILL.md:22
- sbrain-13. Replies to the user in the chat are in the language the user writes in; wiki cards, their format strings, and tasks to and replies from subagents are in English; the prose of the plan overview is in the language of the user. — sbrain/SKILL.md:12
- sbrain-14. The handoff menu of a result written into the topic folder names first the option that starts `splan` in a new session and gives the lines to paste — sbrain/references/handoff.md:16

## splan

- splan-1. For a topic with a folder the plan is written as cards in the topic folder — splan/references/recon.md:13
- splan-2. Every slice has its own card `plan-s<N>-<name>.md` — splan/references/plan-format.md:20
- splan-3. The plan header `plan.md` has the line "Checked against code": the commit and the branch, or the date and time of the check — splan/references/plan-format.md:36
- splan-4. `plan.md` has the section "If the code differs from the plan" — splan/references/plan-format.md:57
- splan-5. `plan-decisions.md` has the sections "Technical decisions" and "Check focus" — splan/references/plan-format.md:18
- splan-6. Every line of "Check focus" is assigned to a slice, and a check line of that slice is set up for it — splan/references/review.md:14
- splan-7. The check lines lie as a table with the columns "No.", "Requirement", "Scenario", "Command", "Expected", "Slice", "Result" — splan/references/plan-format.md:94
- splan-8. Every requirement of the topic has a check line, and its scenario checks exactly that requirement; one line may name several requirements that one command checks (R11) — splan/references/review.md:9
- splan-9. Every check line names a command with the expected result or the words `checked manually: <steps>` — splan/references/slicing.md:7
- splan-10. An end-to-end check line, which checks the goal of the plan as a whole, has the word "goal" in the "Requirement" column — splan/references/plan-format.md:101
- splan-11. Every check line has exactly one slice in the "Slice" column — splan/references/plan-format.md:107
- splan-12. Every slice has at least one check line — splan/references/slicing.md:22
- splan-13. The plan has no slice that the requirements did not ask for — splan/references/slicing.md:32
- splan-14. Every slice names which slices must be done before it, or "none" — splan/references/slicing.md:28
- splan-15. The "Files" block of a slice names every file with the mark "create" or "change" — splan/references/plan-format.md:138
- splan-16. "What to do" of a slice has no lines that decide nothing: "add the needed check", "handle the edge cases", "write tests for this" — splan/references/plan-format.md:139
- splan-17. The "Checks" field of a slice card names the numbers of the check lines, not scenarios and commands — splan/references/plan-format.md:140
- splan-18. The "Reuse" field of a slice is not empty: it holds a list of the ready-made code or the words "nothing to reuse" and where the search went — splan/references/plan-format.md:142
- splan-19. In a project without tests the plan sets up no tests: a command with the expected result or a manual scenario serves as the check — splan/references/slicing.md:14
- splan-20. The plan has no concession words "temporarily", "a stub", "in the first version", "simplified" where the requirements did not permit it — splan/references/review.md:15
- splan-21. The topic index has a line for every plan card — splan/references/plan-format.md:183
- splan-22. Before it is shown to the user, a large plan in cards (more than three slices or a slice of larger code) is read by a separate agent that has not seen the conversation, with the description `Plan review of <topic>`; a small plan is shown with `no fresh reviewer: small plan` (R11) — splan/references/review.md:24
- splan-23. The task for the plan reviewer of a large plan has no arguments of the author and no conclusion "the plan is good" (R11) — splan/references/review.md:26
- splan-24. After the user's "yes" to the plan `splan` sets the phase of the topic to `plan confirmed` — splan/references/plan-format.md:203
- splan-25. `splan` does not execute the plan: there is no product code in the project after it — splan/SKILL.md:22
- splan-26. Replies to the user in the chat are in the language the user writes in; wiki cards, their format strings, and tasks to and replies from subagents are in English; the prose of the plan overview is in the language of the user. — splan/SKILL.md:12
- splan-27. The handoff menu of a plan written into the topic folder names first the option that starts `swork` in a new session and gives the lines to paste — splan/references/approval.md:39

## swork

- swork-1. A slice of larger code of a plan in the topic folder is executed by a separate fresh subagent; a slice without code or with small code (one file, up to about 20 changed lines) is built by the main session (R8) — swork/references/executor.md:5
- swork-2. The executor gets the packet of its own slice only: its task has no cards of other slices — swork/references/executor.md:21
- swork-3. The executor's packet, given only for a slice of larger code (R8), holds the check lines of its slice together with the header row of the table — swork/references/executor.md:12
- swork-4. The exclusions for the search for unreported edits are named in the chat before the first slice and written into "Progress log" with the batch (R9) — swork/references/slices.md:13
- swork-5. "Progress log" is kept as the card `progress.md` in the topic folder, and the topic index has a line about it — swork/references/slices.md:31
- swork-6. A slice gets the status "done" after a check that the main session ran itself after the build — the executor's reply or its own build (R8) — swork/references/slices.md:47
- swork-7. The "Result" column of a check line with a command holds `green YYYY-MM-DD` or `red YYYY-MM-DD` — swork/SKILL.md:75
- swork-8. Every attempt to fix is written into "Progress log", in the batch, as a line "S<N>: attempt <k> of 2" with what was tried and how it ended (R9) — swork/references/slices.md:48
- swork-9. The executor and the reviewers do not write to the wiki: only the main session edits the cards — swork/SKILL.md:76
- swork-10. `swork` adds nothing beyond the plan: no neighbouring edits, no generalizations "for the future", no items from "Not doing" — swork/SKILL.md:28
- swork-11. The start and the end of every stage 5–7 that was passed are written into "Progress log" with the words "stage <N> started" and "stage <N> finished"; stages 5–7 skipped — the record `stages 5–7 skipped: no code`; `stage 7 finished` is the last line of the batch either way (R7, R9) — swork/references/finish.md:14
- swork-12. When the work changed code, the conformance check, the simplification and the review tasks are read in one message by one fresh read-only subagent that has not seen the conversation (R7) — swork/references/finish.md:22
- swork-13. The conformance check task has no executors' reports and no conclusion "everything is done" — swork/references/conformance.md:12
- swork-14. A confirmed finding of the conformance check, "missing" or "wrong", is fixed by the same path as the build of the owning slice: for larger code by its executor, which gets the packet of the slice and the text of the finding; for small code or none by the main session (R8) — swork/references/finish.md:26
- swork-15. What is confirmed as "beyond the plan" is removed from the code if the checks of the affected slices are green after that — swork/references/finish.md:27
- swork-16. A changed or new file that is not in a reviewer's READ line is named in the report, in "Not read by the reviewers" (in the user's language) — swork/references/finish.md:36
- swork-17. The review is read by the same subagent as the conformance check, in one pass; a new subagent reads only the second round (R7) — swork/references/finish.md:22
- swork-18. Every declined finding of the review is named in the report as a line: what was proposed and why it was declined — swork/references/review.md:62
- swork-19. A second round of the review, by a new subagent, goes only if a serious finding was fixed (R7) — swork/references/review.md:66
- swork-20. For every slice the report names the status, the commands of its check lines and the end of the output of each — swork/references/report.md:11
- swork-21. The report has the section "Deviations from the plan" (in the user's language): there was not a single one — it holds the words "the plan was executed as written" — swork/references/report.md:18
- swork-22. Every finding in the report section "Found and left untouched" (in the user's language) is named with the reason why it was left untouched — swork/references/report.md:22
- swork-23. After "accept the work" (in the user's language) `state.md` holds the phase `done` and the next step "none — work accepted" — swork/references/report.md:52
- swork-24. After "accept the work" (in the user's language) the tail of the chain's journal line is `done: <the outcome in one phrase>`, and the journal has no second line of the topic — swork/references/report.md:53
- swork-25. After "accept the work" (in the user's language) the topic's line is not in "In progress" of the root index — swork/references/report.md:54
- swork-26. Replies to the user in the chat are in the language the user writes in; wiki cards, their format strings, and tasks to and replies from subagents are in English; the prose of the plan overview is in the language of the user. — swork/SKILL.md:12

## saway

- saway-1. Before its first message `saway` reads the topic's `state.md` and its plan, so the progress line of that message has the numbers — saway/SKILL.md:37
- saway-2. Every chat message and the full description are in the language the user wrote in before leaving — saway/SKILL.md:12
- saway-3. Every chat message ends with a progress line `Progress: slices <done>/<total> · now: … · ahead: …`, shown in the user's language — saway/SKILL.md:21
- saway-4. `saway` asks the user no question: it does not call the blocking question tool and does not end a turn with a question — saway/SKILL.md:16
- saway-5. No commit, push, branch or merge request is made while the user is away — saway/SKILL.md:28
- saway-6. Every decision made for the user is recorded in `away.md` of the topic folder as a line `- <question> — chosen: <what>; why: <argument>; otherwise: <what would change>`; an edit of a plan or a card the user approved — except the own slice-card edits of `swork` by its section 4, which stay in its progress log — as `- <card>: <what> — was: <…>; became: <…>; why: <argument>; otherwise: <what would change>` — saway/SKILL.md:98
- saway-7. Every bypassed item is recorded as a line `- bypassed: …` under `## Waiting for the user` of `away.md` and, for a slice, as a line `S<N>: bypassed without the user — <reason>` in "Progress log" — saway/SKILL.md:89
- saway-8. A slice with a "Rollback" section executed without the user goes under `## Waiting for the user` of `away.md` as `- executed without the user: S<N> <title> — rollback: <the command>` — saway/SKILL.md:27
- saway-9. Small work (the "Small" path, a plan from the chat, no topic folder, or a topic of at most five requirements whose plan is not large) runs in the session of `saway`; for the rest every stage is run by a fresh subagent with the description `Stage <skill> of <topic>` (R12) — saway/SKILL.md:61
- saway-10. `saway` never sets the phase `done` and does not accept, fix or roll back the work after the `swork` report — saway/SKILL.md:32
- saway-11. A decision made for the user is not passed off as the user's: in the topic cards it is an assumption, not "user chose" — saway/SKILL.md:92
- saway-12. The last line of the full description is word for word `saway: work finished` or `saway: work stopped — waiting for the user` — saway/SKILL.md:116
