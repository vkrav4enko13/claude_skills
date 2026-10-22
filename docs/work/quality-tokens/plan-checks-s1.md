# Check lines of topic quality-tokens: S1

> Строки 1–5: перенос в `sbrain` — объём, порядок, названность файлов этапов, сохранность строк и правила чтения файлов.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 1 | R18 | основной текст `sbrain` после переноса и дописок → не больше 19 000 байт | `cd "$HOME/Documents/my/claude_skills" && [ "$(wc -c < sbrain/SKILL.md)" -le 19000 ] && echo "объём в пределе"` | `объём в пределе` | S1 | green 2026-10-11 |
| 2 | R19 | запрет на реализацию, правило о подтверждениях, правила об остановке и о записи в вики → стоят выше раздела «Этапы» | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && awk "$p2_1" sbrain/SKILL.md && echo "правила выше этапов"` | `правила выше этапов` | S1 | not run |
| 3 | R20 | четыре файла этапов → каждый существует и назван в основном тексте | `cd "$HOME/Documents/my/claude_skills" && for f in context survey approaches handoff; do [ -f sbrain/references/$f.md ] && grep -q "references/$f.md" sbrain/SKILL.md && continue; exit 1; done && echo "файлы этапов названы"` | `файлы этапов названы` | S1 | green 2026-10-11 |
| 4 | R21 | строка прежнего `SKILL.md` из коммита `f3c9f1b` → есть в основном тексте или в файле `references/` | `cd "$HOME/Documents/my/claude_skills" && [ -z "$(LC_ALL=C comm -23 <(LC_ALL=C sort -u <(git show f3c9f1b:sbrain/SKILL.md)) <(LC_ALL=C sort -u sbrain/SKILL.md sbrain/references/*.md))" ] && echo "строки на месте"` | `строки на месте` | S1 | green 2026-10-11 |
| 5 | R22 | текста файла этапа нет в контексте либо текст ссылается на другой файл → основной текст велит прочитать файл | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p5_1" sbrain/SKILL.md && grep -q "$p5_2" sbrain/SKILL.md && echo "правила чтения есть"` | `правила чтения есть` | S1 | not run |
