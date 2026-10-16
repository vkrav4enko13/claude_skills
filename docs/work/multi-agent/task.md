# Task of topic multi-agent

> Several agents of the chain must work in one project folder at once: wait for a busy file instead of asking, tell each other, and not duplicate code.

## In brief

Several agents work in one project folder at the same time — on different topics and on slices of one topic. An agent takes only the files of its current step; a busy file is waited for, never asked about, with a line in the chat. It tells the neighbours, records its edits in a log with a short essence and a diff, so that others reread only what changed and do not write the same code twice. Then the skills go to every profile, and only after that the topic `quality-zero` starts.

## Task

- The user's words of 2026-10-15: "they must learn to work in one folder together, several agents — this is important, think it through"; "if a file is a blocker, do not ask but wait until it is free, and notify other agents"; "write that a file was edited, so another agent knows and can reread it if needed"; "keep briefly what changed or the code, so as not to reread the whole file — decide yourself"; "so that there is no duplicate code"; "spread multi-agent to every place it is used, and only then quality-zero".
- Today the chain assumes one agent per folder. `swork` keeps one time marker `.swork-marker` in the project root and treats every file changed after it and outside the plan as foreign; under git it restores such a file with `git checkout`. A second agent's fresh work would be wiped.
- The shared wiki files — the root index, the journal, `rules.md`, `work/00-index.md` — are edited by every skill with no guard.
- Seen: on 2026-10-11 a neighbouring session wrote a slice into another session's snapshot while that session's menu waited; on 2026-10-15 a reviewer of one stand run wiped the shared temp folder and a neighbouring run with it (`notes/stand-nonstop-parallel.md`).

## Success criteria

- A stand test runs two `swork` sessions at once in one project — once on two topics sharing a file, once on slices of one topic: each reaches its report — the final one or the short one of its own slices — no edit of either is lost, the wait and the notice are recorded, no question is put to the user — R1, R6, R10, R13.
- Blind scenarios — an abandoned claim, a mutual block, a write to a shared wiki file, a reread after another agent's edit, a function another agent already created — each read as required — R2–R5, R8, R11.
- The earlier stand checks stay green: `nonstop-run.sh`, `away-check.sh`, `run-check.sh` — R14.
- The skills are installed to every Mac profile — R15.
