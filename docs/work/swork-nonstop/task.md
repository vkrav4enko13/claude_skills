# Task of topic swork-nonstop

> `swork` keeps halting mid-work; the user wants it to decide every question itself and explain at the end; wiki cards split too often.

## In brief

`swork` goes through the work to the report without a single stop. At every place of a former stop it decides itself, flags it in the chat and goes on; the report lists every problem, its decision and why. `saway` loses its duplicate rules about `swork`. The wiki limits of what is read by a link are doubled.

## Task

- The user's words of 2026-10-15: "swork must be able to work continuously, take every question itself, but describe at the end what the problems were and why"; "it keeps breaking off, it must be only at the end"; "no stops — it may be highlighted in the chat"; "if the user is near, they will correct it — but do not wait, work to the end"; "the main thing is that quality is not lost".
- Today `swork` halts in seven cases of section 4 of its `SKILL.md` and asks four questions when continuing interrupted work; going on without the user needs `saway`, which is started only when the user leaves.
- The wiki has 58 cards split into parts (`away-2`, `plan-checks-*`, …) and 71 more near the limit of 30 lines or 3000 characters.

## Success criteria

- A stand run in `tests/` on a plan that meets the former stop cases reaches the `swork` report without a question to the user in the middle — R1, R2.
- Every decision `swork` took itself in that run is in the report with the problem, the choice and the reason — R11.
- The stand shows no more violations than before the edit, and a blind reading of the new `swork` and `saway` finds no conflict between them — R13.
- `check.sh` passes the wiki of this project by the new limits and flags a card of 61 lines and a root index of 41 lines — R15, R16.
