# S3. saway, not lfg, on "I am leaving"

> The trigger probe runs with the profile's plugins and shows which skill takes "I am leaving, finish without me".

- **Status:** done
- **Covers:** R7
- **Depends on:** S1
- **Files:**
  - change: `tests/chain/trigger.sh` (the temp project setup `:33-37`, the effort `:51`, header)
  - create: `tests/chain/requests-away.tsv`
- **Interfaces:**
  - takes: the temp project under `CHAIN_BASE` (S1, step 1)
  - gives: `trigger.sh` usage unchanged
- **Reuse:** `trigger.sh` as it is; the format of `tests/chain/requests.tsv` — `<request>⇥<expected skill or ->`
- **What to do:**
  1. `trigger.sh`: in each temp project write `.claude/settings.json` holding only the `enabledPlugins` object of `${CLAUDE_CONFIG_DIR:-$HOME/claude/personal}/settings.json` (take it with `jq`); keep `--setting-sources project,local`. The effort at `:51` becomes `medium`. Say both in the header.
  2. `requests-away.tsv`, three lines: the Russian line of `requests.tsv:19` with `saway`; `I am leaving, finish the work without me` with `saway`; `lfg: add one line to README and open a pull request` with `compound-engineering:lfg`.
  3. If the control request gives `none`, the plugin is not loaded — the line is red; report the cause, do not drop the control request.
- **Checks:** line 8
