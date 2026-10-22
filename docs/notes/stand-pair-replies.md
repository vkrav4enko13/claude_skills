# Live pair stand: replies and long checks

> What a `claude -p` pair run gives the checker and what it blocks, found executing multi-agent part 2 on 2026-10-21.

- `.result` of a session's `turns/01.json` holds only the last message of the turn — often just the menu; the report items written earlier are only in the stage folder's `chat.md`, which `pair-check.sh` `reply()` now reads.
- The sessions answer in Russian ("конфликт", "дубл", "общий режим"): a match on an English word misses them; `pair-check.sh` writes the Russian words as `\x{…}` escapes.
- One fact is often split over two lines of a reply: `conflict` and `app.js` match per paragraph, not per line.
- `claude -p` blocks a foreground `sleep 40 && …` check command, while `sleep 20` passes; the blocked session moves it to the background, `Monitor` is denied, and the turn ends with slices not started.
- A session sometimes marks "stage 7 finished" with its agent id instead of its name; `pair-check.sh` then does not take its menu as the final report (`ended: no`) — flaky, about one run in eight.
- Four pair cases at once (eight sessions with subagents) hit the account session limit within the hour; two at a time did not.
