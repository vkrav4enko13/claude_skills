# Design of topic ponytail-lean

> The approved sections, approach B: rules plus a `LADDER:` field in the executor's reply; section 5 — the extension.

## 1. What we get and its parts

- The executor of `swork` writes less superfluous code from the start and cuts nothing needed; risky logic gets its test already in the plan; the stand is not worse.
- `swork/references/executor.md` is the one owner of the rules of writing code: the ladder (R2), the scope before code (R1), callers of a bug (R3), moved code keeps its guards (R4), the never-cut list above the ladder (R5), the `shortcut:` marker (R6) and the reply field `LADDER:` (R7).
- `splan`: a slice with risky logic gets a check line with one small test (R9, R10); the recon takes the code map (R11).
- `swork` elsewhere: the simplification and the review refer to the never-cut list of the executor (R8); the conformance check compares `LADDER:` with the code (R12); the report gets "Debt" (R15); the review treats `shortcut:` by R16, R17.
- A new code-map script (R13).
- `sbrain`, `saway`: no edits in substance; the idea of the "needed at all" rung already lives in `sbrain/references/survey.md:28` as "recommend only what the goal cannot be reached without", without a ladder, and `saway` drives the stages.

## 2. How data flows

- The recon of `splan` calls the map script; the rungs and the ready-made code go into "Reuse"; risky logic gets a test line.
- The executor's packet is built with the slice, its check lines and the map.
- The executor goes down the ladder, writes the code and replies with `LADDER:`.
- The main session runs the check and collects the `shortcut:` comments of the changed files into "Debt".

## 3. Errors

- The map script fails or the project is empty — the packet goes without the map; the search in the project stays required (R14).
- No `LADDER:` field, or a field that the code contradicts — a "wrong" finding of the conformance check and an attempt to fix (R12).
- `shortcut:` without a trigger — a finding of the review (R16).

## 4. Checking

- Five trap tasks with three runs per series, each with a hidden check script that passes its good reference and fails its bad one before the runs (R19, R20).
- Measures per run: delivered lines without tests, hidden checks, a test on risky logic, output tokens, time, cost (R21).
- A fresh baseline series on `cda6856` — all stages and the traps — then a candidate series with all edits (R23).
- Accepted by R24; worse on any quality measure — ablation by R25; tokens and time by R26.
- The new skill rules get lines in `tests/chain/rules.md` (R22).

## 5. Extension of 2026-10-17

- The most of ponytail inside the chain, approved by the user as shown: the executor adds R27–R30; every chain skill ends with a gaps line and gives a requested explanation in full (R31, R32); the review of `swork` is rebuilt by kinds, callers, load, tiers and verdict (R33–R36); the recon of `splan` reads the touched part as an audit (R37).
- Hooks as in ponytail: rules at session start, resume, clear and compaction, into every subagent, a language line before every reply; they fail open; `install.sh` installs them (R38–R41).
- The stand adds an over-engineering judge, an injected-bug check of planned tests, compressed size and medians with ratios (R42–R45); speed — not slower, the speed-up shown (R24, R26).
