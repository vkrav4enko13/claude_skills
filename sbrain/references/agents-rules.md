# Rules of claims between agents

Several agents may work in one project at the same time. Each takes the files it is about to write, the others wait. The claim rule is written only here: the skills refer to these sections and do not retell them.

The script is `scripts/agents.sh` of the running skill; it is called as `bash <path>/agents.sh <command> …` from the project, and its header lists every command and code. Its records lie in `.agents/` of the project root. Inside a topic every call passes `--topic <name of the topic folder>`; outside a topic the option is left out.

## When to claim

- **Before writing a file** of the project or of the wiki — `claim` with all the files of the step at once: the code, the cards, the index, the journal. Claim only what the step writes; reading needs no claim.
- **Code 0** — every file is yours. Each file gets one of three answers:
  - `no changes: <file>` — what you read earlier is still true;
  - the diffs other agents logged since you last held it — take them into account before writing;
  - `reread: <file>` — the changes are too long to print: read the whole file again.
- **A file read earlier is relied on only** after its claim printed `no changes`, printed the diffs, or after it was reread on `reread:`.
- **Code 3** — nothing is claimed, the lines `busy: <file> held by <name>` name the holders: go to "Waiting". A dead owner's claim is removed all the same and named `abandoned: <file> by <name>`.
- A path that is not a file, such as `<topic folder>/.stage`, is claimed the same way: whoever gets it is the one to act.

## Waiting

- **Never hold a claim while waiting**: release what is held (`release <file>…`) before waiting, and claim the whole set again afterwards.
- **Wait with `wait <file>…` in a loop.** Code 3 — still busy, call it again; code 0 — the files are free, now `claim` them. `wait` claims nothing: another agent may get the files first, then wait again.
- **Timeout.** In Claude Code the `wait` command gets a timeout of 600000 ms. In another environment pass `--for <seconds>` shorter than the command timeout of that environment.
- **The user sees a line** before each `wait`: `⏳` and who holds which files, in the user's language. Never ask the user a question about it: the wait ends by itself.
- `abandoned: <file> by <name>` — the owner's process is gone and its claim was removed; the file may hold its half-made edit: read it before writing.

## After a write

- **Call `done "<essence>" <file>…`** with the files of the step and a one-phrase essence of what was changed. It logs one line per changed file with its diff and releases the files; an unchanged file logs nothing.
- **Nothing was written** — `release <file>…` instead of `done`.
