# Строки проверки темы chain-cleanup: чтения splan — остановка

> Строки 50–53: «Фокус» до остановки, пробел, что одобряет «да», размер.

| № | Требование | Сценарий | Команда | Ожидаемое | Срез | Результат |
|---|---|---|---|---|---|---|
| 50 | R35 | остановка до записи → строки «Фокуса» уже заведены, названный счёт окончателен | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p50_1" splan/references/slicing.md && grep -q "$p50_2" splan/references/approval.md && echo есть` | `есть` | S15 | зелёная 2026-10-13 |
| 51 | R36 | требования молчат о случае → `splan` решает сам и показывает; пробел — только то, что меняет объём | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p51_1" splan/references/approval.md && grep -q "$p51_2" splan/references/approval.md && echo есть` | `есть` | S15 | зелёная 2026-10-13 |
| 52 | R37 | «да» на остановке до записи → одобрено всё показанное на ней | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p52_1" splan/references/approval.md && ! grep -q "$p52_2" splan/SKILL.md && echo есть` | `есть` | S15 | зелёная 2026-10-13 |
| 53 | R38 | `splan` назвал размер плана → идёт дальше, ответа не ждёт | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p53_1" splan/references/recon.md && echo есть` | `есть` | S15 | зелёная 2026-10-13 |
