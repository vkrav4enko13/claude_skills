# Check lines of topic chain-speed

> Lines 1–9: the precondition, the reduced stand, the stand tools and the skills check; every command runs from the project root.

`ST` is `~/Documents/my/chain-stand`; run folders are `1`, `2`; the `count` project of a run is `<run>/wiki-trial/clean`.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 1 | R2 | the topic's lane set lies in one file | `cat tests/chain/cs-stages.txt` | one line `brain plan work seed survey grill away trap-reuse trap-native small` | S1 | green 2026-10-22 |
| 2 | R18 | one run of the small lane on the current skills | `bash tests/chain/series.sh cs-small "$PWD" --runs 1 --stages "small"; cat $ST/cs-small/1/small/stage.json` | `"done": true` | S1 | green 2026-10-22 |
| 3 | R20 | a right `count.sh` (lines of `app.txt`, `0` on an empty file, `-v` prints the number and the word) | `bash tests/chain/count-check.sh tests/chain/fixtures/count-good` | `count ok`, exit 0 | S2 | green 2026-10-22 |
| 4 | R20 | a `count.sh` that counts words instead of lines | `bash tests/chain/count-check.sh tests/chain/fixtures/count-words; echo exit $?` | a line `count wrong:` naming the failed input, `exit 1` | S2 | green 2026-10-22 |
| 5 | R19 | the pairwise judge on two recorded series | `bash tests/chain/pair-judge.sh qz-r2 qz-r3` | a line per lane `<lane>: better\|equal\|worse — <reason>` and a last line `pair: <b> better, <e> equal, <w> worse` | S2 | green 2026-10-22 |
| 6 | R7, R8, R11, R12 | the lever counts of a recorded series | `bash tests/chain/levers-check.sh qz-r2` | a line per run and stage with `executor=<n> pass=<n> round2=<n> reviewer=<n> stage-agent=<n>` | S2 | green 2026-10-22 |
| 7 | R21, R3 | the four skills and the rule lists after the citation fix | `bash tests/skills-check.sh` | `skills ok`, exit 0 | S3 | green 2026-10-22 |
| 8 | R21 | in a scratch copy the heading `## Decisions and bypass` of `swork/references/slices.md` is renamed | `C=$(mktemp -d) && cp -R sbrain splan swork saway tests $C && sed -i '' 's/^## Decisions and bypass/## Decisions/' $C/swork/references/slices.md && bash tests/skills-check.sh --root $C; echo exit $?` | a line `heading:` naming `Decisions and bypass`, `exit 1` | S3 | green 2026-10-22 |
| 9 | R21 | a literal string the stand greps is missing | `C=$(mktemp -d) && cp -R sbrain splan swork saway tests $C && grep -rl 'stage 7 finished' $C/swork \| xargs sed -i '' 's/stage 7 finished/stage seven done/g' && bash tests/skills-check.sh --root $C; echo exit $?` | a line `literal: stage 7 finished`, `exit 1` | S3 | green 2026-10-22 |
| 10 | R1 | the topic `multi-agent` is closed by the user | `grep -m1 'Phase' docs/work/multi-agent/state.md` | `done` | S1 | green 2026-10-22 |
