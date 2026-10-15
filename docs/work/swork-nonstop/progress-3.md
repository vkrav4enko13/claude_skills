# Progress log of topic swork-nonstop, part 3

> The review findings left untouched or declined, and the end of stage 7.

- left untouched: a bypassed slice keeps its half-made edits in a file a `done` slice names — the plan decision restores only files no ran slice names; per-slice copies change the plan
- left untouched: the seeded S4 needs a "What to do" edit, which the own card edit does not allow; a run following the text bypasses S4 — the gate passed live, the widening was reverted
- left untouched: a continued `awaiting manual check` slice becomes `not checked` — R8 as written; the report loses it as a pending manual check
- left untouched: foreign files of a crashed executor go to `known.txt` on continuation — R8 as written; a rollback does not restore them
- left untouched: "accept the work" deletes `.swork/` with a "Rollback" saving kept inside it — changes the accept order, outside the plan
- left untouched: `not checked: <reason>` is written by no `swork` text; `entry.md:19` names a report target `report.md` lacks — plan gaps
- declined: a legacy `stopped` slice taken as red after two attempts is too blunt — a technical decision of the plan
- declined: a slice the old `saway` forbade with only an `away.md` line is executed — met only by a topic in flight before the edit
- declined: `nonstop-check.sh` "report in turn 1" may pass on a question holding "Принять" — unlikely, adds branches
- declined: a "Rollback" slice rerun after a card edit may repeat its saving — a guess, no reproduction
- stage 7 finished — final text: line 8 green, line 6 `9 of 9 ok`, line 5 `nonstop run: pass` run alone (`.swork/checks/F-l8.txt`, `F-l6.txt`, `F2-l5.txt`); two parallel `nonstop-run.sh` failed with no stand project — the environment
- Written to the wiki: notes/stand-nonstop-parallel.md — new
