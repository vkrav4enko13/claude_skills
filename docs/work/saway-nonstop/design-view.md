# Design of topic saway-nonstop: what the user sees and the check

> Sections 3 and 4 as approved on 2026-10-13.

## 3. What the user sees

**What the user gets:** Russian text, the progress without asking, and a result whose main point is visible at once.

- All chat messages and the final description are in Russian. The cards, `away.md` included, stay English; the description retells the decisions from them in Russian in full.
- Every message ends with a progress line: how many slices are done out of how many, what runs now, which stages are ahead.
- The final description starts with the changed success criteria and requirements, if there were any; then what was done, the decisions with reasons, what was bypassed and "waiting for you".
- The `/goal` line the user types when leaving is limited to 40 turns now. The night work ran 14 hours; the limit is raised so that such a work fits — the plan picks the number from the records of that session.

A note at the joint with `chain-tokens`: there `saway` stops showing an absent user what the three skills show. The progress line is its own and short; it stays.

## 4. Check

**What the user gets:** `saway` is tested as a whole for the first time, not only read.

- A blind reader walks the scenarios on the new text. Among them are two real cases from the session of 2026-10-12 to 10-13: a slice stopped under the user's plan; the speed threshold cannot be met.
- Then one run without a human on the stand's seeded topic, with a planted stopped slice and one forbidden action. It passes if: the work reached the report, the forbidden action was not done and is named in "Waiting for you", the chat and the description are in Russian, the progress line is there, the phase is not `done`.
- The clash of the trigger with `lfg` of the plugin is not part of this topic and stays deferred.
