# Строки проверки темы quality-tokens: S10

> Строки 42–47: шесть доводок новых текстов `swork` по находкам ревью.

| № | Требование | Сценарий | Команда | Ожидаемое | Срез | Результат |
|---|---|---|---|---|---|---|
| 42 | R11 | сессия прервалась между сверкой и упрощением → задания упрощения отдаются проверяющему заново | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p42_1" swork/references/finish.md && grep -q "$p42_2" swork/references/finish.md && echo "упрощение переживает обрыв"` | `упрощение переживает обрыв` | S10 | не запускалась |
| 43 | R15 | повторный круг ревью прочитал только исправленное → остальные файлы не попадают в «Не прочитано проверяющими» | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p43_1" swork/references/finish.md && echo "повторный круг сверяется с исправленным"` | `повторный круг сверяется с исправленным` | S10 | не запускалась |
| 44 | R5 | попытка исправить переименовала функцию → прежняя строка `created.txt` убирается | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p44_1" swork/references/slices.md && grep -q -F "$p44_2" swork/references/slices.md && grep -q -F "$p44_3" swork/references/snapshot.md && echo "перечень не устаревает"` | `перечень не устаревает` | S10 | не запускалась |
| 45 | R29 | работа принята, снимок удалён → список файлов для коммита запомнен заранее | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p45_1" swork/references/report.md && echo "список для коммита сохранён"` | `список для коммита сохранён` | S10 | не запускалась |
| 46 | R12 | малый путь, проверяющему дописано «проект шире не исследуй» → с оговоркой о задании о дублях | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p46_1" swork/references/small.md && echo "оговорка о дублях есть"` | `оговорка о дублях есть` | S10 | не запускалась |
| 47 | R22 | задача без плана → чтение файла малого изменения идёт раньше первой правки | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p47_1" swork/references/entry.md && echo "малое начинается с файла этапа"` | `малое начинается с файла этапа` | S10 | не запускалась |
