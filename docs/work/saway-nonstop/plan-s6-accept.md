# S6. The new `saway` is accepted by a blind reading and a stand run

> All 15 scenarios end as required, and one run without a human reaches the report in Russian with the forbidden slice untouched and named.

- **Status:** done
- **Covers:** R10, R16, R17
- **Depends on:** S1, S5
- **Files:**
  - change: `saway/SKILL.md` (only what a red line of this slice points at)
  - change: `tests/chain/away-check.sh` (condition 13: the language of the cards; created in S1)
- **Interfaces:**
  - takes: `bash tests/chain/away-blind.sh <skills folder> <out folder>` from S2; `seed-away.sh`, the stage `away` of `drive.sh` and `away-check.sh` from S1; the text of S3–S5
  - gives: the folders `~/Documents/my/chain-stand/away/blind/` and `…/away/after/`, and `…/away/accepted.txt` with the name of the accepted run folder
- **Reuse:** `tests/chain/stand.sh <folder> <skills folder>`; the token counter of line 40 in `docs/work/quality-tokens/plan-checks-s9.md` — the same call for `saway/SKILL.md`
- **What to do:** steps 1–4 were made on 2026-10-13 and their results are stored: do not repeat them and do not run `stand.sh` — it would erase the stored run. Do only step 5, then run lines 27–37. The branch "`away run: fail`" of step 3 does not apply to the failure of condition 13.
  1. Run lines 27 and 28. They need no edit of the text.
  2. Store the final blind reading: `bash tests/chain/away-blind.sh . ~/Documents/my/chain-stand/away/blind`; line 29 reads it. A scenario that differs: read the sentence the reader relied on in `verdict.tsv`, fix that place of `saway/SKILL.md` within the decisions of S3–S5, run the reading again into the same folder.
  3. The stand run, 25–60 minutes, with `B=~/Documents/my/chain-stand/away`: `stand.sh "$B/after/box" .`, `seed-away.sh`, `drive.sh … away "$B/after/away"`, then write the folder name `after` into `$B/accepted.txt`. Lines 30–36 read the folder named there. `away run: fail`: read `chat.md` at the failed line, fix that place of the text, run again into a new folder `after-2` and write that name.
  4. A fix of the text after step 2 passed — store the blind reading again and run line 28 again: lines 29 and 30 compare the text read and driven with the present one, so a fix after the stand run needs a new run too.
  5. `away-check.sh`, condition 13: before the test for `\p{Cyrillic}` remove from every line of an `away*.md` its inline code spans — a backtick, the characters up to the next backtick, that backtick; an unpaired backtick removes nothing. The value `cyrillic` stays for Cyrillic outside them. Nothing else in the script changes and no new stand run is made: lines 30–36 read the stored folder named in `accepted.txt`. Then run line 37.
  6. The turn of the run ended before the description, twice: this is the assumption of the plan that did not hold — stop and report, do not add an answer loop to `drive.sh`.
- **Checks:** lines 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37
