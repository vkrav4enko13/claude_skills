# S6. Text fixes of `sbrain` by the numbers

> The `sbrain` texts behind repeated misses are fixed, and a series shows the survey is not worse and better somewhere.

- **Status:** done
- **Covers:** R9, R11
- **Depends on:** S5
- **Files:**
  - change: `sbrain/SKILL.md`, `sbrain/references/context.md`, `sbrain/references/survey.md`, `sbrain/references/synthesis.md`, `sbrain/references/topic-cards.md` — only the places behind a miss
  - change: `tests/chain/rules.md`, `tests/chain/rules-survey.md` (the tails)
- **Interfaces:**
  - takes: the verdicts of `sv-base`; gives: the file `$S/sv-final.current` — the name of the final survey series
- **Reuse:** the sentence of the rule the miss is about, in its file
- **What to do:**
  - A `no` line or a missed seed in two runs of `sv-base` or more is a miss; fix the sentence behind it so it says the act plainly, at the moment it is due. No new section, no effort.
  - No miss — write `sv-base` into `sv-final.current` and stop.
  - Otherwise first copy `sbrain/`, `tests/chain/rules.md` and `tests/chain/rules-survey.md` into `$S/sv-base/texts-before/`, fix, and run `sv-fix1` as S5 without its `git status` step; `survey-gate.sh sv-base sv-fix1` passed — write `sv-fix1`. Not passed — one more round as `sv-fix2` from its verdicts; passed — write `sv-fix2`; not passed — copy the texts back from `texts-before/`, write `sv-base`, reply `could not` with the numbers.
- **Checks:** line 12
