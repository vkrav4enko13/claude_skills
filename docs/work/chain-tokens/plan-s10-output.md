# S10. Batch "repeated output"

> The plan overview is written once and is the one detailed text, the executor's packet is assembled by a script, `saway` shows nothing to an absent user along the way; the series `b2` confirms the quality.

- **Status:** done
- **Covers:** R15, R16, R17, R18, R24
- **Depends on:** S9
- **Files:**
  - change: `splan/references/plan-format.md` ("Overview", "Order of writing"), `splan/references/approval.md` (sections 7–9), `splan/SKILL.md` (the entry table)
  - create: `swork/scripts/packet.sh`
  - change: `swork/references/executor.md` ("Packet", the task block), `swork/references/slices.md` (steps 3 and 6), `swork/references/finish.md` (the fix by a conformance finding)
  - change: `saway/SKILL.md` (the stage task, sections 3 and 5), `tests/chain/rules.md` (the rules these edits change, the `file:line` tails)
- **Interfaces:**
  - takes: the stage task of `saway` (S8); `tests/chain/levers.tsv`; the gate procedure; `gate.sh … --group output`; `trace.sh <series> overview|kinds`
  - gives: `bash <skill folder>/scripts/packet.sh <topic folder> <slice number> <project root> [<created.txt>]` — prints the packet; no card of that slice — `no slice S<N>` to stderr and code 1. The series `$S/b2`, the run `$S/away-out/1`.
- **Reuse:** the eight items of "Packet" in `swork/references/executor.md:11-18` — their order is the order of the output; the cut-into-a-file mechanism of `swork/SKILL.md:17`; `sbrain/scripts/check.sh` as the model of a skill script
- **What to do:** in part 2; make only the edits of the levers that `levers.tsv` marks `taken`, save the files into `$S/b2/before/` first; none of the group is taken — no edit, no series. Only R18 is taken — no series `b2`, only the run of the stage `away`; line 34 then gets `not run: only R18 taken`.
- **Checks:** lines 30, 31, 32, 33, 34
