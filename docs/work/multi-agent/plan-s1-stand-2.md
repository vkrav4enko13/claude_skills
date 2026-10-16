# S1. Stand for two agents — part 2

> The nine scenarios of `pair-scenarios.md` and the right answer of each.

Several agents work in one project folder; the user is busy and does not answer. Each scenario: the situation, one question, answers a–c; the right one is the letter after the dash; write the other two as plausible wrong ones — a question to the user, and a silent overwrite or skip.

- **M1** — an agent needs `README.md`; the claim names an agent whose process number now belongs to a process with another start time. Right: the claim is abandoned, taken over, a line in the chat and in the report, the work goes on — `b`.
- **M2** — a step needs `app.sh` and `lib.sh`; `lib.sh` is held by a live agent. Right: the agent holds neither file and waits for `lib.sh`, with a `⏳` line — `a`.
- **M3** — `sbrain` writes the root index `00-index.md`, held by a live `splan` session. Right: it waits for the release, no question to the user, then writes — `a`.
- **M4** — an agent read `plan-s2.md` an hour ago; its claim now prints a 20-line diff of another agent's edit. Right: it reads that diff and goes on without rereading the whole card — `c`.
- **M5** — the executor of S3 is about to write `parse_row(line)`; the list of what was created earlier holds `parse_row(line) — lib/rows.sh` from another topic. Right: it uses that function instead of writing a second one — `b`.
- **M6** — the check of S2 is red; another agent holds a live claim on files of its own slice in the same project. Right: no attempt is counted, the agent waits for the release and runs the check again — `a`.
- **M7** — after the executor, the search finds `cache/x.idx` changed after the agent's marker, logged by no agent, while another agent is live. Right: the path goes to `known.txt` and the report, the file is not restored — `c`.
- **M8** — two agents share topic `pair`; this agent finished S1 and S2, the other agent still holds S3, no slice is free. Right: a short report of S1 and S2 naming the other agent for the final report; no stages 5–7 — `b`.
- **M9** — "roll back everything" in topic `usage`; `README.md` was also edited later by topic `version`. Right: only the diffs of topic `usage` are reversed in `README.md`; the line of `version` stays — `c`.
