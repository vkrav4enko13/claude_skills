# Decisions of topic multi-agent, part 3

> The additions of 2026-10-21 after the user returned: the shared mode, the choice of the mode, submodules, the mode only on request — a line per decision.

- A shared mode next to the worktree mode: the agent edits in the shared folder and claims a file only for the seconds of a write, instead of a copy of the folder merged by own code — no copy, no merge; the price is that neighbours' checks may see an unfinished edit; user chose; in force
- The mode is picked by itself — the worktree where possible, the shared mode otherwise — and can be fixed by hand in `.agents/mode` or a word in the request, instead of only automatic or the shared mode by default; user chose; in force
- A repository with submodules keeps the worktree mode with the submodules cloned read-only, and a slice writing inside a submodule runs in the shared mode — instead of the whole repository without a worktree or a full merge inside submodules; user chose; in force
- Without git or with git older than 2.40 the shared mode is used, instead of whole-file claims in turn — follows from the user's "the shared mode where a worktree is impossible"; agreed; in force
- Wiki writes stay in the shared folder under a claim held for the write, the edit applied onto the current version and the lines of append-only cards kept — this is the merge of the wiki the user agreed to, done by the agent, instead of a git merge of wiki cards; agreed; in force
- The worktree mode needs git 2.40 or newer, instead of 2.38 — `git merge-tree --merge-base` came in 2.40 (a reviewer's recollection, unchecked); agreed; in force
- The multi-agent mode works only on the user's request, switched for the whole project by `.agents/mode` that every skill checks before a write, instead of always or per session — a session not told would not see the claims of others; user chose; in force
- The mode is switched off at the user's request or by the last agent to end when no live claim and no worktree of another agent remain, instead of only at the user's request; agreed; in force
