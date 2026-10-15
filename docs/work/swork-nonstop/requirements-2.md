# Requirements of topic swork-nonstop, part 2

> `saway`, the wiki limits, the project rule and the quality gate — R13–R18.

## saway

- R13. `saway` refers to `swork` for its stops and the bypass of slices instead of carrying its own rules about them; it keeps answering for `sbrain` and `splan`, the `/goal` line, the full description and its bans on a commit, a push, actions outside the project and the choice after the report.
- R14. Under `saway`, a slice with a "Rollback" section is executed by R5, not bypassed.

## Wiki limits

- R15. `wiki-rules.md` and `check.sh` set a card to 60 lines and 6000 characters, a folder index to 100 lines, and a line of a folder index, of an archive and of the plan overview to 400 characters.
- R16. The root index stays at 40 lines, `rules.md` at 30 lines, the reading at the start of a session at 80 lines, and a line of the root index, of `rules.md` and of the journal at 200 characters.

## Rule and quality

- R17. The rule "work without the user is driven by the separate skill `saway`; the texts of `sbrain`, `splan` and `swork` are not edited for an absence" keeps only its first half; the user's rule about a continuous `swork` stands next to it in `rules.md`.
- R18. Where the stand in `tests/` shows more violations after the edit than before it, or a decision of `swork` missing from the report, the edit is not accepted.
