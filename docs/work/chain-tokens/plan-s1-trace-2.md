# S1. Cost map tool `trace.sh` — part 2

> The forms of the lines of every section; the numbers are sums over the runs of the series unless a form says otherwise; "per run" in S5 is such a sum divided by the runs.

- `total runs <n>`, `total output <tokens>`, `total thinking <tokens>`, `total output_per_run <output / runs, rounded down>`.
- `stages <stage> <output> <thinking>` — a line per stage the series has.
- `roles <role> <output> <launches> <prompt>` — `<prompt>` is the `tool` tokens of the `Agent` calls that launched this role, matched by `toolUseId` of the meta file; for `main` — launches is the number of sessions, prompt is 0.
- `kinds <role> <thinking|text|tool> <tokens>` — three lines per role.
- `input <uncached|cache_write|cache_read> <tokens> <tokens / runs, rounded down>` — from `input_tokens`, `cache_creation_input_tokens`, `cache_read_input_tokens`.
- `efforts <first|later|agents> <level> <requests>` — by the `effort` field of the records: `first` — the first turn of the main sessions, `later` — their other requests, `agents` — all subagents.
- `reads <role> <class> <calls> <bytes>` — a call is a `Read` tool call, or a `Bash` call whose command starts with `cat`, `head`, `tail`, `less` or `sed -n` and names a path under `.claude/skills/`; a command that names several files is a call per file, and the bytes go to the first of them; `<bytes>` is the size of the tool result. The class by the path: the file name `wiki-rules.md` — `wiki-rules`; `executor.md`, `conformance.md`, `simplify.md` or `review.md` under `.claude/skills/swork/references/` — `task`; anything else under `.claude/skills/` — `skill`; under `docs/` — `card`; otherwise `other`. For `main` the classes `task` and `skill` are printed with zeros too. After them one line `reads session-max wiki-rules <the largest number of wiki-rules calls in one session, its subagents counted with it>`.
- `overview <run> <writes> <tokens> <first> <before|after|none>` — the stage `plan` of a run: the `Write` calls of the main session whose path ends in `plan-overview.md`, the `tool` tokens of all of them, of the first of them, and whether the first comes after the first `Agent` call; no such call or no `Agent` call — `none`.
- `depth <n> <launches>` — the subagents by `spawnDepth` of the meta file.
- `requests <run> <stage> <role> <output> <thinking> <text> <tool> <cache_write> <cache_read>` — a line per request, in the order of time.
