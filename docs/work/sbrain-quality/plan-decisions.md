# Technical decisions of topic sbrain-quality

> What the plan chose, instead of what and why; which failures and kinds of input it checks beyond the named ones.

## Technical decisions

- **A separate judge prompt, rules and seeds for the survey runs** (`judge-survey-prompt.md`, `rules-survey.md`, `seeds-survey.md`) — instead of extending the chain judge: the chain series stay comparable with `en`.
- **The stand-in user is a `claude -p` session per answer** with the persona and the last reply of `sbrain` in its prompt and no tools — instead of one long session: no memory of its own beyond what the chat shows, like a real user reading the chat.
- **A run ends on a new topic in `requirements confirmed` (survey only), on `END` from the stand-in user, on an error, or at the cap** — 12 answers for `survey`, 8 for `grill`; every end is measured, the reason lies in `ended.txt`.
- **The survey project is the clean stand project; the grill project is the clean project with `grill-longest.sh` as `longest.sh`** and the plan `plan-shortest.md` in its root — the plan's claims about the code can be checked, and no planted code defect gets in the way.
- **The verdict of a survey run has three kinds of lines:** `rule⇥sv-<N>`, `decision⇥decision-<N>⇥carried | not carried`, `flaw⇥flaw-<N>⇥named | not named`.
- **Text fixes are chosen from the verdicts** of the baseline: a `no` line or a seed missed in two runs or more is fixed; a single miss is noise.

## Check focus

- the stand-in user is asked something the persona does not cover → it answers «не знаю, решай сам», not an invented fact — S1, line 3
- `sbrain` never reaches the cards on the survey → the run ends at the cap with `cap` in `ended.txt` and is still measured — S1, line 2
- a survey run without a judge verdict → the survey gate says "no measurement", not passed — S4, line 9
