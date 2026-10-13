#!/bin/bash
# Keeps the Russian state of the skills, the stand and the phrase files as a
# copy next to the stand: the translation is compared with it, and the project
# can be returned to it.
#
#   bash tests/translate/state.sh save|check|restore
#
# The copy is $CHAIN_BASE/ru-state, by default
# ~/Documents/my/chain-stand/ru-state. The project root is STATE_ROOT, by
# default the folder two levels above this script. Paths inside the copy are
# paths from the project root.
#   save    - copies the folders saway, sbrain, splan, swork, tests, the file
#             install.sh and both phrase files, then writes MANIFEST: the
#             checksum and the path of every file. The copy already exists -
#             refusal and exit code 1.
#   check   - compares the copy with MANIFEST: "state: saved" and exit code 0.
#             Otherwise the paths that differ and exit code 1.
#   restore - returns every saved folder and file from the copy, deletes from
#             those folders the files the copy does not have, prints "restored".
export LC_ALL=C.UTF-8
set -euo pipefail

usage() {
    echo "run: bash state.sh save|check|restore" >&2
    exit 2
}
[ $# -eq 1 ] || usage

root="${STATE_ROOT:-$(cd "$(dirname "$0")/../.." && pwd)}"
B="${CHAIN_BASE:-$HOME/Documents/my/chain-stand}"
copy="$B/ru-state"
items=(saway sbrain splan swork tests install.sh
    docs/work/chain-cleanup/phrases.sh docs/work/quality-tokens/phrases.sh)

# Checksum and path of every file of the saved folders and files under the
# folder $1, ordered by path.
manifest() {
    (cd "$1" && find "${items[@]}" -type f -exec shasum -a 256 {} + | LC_ALL=C sort -k 2)
}

save() {
    local item
    if [ -e "$copy" ]; then
        echo "refused: $copy already exists" >&2
        exit 1
    fi
    for item in "${items[@]}"; do
        mkdir -p "$copy/$(dirname "$item")"
        cp -Rp "$root/$item" "$copy/$(dirname "$item")/"
    done
    manifest "$copy" > "$copy/MANIFEST"
    echo "saved: $copy"
}

check() {
    local bad
    if [ ! -f "$copy/MANIFEST" ]; then
        echo "no saved state: $copy/MANIFEST" >&2
        exit 1
    fi
    # A line found only in MANIFEST or only in the copy as it is now names a
    # path that differs; a folder the copy has lost gives no lines at all.
    bad=$({ manifest "$copy" 2> /dev/null || true; cat "$copy/MANIFEST"; } |
        LC_ALL=C sort | LC_ALL=C uniq -u | sed 's/^[0-9a-f]*  //' | LC_ALL=C sort -u)
    if [ -n "$bad" ]; then
        printf '%s\n' "$bad"
        exit 1
    fi
    echo "state: saved"
}

restore() {
    local item f
    if [ ! -d "$copy" ]; then
        echo "no saved state: $copy" >&2
        exit 1
    fi
    for item in "${items[@]}"; do
        mkdir -p "$root/$(dirname "$item")"
        cp -Rp "$copy/$item" "$root/$(dirname "$item")/"
        # A file the copy does not have goes away.
        (cd "$root" && find "$item" -type f) | while IFS= read -r f; do
            [ -e "$copy/$f" ] || rm "$root/$f"
        done
    done
    echo restored
}

case "$1" in
    save) save ;;
    check) check ;;
    # restore rewrites this file too: exit before bash reads on in it.
    restore)
        restore
        exit
        ;;
    *) usage ;;
esac
