# Check lines of topic chain-cleanup: двоякие места и второй проход

> Строки 107–110: двоякие места и второй проход.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 107 | R80, R81 | двоякие места собраны в одном файле → у каждого выбрано чтение, спорных нет | `A="$HOME/Documents/my/chain-stand/translate/ambiguous.tsv"; [ -f "$A" ] && LC_ALL=C awk -F'\t' 'NR>1 && ($5=="" || $5=="disputed"){bad++} END{exit bad>0}' "$A" && echo "двоякие места разобраны"` | `двоякие места разобраны` | S45 | green 2026-10-13 |
| 108 | R84 | в файле стоят «готово» и «готов», «Требования темы» и «Требования» и одно непереведённое слово → замена идёт от длинных строк к коротким, слово названо, код 1 | `cd "$HOME/Documents/my/claude_skills" && T=$(mktemp -d) && printf 'Phase \140готово\140, status \140готов\140, \140Требования темы\140, \140Требования\140, слово\n' > "$T/a.md" && { bash tests/translate/apply.sh "$T/a.md" > "$T/out"; c=$?; grep -q 'Phase .done., status .done., .Requirements of topic., .Requirements., слово' "$T/a.md" && grep -q 'a.md:1' "$T/out" && echo "код: $c"; }` | `код: 1` | S46 | green 2026-10-13 |
| 109 | R71, R84 | второй проход по текстам скилов, `check.sh` и образцу его вывода → кириллицы в них нет | `cd "$HOME/Documents/my/claude_skills" && ! LC_ALL=en_US.UTF-8 grep -rlE '[А-Яа-яЁё]' saway sbrain splan swork tests/expected-broken.txt && echo "кириллицы нет"` | `кириллицы нет` | S46 | green 2026-10-13 |
| 110 | R86 | второй проход закончен → прежние строки проверки и стенд вики зелёные | `cd "$HOME/Documents/my/claude_skills" && bash tests/translate/lines.sh > /dev/null && T=$(mktemp -d) && bash tests/make-wiki.sh "$T/wiki-trial" > /dev/null && bash tests/run-check.sh sbrain/scripts/check.sh "$T/wiki-trial" > /dev/null && echo "строки и стенд вики зелёные"` | `строки и стенд вики зелёные` | S46 | green 2026-10-13 |
