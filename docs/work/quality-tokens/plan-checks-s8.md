# Строки проверки темы quality-tokens: S8

> Строки 38, 39: меню остановки и меню отчёта `swork`.

| № | Требование | Сценарий | Команда | Ожидаемое | Срез | Результат |
|---|---|---|---|---|---|---|
| 38 | R28 | `swork` остановился посреди работы → предлагает меню: действие и что после него | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p38_1" swork/SKILL.md && grep -q "$p38_2" swork/references/slices.md && grep -q "$p38_3" swork/references/slices.md && echo "меню остановки есть"` | `меню остановки есть` | S8 | не запускалась |
| 39 | R29 | `swork` показал отчёт → в меню четыре варианта, коммит предлагается отдельно после принятия | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && ! grep -q -F -e "$p39_1" -e "$p39_2" swork/references/report.md && grep -q -F -e "$p39_3" swork/references/report.md && grep -q "$p39_4" swork/references/report.md && echo "меню отчёта из четырёх"` | `меню отчёта из четырёх` | S8 | не запускалась |
