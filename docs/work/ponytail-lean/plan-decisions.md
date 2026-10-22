# Technical decisions of topic ponytail-lean

> What the plan chose, instead of what and why; which failures and kinds of input it checks beyond the named ones.

## Technical decisions

- **`codemap.sh` lives in `swork/scripts/`; `install.sh` and `stand.sh` copy it into `splan/scripts/`** — instead of a copy in each skill folder: one owner, the same way `check.sh` and `agents.sh` of `sbrain` reach `splan` and `swork`.
- **The map is run by `packet.sh` with a 10-second limit made in bash (a background job and `kill`)** — instead of coreutils `timeout`, which this Mac lacks; a hung or failed map leaves the packet without the block.
- **The `LADDER:` field is kept by the main session in `.swork/ladder.txt` and its path is passed to the conformance check** — instead of the whole executor reply: the conformance task still gets no executor reports; this one field is the named exception.
- **A caller outside the slice's "Files" goes through the status "need a file"** — instead of letting the executor edit it: rule 2 of the executor stays whole.
- **The simplification and the review read the executor rules from `<skill folder>/references/executor.md`** — instead of a copy in their tasks: R8, one owner.
- **Hooks: a repo folder `hooks/` with `chain-rules.md`, `inject.sh` and `lang.sh`; `install.sh` copies it to `<profile>/chain-hooks/` of the two Claude Code profiles and merges three entries into their `settings.json` with `jq`, recognised by the path part `/chain-hooks/`** — instead of a skill folder: hooks are not a skill; the marker lets a rerun replace and `--uninstall` remove only ours. Codex gets none (the user's choice 2026-10-17).
- **On the stand the candidate gets the hooks through the box project's `.claude/settings.json`, written by `stand.sh` when the skills folder has `hooks/`** — instead of the profile: stand runs read only project settings, and the baseline must run without hooks.
- **The baseline series takes `rules.md` from `<skills folder>/tests/chain/rules.md` when it exists** — instead of the working tree's file: the baseline is judged by the rules of `cda6856`, whose citations match its skills.
- **"Judge violations not more" counts only rules present in both series' `rules.md`; violations of the new rules are shown on their own line** — instead of all rules: the baseline has no measure for rules that did not exist.
- **Trap measures: delivered lines = added lines of `git diff --no-index --numstat` between the seeded copy and the result, outside `tests/`, `docs/`, `.claude/`, `.git/`, `.agents/` and `.swork*`; compressed size = `gzip -c` bytes of those added lines; risky test = a new or changed file under the project's `tests/`; cost = `total_cost_usd` of the last turn of each stage, summed** — instead of a parser per language: the trap projects are bash.
- **Over-engineering judge: `claude -p` at `medium`, no tools; raised to `xhigh` only if calibration fails at `medium`** — instead of `xhigh` from the start: the chain rule of `medium`.
- **Injected bugs: three `sed` mutants per delivered non-test file (first comparison flipped, first `if` condition made `true`, first integer literal plus one); a mutant is caught when a delivered test exits non-zero** — instead of a mutation tool: none is installed.
- **R31 closing lines stand before the menu or the fixed last line: `Before the menu or the fixed last line, write one or two lines: what was not done, what was not verified, and any risk.`** — instead of literally after it: the last messages of `sbrain`, `splan` and `swork` end with a menu, and `saway` ends with a fixed line its checks rely on.
- **Trap runs are measured by scripts and by the over-engineering judge, not by the main judge; trap stage names stay out of the series' `stages` file** — instead of extending `judge.sh` and `zero.sh`: the new rules are judged on the `count` and `longest` topics, and the traps measure code, not process.
- **Series tokens, wall time and cost are summed over every stage folder of every run (`raw/`, `stage.json`, the last `turns/*.json`)** — instead of `metrics.json`, which covers four stages and has no cost.
- **`compare.sh --only "<stages>"` compares only the named stages and, with `traps`, the trap measures** — instead of a full series per ablation group: an ablation series runs only the stages its failing measure comes from.
- **A trap ratio with a baseline median of 0 is `n/a` and is left out of the geometric mean; acceptance compares the sums of per-task medians** — instead of dividing by zero: 0 is normal for `overeng`, `caught` and `hidden`.
- **The hook rules are scoped to chain-skill work and name the executor rules by an absolute path that `inject.sh` fills in from `$(dirname "$0")/../skills`** — instead of a relative path: `<profile>/chain-hooks/` and a stand box's `.claude/chain-hooks/` both sit next to their `skills/`.
- **Wall time is the sum of the stages' `wall_s`; a series that fails only on time is "not accepted on time", and nothing is reverted by itself** — instead of an automatic rerun: R25 ablation is for quality measures.

## Check focus

- the code map of a big project → output stays at 2,000 characters or less, ends with a truncation line — S1, line 2
- file and folder names with spaces or Cyrillic letters → listed, no error — S1, line 4
- the map script hangs → the packet is still printed within about 10 seconds, without the map block — S1, line 8
- a profile with no `settings.json` or with no `hooks` key → the file is created or extended, other keys kept — S7, line 33
- the candidate's violations only on new rules → not counted against the baseline, shown on their own line — S12, line 46
