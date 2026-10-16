# Technical decisions of topic multi-agent

> What the plan chose, instead of what and why; which failures and kinds of input it checks beyond the named ones.

## Technical decisions

- **The wait runs in the foreground in pieces of at most 9 minutes** — instead of a background watch: a background wake of a `-p` session is unverified and may end it; one call per 9 minutes costs almost nothing.
- **A file shared by two topics is rolled back by reversing this topic's own diffs from the edit log** — instead of the snapshot's `base/` copy, which would wipe the other topic; a diff that does not reverse cleanly leaves the file untouched and goes to the report.
- **A red check while another agent holds a live claim in the project is not an attempt** — the agent waits for the release and runs the check again; otherwise a neighbour's half-made edit bypasses a slice for nothing.
- **An edit outside the plan that no agent logged is never restored while another agent is live** — it goes to `known.txt` and the report: without git it cannot be told whose it is.
- **Stages 5–7 are started by the agent that first claims the pseudo-path `<topic folder>/.stage`** — instead of "whoever sees no claim": two agents finishing together would both start them.
- **The agent id is `<pid>:<start epoch>`, the display name is the session id or `codex`** — the pid alone is reused by the system; every subagent of a session shares its pid, so a claim belongs to the session, not to an executor.
- **The time marker of `swork` is `<snapshot>/agents/<agent id>/marker`, a small change keeps `.swork-<agent id>/` in the project root** — instead of one `.swork-marker` in the root.
- **One claim line per file, no "who waits" field** — instead of one line holding a file list and the waiters: no messages are sent, so the waiters need no record; a line per file makes all-or-nothing a simple scan.
- **The topic is a field of every claim and log line** (`-` outside a topic) — the rollback of one topic and the commit list need to tell topics apart, and two sessions share one topic.
- **A continuing agent adopts the oldest marker under `<snapshot>/agents/`, and a legacy root `.swork-marker` is honoured** — a new process has a new id; the oldest misses no edit since the start of the work (changed from "newest" after the review); the seeds of the stand keep working.
- **The stand gives every `claude -p` turn `TMPDIR=<stage folder>/tmp` and builds stands under `$CHAIN_BASE`** — the cause of the 2026-10-15 failure was a wipe of the shared `$TMPDIR`.

## Check focus

- An owner's process is gone and its number is reused by a new process → the start time differs, the claim counts as abandoned and is taken over — S2, line 3
- Two agents claim overlapping sets at the same moment → exactly one gets all its files, the other gets none and waits — S2, line 3
- A diff of another agent is longer than 100 lines → the claim says "reread the whole file" instead of printing it — S2, line 3
- An agent finishing earlier sees another agent's live slice → short report naming that agent, no stages 5–7 — S5, line 8
- A topic rolled back while another topic edited the same file → only its own diffs are reversed — S5, line 8
