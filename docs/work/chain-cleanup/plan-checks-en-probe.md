# Check lines of topic chain-cleanup: проба описаний и поиск кириллицы

> Строки 121–122: проба описаний и поиск кириллицы.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 121 | R88, R89 | 24 русские просьбы поданы на русские и на английские описания → на каждую выбран тот же скил | `cd "$HOME/Documents/my/claude_skills" && R="$HOME/Documents/my/chain-stand/trigger" && [ "$(wc -l < tests/chain/requests.tsv |tr -d ' ')" = 24 ] && [ "$(wc -l < "$R/ru.tsv" |tr -d ' ')" = 24 ] && LC_ALL=C awk -F'\t' '$2!="none"{n++} END{exit !(n>=12)}' "$R/ru.tsv" && cmp -s "$R/ru.tsv" "$R/en.tsv" && echo "скилы те же"` | `скилы те же` | S51 | green 2026-10-13 |
| 122 | R73 | поиск кириллицы по скилам, скриптам и заготовкам стенда → она только в разрешённых местах; пробная папка с одной русской буквой → отказ | `cd "$HOME/Documents/my/claude_skills" && T=$(mktemp -d) && printf 'я\n' > "$T/x.md" && ! bash tests/translate/cyr.sh "$T" > /dev/null && bash tests/translate/cyr.sh` | `cyrillic: only in allowed places` | S52 | green 2026-10-13 |
