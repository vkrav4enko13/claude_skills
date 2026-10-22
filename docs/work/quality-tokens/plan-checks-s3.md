# Check lines of topic quality-tokens: S3

> Строки 11–15: перенос в `swork` — объём, порядок, названность файлов этапов, сохранность строк и правила чтения файлов.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 11 | R18 | основной текст `swork` после переноса и дописок → не больше 19 000 байт | `cd "$HOME/Documents/my/claude_skills" && [ "$(wc -c < swork/SKILL.md)" -le 19000 ] && echo "объём в пределе"` | `объём в пределе` | S3 | green 2026-10-11 |
| 12 | R19 | запреты, список остановок, правила запуска проверки, записи в план и остановки → стоят выше раздела «Этапы» | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && awk "$p12_1" swork/SKILL.md && echo "правила выше этапов"` | `правила выше этапов` | S3 | not run |
| 13 | R20 | пять файлов этапов → каждый существует и назван в основном тексте | `cd "$HOME/Documents/my/claude_skills" && for f in entry slices finish report small; do [ -f swork/references/$f.md ] && grep -q "references/$f.md" swork/SKILL.md && continue; exit 1; done && echo "файлы этапов названы"` | `файлы этапов названы` | S3 | green 2026-10-11 |
| 14 | R21 | строка прежнего `SKILL.md` из коммита `f3c9f1b`, кроме четырёх, которые меняют S6 и S8, → есть в основном тексте или в файле `references/` | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && [ -z "$(LC_ALL=C comm -23 <(LC_ALL=C sort -u <(grep -v -F -e "$p14_1" -e "$p14_2" -e "$p14_3" -e "$p14_4" <(git show f3c9f1b:swork/SKILL.md))) <(LC_ALL=C sort -u swork/SKILL.md swork/references/*.md))" ] && echo "строки на месте"` | `строки на месте` | S3 | not run |
| 15 | R22 | текста файла этапа нет в контексте либо текст ссылается на другой файл → основной текст велит прочитать файл | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p15_1" swork/SKILL.md && grep -q "$p15_2" swork/SKILL.md && echo "правила чтения есть"` | `правила чтения есть` | S3 | not run |
