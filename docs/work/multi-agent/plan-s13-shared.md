# S13. Skills: the switch and the shared mode

> A skill switches the mode on when the user asks for several agents; `swork` picks the mode before each slice and, in the shared mode, claims a file only for one write, checks duplicates after each step and names the mode in the report; the last agent switches it off.

- **Status:** done
- **Covers:** R31, R32, R35, R36, R14
- **Depends on:** S9, S12
- **Files:**
  - create: `swork/references/modes.md`
  - change: `sbrain/references/agents-rules.md` (a first section "Switch"; "When to claim", first bullet)
  - change: `sbrain/SKILL.md`, `splan/SKILL.md`, `swork/SKILL.md`, `saway/SKILL.md` (one line each; `swork/SKILL.md` also the stage table or "Rules for all stages": while the mode is on read `references/modes.md`)
  - change: `swork/references/slices.md` (step 2: the mode; "Picking a slice"; the `done` before the steps; step 3: the executor message; "Decisions and bypass": a pointer)
  - change: `swork/references/executor.md` (rule 11 of the "Task" block)
  - change: `swork/references/small.md` (one line: the mode)
  - change: `swork/references/report.md` (a "Mode" item; `off --if-last` before the report and the short report)
  - change: `tests/chain/pair-scenarios.md` (the premise in its intro)
  - create: `tests/chain/modes-scenarios.md`, `tests/chain/modes-expected.tsv`
- **Interfaces:**
  - takes: from S12 — `agents.sh on [auto|worktree|shared]`, `off [--if-last]` with `mode: off` / `mode: kept — <reason>`, `mode` with code 0 and the word or code 1 and `off`, the answer `agents: off`; from S9 — `python3 -I <swork>/scripts/dups.py <root> <path>…`, its kinds and the last line `dups: none` | `dups: <n> candidates`; from part 1 — `agents.sh others --since <file>`, `busy`, `wait`, the snapshot folder and `<snapshot>/agents/<id>/marker`
  - gives: `swork/references/modes.md` with the sections "Mode", "Shared mode", "Switch"; the "Progress log" records `mode: off`, `mode: shared — <reason>`, `mode: worktree <path>` (the last written by S10's `worktree.md`); the step marker `<snapshot>/agents/<id>/step`; the executor message line `AGENTS=<path of agents.sh> TOPIC=<topic> SLICE=S<N>`, and the essence of every executor `done` starting with `S<N>:`; the report item "Mode"
- **Reuse:** the claim and wait text of `sbrain/references/agents-rules.md`; `agents.sh others --since` as `swork/references/snapshot.md:46` uses it; the reverse-diff text of `swork/references/report.md:41`; `away-blind.sh` 4-argument form and the scenario form of `tests/chain/pair-scenarios.md`
- **What to do:** see part 2 — [plan-s13-shared-2.md](plan-s13-shared-2.md) — and part 3 — [plan-s13-shared-3.md](plan-s13-shared-3.md)
- **Checks:** lines 36, 37, 38
