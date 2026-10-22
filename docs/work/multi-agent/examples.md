# Acceptance examples of topic multi-agent

> Cases of the continuation where the behaviour depends on conditions: what happened and what should come out.

- **Different lines of one file.** Agents A and B both edit `GameView.js`, A at lines 321–350, B at 860–882; A merges first. B's merge writes both edits, B waited only while A's merge held the lock — seconds; checks R19, R30.
- **Same lines.** A and B both change line 330; A merges first. B's merge returns a conflict; B takes the shared version with A's edit, applies its own edit again, reruns its step check and merges; both intentions are in the file, B's report names the file; checks R21.
- **Green alone, red together.** A renames a function, B adds a call to the old name in another file; both checks were green alone. After B's merge B's rerun of the step check is red; B fixes the call in its worktree and merges again; checks R22.
- **A duplicate.** A adds `formatReward()` to `GameView.js`, B adds `formatReward()` to `utils.js`; after B's merge the script lists both places; B keeps A's and removes its own, reruns the check, merges; checks R24.
- **A JSON key twice.** A and B both add `"bonus_win"` to `resources.json` or to the locale `en.str`, with different values; the script lists the key; the agent that merged second keeps one value; checks R24.
- **The user edits during a merge.** The user saves `project.json` after the merge took its snapshot; the write sees the file differs from the snapshot, writes nothing and starts again with the user's edit in it; checks R20.
- **A dead agent.** A's session is killed mid-slice with edits in `.agents/wt/<A>`; B finds A's claim abandoned, saves the diff into `.agents/orphans/<A>.diff`, removes the worktree; the slice is free and is done again; checks R28.
- **No git.** The same two agents in a folder without git edit the same file in turn by whole-file claims, as before; checks R27.
- **Wiki journal.** Two agents add a journal line at the same moment; each claims the file for the write, adds its line to the current version; both lines stay; checks R26.
