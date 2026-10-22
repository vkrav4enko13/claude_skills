# S2. Executor rules of writing code

> The executor of `swork` maps the reach of a change, takes the cheapest rung that works, fixes shared code once, never cuts guards, and reports its rungs and gaps.

- **Status:** done
- **Covers:** R1, R2, R3, R4, R5, R6, R7, R8, R27, R28, R29, R30
- **Depends on:** none
- **Marks:** ready text
- **Files:**
  - change: `swork/references/executor.md` (`## Task`: rules 4 and 8 at `:38-39`, `:51-53`, new rules after rule 10 `:55`, the reply form `:59-66`)
- **Interfaces:**
  - gives: executor rule numbers — 4 (scope), 8 (ladder, rungs 1–6), 11 (callers), 12 (moved code), 13 (never-cut list), 14 (smallest diff, edge cases), 15 (comments), 16 (`shortcut:`); S3, S4, S5 and S11 cite them by these numbers
  - gives: reply fields `LADDER:` and `GAPS:`, after `PITFALLS:`
- **Reuse:** the existing rules 4 and 8 are rewritten in place, not added next to them; rule 9 (no tests beyond the check lines) stays as it is
- **What to do:**
  1. Replace rule 4 with:
     ```
     4. Before writing code, list every place the change must reach: callers, tests, fixtures,
        configuration and exports. A place outside the "Files" block — return "need a file" with
        the path; do not edit it. Listing a test does not permit writing one: rule 9 holds.
     ```
  2. Replace rule 8 with:
     ```
     8. Before writing a new function, script or file, go down the ladder and take the first rung
        that fully solves the slice: (1) it is not needed at all; (2) it is already in the project —
        the "Reuse" field, the list of what was created earlier, the code map and a search;
        (3) the standard library or the platform; (4) a dependency already installed; (5) one
        readable line; (6) the minimum working code. Never add a dependency to save a few lines.
        Follow the way neighbouring code does the same thing. A line of your own topic's block with
        your slice number is your own code: you may edit it.
     ```
  3. After rule 10 add:
     ```
     11. Fixing a bug in a function: first find every caller of it with a search over the whole
         project, then fix the shared function once, not one caller. A caller outside "Files" — rule 4.
     12. Moving or merging code: carry its validation and its error handling with it.
     13. Never cut, whatever rule 8 suggests: validation where untrusted input enters, error handling
         that prevents data loss, security, accessibility, and anything the slice or the user asked
         for. This list overrides rule 8.
     14. Among working options take the smallest diff — only once the list of rule 4 is known and only
         if it reads at a glance. Of two equally small options take the one that is correct on edge cases.
     15. A comment is one line and says only why — what the code cannot show itself.
     16. A limit you accept knowingly gets a comment `shortcut: <ceiling>; upgrade when <trigger>`
         in the comment syntax of the file.
     ```
  4. After the `PITFALLS:` line of the reply form add:
     ```
     LADDER: <for each new function, script or file: the name — rung 1–6 of rule 8 and why not a lower
     rung, with where you searched; then "callers:" and the places found by rules 4 and 11;
     nothing new — "none">
     GAPS: <what you deliberately did not build, what you did not verify, any risk; nothing — "none">
     ```
  5. The full text of these rules lives only here; do not copy it into any other file.
- **Checks:** lines 10–13
