# S11. Live stand: two agents in one git project

> Two live `swork` sessions at once in one git project: different lines merge in seconds, the same lines resolve with no lost edit, duplicates are listed; without git they share the folder and claim a file only for a write.

- **Status:** done
- **Covers:** R30, R27, R31, R34
- **Depends on:** S7, S8, S9, S10, S13
- **Files:**
  - change: `tests/chain/seed-pair.sh` (cases c, d, e, f; `agents.sh on` in cases a–f)
  - change: `tests/chain/pair-run.sh` (cases c, d, e, f; topics)
  - change: `tests/chain/pair-check.sh` (case lines)
  - change: `sbrain/scripts/agents.sh` (`off`: drop the caller's own claims — own card edit of swork, see progress-5.md)
- **Interfaces:**
  - takes: from S7–S9 — `.agents/wt/`, `.agents/waits.tsv` (field 7 seconds), `swork/scripts/dups.py`; from S10 and S13 — the reply lines naming a conflict file, duplicate candidates and the mode; from S12 — `agents.sh on`
  - gives: `pair-run.sh a|b|c|d|e|f <skills folder>`, last line `pair run: pass|fail`
- **Reuse:** `slice()` and `finish()` of `seed-pair.sh:91–239`, the git block `seed-pair.sh:293–303`, `line()`, `report()` and the stage-7 match of `pair-check.sh:28–79`, the background pair launch of `pair-run.sh:34–40`
- **What to do:**
  0. `seed-pair.sh` gets a slice action `replace <file> <old line> <new line>` with several files per slice and a free check command; the seed itself creates `app.js`, `src/shop.js` with `buy()`, `src/hud.js` with `draw()`, `resources.json` `{}`; every new-case check starts with `sleep 20` so both sessions overlap; case f fills "Checked against code" with the date instead of `git rev-parse`. After its git block (or where it would stand, for case f) every case a–f runs `bash "$P/.claude/skills/swork/scripts/agents.sh" on` from `$P`, so `.agents/mode` holds `auto`.
  1. `seed-pair.sh` c: a committed `app.js` of ~50 lines with `function left()` near the top and `function right()` near line 40; topics `left` and `right`, one slice each with no dependency, ready text changing only its function's return value; checks `grep -qF '<new line>' app.js && echo ok`.
  2. d: the same file; both topics change the line `const label = { text: "Play", color: "grey" };` — `left` sets `text: "Start"`, `right` sets `color: "gold"`; each check greps only its own value, so the final line must hold both.
  3. e: topics `shop` and `hud`; `shop` adds `function formatReward(n)` to `src/shop.js` and calls it in `buy()`, adds `"bonus_win": "Bonus"` to `resources.json`; `hud` adds the same function to `src/hud.js`, calls it in `draw()`, adds `"bonus_win": "Win bonus"`; checks grep the calls and `jq -e '.bonus_win' resources.json`.
  4. f: case c with the git block of `seed-pair.sh:293–303` skipped; `.agents/mode` `auto` gives the shared mode.
  5. `pair-check.sh`: keep `ended 1`, `ended 2`, `slices: all done`, `final`, `claims: none`; add per case — c: `edits: both`, `max wait: ok` (every `waits.tsv` field 7 ≤ 30); d: `label: both` (`Start` and `gold` on one line), `conflict named: yes` (a reply paragraph holding both `conflict` and `app.js`), `max wait: ok`; e: `dups named: yes` (a reply or progress line of either session naming `dups.py`, `duplicate` or `дубл` together with `formatReward`, and one naming `bonus_win` with one of those words or `conflict`/`конфликт`), `dups left: named` (every name in a candidate line of `python3 -I "$project/.claude/skills/swork/scripts/dups.py"` — the copy `stand.sh` makes — over the project's `src/*.js resources.json` appears in a reply or progress line; `dups: none` passes) — line 30 weakened by saway, [away-4.md](away-4.md); f: `edits: both`, `worktrees: none` (no `.agents/wt/`), `max wait: ok`, `mode named: shared` (a reply paragraph of each session holding `shared`); a reply is the turn text of the stage folder's `chat.md`, else `.result` — own card edit of swork, progress-5.md.
  6. `pair-run.sh`: cases `c d f` → topics `left right`, `e` → `shop hud`; its case list (`:21–25`) and the one of `pair-check.sh` (`:43–47`) take `a|b|c|d|e|f`; usage lines list all six. `max wait: ok` also when `.agents/waits.tsv` does not exist.
  7. `agents.sh off`, with or without `--if-last`: when it removes `.agents/mode`, it first removes the caller's own lines from `claims.tsv` (the existing `drop_claims` of its id); `mode: kept — …` changes nothing; `bash tests/switch-test.sh && bash tests/agents-test.sh` (line 33) stays green.
- **Checks:** lines 28–31, 33
