# Check lines of topic chain-tokens: session context

> Lines 22–25: the handoff menus and the stages of `saway` from a clean context.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 22 | R21 | `sbrain` and `splan` hand off with the result in the topic folder → the menu gives the command that starts the next skill in a new session | `S="$HOME/Documents/my/chain-stand/ctx/1"; grep -m1 -oE '/splan [^ ]*count' "$S/brain/chat.md"; grep -c '/clear' "$S/brain/chat.md" "$S/plan/chat.md"; grep -c -e '^- sbrain-14\.' -e '^- splan-27\.' tests/chain/rules.md` | a line that starts with `/splan ` and ends with `count`; two lines with a count of 1 or more; `2` | S8 | green 2026-10-14 |
| 23 | R25 | each next skill is started in a session of its own → it goes from the topic cards alone and completes its stage | `jq -r .done "$HOME/Documents/my/chain-stand/ctx/1"/{brain,plan,work}/stage.json` | `true` three times | S8 | green 2026-10-14 |
| 24 | R22 | `saway` drives the stage `away` → the stage runs in a subagent of its own, which launches the executors and the reviewers; the run passes | `S="$HOME/Documents/my/chain-stand/away-ctx/1"; bash tests/chain/away-check.sh "$S/box/wiki-trial/clean" "$S/away"; bash tests/chain/trace.sh away-ctx depth roles` | the line `away run: pass`; lines `depth 1 <n>` and `depth 2 <n>` with n of 1 or more; a line that starts with `roles stage` | S8 | green 2026-10-14 |
| 25 | R22 | the blind reading of work without the user on the new `saway` → the required answers | `tail -n 1 "$HOME/Documents/my/chain-stand/away-ctx/blind/result.txt"` | `15 of 15 ok` | S8 | green 2026-10-14 |
