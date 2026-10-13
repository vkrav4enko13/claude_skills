# Moving an old file over into cards

Read when a requirements file or a plan of the earlier form — as a single file — is found in the project and the user has agreed to move it into cards or has asked for it themselves. Such a file is not worked from silently: call the format the earlier one and offer the move.

The move rewrites nothing: the lines of the original move into the cards verbatim. Improving the wordings along the way is not allowed.

## Who moves what

- **A requirements file of the earlier form** — `sbrain`. Which section goes into which topic card is said in `references/topic-cards.md` of the `sbrain` skill.
- **A plan** — `splan`. Offer it; do not lay the plan out yourself.

## Order

1. **Make sure the original is saved** — by the user's commit or by a copy. Under git: `git status --porcelain -- <original>` prints nothing, and `git log -1 --oneline -- <original>` names a commit. Otherwise ask the user to commit the file, or make a copy next to the original and name its path; do not commit yourself. While there is neither a commit nor a copy, do not start the move.
2. **Lay the sections out into the topic cards** in `work/<topic>/` — by the layout from "Who moves what". You write the title and the hook line of each card; everything under them is lines of the original.
3. **Move the lines verbatim** — by cutting out line ranges, not by retyping:

   ```bash
   sed -n '<first>,<last>p' <original> >> <card>
   ```

   A retyped line differs from the original unnoticeably. If a card went over the limit, split it and do not change the lines while doing so. Then run the wiki check — `references/wiki-rules.md`, section "Check". If the check named a link in a moved line broken, its target was counted from the folder of the original: rewrite the target from the folder of the card and change nothing else in the line. This is the only edit the move allows.
4. **Compare line by line.** Every non-empty line of the original, except the section headings and the header, is verbatim in the topic cards. The command prints the lines of the original that are not in the cards:

   ```bash
   grep -v '^[[:space:]]*$' <original> | grep -v '^#' | while IFS= read -r line; do
       grep -rqxF -- "$line" <topic folder> || printf '%s\n' "$line"
   done
   ```

   Only the header — the lines of the original before the first section — and the lines in which the link target was rewritten at step 3 are allowed in the output. Any other line is lost: return it to the card by cutting and run the comparison again.
5. **Show the result and wait for a "yes".** Name how many non-empty lines the original has, how many of them were found in the cards, which were not moved and in which the link target was rewritten. Delete the original only after the user's "yes" to the results of the comparison. A fix is not approval: if you fixed the cards, compare again, show and wait for a "yes".
