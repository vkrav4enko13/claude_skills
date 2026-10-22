# Decided without the user in topic multi-agent, part 4

> The `swork` stage executing the plan of part 2, 2026-10-21, decided by `saway` while the user was away; part 3 is [away-3.md](away-3.md).

- Line 30, case e (plan-checks-stand.md) — was: "a reply or a progress card of either session names `formatReward` and `bonus_win` as duplicate candidates, and `python3 -I swork/scripts/dups.py` over the final project prints `dups: none`"; became: "a reply or a progress card of either session names `formatReward` as a duplicate candidate and `bonus_win` as a duplicate candidate or a merge conflict, and every candidate `dups.py` still lists over the final project is named in a reply or a progress card"; why: two live runs showed the scenario cannot be met without breaking another rule — the kept `formatReward` lies in the other topic's `src/hud.js`, unexported (CommonJS), so rerouting needs an edit outside the slice "Files", which swork forbids; and in the worktree mode the same JSON key with another value reaches the second agent as a merge conflict, never as a duplicate; both sessions named both and decided sensibly; otherwise: S11 is bypassed after its attempts and S14 (lines 39, 40, 32) is not run.

## Waiting for the user

- R24 says the merging agent "keeps one version"; with a duplicate whose kept version lies in a file outside the slice "Files" (another topic's), `swork` keeps both and names it — the requirement and the rule "only the slice Files" disagree; the line was weakened, the requirement is untouched.
