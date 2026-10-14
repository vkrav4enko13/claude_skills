<!-- project-wiki:begin -->
## Project wiki

The project has a wiki — records for the next session. The full rules: `{{RULES}}`; read them before the first write in a session.

- **Where.** `docs/00-index.md` in the project root or higher up the folder tree; the root is the git root, without git — the launch folder. A `.wiki-path` file in the root names another wiki folder or `off` — "do not keep". If the project has its own rules for records, they apply and this wiki is not kept.
- **At the start of a session, once:** read `00-index.md`, `rules.md` and the last 10 lines of the journal in `journal/`. The rest — by a link or by search, one card at a time. What is decided in `rules.md` is a fact.
- **After a task that changed something:** one line in the journal. What is unfinished — as a line in "In progress" or "Deferred" of the index. A non-obvious fact or a pitfall — as a card in `notes/`, if it cannot be recovered from the code and the cards; search first: if there is a card, edit it. A project rule in `rules.md` — only in the user's words.
- **You only answered or read** — do not write to the wiki and do not set it up.
- **There is no wiki** — set it up at the first edit: the index and the journal, nothing else. Do not set it up in the home folder or in a temporary folder, and say so. If `docs/` holds something else, ask once where to keep the records.
- **After a write** run `{{CHECK}} <wiki folder>`{{NOTE}} and fix what it names; if it does not run, check the limits yourself and say so.
- **In the final message** name in one line what you wrote to the wiki.
- **Records are a hint:** check a statement about the code against the code, fix an out-of-date card.
- **A subagent** does not write to the wiki; a stage subagent of `saway` stands in for the main session of its stage and writes as it does.
<!-- project-wiki:end -->
