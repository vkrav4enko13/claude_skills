# Requirements of topic ponytail-lean, part 3

> The extension of 2026-10-17: the most of ponytail inside the chain, hooks, the stand's extra measures.

## Writing code, more (executor of swork)

- R27. Among working options, the executor takes the smallest diff, only after the scope of R1 is known and only if it reads at a glance.
- R28. When the executor writes a comment, it is one line and says only why, what the code cannot show itself.
- R29. When two options are equally small, the executor takes the one that is correct on edge cases.
- R30. The reply of the executor carries a field `GAPS:` — what it deliberately did not build, what it did not verify, and any risk.

## Every chain skill

- R31. The last message of `sbrain`, `splan`, `swork` and `saway` to the user ends with one or two lines: what was not done, what was not verified, and any risk.
- R32. When the user asks for a detailed explanation, the chain skill gives it in full and does not trim it for brevity.

## Review and audit

- R33. The review of `swork` ranks its findings by kind in this order: bug, risk (security, data loss), load, missing test on risky logic, speed, superfluous code.
- R34. When the reviewed change alters a signature, a return value or behaviour, the review of `swork` searches for every caller of it.
- R35. The review of `swork` states the load it assumes for the code, taken from the project's documents, and judges load findings against it.
- R36. The review of `swork` returns its findings in three tiers of importance, numbered across the tiers, each with what the code is for, what goes wrong, the fix and the cost of not fixing; it ends with a verdict, the number of removable lines and what was not checked.
- R37. The recon of `splan` reads the part of the project the work touches as an audit: the code map first, then the risky paths — input, money, access, writes, background jobs, shared state — read in full, and the parts not read are listed.

## Hooks

- R38. Hooks of the chain inject the key rules of the chain skills at session start, on resume, after a clear and after context compaction, and into every subagent when it starts.
- R39. Before every reply, a hook adds one line: reply in the language of the user's own words.
- R40. If a hook fails or runs over its time limit, then the session goes on without it.
- R41. `install.sh` installs the hooks into every Mac profile whose host supports them.

## The stand, more

- R42. The stand has an over-engineering judge that scores each trap run 0–3 and names the construct it finds unnecessary; it is trusted only after it ranks a known over-built reference above a known minimal one.
- R43. The stand checks the value of the planned tests of R9 by injecting small bugs into the delivered code — a flipped comparison, a dropped condition, an off-by-one — and records the share the tests catch.
- R44. For each trap run the stand also records the compressed size of the delivered code.
- R45. The stand reports each trap measure as the median over the runs of a task and the ratio of the candidate to the baseline; R24 holds also for the over-engineering score (not higher) and the share of caught bugs (not lower).
