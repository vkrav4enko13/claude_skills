# Project wiki rules

Read before the first write to the wiki in a session. The wiki rules are written only here: the skills and the shared instructions refer to this file and do not retell it.

The wiki is the project's records kept as cards: what is in progress, what is deferred, what is done and what has already been found out about the project. An agent writes it, the next session reads it.

## Where the wiki is

The project root is the output of `git rev-parse --show-toplevel`; in a project without git it is the folder where the session was started. Go in order and stop at the first item that fits:

1. **The project has its own rules for records** — its instructions say where and how to keep them. Those rules apply; no wiki is set up by this file.
2. **There is a `.wiki-path` file** — in the launch folder or above it. It holds one line: the path to the wiki folder from the project root — from the folder where this file itself lies — or `off` — the wiki is not kept in this project.
3. **There is a `docs/00-index.md`** — in the project root or above it. This is the wiki: use it and do not set up a second one.
4. **There is `docs/`, but no `00-index.md` in it** — the folder is taken by other content. Ask the user once: keep the records here, in another folder, or not keep them. "Here" — the wiki is set up in `docs/`, next to what lies there. Another folder — its path from the project root is written to `.wiki-path` in the root. "Do not keep" — `off` is written to `.wiki-path`. The answer is stored in the project; do not ask a second time.
5. **There is no `docs/`** — the wiki is set up in `docs/` at the first edit: the root index and the journal file of the current month, nothing else.

Items 4 and 5 fire only when there is something to write (section "Writing"): a session that read and answered does not ask and does not set up a wiki. The forms of the files of a new wiki are in the "Composition" section.

**No wiki is set up in the home folder or in a temporary folder.** The home folder is `$HOME` itself (on Windows — `%USERPROFILE%`), but not the folders inside it. Temporary folders are `/tmp`, `/private/tmp`, `/var/folders`, `$TMPDIR`, `%TEMP%` and everything that lies in them. If the session was started in such a folder, items 4 and 5 do not apply: instead of writing, say in one line that no wiki is set up here.

## The wiki is not kept

The wiki is not kept in the project in three cases: the project has its own rules for records; `.wiki-path` holds `off`; the session was started in the home folder or in a temporary folder and the project has no wiki. If the project already has a wiki, it is kept from a temporary folder too.

If the wiki is not kept but the work needs a topic folder, it lies where the user named it; if they did not name it, ask once where to put it. Write only to the topic cards: skip the writes to the root index, the journal and `notes/`, do not run the check script, check the card limits yourself and say so in the final message.

## Composition

The wiki folder `W` is `docs/` in the project root by default. The wiki has five parts: `00-index.md`, `rules.md`, `journal/`, `work/` and `notes/`. Everything else in the folder `W` and folders with a dot at the start of the name at any depth are not the wiki: the rules do not concern them, the check script does not see them.

| Path | What it is |
|---|---|
| `W/00-index.md` | The root index: `# <Project>`, a line `> <the project in one phrase>`, sections `## In progress`, `## Deferred`, `## Sections` |
| `W/rules.md` | `# Project rules`, a hook line, lines `- <rule> — YYYY-MM-DD, in the user's words` |
| `W/journal/YYYY-MM.md` | Only the lines of records, without a title: `- YYYY-MM-DD · <what was done> — <why> · <links>` |
| `W/notes/<name>.md` | A card: `# <title>`, `> <the essence in one line>`, items, the last one — `- Source: <file:line, a command or the user's words with the date>` |
| `W/work/<topic>/` | A topic folder: the cards of one piece of work; `<topic>` is in Latin letters, hyphenated |
| `W/<folder>/00-index.md` | A folder index: `# <Name>`, a hook line, `## Cards`, lines `- [<title>](<file>) — <essence>` |
| `W/<folder>/00-archive.md` | An archive index of the same form: the lines of finished topics go here |
| `.wiki-path` in the project root | One line: the path to the wiki folder from the root, or `off` — "do not keep" |

- **The root index** holds the project in one phrase, the "In progress" list — topic, phase, next step — the "Deferred" list and the links to the sections. A line of "In progress": `- [<topic>](work/<topic>/00-index.md) — <phase> — next: <next step>`. A line of "Deferred": `- <what is deferred> — <why or until what>`. "Sections" names only the existing parts of the wiki.
- **`rules.md`** holds the project rules — decisions and answers that hold for the whole project — a line per rule.
- **The journal** is kept as a file per month, a line per task: the date, what was done, why, the links to the cards touched.
- **A folder index** holds a line for every card of its folder.

A link is written from the folder of the file it stands in: from the journal to a note — `../notes/<name>.md`.

```markdown
- [Project rules](rules.md) — decisions and answers that hold for the whole project
- [Journal](journal/) — a line per task, a file per month
- [Topics](work/00-index.md) — topic folders
- [Notes](notes/00-index.md) — facts that cannot be recovered from the code
```

A wiki that has just been set up has one line in "Sections" — the journal; the others are added together with their part. The "In progress" and "Deferred" lists of a new wiki are empty. If no cards were touched, the journal line ends at "why". An index names a nested folder by a link to its index. The archive is set up when the first line is moved into it.

## Card and limits

A card holds one fact: a title, the essence in one line, items. Cards are all the `.md` files in `notes/` and `work/`, except `00-index.md`, `00-archive.md` and the plan overview `plan-overview.md`.

Every card is named in an index: its name stands as the target of a link in the `00-index.md` or `00-archive.md` of its folder. Every folder is named the same way: its `00-index.md` is linked from the index or the archive one level up; for `notes/` and `work/` the level up is "Sections" of the root index.

| What | Limit |
|---|---|
| A card | 60 lines and 6000 characters |
| The root index | 40 lines |
| `rules.md` | 30 lines |
| A folder index `00-index.md` | 100 lines |
| A line of the root index, of `rules.md` and of the journal | 200 characters |
| A line of a folder index, of an archive and of the plan overview | 400 characters |

A journal file, the archive `00-archive.md` and the plan overview `plan-overview.md` have no limit on the number of lines or on the total size; the line length limit applies in them too. Characters are letters, not bytes: a Russian letter is one character.

## Reading

When the session takes its first task in a project with a wiki, read — once per session, at most 80 lines together:

- `00-index.md`;
- `rules.md`;
- the tail of the journal — the last 10 lines of the newest file `journal/YYYY-MM.md`; if it has fewer than ten, take the missing ones from the end of the previous one.

Read the other cards by a link from an index or by search, one at a time.

## Writing

- **Claim before a write.** Before writing a wiki file — the root index, the journal, `rules.md`, a folder index, a note or a topic card — claim it, and after the write call `done`, by `references/agents-rules.md`.
- **Only the main session writes.** A subagent does not write to the wiki; a stage subagent of `saway` stands in for the main session of its stage and writes as it does. Write wiki cards in English, both the format and the content. Words of the user are recorded in English translation. Cards written earlier in another language are read as they are and are not translated.
- **The session only answered questions or read** — do not write to the wiki and do not set up a wiki.
- **A task that changed something is finished** — add exactly one line to the journal. If there is no file for the current month, set it up.
- **Something unfinished or deferred is left after the task** — write it as a line in "In progress" or "Deferred" of the root index.
- **You learned a non-obvious fact or hit a pitfall** — write a card in `notes/`. Only if it cannot be recovered from the code and the cards already written.
- **A card about the same thing already exists** — edit it, do not start a new one. Before a new card, search the folder index.
- **A new card gets a line in the index of its folder.** The first card in a folder also sets up the folder index itself, and a line about it in the index one level up.
- **A project rule** is written to `rules.md` only from what the user said. Do not write an observation of your own as a rule.
- **Check a wiki statement about the code against the code** before you rely on it. If a card is out of date, fix it.
- **Wrote it — name it.** Name everything written to the wiki in one line in the final message.

## Replacement and archive

- **A fact has changed** — fix its card in place, do not start a new one.
- **A decision is replaced** — the old card stays with the status "superseded" and a link to the new one; the new one gets the status "in force".
- **A folder index has outgrown the limit** — move the lines of finished topics into the neighbouring archive index `00-archive.md`. The cards themselves and the topic folders stay in place.
- **Past months of the journal and archive indexes** — read them only by search.
- **Wiki records are not retold and not compressed.**

## Check

After every write to the wiki, once `done` is called, run the check script and fix everything it names. The script lies in the skill folder, next to `references/`:

```bash
bash <skill folder>/scripts/check.sh <wiki folder>
```

No violations — the line `wiki is fine`, code 0. If there are any — code 1 and a line per violation: `<path from the wiki folder>[:<line number>]: <violation>`. Code 2 — the path was not given or the folder has no `00-index.md`. The script itself changes nothing. Once fixed, run it again.

| Violation | How to fix |
|---|---|
| `card is longer than 60 lines`, `card is longer than 6000 characters` | Split the card by meaning into two — `<name>-<part>.md` — and name both in the index |
| `index is longer than 100 lines` | Move the lines of finished topics into `00-archive.md` of the same folder; do not touch the cards |
| `root index is longer than 40 lines` | Remove the lines of finished topics from "In progress", and what is done or withdrawn from "Deferred" |
| `rules are longer than 30 lines` | Ask the user which rules are out of date: they are written from what the user said, do not remove them yourself |
| `line is longer than 400 characters`, `line is longer than 200 characters` | Shorten the line |
| `no line in index <folder>/00-index.md` | Give the card or the folder a line in the named index |
| `broken link <target>` | Fix the link or remove it |
| `no title or hook line` | Give the card a title `# …` and a hook line `> …` |

Name to the user a violation that cannot be fixed without their decision, and ask.

**The script does not run** — check the limits yourself, by the table from "Card and limits", and say so in the final message.
