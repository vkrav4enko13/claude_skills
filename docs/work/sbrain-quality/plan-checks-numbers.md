# Check lines of topic sbrain-quality: numbers

> Lines 9–14: the survey gate, the baseline, the fixes and the final chain series.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 9 | R6 | a series the judge has not read → "no measurement", not passed | `T=$(mktemp -d); cp -R $HOME/Documents/my/chain-stand/sv-smoke "$T"; CHAIN_BASE=$T bash tests/chain/survey-gate.sh sv-smoke sv-smoke; echo "code $?"` | `survey gate: failed — no measurement`, `code 1` | S4 | green 2026-10-14 |
| 10 | R6 | a series against itself → three numbers and "not worse, not better" | `bash tests/chain/survey-gate.sh sv-smoke sv-smoke; echo "code $?"` | lines `violations:`, `decisions:`, `flaws:` with both series, then `survey gate: not worse, not better`, `code 1` | S4 | green 2026-10-14 |
| 11 | R8, R12 | the baseline → three runs of `survey` and `grill` at `medium` on the present texts, judged, with its numbers and cost | `cat "$HOME/Documents/my/chain-stand/sv-base/effort"; ls -d $HOME/Documents/my/chain-stand/sv-base/[123]/survey $HOME/Documents/my/chain-stand/sv-base/[123]/grill; bash tests/chain/survey-gate.sh sv-base sv-base; bash tests/chain/trace.sh sv-base total` | `medium`; six folders; the three number lines; `total output_per_run <n>` | S5 | green 2026-10-14 |
| 12 | R9, R11 | the fixed texts → the series `sv-fix` is not worse than `sv-base` on all three numbers and better on one; no skill raises the effort | `bash tests/chain/survey-gate.sh sv-base "$(cat $HOME/Documents/my/chain-stand/sv-final.current)"; grep -c -E 'effort: (high|xhigh|max)' sbrain/SKILL.md; true` | `survey gate: passed` — or, with no fix needed, the name `sv-base` and `survey gate: not worse, not better`; then `0` | S6 | green 2026-10-14 |
| 13 | R10 | the `sbrain` texts were changed → the full chain series passes the gate against `en` | `bash tests/chain/gate.sh en sq-chain; echo "code $?"` | `gate: passed`, `code 0` | S7 | not run: no sbrain text changed |
| 14 | goal | the report → the three numbers of the baseline and of the final series, and the cost of a series | `bash tests/chain/survey-gate.sh sv-base "$(cat $HOME/Documents/my/chain-stand/sv-final.current)"; bash tests/chain/trace.sh sv-base total` | the three number lines with both series and `total output_per_run` | S7 | green 2026-10-14 |
