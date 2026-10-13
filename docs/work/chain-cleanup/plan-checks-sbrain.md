# Строки проверки темы chain-cleanup: внутри sbrain

> Строки 46–49: четыре противоречия `sbrain`.

| № | Требование | Сценарий | Команда | Ожидаемое | Срез | Результат |
|---|---|---|---|---|---|---|
| 46 | R31 | до первого вопроса → гипотеза о задаче; свои решения — после слов пользователя | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p46_1" sbrain/references/context.md && grep -q "$p46_2" sbrain/references/context.md && echo есть` | `есть` | S14 | зелёная 2026-10-13 |
| 47 | R32 | малый путь `sbrain` → согласие одно, на показанный короткий дизайн | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p47_1" sbrain/references/synthesis.md && echo есть` | `есть` | S14 | зелёная 2026-10-13 |
| 48 | R33 | папки темы нет → `sbrain` в вики не пишет; правило о `state.md` действует только при папке темы | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p48_1" sbrain/SKILL.md && grep -q "$p48_2" sbrain/SKILL.md && echo есть` | `есть` | S14 | зелёная 2026-10-13 |
| 49 | R34 | пользователь выбрал следующий шаг → `sbrain` называет, как его запустить, и сам не начинает | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p49_1" sbrain/references/handoff.md && ! grep -q "$p49_2" sbrain/references/handoff.md && echo есть` | `есть` | S14 | зелёная 2026-10-13 |
