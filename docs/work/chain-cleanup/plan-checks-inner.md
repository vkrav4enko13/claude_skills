# Check lines of topic chain-cleanup: внутри swork

> Строки 39–45: малый путь, откат, вопросы продолжения, сверка с кодом и грабли.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 39 | R25 | малый путь, проверяющему уходит несколько заданий → запреты задания действуют только внутри него | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p39_1" swork/references/small.md && echo есть` | `есть` | S12 | green 2026-10-13 |
| 40 | R27 | малое изменение → файлы названы до первой правки, копии и поиск идут по этому списку | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p40_1" swork/references/small.md && echo есть` | `есть` | S12 | green 2026-10-13 |
| 41 | R50 | раздел малого пути → по пункту на правило: повтора шапки и второго пункта о поиске по проекту нет | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && ! grep -q "$p41_1" swork/references/small.md && [ "$(grep -c "$p41_2" swork/references/small.md)" = 1 ] && echo 1` | `1` | S12 | green 2026-10-13 |
| 42 | R26 | выбран «откатить всё» → снимок и записи хода удаляются, повторный запуск начинается как первый | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p42_1" swork/references/report.md && ! grep -q "$p42_2" swork/references/report.md && echo есть` | `есть` | S13 | green 2026-10-13 |
| 43 | R28 | вопросы при продолжении прерванной работы → названы в основном тексте среди остановок | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p43_1" swork/SKILL.md && echo есть` | `есть` | S13 | green 2026-10-13 |
| 44 | R29 | первый запуск исполнения плана → «Сверено с кодом» сверяется с нынешним кодом | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p44_1" swork/references/slices.md && echo есть` | `есть` | S13 | green 2026-10-13 |
| 45 | R30 | исполнитель наступил на грабли → возвращает их отдельным полем, по нему пишутся заметки | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p45_1" swork/references/executor.md && grep -q "$p45_2" swork/references/slices.md && echo есть` | `есть` | S13 | green 2026-10-13 |
