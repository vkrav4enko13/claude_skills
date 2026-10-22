# Check lines of topic chain-cleanup: слепота судьи

> Строки 80–81: путь серии в следах и чтение судьи только в своей папке.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 80 | R57 | в следах прогона путь серии записан в двух видах, в разных файлах, — с косыми чертами и с дефисами → в папке метки нет ни одного; сессия судьи вызвана с `--restricted` | `cd "$HOME/Documents/my/claude_skills" && T=$(mktemp -d) && R="$T/x/1" && S=${R//[^A-Za-z0-9]/-} && mkdir -p "$R/brain" "$R/plan" "$T/home/.local/bin" && printf '%s\n' "путь $R/wiki-trial" > "$R/brain/chat.md" && printf '%s\n' "папка $S-wiki-trial-clean" > "$R/plan/chat.md" && printf '%s\n' '#!/bin/bash' 'printf "%s\n" "$@" > ../args.txt' 'echo x > verdict.tsv' > "$T/home/.local/bin/claude" && chmod +x "$T/home/.local/bin/claude" && HOME="$T/home" CHAIN_BASE="$T" bash tests/chain/judge.sh x > /dev/null && L=$(cut -f1 "$T/blind/key.tsv") && ! grep -rqF -e "$R" -e "$S" "$T/blind/$L" && grep -qx -- --restricted "$T/blind/args.txt" && echo "судья слеп"` | `судья слеп` | S22 | green 2026-10-13 |
| 81 | R57 | шесть прогонов упакованы судье → ни в одной папке метки нет имени серии ни в одном виде пути | `B="$HOME/Documents/my/chain-stand/blind"; n=0; for L in $(LC_ALL=C awk -F'\t' '$2=="before"{print $1} $2=="after"{print $1}' "$B/key.tsv"); do if grep -rqE -e 'chain-stand[/-]before' -e 'chain-stand[/-]after' "$B/$L"; then exit 1; fi; n=$((n+1)); done; [ $n -eq 6 ] && echo "имён серий нет"` | `имён серий нет` | S20 | green 2026-10-13 |
