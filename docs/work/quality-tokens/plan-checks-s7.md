# Строки проверки темы quality-tokens: S7

> Строки 33–37: правило об остановках в трёх скилах и меню согласия со сводкой.

| № | Требование | Сценарий | Команда | Ожидаемое | Срез | Результат |
|---|---|---|---|---|---|---|
| 33 | R23 | скилу нужно согласие → описание каждого варианта меню говорит, что будет после него | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && for s in sbrain splan swork; do grep -q "$p33_1" $s/SKILL.md && continue; exit 1; done && echo "шаг после варианта назван"` | `шаг после варианта назван` | S7 | не запускалась |
| 34 | R24 | меню согласия → называет, что именно одобряется | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && for s in sbrain splan swork; do grep -q "$p34_1" $s/SKILL.md && continue; exit 1; done && echo "одобряемое названо"` | `одобряемое названо` | S7 | не запускалась |
| 35 | R25 | меню согласия → в нём есть «Поправить» и «Ничего не делать», и в меню передачи дальше тоже | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && for s in sbrain splan swork; do grep -q "$p35_1" $s/SKILL.md && continue; exit 1; done && grep -q "$p35_2" sbrain/references/handoff.md && grep -q "$p35_3" splan/references/approval.md && echo "оба варианта есть"` | `оба варианта есть` | S7 | не запускалась |
| 36 | R26 | остановка, а от пользователя ничего не нужно → это сказано последней строкой сообщения | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && for s in sbrain splan swork; do grep -q "$p36_1" $s/SKILL.md && continue; exit 1; done && echo "ничего не нужно — сказано"` | `ничего не нужно — сказано` | S7 | не запускалась |
| 37 | R27 | `sbrain` показал сводку → согласие спрашивается меню, а не открытым вопросом | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && ! grep -q "$p37_1" sbrain/references/synthesis.md && grep -q "$p37_2" sbrain/references/synthesis.md && echo "сводка через меню"` | `сводка через меню` | S7 | не запускалась |
