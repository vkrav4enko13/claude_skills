# Technical decisions of topic chain-tokens

> What the plan chose, instead of what and why; which failures and kinds of input it checks beyond the named ones.

## Technical decisions

- **`trace.sh` in bash and `jq`** — instead of moving the Python scripts of 2026-10-13: `tests/` has no Python, and those scripts are tied to series `en` and to absolute paths.
- **The stand passes `--effort`** — instead of `CLAUDE_CODE_EFFORT_LEVEL`: the variable would beat both the pin in the skills and a per-role raise of the gate procedure.
- **The pin is the frontmatter plus one launch sentence per skill** — instead of the frontmatter alone or a word at each of thirteen launch places: the frontmatter level holds for one turn, the launch parameter holds in any turn.
- **Levers are ranked by an upper bound** — the whole sink a lever addresses, instead of a guessed share: a lever whose whole sink is under 3 % cannot matter.
- **R19 is the deletion batch** — instead of a behaviour edit; only `CHECK` goes. `CHANGED` and `CREATED` stay: `saway` reads them; `kind` and "what you could not check" stay as guards.
- **The blind reading reuses `away-blind.sh`** with two optional arguments — instead of a second script.
- **The pin, the deletions and the context levers ride in the first batch series** — instead of a series each; a failed batch is reverted and the series is repeated without it.
- **No separate final series** when the last passed series ran on the final texts — instead of always one more.
- **Second-round tasks lie in files of their own** — instead of a second code block: the cut commands take every block of a file.
- **The packet goes to the executor as a file in the temporary folder** — instead of text in the launch message.
- **`saway` edits are also accepted by the stage `away`** of the stand and its blind reading: a series does not run `saway`.
- **The batch series are judged with two more rules than `en`** (`sbrain-14`, `splan-27`) — instead of a new reference series: more rules can only add violations, the gate gets stricter.

## Check focus

- a series that lacks some stages → `trace.sh` prints the stages it has and ends with code 0 — S1, line 3
- an unknown effort level → a refusal with code 2 and no series folder — S2, line 6
- a started series asked at another level → a refusal that names the level it was run at — S2, line 7
- a series the judge has not read → the gate fails with "no measurement", it does not pass in silence — S3, line 11
- `saway` after the rewrite of its stages → the blind reading of work without the user still gives 15 of 15 — S8, line 25
