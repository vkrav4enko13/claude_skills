# S12. Result: the saving and the install

> The final numbers are printed by one command, and the Mac profiles get the texts whose series passed the gate.

- **Status:** done
- **Covers:** R8, R11, R26, R27, R28, R29
- **Depends on:** S11
- **Files:**
  - create: `tests/chain/saving.sh`
- **Interfaces:**
  - takes: `trace.sh <series> total|input` (S1), `gate.sh` (S3), the series `medium` (S4) and `b1`, `b2`, `b3` (S9–S11)
  - gives: `bash tests/chain/saving.sh <baseline> <final> <reference>`; the file `$S/final.current` — the name of the final series
- **Reuse:** `total output_per_run` and the `input` lines of `tests/chain/trace.sh`; `./install.sh --mac`; the file `$S/en.current` as the model of a pointer to a series
- **What to do:**
  - The final series. Take the last of `b3`, `b2`, `b1` (or its `r` rerun) whose gate passed. `diff -r "$S/<it>/skills/<skill>" <skill>` prints nothing for the four skills — write its name into `$S/final.current`. It prints something, or no batch series exists — run the series `final` by the gate procedure and write `final`.
  - `saving.sh` prints: `output per run: <baseline> <n>, <final> <n>, <reference> <n>`; `saving against <baseline>: <p> % — threshold met` when `<p>` is 10.0 or more, otherwise `… — threshold not met`; `saving against <reference>: <p> %`; for each of the three series `cache <series>: write <n> read <n> per run`. `<p>` is (1 − final / other) × 100, one decimal. Code 0 with either mark; a series is missing — `no measurement: <what>` and code 1.
  - Line 16 reads the "Deferred" lines the main session wrote after S5; a lever is missing there — name it in `NOTICED`, do not write the index yourself.
  - `bash tests/chain/gate.sh en "$(cat "$S/final.current")"` passed — run `./install.sh --mac`. Not passed — install nothing and reply `could not`.
- **After the slice (main session):** quote the output of `saving.sh` in the report. With `threshold not met` the topic still closes, with the achieved number and that mark; the batches that passed the gate stay.
- **Checks:** lines 16, 37, 38, 39, 40, 41
- **Rollback:** before `./install.sh --mac` copy the folders `sbrain`, `splan`, `swork`, `saway` of `~/claude/personal/skills`, `~/claude/work/skills` and `~/.codex/skills` and the files `~/claude/personal/CLAUDE.md`, `~/claude/work/CLAUDE.md`, `~/.codex/AGENTS.md` into `$S/installed-before/<profile>/`; to bring the earlier state back, copy them over the installed ones
