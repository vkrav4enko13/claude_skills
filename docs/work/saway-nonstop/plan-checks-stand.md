# Check lines of topic saway-nonstop: the check script and the run "before"

> Lines 3–4: `away-check.sh` fails an untouched seed, and the present text of `saway` fails the stand run.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 3 | R17 | `away-check.sh` is given a freshly seeded project and a stage folder with one empty turn and no `chat.md` → it prints 13 lines and fails, the report is not reached; the new scripts hold Cyrillic only where `tests/translate/cyr-allow.txt` allows | `cd ~/Documents/my/claude_skills && bash tests/translate/cyr.sh && T=$(mktemp -d) && P="$T/wiki-trial/clean" && bash tests/chain/stand.sh "$T" . > /dev/null && bash tests/chain/seed-away.sh "$P" > /dev/null && mkdir -p "$T/away/turns" && echo '{"session_id":"x","result":"ok"}' > "$T/away/turns/01.json" && bash tests/chain/away-check.sh "$P" "$T/away" || true` | 15 lines; the first is `cyrillic: only in allowed places`, the second `report: not reached`, the last `away run: fail` | S1 | green 2026-10-13 |
| 4 | R17 | the run "before" that step 5 of the slice made and stored: the text of `saway` of commit `529351c` was driven over the seed → the work did not reach the report: the planted stop held it | `cd ~/Documents/my/claude_skills && A=~/Documents/my/chain-stand/away/before && git show 529351c:saway/SKILL.md > "$A/head.md" && cmp "$A/SKILL.md" "$A/head.md" && echo "text before" && sed -n '1p;$p' "$A/check.txt"` | three lines: `text before`, `report: not reached`, `away run: fail` | S1 | green 2026-10-13 |
