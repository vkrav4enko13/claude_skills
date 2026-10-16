# S3. Wiki writes under a claim, in every skill

> `sbrain`, `splan`, `swork` and `saway` claim a wiki file or a topic card before writing it and log the edit after.

- **Status:** done
- **Covers:** R13
- **Depends on:** S2
- **Files:**
  - change: `sbrain/references/wiki-rules.md` (section "Writing", lines 85–96; section "Check", lines 106–113)
  - change: `sbrain/references/topic-cards.md` (line 23, the "A card" rule)
  - change: `splan/references/plan-format.md` (line 23, the "A card" rule)
  - change: `swork/SKILL.md` (the paragraph "Who writes to the plan and to the wiki")
  - change: `saway/SKILL.md` (section "What changes while the user is away")
- **Interfaces:**
  - takes: `agents.sh claim|wait|done`, sections `## When to claim`, `## Waiting`, `## After a write` of `references/agents-rules.md` (S2)
- **Reuse:** the existing references to `references/wiki-rules.md` by section; no new rule text beyond one pointer per place
- **What to do:**
  1. `wiki-rules.md`, "Writing": a first bullet — "**Claim before a write.** Before writing a wiki file — the root index, the journal, `rules.md`, a folder index, a note or a topic card — claim it, and after the write call `done`, by `references/agents-rules.md`." "Check": the check script runs after `done`.
  2. `topic-cards.md:23` and `plan-format.md:23`: after "by `references/wiki-rules.md`" add "; a card is written under a claim — `references/agents-rules.md`".
  3. `swork/SKILL.md`, "Who writes…": "Only the main session" becomes "Only the main session of an agent, under a claim by `references/agents-rules.md`"; the check script names cards of other topics too — fix only the cards of this topic.
  4. `saway/SKILL.md`: one bullet — a busy file is waited for by `agents-rules.md` of the stage skill, not bypassed and not asked about.
- **Checks:** line 5
