# Check lines of topic chain-cleanup: читатели, порции 6–9

> Строки 103–106: читатели, порции 6–9.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 103 | R83 | читатель сверил порцию 6 — `splan`: формат плана, нарезка, разведка — с оригиналом → о каждом файле есть строка отчёта, устройство прежнее, прежние строки проверки зелёные | `cd "$HOME/Documents/my/claude_skills" && bash tests/translate/compare.sh --portion 6 --reviewed > /dev/null && bash tests/translate/lines.sh > /dev/null && echo "порция 6 сверена"` | `порция 6 сверена` | S41 | green 2026-10-13 |
| 104 | R83 | читатель сверил порцию 7 — `splan`: проверка и одобрение; `swork`: вход и малое — с оригиналом → о каждом файле есть строка отчёта, устройство прежнее, прежние строки проверки зелёные | `cd "$HOME/Documents/my/claude_skills" && bash tests/translate/compare.sh --portion 7 --reviewed > /dev/null && bash tests/translate/lines.sh > /dev/null && echo "порция 7 сверена"` | `порция 7 сверена` | S42 | green 2026-10-13 |
| 105 | R83 | читатель сверил порцию 8 — `swork`: срезы, завершение, исполнитель, сверка — с оригиналом → о каждом файле есть строка отчёта, устройство прежнее, прежние строки проверки зелёные | `cd "$HOME/Documents/my/claude_skills" && bash tests/translate/compare.sh --portion 8 --reviewed > /dev/null && bash tests/translate/lines.sh > /dev/null && echo "порция 8 сверена"` | `порция 8 сверена` | S43 | green 2026-10-13 |
| 106 | R83 | читатель сверил порцию 9 — `swork`: снимок, отчёт, упрощение, ревью — с оригиналом → о каждом файле есть строка отчёта, устройство прежнее, прежние строки проверки зелёные | `cd "$HOME/Documents/my/claude_skills" && bash tests/translate/compare.sh --portion 9 --reviewed > /dev/null && bash tests/translate/lines.sh > /dev/null && echo "порция 9 сверена"` | `порция 9 сверена` | S44 | green 2026-10-13 |
