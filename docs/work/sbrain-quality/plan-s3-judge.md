# S3. The judge of a survey run

> The blind judge rates a survey run by survey rules and counts the persona decisions carried and the plan flaws named.

- **Status:** done
- **Covers:** R5, R6, R7
- **Depends on:** S2
- **Files:**
  - create: `tests/chain/judge-survey-prompt.md`, `tests/chain/rules-survey.md`
  - change: `tests/chain/judge.sh` (`pack`, the prompt choice)
- **Interfaces:**
  - takes: the stage folders `survey` and `grill`, the projects `surveybox/…` and `grillbox/…` (S1, S2)
  - gives: a verdict of lines `rule⇥sv-<N>⇥…`, `decision⇥decision-<N>⇥carried | not carried⇥…`, `flaw⇥flaw-<N>⇥named | not named⇥…`
- **Reuse:** `tests/chain/judge.sh` as a whole; `tests/chain/judge-prompt.md` — the form of the prompt and of the answers
- **What to do:**
  - `rules-survey.md`, section `## sbrain survey`: sv-1 a hypothesis with a confidence percent before the first question; sv-2 every question has a recommendation; sv-3 at most four questions in a round; sv-4 the tree counter from the second round; sv-5 no question whose answer lies in the project files or the wiki; sv-6 no requirement, decision or criterion nobody named; sv-7 on the grill, the plan's claims about the code are checked before the questions. Each line ends with ` — <sbrain file>:<line>` of its sentence.
  - `judge.sh`: a run with a `survey` or `grill` folder is packed with `chat-survey.md`, `chat-grill.md`, `agents-…/`, `project-survey/`, `project-grill/` (as the other projects, without `.claude/` and `.swork/`), `rules-survey.md`, `seeds-survey.md`, and judged with `judge-survey-prompt.md`; the persona files are not copied. Other runs — as now.
  - `judge-survey-prompt.md`: the structure of `judge-prompt.md`; sv-1, sv-4, sv-6 against `survey`, sv-7 against `grill` (elsewhere `not applicable`), sv-2, sv-3, sv-5 against both — violated at either, violated. The rule lines are written first; `seeds-survey.md` is read only after the rule lines are written. A decision is `carried` when the topic cards of `project-survey/` hold it; a flaw is `named` when `sbrain` named it in `chat-grill.md` or fixed it in `project-grill/plan-shortest.md`.
  - Then `bash tests/chain/series.sh sv-smoke . --runs 1 --stages grill` (the run `sv-smoke/1` gets its grill stage), then `bash tests/chain/judge.sh sv-smoke`.
- **Checks:** lines 6, 7, 8
