# Строки проверки темы chain-cleanup: показ плана

> Строки 12–20: показ плана целиком, обзор `plan-overview.md`, его статусы и пределы.

| № | Требование | Сценарий | Команда | Ожидаемое | Срез | Результат |
|---|---|---|---|---|---|---|
| 12 | R1 | `splan` показывает план карточками на одобрение → правило велит показать его в чате целиком | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p12_1" splan/references/approval.md && echo есть` | `есть` | S6 | зелёная 2026-10-13 |
| 13 | R2 | карточки плана записаны или поправлены → формат велит писать обзор и переписывать его после каждой правки | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p13_1" splan/references/plan-format.md && grep -q "$p13_2" splan/references/plan-format.md && echo есть` | `есть` | S6 | зелёная 2026-10-13 |
| 14 | R3 | шапка обзора → называет источником карточки срезов | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p14_1" splan/references/plan-format.md && echo есть` | `есть` | S6 | зелёная 2026-10-13 |
| 15 | R4 | вход в тему, у которой есть план → `splan` пересобирает обзор из карточек | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p15_1" splan/SKILL.md && echo есть` | `есть` | S6 | зелёная 2026-10-13 |
| 16 | R4 | обзор расходится с карточкой среза → `swork` действует по карточке | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p16_1" swork/references/entry.md && echo есть` | `есть` | S7 | зелёная 2026-10-13 |
| 17 | R5 | `swork` меняет статус среза → ставит тот же статус в обзоре | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p17_1" swork/SKILL.md && echo есть` | `есть` | S7 | зелёная 2026-10-13 |
| 18 | R6 | пакет исполнителя → обзор в нём не передаётся | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p18_1" swork/references/executor.md && echo есть` | `есть` | S7 | зелёная 2026-10-13 |
| 19 | R7 | обзор из 40 строк и обзор со строкой в 250 знаков → первый проходит проверку вики, строка второго названа нарушением | `cd "$HOME/Documents/my/claude_skills" && T=$(mktemp -d) && bash tests/make-wiki.sh "$T/wiki-trial" > /dev/null && [ "$(wc -l < "$(find "$T/wiki-trial/big" -name plan-overview.md)" |tr -d ' ')" = 40 ] && bash tests/run-check.sh sbrain/scripts/check.sh "$T/wiki-trial" > /dev/null && echo "стенд вики зелёный"` | `стенд вики зелёный` | S7 | зелёная 2026-10-13 |
| 20 | R7 | правила вики о пределах → у обзора нет предела числа строк и размера, предел длины строки действует | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p20_1" sbrain/references/wiki-rules.md && echo есть` | `есть` | S7 | зелёная 2026-10-13 |
