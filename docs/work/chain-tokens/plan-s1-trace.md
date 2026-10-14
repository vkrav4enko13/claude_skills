# S1. Cost map tool `trace.sh`

> One command prints where a series spends its tokens: by stage, role and kind, the input by cache, the effort levels and the reads.

- **Status:** done
- **Covers:** R9
- **Depends on:** none
- **Files:**
  - create: `tests/chain/trace.sh`
- **Interfaces:**
  - gives: `bash tests/chain/trace.sh <series> [<section>…]`; sections `total stages roles kinds input efforts reads overview depth requests`, printed in the order asked; none named — `total stages roles kinds input`. A line is words separated by one space, the first word is the section; the forms are in part 2. No series folder — `no series <name>` to stderr and code 1.
- **Reuse:** the grouping of records by `requestId` — the `jq` reduce of `tests/chain/measure.sh:46-55`; the role keywords — `role_of` in `~/Documents/my/chain-stand/analysis-2026-10-13/trace/extract.py:23-37`; the split of the output into kinds — the same file, lines 113–123.
- **What to do:**
  - Read the run folders `$S/<series>/[0-9]*`; in each the stage folders `brain plan work seed away`, whichever exist; in a stage `raw/*.jsonl`, `raw/subagents/agent-*.jsonl` and `agent-*.meta.json` — nested subagents lie in the same folder.
  - A request is the `assistant` records of one `requestId`: the usage of the last record, the content blocks of all of them without repeats.
  - Thinking is `usage.output_tokens_details.thinking_tokens`. The rest of `output_tokens` is split into `text` and `tool` by the UTF-8 bytes of the text blocks against the JSON of the tool inputs.
  - The role: `main` for the session file; for a subagent by the lowercase `description` of its meta file, first match, where "second round" means it contains `second` or `round 2`: starts with `stage ` — `stage`; contains `plan review` and is a second round — `plan-review-2`; contains `plan review` — `plan-review`; starts with `execute slice` — `executor`; starts with `fix ` — `fixer`; contains `conformance` — `conformance`; is a second round — `review-2`; contains `review` — `review`; otherwise `other`.
  - The first turn of a main session is its requests before the second user record that carries a prompt text, not a tool result and not a meta record.
- **Checks:** lines 1, 2, 3
