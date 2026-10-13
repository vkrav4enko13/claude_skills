# S5. Russian chat, a progress line and a description that starts with the main thing

> The user sees Russian text, the progress in every message, and a final description that opens with the changes in their requirements and ends with what to check and the choice.

- **Status:** done
- **Covers:** R11, R12, R13, R14, R15, R18
- **Depends on:** S4
- **Files:**
  - change: `saway/SKILL.md` (the language paragraph, "What changes while the user is away", section 5, "How to leave so that the session does not stall")
- **Interfaces:**
  - takes: the line forms of `away.md` from S3 (`was: …; became: …`) and S4 (`bypassed: …`)
  - gives: the progress line `Progress: slices <done>/<total> · now: <what runs> · ahead: <stages left>`, which `tests/chain/away-check.sh` finds by `[0-9]+/[0-9]+ · `; the `/goal` line with `stop after 100 turns`
- **Reuse:** the options after the report of `swork/references/report.md:28` — "accept the work", "fix", "roll back everything", "do nothing"; the present `/goal` line of `saway/SKILL.md:101`
- **What to do:**
  1. The language paragraph, add word for word: "Every chat message and the full description are in the language the user wrote in before leaving. `away.md` and the other cards stay English; the description retells them in the user's language in full, not by a link."
  2. "What changes", a new item `**Every chat message ends with a progress line**`: the form from "gives", shown in the user's language; before there is a plan — `Progress: no plan yet · now: … · ahead: …`; `<done>` — the slices with the status `done`, `<total>` — all slices. In the full description it stands right before the last line.
  3. Section 5, the list becomes eight items in this order: **Changed in your requirements** — every edit of a success criterion or a requirement: was, became, why; the item is absent when there were none · **What was done** · **Where it stands** · **Decided without you** — every line of `away.md` in full · **Bypassed** — every bypassed item, its reason and the slices not started because of it · **Waiting for you** · **How to roll back** · **What to check and your choice** — what to look at first, then the four options of the `swork` report by their names, each with what it does: the user answers and `swork` carries it out; the present item "What is needed from you first" merges into it. The `known.txt` sentence stays in "Waiting for you".
  4. The `/goal` line: `stop after 100 turns` instead of `stop after 40 turns`; the rest of the line stays.
  5. "What changes", the item "Before starting each skill of the chain, reread this file": add — and before writing the full description.
  6. Then store the blind reading into `~/Documents/my/chain-stand/away/blind-s5` with `away-blind.sh`; line 23 reads its `result.txt`. Measure the size with the counter of line 28, printing `$((t - b))` first; name the number; over 6000 — shorten the wording added by S3–S5.
- **Checks:** lines 20, 21, 22, 23, 24, 25, 26
