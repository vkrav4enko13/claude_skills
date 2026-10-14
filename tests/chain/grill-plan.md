# Plan: the shortest word in `longest.sh`

> Add a `-s` flag to `longest.sh` that prints the shortest word of `app.txt`.

## Requirements

- R1. `bash longest.sh -s` prints the shortest word of `app.txt`, one line.
- R2. The length of a word is counted in letters, as for the longest word.
- R3. `app.txt` is empty — `bash longest.sh -s` prints an empty line.
- R4. Without a flag and with `-n` the script works as before.
- R5. `README.md` names the `-s` flag.

## Slices

### Slice 1. The `-s` flag

- **Files:** change `longest.sh`
- **Steps:**
  1. In the read loop, keep the shortest word next to the longest one: its length is taken by the function `word_length` of `longest.sh`, as for the longest word.
  2. Add the case `-s` to the flag `case`: it prints the shortest word.
  3. `app.txt` is empty — with `-s` the script prints `0`.
  4. Handle the errors properly.
- **Check:** `bash longest.sh -s` prints `викки`, and `grep -c 'longest.sh -s' README.md` prints `1`.

### Slice 2. `README.md`

- **Files:** create `README.md`
- **Steps:**
  1. Write `README.md` with the section "Running" and the lines `bash longest.sh`, `bash longest.sh -n` and `bash longest.sh -s`, each with what it prints.
- **Check:** `grep -c 'longest.sh -s' README.md` prints `1`.

## Checks

| No. | Requirement | Command | Expected | Slice |
| 1 | R1, R2, R5 | `bash longest.sh -s; grep -c 'longest.sh -s' README.md` | `викки`, `1` | 1 |
| 2 | R3 | `d=$(mktemp -d) && : > "$d/app.txt" && cp longest.sh "$d/" && cd "$d" && bash longest.sh -s` | an empty line | 1 |
| 3 | R4 | `bash longest.sh; bash longest.sh -n` | `карточка`, `карточка 1` | 1 |
| 4 | R5 | `grep -c 'longest.sh -s' README.md` | `1` | 2 |
