# Where the chain spends tokens at `xhigh`: stand and real sessions

> Thinking is 59–66 % of output and read-only checkers 46 %; text the skills order to be written is about 11 %; the input side is driven by a main context that is never reset.

- **Stand, series `en`, 3 runs at `xhigh`.** 396k output tokens per run, spread 2 %: thinking 233k, text 36k, tool arguments 128k. By stage: brain 22k, plan 121k, work 112k, seed 140k.
- **Roles on the stand.** Main sessions 48 %, conformance reader 17 %, reviewer round one 13 %, plan reviewer 12.5 %, round two 3.9 %, executors 3.4 %, fixers 2.5 %. One subagent swings from 21k to 49k: a lever under 10k on one subagent is noise.
- **Thinking bursts.** About 15 requests per run with 5k or more thinking hold 55 % of all thinking; they come right after a bulk load of skill files or cards.
- **Reading nobody asked for.** The plan reviewer reads about 90 KB of skill files, the conformance reader prints `SKILL.md` and references; neither task asks for it. Seen on the stand only, where the skills lie inside the project.
- **Real sessions 2026-10-10 to 10-13.** 15 sessions, 155 subagents, 10.79M output tokens: thinking 66 %, subagents 68 %. Slice executors 29 % — 79 slices at a mean of 40k; plan reviewers 10 %, 124k per launch. 12,022 of 12,149 records ran at `xhigh`.
- **Written by order of the texts.** Wiki cards 3.1 % of output, launch messages 2 % and half of that is repeated boilerplate, chat 5.6 %. Repeat rounds and continuations of reviewers about 7.5 %.
- **Input side.** 920M cache read and 37.4M cache write. The main context grows to 300–790k because it is not reset between skills; 46 % of cache read falls on messages above 300k. Ten rebuilds of a large cache after an idle gap over an hour cost 4.3M.
- **Not confirmed.** Unchanged rereads and word-for-word "chat and file" duplicates are almost absent.
- **Text-only cuts.** The audit of the texts sizes all cut candidates together at 15–30k per stand run, 4–8 %.
- **Limits.** Thinking tokens are exact per request (`usage.output_tokens_details.thinking_tokens`); text against tool arguments is split by bytes, ±25 % per cell. The stand's `brain` starts from a ready summary. This project edits the skills themselves, so skill-file reads by subagents are inflated.
- **Scripts.** `~/Documents/my/chain-stand/analysis-2026-10-13/`: `trace/extract.py` then `trace/report.py` for the stand; `real/analyze.py` then `real/report1.py`–`report4.py` for sessions.
- Source: three subagent analyses of 2026-10-13; totals match `metrics.json` of series `en`; the other numbers were not rechecked by the main session
