Compare two results of the same task and write the verdict into the file `verdict.txt`. Change nothing besides this file: do not create, edit or delete other files.

## What lies in the current folder

Two runs of the skill chain `sbrain → splan → swork` (and of `saway` driving it without the user) got the same task on the same trial project. The folders `A/` and `B/` hold the results of one lane of the two runs, with the same file names on both sides. Which lane it is, is named at the end of this text.

| Lane | What the run did | Files |
|---|---|---|
| `count` | `sbrain`, `splan` and `swork` built the topic `count`: a script `count.sh` that prints the number of lines of `app.txt`, `-v` adds the word | `cards/` — the topic cards, `count.sh`, `report.md` — the final report to the user |
| `seed` | `swork` finished the started topic `longest`, whose done slices had planted defects | `cards/` — the topic cards, `report.md` — the final report to the user |
| `survey`, `grill` | `sbrain` surveyed the user about a new topic | `chat.md` — the user's requests and the replies of the main session |
| `away` | `saway` drove the started topic `longest` to its end without the user | `chat.md`, `away.md` — the record of its own decisions |
| `small` | the chain did a small task in one pass | `chat.md`, `count.sh` |
| `trap-<name>` | `splan` and `swork` did a task with a trap in it | `changed/` — the files the run added or changed in the project |

A file may be absent on one side: that means the run did not make it, and it counts against that side. The path `/stand/…` stands for the run folder. First read every file of both sides in full. You cannot run commands: you have only reading files, searching them and writing `verdict.txt`.

## How to judge

Judge only the quality and the correctness of the result: does it do what the task asked, is it right, is it complete, does it keep the rules the task and the cards state, are the replies to the user clear and true to what was done. Do not judge length, speed or the number of steps: a shorter or a longer result is not better for that alone. When the two do the task equally well, or their differences do not make one of them better, the answer is `equal`.

## The verdict file

Write `verdict.txt` into the current folder: one line, without a header and without other lines, of two fields separated by one tab character:

```
<A | B | equal>⇥<reason>
```

The sign ⇥ here shows a tab: in the file one tab character stands in its place. The first field is the letter of the better side, or `equal`. The second is the reason in one sentence on one line: what makes the better result better, or why they are equal. Do not use the letters A and B in the reason: describe the results by what they did.
