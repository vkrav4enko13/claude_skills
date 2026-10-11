# Строки проверки темы quality-tokens: S7

> Строки 33–37: правило об остановках в трёх скилах и меню согласия со сводкой.

| № | Требование | Сценарий | Команда | Ожидаемое | Срез | Результат |
|---|---|---|---|---|---|---|
| 33 | R23 | скилу нужно согласие → описание каждого варианта меню говорит, что будет после него | `cd "$HOME/Documents/my/claude_skills" && for s in sbrain splan swork; do grep -q 'описание каждого варианта говорит, что произойдёт после него' $s/SKILL.md && continue; exit 1; done && echo "шаг после варианта назван"` | `шаг после варианта назван` | S7 | зелёная 2026-10-11 |
| 34 | R24 | меню согласия → называет, что именно одобряется | `cd "$HOME/Documents/my/claude_skills" && for s in sbrain splan swork; do grep -q 'называет, что именно одобряется' $s/SKILL.md && continue; exit 1; done && echo "одобряемое названо"` | `одобряемое названо` | S7 | зелёная 2026-10-11 |
| 35 | R25 | меню согласия → в нём есть «Поправить» и «Ничего не делать», и в меню передачи дальше тоже | `cd "$HOME/Documents/my/claude_skills" && for s in sbrain splan swork; do grep -q '«Поправить» и «Ничего не делать»' $s/SKILL.md && continue; exit 1; done && grep -q 'В меню добавь «Ничего не делать»' sbrain/references/handoff.md && grep -q 'В меню добавь «Ничего не делать»' splan/references/approval.md && echo "оба варианта есть"` | `оба варианта есть` | S7 | зелёная 2026-10-11 |
| 36 | R26 | остановка, а от пользователя ничего не нужно → это сказано последней строкой сообщения | `cd "$HOME/Documents/my/claude_skills" && for s in sbrain splan swork; do grep -q 'последней строкой сообщения' $s/SKILL.md && continue; exit 1; done && echo "ничего не нужно — сказано"` | `ничего не нужно — сказано` | S7 | зелёная 2026-10-11 |
| 37 | R27 | `sbrain` показал сводку → согласие спрашивается меню, а не открытым вопросом | `cd "$HOME/Documents/my/claude_skills" && ! grep -q 'без меню: меню уведёт' sbrain/references/synthesis.md && grep -q 'Согласие со сводкой спрашивай меню' sbrain/references/synthesis.md && echo "сводка через меню"` | `сводка через меню` | S7 | зелёная 2026-10-11 |
