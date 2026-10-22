# Check lines of topic chain-cleanup: передача плана

> Строки 21–25: значения словами, карточки темы, допущения и отметка о проверке плана.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 21 | R8 | значение из требований нужно в плане → формат велит писать его словами, примера «текст из R4» нет | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p21_1" splan/references/plan-format.md && ! grep -q "$p21_2" splan/references/plan-format.md && echo есть` | `есть` | S8 | green 2026-10-13 |
| 22 | R11 | `splan` планирует по теме → читает все карточки, названные в её индексе | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p22_1" splan/SKILL.md && echo есть` | `есть` | S8 | green 2026-10-13 |
| 23 | R14 | допущение или снятый блокирующий вопрос → у шапки плана есть раздел «Допущения», вход `splan` пишет туда | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p23_1" splan/references/plan-format.md && grep -q "$p23_2" splan/SKILL.md && echo есть` | `есть` | S8 | green 2026-10-13 |
| 24 | R15 | срез зависит от допущения → `swork` называет его перед срезом; правила об отложенных вопросах нет | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -qF -e "$p24_1" swork/references/entry.md && ! grep -qF -e "$p24_2" swork/references/entry.md && echo есть` | `есть` | S8 | green 2026-10-13 |
| 25 | R16 | план записан, независимая проверка не пройдена → вход ведёт на шаг 8, шаг в `state.md` это называет | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p25_1" splan/SKILL.md && grep -q "$p25_2" splan/references/approval.md && grep -q "$p25_3" splan/references/approval.md && echo есть` | `есть` | S8 | green 2026-10-13 |
