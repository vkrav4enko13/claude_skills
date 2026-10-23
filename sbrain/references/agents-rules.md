# Rules of claims between agents

Several agents may work in one project at once: each claims the files it will write, the others wait.

The script is `scripts/agents.sh` of the running skill, called from the project as `bash <path>/agents.sh <command> …`; its header lists the commands and codes. Records lie in `.agents/` of the project root. Inside a topic every call passes `--topic <name of the topic folder>`.

## Switch

- **The rules of this file hold only while the project root holds `.agents/mode`.** Without it `agents.sh` answers `agents: off`, `busy` finds nothing, nothing goes to `.agents/` — write as a single agent but keep making the calls: they are the check before each write.
- **The user asks to work with several agents** — before the first write `bash <path>/agents.sh on`, with `worktree` or `shared` when the user named one ("without worktree" means `shared`).
- **The user asks to stop it** — `agents.sh off`. `swork` before its report and `saway` before its full description call `agents.sh off --if-last` and name the outcome: `mode: off` — switched off; `mode: kept — <reason>` — who keeps it.

## When to claim

- **Before writing a file** of the project or the wiki — `claim` all the step's files at once: code, cards, index, journal. Only what the step writes; reading needs no claim. In the shared mode of `swork` the executor claims each file for its write by `swork/references/modes.md`.
- **Code 0** — every file is yours: edit the current version; a line for an append-only card (the journal, "Progress log", an index list) goes into the current file, keeping others' lines. Each file gets one of:
  - `no changes: <file>` — what you read earlier still holds;
  - the diffs other agents logged since you last held it — account for them before writing;
  - `reread: <file>` — too long to print: read the whole file again.
- **A file read earlier is relied on only** after its claim printed `no changes` or the diffs, or after a reread on `reread:`.
- **Code 3** — nothing claimed; `busy: <file> held by <name>` names the holders: go to "Waiting". A dead owner's claim is removed and named `abandoned: <file> by <name>`.
- A path that is not a file, such as `<topic folder>/.stage`, is claimed the same way: whoever gets it acts.

## Waiting

- **Never hold a claim while waiting**: `release <file>…` before waiting, claim the whole set again after.
- **Wait with `wait <file>…` in a loop.** Code 3 — busy, call again; code 0 — free, now `claim` (`wait` claims nothing; lost the race — wait again).
- **Timeout.** In Claude Code `wait` gets a timeout of 600000 ms; elsewhere pass `--for <seconds>` shorter than the environment's command timeout.
- **The user sees a line** before each `wait`: `⏳` and who holds which files, in the user's language. Never ask the user about it.
- `abandoned: <file> by <name>` — the file may hold a half-made edit: read it before writing.

## After a write

- **Call `done "<essence>" <file>…`** with the step's files and a one-phrase essence of the change. It logs each changed file's diff and releases the files.
- **Nothing was written** — `release <file>…` instead of `done`.

## Worktree

In the worktree mode a `swork` agent edits in its own git worktree under `.agents/wt/`: `wt` creates it, `sync` brings in the shared folder's merged changes before a step, `merge` writes its green edits back, `drop` removes it. Code 4 of `sync` and `merge` — a conflict to resolve in the worktree; code 5 of `wt`, `sync` and `merge` — use the shared mode. A dead agent's unmerged edits are saved in `.agents/orphans/`; every wait is logged in `.agents/waits.tsv`. The order of these calls — `swork/references/worktree.md`.
