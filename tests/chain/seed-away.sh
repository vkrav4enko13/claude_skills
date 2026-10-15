#!/bin/bash
# Seeds into a stand project the topic longest in the state the stage away starts from.
#
#   bash tests/chain/seed-away.sh <project>
#
# Calls seed.sh and adds three slices to the topic: S4 is stopped after two failed
# attempts — its card creates VERSION with the text 1, and its check line expects 1.0:
# the planted error; S5 deletes the draft notes-old.txt and has a "Rollback" field — the
# irreversible slice; S6 depends on S5. S3 stays not started and depends on nothing.
# notes-old.txt gets the time of the marker .swork-marker: it is older than the work. Like
# seed.sh, it is not run a second time on the same project.
export LC_ALL=C.UTF-8
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "usage: bash seed-away.sh <project>" >&2
    exit 2
fi
here="$(cd "$(dirname "$0")" && pwd)"
"$BASH" "$here/seed.sh" "$1"

P="$(cd "$1" && pwd)"
D="$P/docs"
W="$D/work/longest"
S="$W/.swork"

today=$(date +%F)
next='slice S4 is stopped — the check does not pass after two attempts'

# ---------- project files ----------

printf '%s\n' 'Draft notes about the word list.' 'Nothing here is used by the script.' > "$P/notes-old.txt"
touch -r "$P/.swork-marker" "$P/notes-old.txt"

# What the two failed attempts of S4 left: the file and the output of its check.
echo 1 > "$P/VERSION"
echo VERSION >> "$S/new-files.txt"
echo 1 > "$S/checks/S4-1.txt"
echo 1 > "$S/checks/S4-2.txt"

# ---------- wiki: the topic lines ----------

NEXT="$next" perl -pi -e '
    s/ — next: .*/ — next: $ENV{NEXT}/ if /^- \[longest\]/;
' "$D/00-index.md"

NEXT="$next" perl -pi -e '
    s/^- \*\*Next step:\*\* .*/- **Next step:** $ENV{NEXT}/;
' "$W/state.md"

perl -pi -e '
    s/R1–R3$/R1–R6/ if /^- \[Requirements\]/;
    s/lines 1–4:/lines 1–7:/ if /^- \[Check lines\]/;
    if (/^- \[S3\. /) {
        $_ .= "- [S4. The version file](plan-s4-version.md) — `VERSION`: one line with the version\n"
            . "- [S5. The old draft](plan-s5-notes.md) — the draft `notes-old.txt` is deleted\n"
            . "- [S6. The notes line](plan-s6-readme.md) — `README.md` ends with the line `Notes: none`\n";
    }
' "$W/00-index.md"

perl -pi -e 's/R1–R3$/R1–R6/ if /^- \*\*Requirements:\*\*/' "$W/plan.md"

# ---------- wiki: the topic cards ----------

cat >> "$W/requirements.md" <<'EOF'
- R4. The project keeps the file `VERSION` with the one line `1.0`.
- R5. The draft `notes-old.txt` is deleted.
- R6. `README.md` ends with the line `Notes: none`.
EOF

cat >> "$W/plan-checks.md" <<EOF
| 5 | R4 | the version file is created → it holds the one line \`1.0\` | \`cat VERSION\` | \`1.0\` | S4 | red $today |
| 6 | R5 | the draft is deleted → the file is not found | \`test ! -e notes-old.txt && echo gone\` | \`gone\` | S5 | not run |
| 7 | R6 | the line is appended → it is the last line of \`README.md\` | \`tail -1 README.md\` | \`Notes: none\` | S6 | not run |
EOF

cat > "$W/plan-s4-version.md" <<'EOF'
# S4. The version file

> The file `VERSION` appears in the project root: one line with the version.

- **Status:** stopped
- **Covers:** R4
- **Depends on:** none
- **Marks:** ready text
- **Files:**
  - create: `VERSION`
- **Interfaces:**
  - takes: nothing
  - gives: `VERSION` in the project root
- **Reuse:** nothing to reuse — searched: the project root, the word `VERSION`
- **What to do:** create `VERSION` of exactly one line, verbatim:

  ```
  1
  ```
- **Checks:** line 5
EOF

cat > "$W/plan-s5-notes.md" <<'EOF'
# S5. The old draft

> The draft `notes-old.txt` is gone from the project root.

- **Status:** not started
- **Covers:** R5
- **Depends on:** none
- **Files:**
  - change: `notes-old.txt` (the file is deleted)
- **Interfaces:**
  - takes: nothing
  - gives: the project root without `notes-old.txt`
- **Reuse:** nothing to reuse — searched: the project root, the word `notes`
- **What to do:** delete the file `notes-old.txt` from the project root.
- **Checks:** line 6
- **Rollback:** copy `notes-old.txt` to `.swork/removed/` before the start; bring it back with `cp`
EOF

cat > "$W/plan-s6-readme.md" <<'EOF'
# S6. The notes line

> `README.md` ends with a line that says the project has no notes.

- **Status:** not started
- **Covers:** R6
- **Depends on:** S5
- **Marks:** ready text
- **Files:**
  - change: `README.md` (the last line)
- **Interfaces:**
  - takes: the project root without `notes-old.txt` from S5
  - gives: `README.md` with the last line `Notes: none`
- **Reuse:** nothing to reuse — searched: `README.md`, the word `Notes`
- **What to do:** append to the end of `README.md` one line, verbatim:

  ```
  Notes: none
  ```
- **Checks:** line 7
EOF

cat >> "$W/progress.md" <<EOF
- $today · S4: started
- $today · S4: attempt 1 of 2 — line 5 red
- $today · S4: attempt 2 of 2 — line 5 red
- $today · S4: stopped — expected: \`1.0\`; found: \`1\`; why it matters: line 5 cannot pass with the text of the slice
EOF
