# Строки проверки темы chain-cleanup: сохранение русского состояния

> Строки 85–86: сохранение русского состояния.

| № | Требование | Сценарий | Команда | Ожидаемое | Срез | Результат |
|---|---|---|---|---|---|---|
| 85 | R78 | русское состояние сохранено → копия цела и сходится со своей описью | `cd "$HOME/Documents/my/claude_skills" && bash tests/translate/state.sh check` | `state: saved` | S25 | зелёная 2026-10-13 |
| 86 | R78, R98 | в пробном проекте после сохранения файл изменён и добавлен лишний → `restore` возвращает прежний файл и убирает лишний | `cd "$HOME/Documents/my/claude_skills" && T=$(mktemp -d) && mkdir -p "$T/p/saway" "$T/p/sbrain" "$T/p/splan" "$T/p/swork" "$T/p/tests" "$T/p/docs/work/chain-cleanup" "$T/p/docs/work/quality-tokens" && echo a > "$T/p/saway/SKILL.md" && echo i > "$T/p/install.sh" && echo p > "$T/p/docs/work/chain-cleanup/phrases.sh" && echo q > "$T/p/docs/work/quality-tokens/phrases.sh" && STATE_ROOT="$T/p" CHAIN_BASE="$T/b" bash tests/translate/state.sh save > /dev/null && echo b > "$T/p/saway/SKILL.md" && echo n > "$T/p/saway/extra.md" && STATE_ROOT="$T/p" CHAIN_BASE="$T/b" bash tests/translate/state.sh restore > /dev/null && cat "$T/p/saway/SKILL.md" && [ ! -e "$T/p/saway/extra.md" ] && echo restored` | `a` и `restored` | S25 | зелёная 2026-10-13 |
