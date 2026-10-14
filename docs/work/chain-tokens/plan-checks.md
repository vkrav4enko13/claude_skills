# Check lines of topic chain-tokens: cost map and effort

> Lines 1–7: the tool `trace.sh` on the series that already exist and the effort level of a series.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 1 | R9 | series `en` → the totals equal the stand's own measurement: output 1188907, thinking 697705 | `bash tests/chain/trace.sh en total` | lines `total runs 3`, `total output 1188907`, `total thinking 697705`, `total output_per_run 396302` | S1 | green 2026-10-13 |
| 2 | R9 | series `en` → output by stage, by role and by kind, input by cache write and cache read | `bash tests/chain/trace.sh en stages roles kinds input` | lines that start with `stages brain`, `stages plan`, `stages work`, `stages seed`, `roles main`, `roles conformance`, `kinds main thinking`, `kinds main text`, `kinds main tool`, `input cache_write 2598878`, `input cache_read 32851436` | S1 | green 2026-10-13 |
| 3 | R9 | series `effort`, which has only the stage `seed` → the stage it has, no crash | `bash tests/chain/trace.sh effort stages; echo "code $?"` | one line that starts with `stages seed`, then `code 0` | S1 | green 2026-10-13 |
| 4 | R1 | a series started with `--effort medium` → every request of its sessions ran at `medium` | `bash tests/chain/trace.sh smoke-m efforts; cat "$HOME/Documents/my/chain-stand/smoke-m/effort"` | every `efforts` line names the level `medium`; the last line is `medium` | S2 | green 2026-10-13 |
| 5 | R1 | the judge → still at `xhigh` | `grep -c -- '--effort xhigh' tests/chain/judge.sh` | `1` | S2 | green 2026-10-13 |
| 6 | R1 | the unknown level `ultra` → a refusal with code 2, no series folder is created | `T=$(mktemp -d); CHAIN_BASE=$T bash tests/chain/series.sh x . --effort ultra 2> /dev/null; echo "code $?"; ls "$T"` | `code 2` and nothing after it | S2 | green 2026-10-13 |
| 7 | R1 | the series `smoke-m`, run at `medium`, is asked at `high` → a refusal that names its level | `bash tests/chain/series.sh smoke-m . --runs 1 --stages brain --effort high 2>&1; echo "code $?"` | `series smoke-m was run at medium`, then `code 2` | S2 | green 2026-10-13 |
