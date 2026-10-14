# S2. The stage `grill` with five planted flaws

> The stand gives `sbrain` a ready plan with five known flaws and lets the stand-in user answer its grill.

- **Status:** done
- **Covers:** R4
- **Depends on:** S1
- **Files:**
  - create: `tests/chain/grill-plan.md`, `tests/chain/grill-longest.sh`, `tests/chain/seeds-survey.md`
  - change: `tests/chain/persona.md` (a part for the grill), `tests/chain/drive.sh`, `tests/chain/collect.sh`, `tests/chain/series.sh`, `tests/chain/trace.sh` (the stage `grill`)
- **Interfaces:**
  - takes: `answer.sh`, the stage case of `drive.sh` (S1)
  - gives: the stage `grill`; the lane `grill` builds `$R/grillbox/wiki-trial/clean` by `stand.sh`, copies `grill-longest.sh` to `longest.sh` and `grill-plan.md` to `plan-shortest.md` in the project root; `seeds-survey.md` lines `- decision-<N>. …` and `- flaw-<N>. …`
- **Reuse:** `longest.sh` of `tests/chain/seed.sh:56-100` — `grill-longest.sh` is it without the planted defects: no `-a`, the message `no file app.txt` and code 2, `wc -m`, the last line read; `tests/chain/seeds.md` — the form of a seed line
- **What to do:**
  - `grill-plan.md`, in English: a plan to add a `-s` flag to `longest.sh` that prints the shortest word, its requirements, two slices and checks. Plant five flaws and list them in `seeds-survey.md`: flaw-1 the plan reuses a function `word_length` of `longest.sh` — the script has `length`; flaw-2 its requirement says an empty file prints an empty line, its step prints `0`; flaw-3 it is silent on which word wins a tie of the shortest length; flaw-4 a step "handle the errors properly" that decides nothing; flaw-5 the check of slice 1 needs the `README.md` line that slice 2 writes.
  - `seeds-survey.md` also lists `decision-1`…`decision-5` as D1–D5 of the persona, in English.
  - `persona.md`, the grill part: the plan is theirs; they want `-s` and no other new flag; on a named flaw they agree to fix it.
  - `drive.sh`, stage `grill`: the first turn `/sbrain погрилль мой план plan-shortest.md`; answers by `answer.sh`; ends as the stage `survey` does, at 8 answers and without the `confirmed` reason; always writes `ended.txt` with the reason.
  - `collect.sh`, stage `grill`: `done` — `ended.txt` exists.
  - Then `bash tests/chain/series.sh gr-smoke . --runs 1 --stages grill`.
- **Checks:** lines 4, 5
