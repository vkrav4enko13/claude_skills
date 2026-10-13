# Строки проверки темы chain-cleanup: части и пометка среза

> Строки 26–29: части переросших карточек и срез, не меняющий поведения.

| № | Требование | Сценарий | Команда | Ожидаемое | Срез | Результат |
|---|---|---|---|---|---|---|
| 26 | R9 | шапка или срез переросли предел карточки → формат называет имена частей | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p26_1" splan/references/plan-format.md && echo есть` | `есть` | S9 | зелёная 2026-10-13 |
| 27 | R10 | у шапки и среза есть части → `swork` читает части шапки и передаёт исполнителю все части среза | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p27_1" swork/references/entry.md && grep -q "$p27_2" swork/references/entry.md && grep -q "$p27_3" swork/references/executor.md && echo есть` | `есть` | S9 | зелёная 2026-10-13 |
| 28 | R12 | срез-перестройка → `splan` помечает его в карточке | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -qF -e "$p28_1" splan/references/plan-format.md && grep -q "$p28_2" splan/references/slicing.md && echo есть` | `есть` | S9 | зелёная 2026-10-13 |
| 29 | R13 | у среза с пометкой проверка зелёная до правок → это не остановка | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p29_1" swork/references/slices.md && grep -q "$p29_2" swork/SKILL.md && echo есть` | `есть` | S9 | зелёная 2026-10-13 |
