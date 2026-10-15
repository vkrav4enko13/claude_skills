# S3. swork decides instead of stopping

> A started `swork` meets a former stop case, decides, flags it in the chat and goes on to the report.

- **Status:** done
- **Covers:** R1–R10, R12
- **Depends on:** S1
- **Files:**
  - change: `swork/SKILL.md` (lines 14, 16, 24, 28, section 4, "Rules for all stages", Traps)
  - change: `swork/references/slices.md` (lines 35–55, section "Stop menu")
  - change: `swork/references/entry.md` ("Continuing interrupted work")
  - change: `swork/references/snapshot.md` (lines 15, 57, 67–72)
  - change: `swork/references/finish.md` (lines 9, 15–21, 37)
  - change: `swork/references/small.md` (line 9)
- **Interfaces:**
  - gives: section `## 4. Own decisions` of `swork/SKILL.md`; section `## Decisions and bypass` of `slices.md`; statuses `bypassed`, `not checked`; the chat line `⚠ Decided myself — S<N>: <problem> → <choice> → <why>` in the user's language; the log line `S<N>: decided myself — <problem>; chosen: <what>; why: <reason>; otherwise: <what would change>`; marks "not checked" and "on unchecked ground" in "Progress log"
- **Reuse:** the bypass items of `saway/SKILL.md` lines 84–91 (dependents, everything else executed, reviewers' sentence, screening) — moved, not copied; `known.txt` handling of `snapshot.md`; the `base/` copies of the snapshot
- **What to do:** in [part 2](plan-s3-decide-2.md) and [part 3](plan-s3-decide-3.md)
- **Checks:** line 8
