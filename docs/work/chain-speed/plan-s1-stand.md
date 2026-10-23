# S1. Reduced stand

> A series of this topic runs only the lanes the levers touch, plus a new small lane.

- **Status:** done
- **Covers:** R1, R2, R18
- **Depends on:** none
- **Files:**
  - create: `tests/chain/cs-stages.txt`, `tests/chain/seed-small.sh`
  - change: `tests/chain/series.sh` (stage check `:86`, the `stages` writer `:121`, the lane case `:145-154`, lane loop `:240`), `tests/chain/drive.sh` (`:58-121`, the `small` stage), `tests/chain/collect.sh` (`:33-45`, the `small` stage and its done test)
- **Interfaces:**
  - gives: stage name `small`; file `tests/chain/cs-stages.txt` with the line `brain plan work seed survey grill away trap-reuse trap-native small`
- **Reuse:** the `away` lane: `tests/chain/seed-away.sh`, its branches in `series.sh`, `drive.sh`, `collect.sh`; `tests/chain/stand.sh`, `tests/make-wiki.sh` (`:53`, the clean project)
- **What to do:**
  - First lines 10 and 18: `multi-agent` not closed, or the stand misses a named file → stop the slice; nothing else runs (R1). Then re-verify the line numbers of this card.
  - `cs-stages.txt`: the single line above.
  - `seed-small.sh`: the clean project of `make-wiki.sh` plus `count.sh` (prints the line count of `app.txt`) and a topic `docs/work/count-q/` at `requirements confirmed` with one requirement «with `-q`, `count.sh` prints nothing and exits 0 when `app.txt` is empty, 1 otherwise»; one first message to `saway` like the `away` lane.
  - The lane box is `smallbox`, its seed branch beside the `away` one in `series.sh` (`:171-190`); the clean project is built by `make-wiki.sh` (`:87`).
  - Done test of `small`: the last turn's `.result` has `saway: work finished`, and `count.sh -q`, run on a temp copy, exits 0 on an empty and 1 on a non-empty `app.txt`.
- **Checks:** lines 1, 2, 10, 18
