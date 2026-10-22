# S14. Live stand: a submodule and the switch

> Two live `swork` sessions: in a repository with a submodule one works in its worktree while a slice inside the submodule runs in the shared mode; a session started without the mode joins when a second one switches it on, and the last one removes it; the earlier checks stay green.

- **Status:** awaiting manual check
- **Covers:** R33, R34, R35, R36, R14, R15
- **Depends on:** S11
- **Files:**
  - change: `tests/chain/seed-pair.sh` (cases g, h)
  - change: `tests/chain/pair-run.sh` (cases g, h)
  - change: `tests/chain/pair-check.sh` (case lines g, h)
  - change: `tests/chain/drive.sh` (stage `pair-multi`)
- **Interfaces:**
  - takes: from S11 — the slice action `replace <file> <old line> <new line>`, the seed of `app.js` with `function left()` and `function right()`, the `agents.sh on` call of the seed, the case lines `edits: both`, `max wait: ok`; from S12 — `.agents/mode`; from S13 — the "Progress log" records `mode: …` and the report line on `off --if-last`; from S10 — the record `S<N>: shared mode — inside submodule <path>`
  - gives: `pair-run.sh a|b|c|d|e|f|g|h <skills folder>`, last line `pair run: pass|fail`; `drive.sh <project> pair-multi <stage folder> <level> <topic>`
- **Reuse:** the `pair` places of `tests/chain/drive.sh` (:11, :42, :88–92, :209); S11's seed functions and the git block of `seed-pair.sh:293–303`; `line()`, `report()` of `pair-check.sh:28–79`; the background launch of `pair-run.sh:34–40`
- **What to do:**
  1. `drive.sh` — a stage `pair-multi`, the same as `pair` but with the first message `/swork $topic — исполни план; работаем несколькими агентами`: added next to `pair` in the stage list (:11), the 5-argument check (:42), the `case` (:88–92) and the one-turn test (:209); the usage lines name it.
  2. `seed-pair.sh` g — a repository `$P/../lib-src` with `util.js` holding `function tag() { return "old"; }`, committed; in the stand, after the git block: `git -c protocol.file.allow=always submodule add <that path> lib` and a commit; `agents.sh on`; topic `left` as in case c; topic `right` one slice with "Files" `lib/util.js`, the ready text changing `"old"` to `"new"`, check `sleep 20; grep -qF '"new"' lib/util.js && echo ok`.
  3. `seed-pair.sh` h — case c with no `agents.sh on` and no `.agents/`; topic `left` with two slices, `right` with three, each later slice changing another line of its own function, every check starting with `sleep 20` (a foreground `sleep 40` is blocked under `claude -p` — own card edit of swork, see progress-5.md); `right` keeps three slices to `left`'s two and starts later, so session 2 ends after session 1 and is the last agent.
  4. `pair-run.sh` g — topics `left right` started at once as in case c. h — start `drive.sh … pair … left`; poll `$P/docs/work/left/state.md` every 5 s, at most 600 s, for `execution in progress`; write `before switch: none` into `$T/before.txt` when `$P/.agents` does not exist, else `before switch: present`; then start `drive.sh … pair-multi … right`; wait for both. The usage line lists eight cases.
  5. `pair-check.sh` — keep `ended 1`, `ended 2`, `slices: all done`, `final`, `claims: none`; add g: `edits: both` (the new line in `app.js`, `"new"` in `lib/util.js`), `worktree used: yes` (a "Progress log" line of topic `left` holds `mode: worktree`), `submodule slice: shared` (a "Progress log" line of topic `right` holds `inside submodule lib`); h: `before switch: none` (from `before.txt`), `joined: yes` (field 2 of `.agents/log.tsv` holds two different ids), `mode at end: off` (no `.agents/mode`), `switch-off named: yes` (a reply line holding both `mode` and `off`), `edits: both`.
  6. Run line 32 last; line 41 stays `awaiting manual check` for the user.
- **Checks:** lines 39, 40, 32, 41
