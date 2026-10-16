# Decisions of topic quality-zero

> What was chosen, instead of what, and whose decision.

- Zero judge violations in one full series of three runs over the four skills, instead of a threshold of a few violations — the user set the goal on 2026-10-15; user chose; in force
- Every "no" checked by hand and a wrong verdict fixed in the judge rules with proof, instead of trusting the judge as it is — a wrong judge would make zero meaningless; user chose; in force
- `saway` gets judge rules and its stage runs in the series, instead of leaving `saway` unjudged — the user chose it on 2026-10-15; user chose; in force
- The deferred review findings of the skills are fixed, the token items below 3 % are not — the user chose it on 2026-10-15; user chose; in force
- At most three rounds of "fix → series", then the rest goes to the report, instead of rounds until zero — the user chose it on 2026-10-15; user chose; in force
- The stand holes are fixed before the measuring, instead of measuring on the stand as it is — the user chose it on 2026-10-15; user chose; in force
- The series includes `nonstop` and `pair` runs, instead of only the `series.sh` lanes — both known violations show only there; agreed; in force
- Three `nonstop` and three `pair` runs, instead of one each — the progress line was green in 1 of 3 runs, one run hides that; agreed; in force
- Zero is counted on one whole series after the last edit, instead of stitching lanes from different rounds — a late fix can break an earlier green lane; agreed; in force
- Of the four `multi-agent` leftovers the two confirmed defects are fixed, instead of all four — the timing case is a guess, renaming `.agents/` changes R1 of `multi-agent`; agreed; in force
- Of the `saway-sources` doubts only the trigger check against `lfg` is taken, instead of also a `/goal` run — `lfg` ends with a push; a `/goal` run needs the user live; agreed; in force
- The `rm -rf` is fixed in the stand and in the `swork` reviewer task, instead of the stand only — on a live project such a reviewer is harmful too; agreed; in force
- Approach B: everything known is fixed before the first series and that series is round 1, instead of a baseline series first (A) or scripts in place of skill text (C) — one series fewer; C contradicts the rule of 2026-10-14; agreed; in force
- A stand failure is neither a violation nor a round, instead of counting it as a round — my proposal in design section 4; agreed; in force
