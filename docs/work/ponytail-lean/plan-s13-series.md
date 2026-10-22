# S13. Series, acceptance and install

> The baseline on `cda6856` and the candidate run the same stages and traps; the edits are accepted by the comparison, the map is kept or dropped by its own trap series, the clean room is verified, and the hooks reach the Mac profiles.

- **Status:** not started
- **Covers:** goal, R18, R23, R24, R25, R26, R41
- **Depends on:** S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12
- **Files:**
  - change: the files of S1–S7 and `tests/chain/rules.md` only if the map is dropped (step 5) or an ablation reverts a group (step 6)
- **Interfaces:**
  - takes: `series.sh` with `traps` (S9), `zero.sh`, `compare.sh` and `--map` (S12)
  - gives: series `pl-base`, `pl-cand`, `pl-nomap`, ablation series `pl-abl-<group>` under `CB`
- **Reuse:** `tests/chain/series.sh`, `tests/chain/zero.sh` (it judges), `tests/chain/compare.sh`; `install.sh --mac`
- **What to do:**
  1. `git worktree add --detach "$CB/base-src" cda6856` (outside the project).
  2. All stages are `brain plan work seed survey grill away nonstop pair traps`, three runs, effort `medium`: `bash tests/chain/series.sh pl-base "$CB/base-src" --stages "<all>"`, then the same as `pl-cand` with `.`; then `bash tests/chain/zero.sh pl-base` and `bash tests/chain/zero.sh pl-cand` to judge both.
  3. `bash tests/chain/compare.sh pl-base pl-cand` — keep the output in the progress log.
  4. The map: copy `sbrain splan swork saway hooks` and `tests/chain/rules.md` of the project into `$CB/nomap-src` (same layout), delete `swork/scripts/codemap.sh` there; `bash tests/chain/series.sh pl-nomap "$CB/nomap-src" --stages traps`; `bash tests/chain/compare.sh --map pl-nomap pl-cand`.
  5. `map: drop` → remove the map from the project: `swork/scripts/codemap.sh`, `tests/codemap-test.sh`, the map block of `packet.sh`, item "The code map" of `executor.md`, "Map first" of `recon.md`, the `codemap.sh` copies of `install.sh` and `stand.sh`, and in rule 8 of `executor.md` "the code map and a search" becomes "and a search"; mark lines 1–9 and 23 `not checked: map dropped by line 50`.
  6. `accept: fail` on a measure other than `wall` → ablation: groups G1 executor (`swork/references/executor.md`), G2 checkers (`simplify.md`, `conformance.md`, `slices.md`, `report.md` of `swork/references/`), G3 review (`swork/references/review.md`), G4 splan (`slicing.md`, `recon.md`, `plan-format.md` of `splan/references/`), G5 closing (`sbrain/references/handoff.md`, `splan/references/approval.md`, `saway/SKILL.md`), G6 hooks (no `hooks/`), G7 map (no `codemap.sh`). Start with the group nearest to the failing measure; per group a copy of the candidate with that group's files taken from `$CB/base-src`, a series `pl-abl-<group>` of the stages the failing measure comes from, `bash tests/chain/zero.sh pl-abl-<group>` when a judged stage is among them, and `compare.sh --only "<those stages>" pl-base pl-abl-<group>`. The first group whose series passes is reverted in the project the same way; its check lines become `not checked: idea dropped by ablation`. At most one series per group.
  7. After step 5 or a revert of step 6: repeat step 2 of S11, run line 42, and remove from `hooks/chain-rules.md` and `tests/chain/rules.md` what points at a dropped rule.
  8. `accept: fail — wall (time only)` → no ablation; record it and go on.
  9. The clean room (line 52): a fresh subagent, effort `medium`, that is allowed to read https://github.com/dietrichgebert/ponytail compares `git diff cda6856 -- sbrain splan swork saway hooks tests install.sh` with it and lists every run of eight or more words copied from it; none — `no copied wording`. A run found — reword it and repeat once.
  10. After the user accepts the work: save, then install (line 53).
  11. The ideas left out by reasoning are tested, not dropped by opinion (the user, 2026-10-18): variants of the candidate under `$CB/<name>-src` — `lite` (executor rules of writing code cut to 8 and 13), `ultra` (the executor first names what in its slice the goal does not need), `terse` (replies and reports short, no restating) — each `series.sh pl-<name> "$CB/<name>-src"` (`lite`, `ultra`: `--stages traps`; `terse`: `--stages "brain plan work traps"` and `zero.sh`), then `compare.sh --only "<those stages>" pl-cand pl-<name>`; `accept: pass` with fewer lines or tokens — taken into the project; otherwise dropped by the numbers (line 54). Host-bound ideas (band, board, status line, gain and help, adapters, translations) do not enter a stand run: listed for the user.
- **Checks:** lines 47–54
- **Rollback:** before `./install.sh --mac`: `mkdir -p "$CB/pl-rollback" && cp "$HOME/claude/personal/settings.json" "$CB/pl-rollback/personal.json" && cp "$HOME/claude/work/settings.json" "$CB/pl-rollback/work.json"`. Restore: `cp "$CB/pl-rollback/personal.json" "$HOME/claude/personal/settings.json" && cp "$CB/pl-rollback/work.json" "$HOME/claude/work/settings.json" && rm -rf "$HOME/claude/personal/chain-hooks" "$HOME/claude/work/chain-hooks" && bash "$CB/base-src/install.sh" --mac`.
