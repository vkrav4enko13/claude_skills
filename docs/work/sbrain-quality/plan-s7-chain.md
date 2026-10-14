# S7. The full chain still passes, the report

> If `sbrain` texts changed, the chain series passes the gate against `en`; the numbers are reported.

- **Status:** done
- **Covers:** R10, R12
- **Depends on:** S6
- **Files:**
  - none in the project; the stand folder `$S/sq-chain`
- **Interfaces:**
  - takes: `sv-final.current` (S6), `gate.sh`, `survey-gate.sh`
- **Reuse:** the gate procedure of topic `chain-tokens`: `series.sh … --effort medium` by runs, `judge.sh`, `gate.sh en <series>`
- **What to do:** `sv-final.current` is `sv-base` — no chain series, the main session writes `not run: no sbrain text changed` into the Result of line 13. Otherwise run `sq-chain` with the stages `brain plan work seed`, judge it, `gate.sh en sq-chain`. Install nothing: the main session asks the user.
- **Checks:** lines 13, 14
