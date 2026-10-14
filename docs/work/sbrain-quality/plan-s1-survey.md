# S1. Stand-in user and the stage `survey`

> The stand runs `sbrain` from a raw idea and a stand-in user answers its questions from a persona until the cards are approved.

- **Status:** done
- **Covers:** R1, R2, R3
- **Depends on:** none
- **Files:**
  - create: `tests/chain/persona.md`, `tests/chain/persona-prompt.md`, `tests/chain/answer.sh`
  - change: `tests/chain/drive.sh` (the stage case, the answer loop), `tests/chain/collect.sh` (the stage case), `tests/chain/series.sh` (the stage list, the lane `survey`), `tests/chain/trace.sh` (the stage list)
- **Interfaces:**
  - gives: `bash tests/chain/answer.sh <persona file> <question file>` — prints the stand-in user's answer, code 0; the stage `survey` of `drive.sh` and `series.sh`; the lane `survey` builds `$R/surveybox/wiki-trial/clean` by `stand.sh`
- **Reuse:** the `claude -p` call of `tests/chain/judge.sh:93-105` (flags, `--restricted`, no tools); the stage case and the turn loop of `tests/chain/drive.sh:35-102`; the lane function of `tests/chain/series.sh`
- **What to do:**
  - `persona.md`, in Russian: the user wants `long.sh` that prints how many words of `app.txt` are longer than N letters — no topic of the stand project covers it. Five decisions, `D1`–`D5`: D1 N is the first argument, 5 without it; D2 letters are counted, not bytes; D3 the output is the number alone; D4 without `app.txt` — `no file app.txt` to stderr, code 2; D5 several files are out of scope. A question about what the project files already say — «посмотрите в проекте».
  - `persona-prompt.md`: answer as this user, in Russian, briefly, only from the persona; uncovered — «не знаю, решай сам»; options — by the persona, else the recommended one; shown cards or a summary — approve if they agree with the persona, else name the contradiction; `sbrain` asks nothing more — reply exactly `END`.
  - `answer.sh`: one `claude -p` session at `xhigh` in an empty temporary folder, with `--tools ""`, `--strict-mcp-config`, `--setting-sources ""` and no permission mode, the prompt, the persona and the question in its text; prints `.result`; `.is_error` true or an empty `.result` — code 1.
  - `drive.sh`, stage `survey`: before the first turn note the topic folders of `docs/work/`; the first turn is `/sbrain погрилль меня: хочу скрипт long.sh, который считает, сколько слов в app.txt длиннее N букв` (a grill on an idea goes the "Large" path); each next turn is `answer.sh` on the text of all the reply blocks of the last turn from the session records; it ends when a new topic folder's `state.md` holds `requirements confirmed`, on an answer whose last non-empty line is `END`, on a failed `answer.sh`, or after 12 answers, and writes the reason — `confirmed`, `END`, `error` or `cap` — into `ended.txt` of the stage folder.
  - `collect.sh`, stage `survey`: `done` — `ended.txt` exists: a run that ended for any reason is measured.
  - Then `bash tests/chain/series.sh sv-smoke . --runs 1 --stages survey`.
- **Checks:** lines 1, 2, 3
