# S8. Handoff into a new session; `saway` stages from a clean context

> The handoff menu offers first to start the next skill in a new session, with the command; `saway` runs every stage in a subagent of its own.

- **Status:** done
- **Covers:** R21, R22, R25
- **Depends on:** S6, S7
- **Files:**
  - change: `sbrain/references/handoff.md` (section 8), `splan/references/approval.md` (section 9)
  - change: `saway/SKILL.md` ("What changes while the user is away", section 2)
  - change: `sbrain/references/wiki-rules.md` ("Writing", the first item), `sbrain/references/wiki-block.md` (the last item)
  - change: `tests/chain/rules.md` (two new rules, the `file:line` tails)
  - change: `tests/chain/away-check.sh` (part 3, the last two items), `tests/chain/away-scenarios.md`, `tests/chain/away-expected.tsv` — only by the item about a red line
- **Interfaces:**
  - takes: the paragraph "Subagents run at `medium`." (S6); `away-blind.sh` (S7); the commands of the stage `away` from S4
  - gives: the stage task of `saway` — a code block in `saway/SKILL.md` with the reply fields `PHASE`, `ENDED`, `FOR THE USER`; a stage subagent is launched with a description that starts with `Stage ` — S10 adds one sentence to that block
- **Reuse:** the menus of `sbrain/references/handoff.md:13-21` and `splan/references/approval.md:40-47`; the table of section 2 of `saway/SKILL.md`
- **What to do:** in parts 2 and 3
- **Checks:** lines 22, 23, 24, 25
