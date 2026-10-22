# Design of topic multi-agent, part 4

> Sections 12–15, written from the summary the user approved on 2026-10-21: the switch of the multi-agent mode, the choice of the mode, the shared mode, submodules.

## 12. Switch — R35, R36

- **Off by default.** Without `.agents/mode` the four skills skip every `agents.sh` call and write as a single agent; `.agents/` is not created.
- **On.** When the user asks a skill to work with several agents, the skill writes `.agents/mode` — `auto`, or `worktree` / `shared` if the user named one — and adds `.agents/` to `.git/info/exclude` under git.
- **Checked before each write** by a test of the file, so a session started before the switch joins at its next write.
- **Off.** At the user's request the file is removed; an agent ending its work removes it when `busy` shows no live claim of another agent and `.agents/wt/` holds no worktree of a live agent; the report names it.

## 13. Choice of the mode — R32

`auto` takes the worktree mode when git is 2.40 or newer, the root is the git top level and `wt` succeeds; otherwise the shared mode, with the reason in the report. `worktree` that cannot be made falls back to the shared mode with the reason; `shared` is obeyed as written.

## 14. Shared mode — R31

- `swork` claims the slice card to pick a slice (R18), never its "Files": the executor claims a file right before a write and calls `done` right after it, in one step of its work.
- Each claim prints the diffs of others since its last hold (R7), so the edit is made onto the current text.
- After every step: the duplicate script on the files the step changed; a red check in a file another live agent edited during the step — `wait` for that agent's next `done`, then the check once more; a red that stays is the agent's own.
- The wiki writes are the same in both modes (R26).

## 15. Submodules — R33

`wt` clones each submodule folder into the worktree with `cp -cR` and does not merge it back; a slice whose "Files" lie inside a submodule runs in the shared mode while the rest of the agent's work stays in its worktree.
