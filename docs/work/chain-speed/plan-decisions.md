# Technical decisions of topic chain-speed

> What the plan chose, instead of what and why; which failures and kinds of input it checks beyond the named ones.

## Technical decisions

- **The lane set in one file `tests/chain/cs-stages.txt`** — instead of typing `--stages` by hand: "before" and "after" must run exactly the same lanes, and S4 and S9 read the same file.
- **`stage 7 finished` written even when stages 5–7 are skipped** — instead of dropping the record: `collect.sh`, `away-check.sh`, `nonstop-check.sh` and `pair-check.sh` look for it, and a lane without it fails. The record stays the last line of the batch of R9.
- **`levers-check.sh` counts subagents by role from the stage traces** — instead of reading the skill text: the levers R7, R8, R11, R12 change who works, and only the trace shows it.
- **The pairwise judge reuses the blind setup of `judge.sh`** (random A/B letters per lane, the key kept apart) — instead of a new judging scheme; one session per lane, effort `medium`.
- **Behaviour levers (S5, S6) before the slimming (S7)** — instead of slimming first: the slimming then works on the final text once, and the citations are re-pointed once.
- **Tokens in R15 are the output tokens of `compare.sh` `tokens:` divided by the run count; time is `wall:` per run; cost is reported beside them** — instead of input tokens: cached input dominates and hides the change, the output is what the levers cut.
- **`zero.sh` failing on `nonstop 0/2` and `pair 0/2` is expected** on the reduced stand — those lanes are dropped; only its violation counts are used.
- **A revert of one lever re-edits the slimmed text back to the behaviour of the copy `~/Documents/my/chain-stand/cs-snap/before/`**, then `skills-check` — instead of a file restore: S7 rewrites the same text, so no per-lever file copy survives.
- **The citation check matches key words, not a line number alone** — instead of "the file has N lines": the current check passed while about 15 citations already pointed at the wrong line.

## Check focus

- `count.sh` counts words instead of lines (lines with several words) → the result check names it wrong — S2, line 4
- A cited `## heading` renamed in one file → the skills check names the file and the heading, exit 1 — S3, line 8
- Stages 5–7 skipped on work without code → the `seed`/`small` lanes still find `stage 7 finished` and pass — S5, line 12
- A slimmed skill loses a literal string the stand greps → the skills check names it — S7, line 14
- The final series is worse in quality → the levers are reverted R13 → R8 → R9 → the rest, at most two extra series — S9, line 17
