# Строки проверки темы quality-tokens: S5

> Строки 21–27: перечень созданного, поля отчёта исполнителя, замеченное и малый путь.

| № | Требование | Сценарий | Команда | Ожидаемое | Срез | Результат |
|---|---|---|---|---|---|---|
| 21 | R4 | исполнитель возвращает отчёт → в нём поле созданных функций | `cd "$HOME/Documents/my/claude_skills" && grep -q 'СОЗДАНЫ ФУНКЦИИ:' swork/references/executor.md && echo "поле созданного есть"` | `поле созданного есть` | S5 | зелёная 2026-10-11 |
| 22 | R5 | срез начинается после других срезов → в пакете перечень из `created.txt`, без текста функций | `cd "$HOME/Documents/my/claude_skills" && grep -q 'created.txt' swork/references/executor.md && grep -q 'без текста функций' swork/references/executor.md && grep -q 'created.txt' swork/references/slices.md && grep -q 'created.txt' swork/references/snapshot.md && echo "перечень передаётся"` | `перечень передаётся` | S5 | зелёная 2026-10-11 |
| 23 | R6 | перечень передан → исполнитель всё равно ищет готовое в проекте | `cd "$HOME/Documents/my/claude_skills" && grep -q 'поиск в проекте не заменяет' swork/references/executor.md && echo "поиск остаётся"` | `поиск остаётся` | S5 | зелёная 2026-10-11 |
| 24 | R7 | правка без плана карточками → до правки назван готовый код или где искали | `cd "$HOME/Documents/my/claude_skills" && grep -q 'назови в чате готовый код' swork/references/small.md && echo "малый путь называет готовое"` | `малый путь называет готовое` | S5 | зелёная 2026-10-11 |
| 25 | R8 | у среза есть строки проверки → исполнитель не пишет тестов сверх них | `cd "$HOME/Documents/my/claude_skills" && grep -q 'сверх переданных строк проверки' swork/references/executor.md && echo "лишних тестов нет"` | `лишних тестов нет` | S5 | зелёная 2026-10-11 |
| 26 | R9 | исполнитель видит изъян вне среза → называет его в отчёте и не правит | `cd "$HOME/Documents/my/claude_skills" && grep -q 'ЗАМЕЧЕНО:' swork/references/executor.md && echo "поле замеченного есть"` | `поле замеченного есть` | S5 | зелёная 2026-10-11 |
| 27 | R10 | исполнитель назвал изъян → он записан в ход и показан в отчёте | `cd "$HOME/Documents/my/claude_skills" && grep -q 'Замечено исполнителями' swork/references/report.md && grep -q 'замечено вне среза' swork/references/slices.md && echo "замеченное в отчёте"` | `замеченное в отчёте` | S5 | зелёная 2026-10-11 |
