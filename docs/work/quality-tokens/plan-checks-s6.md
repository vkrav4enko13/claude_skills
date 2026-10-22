# Check lines of topic quality-tokens: S6

> Строки 28–32: один читатель на сверку и лишнее, второй — на ошибки, список прочитанного.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 28 | R11 | последний срез исполнен → сверку и задания упрощения читает один проверяющий, отдельных читателей упрощения нет | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && ! grep -rq -e "$p28_1" -e "$p28_2" -e "$p28_3" swork && grep -q "$p28_4" swork/references/finish.md && echo "читатель один"` | `читатель один` | S6 | not run |
| 29 | R12 | задание о дублях → ищет по всему проекту, и на малом пути тоже | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p29_1" swork/references/simplify.md && grep -q "$p29_2" swork/references/small.md && echo "дубли ищутся по проекту"` | `дубли ищутся по проекту` | S6 | not run |
| 30 | R13 | правки первого проверяющего закончены → ошибки ищет второй проверяющий | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p30_1" swork/references/finish.md && echo "ревью вторым"` | `ревью вторым` | S6 | not run |
| 31 | R14 | проверяющий возвращает находки → вместе с ними список прочитанных файлов | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p31_1" swork/references/conformance.md && grep -q "$p31_2" swork/references/simplify.md && grep -q "$p31_3" swork/references/review.md && echo "поле прочитанного есть"` | `поле прочитанного есть` | S6 | not run |
| 32 | R15 | изменённого файла нет в списке прочитанного → он назван в отчёте непроверенным | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p32_1" swork/references/finish.md && grep -q "$p32_2" swork/references/report.md && echo "непрочитанное в отчёте"` | `непрочитанное в отчёте` | S6 | not run |
