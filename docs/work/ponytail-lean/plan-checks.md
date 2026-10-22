# Check lines of topic ponytail-lean

> How each requirement is checked, lines 1–14: scenario, command, expected result and the owning slice.

All commands start in the project root: `cd "$HOME/Documents/my/claude_skills" && …`; `CB` stands for `"$HOME/Documents/my/chain-stand"`, made with `mkdir -p` before the first use. Lines 15–27 — [part 2](plan-checks-2.md), 28–40 — [part 3](plan-checks-3.md), 41–53 — [part 4](plan-checks-4.md).

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 1 | R13 | folders `app/` and `lib/`, a function in `tests/t.sh`, a Python `def` inside a `def` → `lib/` first, nothing from tests, only the outer def | `bash tests/codemap-test.sh \| grep -E '^(order\|tests\|nested):'` | `order: ok`, `tests: ok`, `nested: ok` | S1 | green 2026-10-18 |
| 2 | R13 | 300 functions in 30 files → at most 2,000 characters, last line `… (truncated)` | `bash tests/codemap-test.sh \| grep '^size:'` | `size: ok` | S1 | green 2026-10-18 |
| 3 | R14 | an empty folder → empty map, code 0 | `bash tests/codemap-test.sh \| grep '^empty:'` | `empty: ok` | S1 | green 2026-10-18 |
| 4 | R13 | a file `my file.sh` and a folder `данные/` with functions → both listed, code 0 | `bash tests/codemap-test.sh \| grep '^names:'; bash tests/codemap-test.sh \| tail -1` | `names: ok`, then `codemap: all ok` | S1 | green 2026-10-18 |
| 5 | R13 | the map of this repo → within 2,000 characters, no `tests/` block | `bash swork/scripts/codemap.sh . \| LC_ALL=C.UTF-8 wc -m \| tr -d ' '; bash swork/scripts/codemap.sh . \| grep -c '^tests/'` | a number of 2000 or less, then `0` | S1 | green 2026-10-18 |
| 6 | R13 | a packet of an existing topic → it has the map block | `bash swork/scripts/packet.sh docs/work/quality-zero 1 . \| grep -c '^=== code map ===$'` | `1` | S1 | green 2026-10-18 |
| 7 | R14 | the map script fails → the packet is printed without the map block | `T=$(mktemp -d "$CB/pk.XXXXXX") && cp -R swork $T/ && printf 'exit 1\n' > $T/swork/scripts/codemap.sh && bash $T/swork/scripts/packet.sh docs/work/quality-zero 1 . > $T/p.txt; echo "rc $?"; grep -c '=== code map ===' $T/p.txt; grep -c '^# S1\.' $T/p.txt` | `rc 0`, `0`, `1` | S1 | green 2026-10-18 |
| 8 | R14 | the map script hangs → the packet ends within 12 seconds, without the map | `T=$(mktemp -d "$CB/ph.XXXXXX") && cp -R swork $T/ && printf 'sleep 60\n' > $T/swork/scripts/codemap.sh && SECONDS=0 && bash $T/swork/scripts/packet.sh docs/work/quality-zero 1 . \| grep -c '=== code map ==='; echo "s $SECONDS"` | `0`, then `s <n>` with n of 12 or less | S1 | green 2026-10-18 |
| 9 | R11 | a stand box and `install.sh` → `splan` and `swork` both get `codemap.sh` | `T=$(mktemp -d "$CB/cm.XXXXXX") && bash tests/chain/stand.sh $T . >/dev/null && ls $T/wiki-trial/clean/.claude/skills/{splan,swork}/scripts/codemap.sh \| wc -l \| tr -d ' '; grep -c 'codemap.sh' install.sh` | `2`, then a number of 2 or more | S1 | green 2026-10-18 |
| 10 | R1, R3, R4 | the executor task names the reach of a change, the callers of a bug and moved guards | `for p in 'list every place the change must reach' 'find every caller of it' 'carry its validation and its error handling'; do grep -cF "$p" swork/references/executor.md; done` | `1` three times | S2 | green 2026-10-18 |
| 11 | R2, R5 | the ladder, the no-dependency rule and the never-cut list over the ladder | `for p in 'go down the ladder' 'Never add a dependency to save a few lines' 'This list overrides rule 8'; do grep -cF "$p" swork/references/executor.md; done` | `1` three times | S2 | green 2026-10-18 |
| 12 | R6, R27, R28, R29 | the shortcut marker, the smallest diff, why-comments, edge cases | `for p in 'shortcut: <ceiling>; upgrade when <trigger>' 'take the smallest diff' 'says only why' 'correct on edge cases'; do grep -cF "$p" swork/references/executor.md; done` | `1` four times | S2 | green 2026-10-18 |
| 13 | R7, R30 | the reply form has `LADDER:` and `GAPS:` | `grep -cE '^(LADDER\|GAPS): ' swork/references/executor.md` | `2` | S2 | green 2026-10-18 |
| 14 | R8 | the ladder text lives in one file of the four skills and the hooks | `grep -rlF 'go down the ladder' sbrain splan swork saway hooks 2>/dev/null` | only `swork/references/executor.md` | S3 | green 2026-10-18 |
