# Check lines of topic chain-cleanup: остановки и отчёт

> Строки 30–33: записи в «Ход исполнения» и отчёт без выбора.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 30 | R17 | `swork` останавливается → причина записана в «Ход исполнения» до показа | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p30_1" swork/SKILL.md && echo есть` | `есть` | S10 | green 2026-10-13 |
| 31 | R18 | `splan` запущен по теме с остановленным исполнением → читает «Ход исполнения» | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p31_1" splan/SKILL.md && echo есть` | `есть` | S10 | green 2026-10-13 |
| 32 | R19 | `swork` показывает отчёт → отклонённые и нетронутые находки до показа записаны в «Ход» | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p32_1" swork/references/report.md && grep -q "$p32_2" swork/references/report.md && echo есть` | `есть` | S10 | green 2026-10-13 |
| 33 | R20 | отчёт показан, выбор не сделан, работу продолжают → отчёт показывается по записям хода | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p33_1" swork/references/entry.md && echo есть` | `есть` | S10 | green 2026-10-13 |
