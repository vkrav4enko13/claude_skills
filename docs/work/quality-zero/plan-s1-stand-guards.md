# S1. Stand guards

> The stand keeps its temp files to itself, a restore keeps new test files, a bad verdict is "no measurement".

- **Status:** done
- **Covers:** R1, R2, R3
- **Depends on:** none
- **Files:**
  - change: `tests/chain/trigger.sh` (the temp project, `:25`)
  - change: `tests/chain/answer.sh` (`box=$(mktemp -d)`, `:28`)
  - change: `tests/chain/drive.sh` (the question and persona files, `:161`, `:163`)
  - change: `tests/agents-test.sh` (`P=$(mktemp -d)`, `:17`)
  - change: `tests/translate/state.sh` (`restore`, `:78-85`)
  - change: `tests/chain/verdict.sh` (`tally`, `:53-76`)
  - change: `tests/chain/survey-gate.sh` (its copy of the tally, `:37-72`)
  - create: `tests/chain/tally.sh`
  - create: `tests/chain/verdict-test.sh`
- **Interfaces:**
  - gives: `tests/chain/tally.sh`, sourced, with `tally_label <label folder>` — prints one line `<rule no> <decision carried> <flaw named> <seed found> <sbrain no> <splan no> <swork no> <saway no> <sv no> <saway answered>` of one label (`<saway answered>` — `saway-` rule lines answered yes or no), return 1 on a malformed verdict; `verdict.sh` and `survey-gate.sh` keep their output forms; a bad verdict gives `no measurement: <what>` (verdict) and `survey gate: failed — no measurement` (survey gate), both code 1; `verdict-test.sh` with no arguments, last line `verdict test: all ok`, code 0
- **Reuse:** `tally` of `tests/chain/verdict.sh`, moved into `tally.sh`; the English names of `tests/translate/map.tsv` (scope stand, kind judge) as the tally reads them now; the `no measurement:` prefix that `gate.sh:67,74` matches; `CHAIN_BASE` and `STATE_ROOT` of `state.sh`
- **What to do:**
  1. `trigger.sh`: make the temp project with `mktemp -d "${CHAIN_BASE:-$HOME/Documents/my/chain-stand}/trigger.XXXXXX"`; `mkdir -p` the base first.
  2. `answer.sh`: make `box` under the same base, `answer.XXXXXX`.
  3. `drive.sh`: write the question and persona files as `"$dir/tmp/question"` and `"$dir/tmp/persona"`; `$dir/tmp` exists from `:151`.
  4. `agents-test.sh`: make `P` under the same base, `agents-test.XXXXXX`, and remove it at the end as it does now.
  5. `state.sh restore`: skip the delete loop for the item `tests` — the copy is restored over it, files the copy does not have stay. Write that in the header line of `restore`.
  6. `tally.sh`: the tally of `verdict.sh` moves here as `tally_label`, words mapped by `map.tsv` as now. A verdict is malformed when a non-empty line has not four tab-separated fields, or when the number of `rule` lines is less than the rule lines of the label's rules file — `rules.md` (`- <skill>-<N>.`) for a main label, `rules-survey.md` (`- sv-<N>.`) for a survey label; old labels are checked the same way, their files are packed.
  7. `verdict.sh` and `survey-gate.sh` source `tally.sh` and drop their own tallies; a malformed verdict gives `no measurement: verdict <label>` and `survey gate: failed — no measurement`. Say it in both headers.
  8. `verdict-test.sh`: build a throwaway `CHAIN_BASE` under the base (`vt.XXXXXX`) with two series of one run each, `blind/key.tsv` and per label `rules.md` and `verdict.tsv`; four cases, a line each: `verdict malformed: …` (a line of three fields), `verdict short: …` (one rule line for two rules), `survey malformed: …` (a three-field line in a survey label with `rules-survey.md`, through `survey-gate.sh`), `verdict good: counted` (a well-formed verdict gives a number); then `verdict test: all ok` or `verdict test: failed`.
- **Checks:** lines 1, 2, 3, 4
