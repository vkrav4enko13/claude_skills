# Строки проверки темы chain-cleanup: стыки скилов

> Строки 34–38: `saway`, совет о новой сессии, кто исполнитель и кто правит срез.

| № | Требование | Сценарий | Команда | Ожидаемое | Срез | Результат |
|---|---|---|---|---|---|---|
| 34 | R21 | срез ждёт ручной проверки, зависимых срезов нет → `saway` не считает это остановкой | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p34_1" saway/SKILL.md && grep -q "$p34_2" saway/SKILL.md && echo есть` | `есть` | S11 | зелёная 2026-10-13 |
| 35 | R21 | правка `saway` → основной текст не длиннее 20 600 байт, то есть в пределах 5 000 токенов | `cd "$HOME/Documents/my/claude_skills" && [ "$(wc -c < saway/SKILL.md)" -le 20600 ] && echo "в пределе"` | `в пределе` | S11 | зелёная 2026-10-13 |
| 36 | R22 | итог лежит только в чате → `splan` и `sbrain` новую сессию не советуют | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p36_1" splan/references/approval.md && grep -q "$p36_2" sbrain/references/handoff.md && echo есть` | `есть` | S11 | зелёная 2026-10-13 |
| 37 | R23 | статус среза и результат проверки → `splan` называет их работой `swork`, а не исполнителя | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p37_1" splan/references/plan-format.md && ! grep -q -e "$p37_2" -e "$p37_3" splan/references/plan-format.md && ! grep -q "$p37_4" splan/SKILL.md && echo есть` | `есть` | S11 | зелёная 2026-10-13 |
| 38 | R24 | исполнитель нашёл мелкое расхождение → сообщает о нём, карточку правит `swork` | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p38_1" splan/references/plan-format.md && ! grep -q "$p38_2" splan/references/plan-format.md && grep -q "$p38_3" swork/references/executor.md && echo есть` | `есть` | S11 | зелёная 2026-10-13 |
