# Check lines of topic chain-speed — part 3

> Lines 19–23: the code map, the rule levels and the final series with them.

`ST` is `~/Documents/my/chain-stand`.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 19 | R22 | the map of this project | `bash sbrain/scripts/codemap.sh "$PWD" \| tee /dev/stderr \| wc -c` | lines `<folder>: <names>` with `sbrain/scripts` and `swork/scripts` names (`dups.py` functions); no `tests/` line; count ≤ 2100 | S10 | green 2026-10-23 |
| 20 | R22 | a folder without code → empty map, exit 0; the packet carries the map | `d=$(mktemp -d) && bash sbrain/scripts/codemap.sh $d; echo exit $?; rm -rf $d; bash swork/scripts/packet.sh docs/work/chain-speed 10 "$PWD" \| grep -cx '=== code map ==='` | `exit 0` with no other line; `1` | S10 | green 2026-10-23 |
| 21 | R23 | every stages table has the `lite` column and the line | `grep -c 'Small work reads only the files marked' sbrain/SKILL.md splan/SKILL.md swork/SKILL.md saway/SKILL.md` | `1` in each of the four | S11 | green 2026-10-23 |
| 22 | R23 | a light path loses no ban | checked by a fresh read-only subagent: for each skill read `SKILL.md` and only the `lite` files and list every ban, stop or menu of the light path (by `~/Documents/my/chain-stand/cs-snap/before/`) not stated there; then `bash tests/skills-check.sh` | the list is empty; `skills ok` | S11 | green 2026-10-23 |
| 23 | goal, R15, R22, R23 | the series with all levers against "before" | the commands of line 16 with `cs-after-3` instead of `cs-after`, plus `bash tests/chain/compare.sh --only "$(cat tests/chain/cs-stages.txt)" cs-after-2 cs-after-3` | as line 16 against `cs-before`; against `cs-after-2` `wall:` and `tokens:` not higher | S12 | red 2026-10-23 (vs cs-after-2: wall ×1.04, tokens ×1.01) |
