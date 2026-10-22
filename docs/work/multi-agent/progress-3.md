# Progress log of topic multi-agent, part 3

> Stage 7: the review, its fixes, the second round and what was left.

- stage 7: review — 4 serious, 5 minor; fixed: the marker lines ran one after the other and copied the marker onto itself, now ONE of two and the oldest adopted; the accept block deleted the snapshot unconditionally, now ONE of two with `[ $? -eq 1 ]`; `claim` took a dead owner's claim silently with "no changes", now `abandoned:` and `reread:`; a wiki above the git root could not be claimed, now `docs/00-index.md` comes before the git root; an agent with no free slice waited instead of the short report, now it goes to stages; lines 3, 4, 6, 7 green after (`.swork/checks/H-l*.txt`)
- stage 7: card edits for these fixes — S2 root order, S4 oldest marker and the no-free-slice rule, the decision line on the marker
- stage 7, second round: fixes of the marker, the accept block and the dead-owner claim confirmed; the root-order fix brought an error — a git repo with `docs/00-index.md` in a subfolder got two `.agents/` stores and two agents could claim one file — reverted to the git root first; line 3 green after (`.swork/checks/I-l3.txt`); line 8 `9 of 9 ok` after the fixes (`H-l8.txt`)
- left untouched: a wiki above the git root cannot be claimed (`agents.sh` refuses paths outside the git root) — the fix was reverted, it needs one root shared with `swork`
- left untouched: `claim` of a busy file together with a file of a dead owner prints `abandoned:` with code 3 and removes nothing — found by the second round
- left untouched: an agent with no free slice goes to stages; between a neighbour's `done` of one slice and its claim of the next, it may finish the topic early — a timing guess of the second round
- left untouched: `.agents/` may clash with a repo that keeps its own `.agents/` folder (the Codex skills convention) — renaming it changes R1
- declined: the `.stage` claim left after the final report fails "claims: none" — the pair runs ended with no claim left; the PC cannot run `agents.sh` and the id holds `:` — every agent runs on this Mac by the plan
- S6: line 12 done after the user accepted — `install.sh --mac`, `grep -l agents-rules` printed the three profiles; commit ee94340
