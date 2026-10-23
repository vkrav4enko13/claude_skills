# Choose the size and name it aloud. Recon

Read at steps 2 and 3.

## 2. Choose the size and name it aloud

Name the size and why, then go on: not a stop. The user may correct it any time.

| Size | When | Result |
|---|---|---|
| **Direct** | Named, made and checked in one pass; nothing for the user to weigh | Two or three sentences in the chat: what, where, how checked |
| **Short** | One to three slices, at most one decision to weigh, no danger zone | A plan in the chat: goal, slices (what starts working, files, check), what we do not do |
| **Cards** | Everything else; always with a topic folder, on request, or in a danger zone: login and permissions, money, data migration, external agreements | A plan in cards in the topic folder — by `references/plan-format.md` |

In doubt take the heavier. Recon shows complexity — stop, say so, go heavier; never lighter.

"Cards" without a topic folder — `splan` sets it up when writing (`references/plan-format.md`) and opens the chain's journal line with the tail `plan written`. Wiki not kept — `references/wiki-rules.md`, section "The wiki is not kept".

Direct and short: recon yourself by reading the named places; no step 6; step 8 is the self-check only; step 9 is mandatory. No topic folder, no wiki writes: the result stays in the chat; whoever makes the edit writes the journal line.

## 3. Recon

First the code, then the questions. First run `bash <skill folder>/scripts/codemap.sh <project root>` for a map of the code; it does not replace the search.

- **What to look for:** the touched places; how the project does similar things — follow it; build, launch and check commands; project instructions and glossary; what breaks nearby.
- **You look for the facts, the user makes the decisions.** Never ask what the repository, tools or web answer.
- **For a plan in cards** with unknown affected places, use subagents if available: at most three, one question each, in one message, asking for a conclusion with paths and lines, not a file dump. Pass decisions as facts without arguments, plus "if you find that this cannot work — report it". Read places named in the requirements or task yourself.
- **Check before you assert.** Every "the project does not have this", path and name is checked against the code or marked an unverified guess.
- **Check the user's correction about the code against the code**; name the discrepancy.
- **Ready-made code.** For the touched places find a function, class or script to take instead of new code; note name, signature, file.

Ask the user only blocking questions that neither code nor requirements answer — without them the slicing or an expensive-to-undo decision cannot be chosen — via the blocking question tool, each with a recommendation. Decide the rest; show it in the plan as decided.
