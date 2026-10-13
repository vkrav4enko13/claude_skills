# Technical decisions of topic saway-nonstop — part 2

> Which failures and kinds of input the plan checks beyond the named ones.

## Check focus

- `swork` is entered again after a compaction and a bypassed slice has the status `stopped` → it is not retried — S4, line 15
- a slice has "Depends on: none" but shares a file with the bypassed slice → it is not started — S4, line 16
- `splan` fixed the slice, the phase became `plan confirmed`, the log holds "attempt 2 of 2" → the phase returns to `execution in progress`, the attempts start anew — S4, line 17
- every slice left depends on the bypassed one → the conformance check, the review and the report still run — S4, line 18
- many bypassed items → "Next step" stays `user's choice after the report`, the list stays in `away.md` — S4, line 19
