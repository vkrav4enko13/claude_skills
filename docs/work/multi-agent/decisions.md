# Decisions of topic multi-agent

> What was chosen, instead of what, and whose decision — a line per decision.

- Two topics: `multi-agent` first, `quality-zero` after it, instead of one topic or quality first — quality would have to be measured again after this edit; agreed; in force
- Agents work both on different topics and on slices of one topic, instead of only one of the two; user chose; in force
- An agent claims the files of its current step, instead of the whole folder for a run — others wait only on an overlap; agreed; in force
- The claims file is the truth and a message is added in Claude Code, instead of messages alone — works in Codex too, a lost message cannot hang a waiter; agreed; superseded by the shell watch below
- Wait while the owner lives, instead of a timeout or waiting forever; agreed; in force
- Any agent writes a topic card under a claim, instead of one leading agent — the fall of one does not stop the rest; agreed; in force
- An owner is alive while the process of its session exists, instead of a heartbeat every 30 minutes — a slice with an hour-long live run would look abandoned; agreed; in force
- All four skills use claims, instead of only `swork` and `saway` — the shared wiki files are edited by all; agreed; in force
- All files of a step or none, never waiting with a claim held, instead of claiming one by one — no mutual block; agreed; in force
- Acceptance by a live test of two `swork` plus blind scenarios, instead of scenarios alone; agreed; in force
- Neighbours get only "released" for files they wait for; the user sees `⏳` lines and the waits in the report, instead of every claim to everyone; agreed; superseded for the messages by the shell watch below, the `⏳` lines stay
- A shell watch on the claims file wakes the waiter, no messages between sessions; records are one tab-separated line — instead of messages and markdown tables: a file event cannot be lost, costs no tokens while waiting, works in Codex; user chose; in force
- The edit log keeps an essence, the line ranges and the diff; the whole file is reread only over 100 diff lines — instead of rereading every edited file — the user's "so as not to reread the whole file, decide yourself"; agreed; in force
- No duplicate code: the executor looks at what other agents created before writing a function; one script and one rules file, instead of rules copied into each skill — the user's words; agreed; in force
- Claim and "what changed" in one call, release and log in one call, the diff computed by the script — instead of separate calls and the model writing log lines: the cheapest per step; the user's "is there something cheaper"; agreed; in force
- The wait runs in the foreground in pieces of at most 9 minutes, instead of a background watch — a background wake of a `-p` session is unverified and may end it; agreed at the plan stop, 2026-10-15; in force
- An agent that finishes earlier ends with a short report of its own slices, instead of no report — the acceptance needs every session to end; agreed at the plan stop; in force
- Commit, `install.sh --mac` to every profile, then `quality-zero`; user chose; in force
