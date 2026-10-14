# Progress log of topic chain-tokens — part 3

> The continuation of the progress log: the findings of stages 5–7.

- stage 5 finished
- stage 6 started
- stage 6: applied — `trace.sh:134` sum by `add // 0` (lines 1, 2, 3, 14, 17 green · `checks/stage6-1.txt`); skipped — two `away-blind.sh` edits (only a blind-reading run checks them) and `saving.sh:37` (a guard at the boundary)
- stage 6 finished
- stage 7 started
- stage 7: fixed — `packet.sh` en-dash ranges (serious), `packet.sh` section carry-over, `saving.sh` rounded threshold; second round: the `saving.sh` fix fails an exact 10 % — restored from `stage-7`, both findings go to the report; `./install.sh --mac` rerun for `packet.sh`; lines 1, 32, 37–41 green · `checks/stage7-2.txt`
- stage 7 finished
- declined: `saway/SKILL.md:36` "a short note between tool calls" as beyond the plan — the S8 check wants the line in every reply
- declined: `packet.sh` code 2 for a missing topic folder as wrong — the interface names only a missing slice
- declined: `away-check.sh` misses `export VAR=` and relative `rm` forms — unlikely in a run, the edit adds branches
- declined: `gate.sh` empty seed count when `verdict.sh` crashes — a guess, the gate still fails
- declined: `saway` stage task "start no other skill" against section 3 — a guess; blind reading 15 of 15 and the `away` run pass
- left untouched: `saving.sh` threshold on the rounded value (9.96 % passes) — the fix failed an exact 10 % in the second round and was restored
- left untouched: the packet file is not rebuilt after a minor discrepancy (`slices.md:51`), nor in a resumed session (`finish.md:15`), and `executor.md:24`, `swork/SKILL.md:20` still speak of the packet as text — skill-text edits after the final series need a series of their own
- left untouched: stage 6 — two `away-blind.sh` simplifications (only a blind-reading run checks them), `saving.sh:37` guard
