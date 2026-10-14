# Requirements of topic sbrain-quality

> A stand-in user, two new stand stages, judge rules and seeds for them, and text fixes of `sbrain` accepted by numbers.

- R1. The stand holds a persona file: the stand-in user's goal, the facts they know, and five decisions they hold, each a numbered decision seed.
- R2. When `sbrain` asks a question on the stand, a stand-in user session answers it from the persona file alone, in Russian; it runs at `xhigh`, like the judge.
- R3. The stand has a stage `survey`: `sbrain` starts from a raw idea in the persona's words, and the stand-in user answers every turn until the topic phase is `requirements confirmed` or twelve answers are given.
- R4. The stand has a stage `grill`: the project holds a ready plan with five planted flaws, each a numbered flaw seed, and `sbrain` is started on it as "grill my plan"; the stand-in user answers its questions.
- R5. The judge checks the survey by rules taken from the `sbrain` texts: a hypothesis with a confidence percent before the first question, a recommendation in every question, at most four questions in a round, the tree counter from the second round, no question whose answer lies in the project files, no addition nobody asked for.
- R6. The judge marks every decision seed carried or not carried into the topic cards, and every flaw seed named or not named in the grill; the stand prints per series the rule violations, the decision seeds carried and the flaw seeds named.
- R7. The stand-in user and the judge do not see each other's prompts, and the judge does not see the persona's seeds list until it rates.
- R8. A baseline series of three runs of the stages `survey` and `grill` runs on the present `sbrain` texts at `medium`.
- R9. Text fixes of `sbrain` are accepted only by a series of the same stages that is not worse than the baseline on all three numbers and better on at least one; at most two rounds of fixes.
- R10. If `sbrain` texts were changed, then a full chain series passes the gate against `en` before the texts reach the Mac profiles.
- R11. The chain runs at `medium` throughout; no fix raises the effort.
- R12. The final report gives the three numbers of the baseline and of the final series, and the cost of one series in output tokens.
