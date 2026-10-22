# Check lines of topic chain-cleanup: чтения splan — формат

> Строки 54–58: команда и «Ожидаемое», цель, алгоритм, файл прежнего среза, интерфейс.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 54 | R39 | строка проверки → команда печатает результат, сравнение идёт по «Ожидаемому» | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p54_1" splan/references/plan-format.md && grep -q "$p54_2" splan/references/review.md && echo есть` | `есть` | S16 | green 2026-10-13 |
| 55 | R40 | сквозная строка → цель берётся из подтверждённой цели темы; ручной она бывает только по решению пользователя | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p55_1" splan/references/slicing.md && grep -q "$p55_2" splan/references/slicing.md && echo есть` | `есть` | S16 | green 2026-10-13 |
| 56 | R41 | алгоритм в плане → только когда от его выбора зависит результат сценариев | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p56_1" splan/references/plan-format.md && echo есть` | `есть` | S16 | green 2026-10-13 |
| 57 | R42 | срез правит файл, созданный прежним срезом → «изменить» с пометкой среза-создателя | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p57_1" splan/references/plan-format.md && echo есть` | `есть` | S16 | green 2026-10-13 |
| 58 | R43 | срезы правят один файл → общие имена названы в «Интерфейсах» | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p58_1" splan/references/plan-format.md && echo есть` | `есть` | S16 | green 2026-10-13 |
