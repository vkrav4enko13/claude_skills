# Check lines of topic chain-tokens: baseline and ranking

> Lines 12–16: the baseline series `medium`, the raise of a role, the ranking of the levers; line 16 is owned by S12.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 12 | R5 | the baseline → three runs at `medium` on the texts without the pin, and one run of the stage `away` kept as the base for R18 | `S="$HOME/Documents/my/chain-stand"; cat "$S/medium/effort"; ls "$S/medium"; grep -c '^effort:' "$S"/medium/skills/*/SKILL.md; ls "$S/away-m/1/away/raw"` | `medium`; `1 2 3 done effort rules.md skills`; four lines that end in `:0`; a `.jsonl` file and `subagents` — the records of the `away` run | S4 | green 2026-10-14 |
| 13 | R6 | the baseline series against series `en` → the gate is passed | `bash tests/chain/gate.sh en medium; echo "code $?"` | `stages: 12/12`, `seeds: 15/15`, `gate: passed`, `code 0` | S4 | green 2026-10-14 |
| 14 | R7 | the baseline after the text fixes → every role ran at `medium`, none was raised | `bash tests/chain/trace.sh medium efforts; echo ---; cat tests/chain/raised.tsv` | above `---` every line names `medium`, except one line `efforts agents high` — the executor of the `ready text` slice of stage `seed`, by the old text of `slices.md`; below — only the header row | S4 | green 2026-10-14 |
| 15 | R10, R11 | the map of the baseline → eleven levers R12–R22 in descending order of tokens saved per run; `deferred` only for a behaviour lever under 3 % | `awk -F'\t' 'NR>1{n++; bad+=(($6=="deferred")!=($3=="behaviour"&&$5<3)); if(NR>2&&$4>p)u++; p=$4} END{print n, bad+0, u+0}' tests/chain/levers.tsv` | `11 0 0` | S5 | green 2026-10-14 |
| 16 | R11 | a deferred lever → a line in "Deferred" of the root index with its number | `awk -F'\t' '$6=="deferred"{print "chain-tokens " $1}' tests/chain/levers.tsv; echo ---; grep -o 'chain-tokens R[0-9]*' docs/00-index.md; true` | the same names above and below `---`; nothing deferred — both parts empty | S12 | green 2026-10-14 |
