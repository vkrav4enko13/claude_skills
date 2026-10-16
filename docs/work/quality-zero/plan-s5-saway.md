# S5. saway: the first progress line and the review findings

> `saway` shows its progress line from the first message and its text no longer leaves the reviewed cases open.

- **Status:** done
- **Covers:** R9, R13
- **Depends on:** none
- **Files:**
  - change: `saway/SKILL.md` (`:18` return of the user, `:37` first message, `:82` card edit, `:113` the last line)
  - change: `tests/chain/away-blind.sh` (the prompt `:45,47`, header `:13`)
  - change: `tests/chain/away-scenarios.md`, `tests/chain/away-expected.tsv` (two new scenarios)
- **Interfaces:**
  - gives: scenario ids `B16`, `B17` in the form of the existing `B1`–`B15`
- **Reuse:** `away-blind.sh <skills folder> <out> [<scenarios> <expected>]`; the forms of `away-scenarios.md` and `away-expected.tsv`
- **What to do:**
  1. `SKILL.md:37`: `saway` reads `state.md` before the first message, so that its progress line has the numbers; the sentence holds the words `before the first message` and `state.md`. The rule of the line stays written in full at `:21` only.
  2. `away-blind.sh`: say in the prompt that `⇥` stands for a real tab character in `verdict.tsv`; the header `:13` says `<k> of 17 ok`.
  3. A return of the user in the middle of the work: add it to the conditions of `saway: work stopped — waiting for the user` at `:113`; `:18` refers to that line and does not repeat it.
  4. `SKILL.md:82`: decisions marked "user chose" are not edited in the card — they go to the bypass of `:31`.
  5. Two scenarios, `B16` for step 3 and `B17` for step 4, each with one right letter in `away-expected.tsv`.
- **Checks:** lines 12, 13
