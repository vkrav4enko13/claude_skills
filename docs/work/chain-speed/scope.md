# Scope of topic chain-speed

> What is out of scope, assumptions and open questions.

## Out of scope

- The full stand series: only the reduced stand of R2.
- The outcome of `multi-agent`: the user decides it before R1 lets the work start.
- The effort level and `/fast`: the chain stays at `medium` (`docs/rules.md`).
- A new lever beyond R6–R13.

## Assumptions

- The reduced stand may miss a regression in a dropped scenario; R2 names what was dropped.
- Two runs per side is still a noisy measure; R16 bounds the extra series.
- `judge.sh` does not judge the `small` and trap lanes; only the pairwise judge and the result checks cover them.
- "Small code" is one file and about 20 changed lines; the plan may name the exact measure.
- A series on the reduced stand (2 runs) costs about $50; "before" and "after" with the judges about $100–110; each series of R16 adds up to about $50; plus about $5 for the S1 small-lane run and about $5 for the S2 judge run on two old series.
