# Task of topic chain-tokens

> The chain spends most of its tokens on thinking at `xhigh` and on checkers; we move it to `medium` under a quality gate and then cut what a fresh map shows.

## In brief

The four chain skills move to effort `medium`, pinned in the skills themselves, after the stand has shown that quality is not worse than at `xhigh`. Then, by a cost map taken at `medium`, extra reading, repeated writing, the full second review round and context growth are removed in batches, each with its own check.

## Task

The owner runs `sbrain → splan → swork` and `saway` on Opus 5.5 under a subscription limit and hits it. Measured on 2026-10-13:

- A stand run emits 396k output tokens; 59 % of them are thinking, 46 % belong to read-only checkers.
- Real sessions of 2026-10-10 to 10-13 emitted 10.79M output tokens; 66 % thinking, 68 % inside subagents; all of it at `xhigh`.
- Text the skills order to be written — cards, launch messages, chat, menus — is about 11 % of output; cutting duplicates in it gives 4–8 %.
- The main session is not reset between skills: `splan` and `swork` start at 240–750k tokens of context, and 46 % of cache read falls on messages above 300k.
- Anthropic advises `medium` as the starting level for Opus 5.5; the stand hardcodes `xhigh`.

The owner suspected bloated texts. The measurements say the texts cost mostly through what they make the model read before it thinks, not through their own length.

## Success criteria

- The baseline series at `medium` passes the quality gate against series `en` — R6.
- The final series emits at least 10 % fewer output tokens per run than the baseline series and passes the same gate — R26.
- No edit reaches the Mac profiles before a series with it has passed the gate — R8.
