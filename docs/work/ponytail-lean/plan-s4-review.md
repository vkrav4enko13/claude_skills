# S4. Review of swork rebuilt

> The review of `swork` ranks findings by kind, searches every caller of a changed contract, states the load it assumes, and returns three tiers with a verdict.

- **Status:** done
- **Covers:** R8, R16, R17, R33, R34, R35, R36
- **Depends on:** S2
- **Files:**
  - change: `swork/references/review.md` (`:5`, the task `:13-50`, screening `:52-66`, second round `:68-74`)
- **Interfaces:**
  - takes: executor rules 8, 13, 16 — from S2
  - gives: the review reply form below; finding kinds `bug`, `risk`, `load`, `missing test`, `speed`, `superfluous`; tiers `TIER 1`, `TIER 2`, `TIER 3`
- **Reuse:** the existing "Look for" list `:21-26`, the reproduction rule `:37-38`, the `READ:` line `:49` stay
- **What to do:**
  1. `:5` becomes: `The review looks for errors and for superfluous code the simplification left. Conformance to the plan is the business of the conformance check.`
  2. In the task, before "Look for" (`<skill folder>` is a placeholder the main session fills in, like `<path>`): `Read rules 8, 13 and 16 of the executor task in <skill folder>/references/executor.md: they are the measure of superfluous code, of what must never be cut, and of marked shortcuts.` Add to "Look for": `- a changed signature, return value or behaviour: search the whole project for every caller of it and check each one;` and `- a risky branch, loop, parser, money or security logic with no test.`
  3. Add: `Before the findings write one line ASSUMED LOAD: the load this code is meant for — data sizes, calls, users — taken from the project's README or the plan; nothing written — "not stated, assumed small". Judge load findings against it.`
  4. Replace "Do not propose: style, renamings, simplifications…" with `Do not propose: style, renamings, protection against an input that cannot occur here. A \`shortcut:\` comment with a ceiling and a trigger, while the code stays within its ceiling, is a decision, not a finding; a \`shortcut:\` comment without a trigger is a finding of kind risk.`
  5. Replace the return form `:40-47` with:
     ```
     Rank the findings by kind, in this order: bug, risk (security, data loss), load,
     missing test, speed, superfluous. Split them into three tiers — TIER 1: must fix
     before accepting; TIER 2: should fix; TIER 3: may fix. Number them across the tiers (1, 2, 3 …).
     Each finding:
     - kind; place: file:line
     - what the code is for
     - what goes wrong, with the input or steps that reproduce it
     - the fix, the smallest one, preferably a deletion
     - the cost of not fixing
     After the findings:
     VERDICT: accept | fix first
     REMOVABLE LINES: <how many lines can go, by the superfluous findings>
     NOT CHECKED: <what you could not check and why>
     ```
     Keep "Found no errors — say so, do not make any up." before `VERDICT:` and the `READ:` line last. Every quoted phrase stays on one line.
  6. Screening and second round: wherever they say "serious" read "TIER 1", wherever "minor" — "TIER 2 or 3"; a TIER 3 superfluous finding is applied only if the checks of its slice stay green.
- **Checks:** lines 18–21
