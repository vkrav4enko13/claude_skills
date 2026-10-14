# Decisions of topic chain-tokens — part 2

> Decisions made at the planning stop of 2026-10-13, after the recon and two probes.

- The skills pin `medium` in the frontmatter and at every subagent launch, and the later turns of the main session follow the session level, instead of a pin for the whole session — the frontmatter level holds for one turn; user chose; in force
- The one detailed text of the plan is the overview file, instead of the chat — the file outlives the session, and `swork` and `saway` use it; user chose; in force
- The context levers R21 and R22 enter the work without the 3 % threshold, instead of being deferred — the threshold counts output, they save cache read; user chose; in force
- `saway` gets a clean context from a stage subagent that stands in for the main session and writes the cards, instead of a child `claude -p` session — less plumbing; the wiki rules get one exception; user chose; in force
- Strictly `medium`, errors fixed in the texts, instead of raising a failed role to `high` and `xhigh` — raising `swork` gave 8 violations instead of 6, and the failing rules fail at `xhigh` too; user chose 2026-10-14; in force
