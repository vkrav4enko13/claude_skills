# A reviewer wiped the shared temp folder

> The two `nonstop-run.sh` failures of 2026-10-15 were not a collision of parallel runs: a review subagent of a tested `swork` ran `rm -rf` on every `tmp.*` of `$TMPDIR`.

- At 16:51:05 a stage-7 review subagent of the stand session in `tmp.W9qrAedxHQ` ran `cd /tmp && rm -rf "$(dirname $(mktemp -u))"/tmp.*`: its own stand and the neighbouring `tmp.5bpZGzETIo` were deleted.
- The neighbour's next `--resume` turn failed at `drive.sh:98` (`cd: …/wiki-trial/clean: No such file or directory`): hence `drive.sh failed` and every slice status `missing`.
- A single run is exposed the same way: the wipe deleted its own stand too. The reviewer had been told "Change nothing".
- Guard: give each `claude -p` turn its own `TMPDIR` under the stage folder and build stands outside the shared `$TMPDIR`.
- Source: the session records under `~/claude/personal/projects/` of `e98f12be…` and of the stand session `ee83724f…`, reconstructed on 2026-10-15
