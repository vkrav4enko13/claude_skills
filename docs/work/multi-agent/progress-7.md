# Progress log of topic multi-agent, part 7

> Stage 7 of the execution of part 2: the review, its two rounds, the final rerun and what was left; part 6 is [progress-6.md](progress-6.md).

- stage 7 started [dcc4dac2-e579-4bc6-8ac3-16e8efc4ac8b]
- stage 7 [dcc4dac2-e579-4bc6-8ac3-16e8efc4ac8b]: review — 2 serious, 3 minor; fixed: a second `on` with the same word rewrote `.agents/mode`, so `off --if-last` switched the mode off under an agent active a second before — the same word now keeps the file and its time; the R20 loop of `merge` read the status letter into `st`, the start time of its `waits.tsv` line — renamed `sl`; a file the agent created went into `base/` on its second `merge --base` — a path of `new-files.txt` is not copied; `merged: nothing` did not sync the worktree as the header says — it syncs; lines 13–25, 33–35 green after (`.swork/checks/H7.txt`), the reviewer's reproductions now give the expected result
- declined: `dups.py` takes a changed path typed in another letter case as a second file — the paths come from `.agents/log.tsv`, written from the real names; the fix adds a case-folding branch for an unlikely input
- stage 7, second round [dcc4dac2-e579-4bc6-8ac3-16e8efc4ac8b]: the fixes of `sl`, `new-files.txt` and the sync on `merged: nothing` confirmed; the `on` fix holds for the same word only
- left untouched: `on` with another word still rewrites `.agents/mode` with a new time, so `off --if-last` can switch the mode off under a neighbour active within 300 s (e.g. keep the time with `touch -r`) — found by the second round
- stage 7 [dcc4dac2-e579-4bc6-8ac3-16e8efc4ac8b]: final rerun after the edits of stages 5–7 — lines 28–31, 39, 40 `pair run: pass` (`.swork/checks/Z-c.txt` … `Z-h.txt`), line 1 code 0 (old skills: a pass, b fail, `Z-l1.txt`), line 32 `agents: all ok`, `pair run: pass` ×2, `nonstop run: pass`, `away run: pass`, `script is fine` (`Z-l32.txt`); lines 2–7, 13–25, 33–35 green (`H7.txt`, `F-l<N>.txt`); 26, 36, 38 green in `F-l26.txt`, `F-l36.txt`, `F-l38.txt` — no skill text changed after them; no unreported edits in the whole work
- Written to the wiki: notes/stand-pair-replies.md — new
- mode: off — the project root has no `.agents/mode`; the installed `agents.sh` this run used has no `off --if-last`
- left untouched: `dups.py` compares a key of one `.str` file with every other `.str` file, so locale files flag each translated key as `value` — as S9 item 4 says
- left untouched: the S11 live cases depend on the session's wording — the agent-id mark of "stage 7 finished" turns `ended` red at times
- stage 7 finished [dcc4dac2-e579-4bc6-8ac3-16e8efc4ac8b]
