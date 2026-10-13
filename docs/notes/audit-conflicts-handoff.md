# Аудит цепочки: где скилы мешают друг другу

> Места в текстах по коммиту `8655b4b`, из-за которых один скил ломает ход другого; требования R8–R24 темы `chain-cleanup`.

- **Требование номером.** `splan/references/plan-format.md:98` «текст из R4» и `:80` против `swork/references/executor.md:20`: карточки требований исполнителю не передаются.
- **Предел карточки.** `sbrain/references/wiki-rules.md:51` против `plan-format.md:22`, где делятся только строки проверки, и `swork/references/entry.md:7`. В теме `quality-tokens` `plan.md` занял 30 строк из 30.
- **Карточки `sbrain`.** `splan/SKILL.md:45` называет требования, `decisions.md` и `scope.md`; `task.md`, `examples.md`, `design.md` и `decision-*.md` не названы.
- **Срез-перестройка.** `splan/references/slicing.md:24` «поведения не меняет» против `swork/references/slices.md:34` и `:66`: зелёная до правок проверка — остановка.
- **Допущение.** `splan/SKILL.md:49` «запиши в плане допущением» против `plan-format.md:61`; правило `entry.md:30` сработать не может.
- **Проверка плана.** `splan/references/approval.md:24` ставит фазу на шаге 7, `splan/SKILL.md:38` ведёт с неё на шаг 9, мимо шага 8.
- **Причина остановки.** `entry.md:24` читает её из «Хода исполнения», а `swork/SKILL.md:59` и `:74` записать не велят; `slices.md:61` отправляет в `splan`, который «Ход» не читает.
- **Отчёт.** `swork/references/report.md:7` пишет шаг «выбор пользователя после отчёта», ветки для него в `entry.md:14–26` нет.
- **`saway`.** `saway/SKILL.md:54` и `:66` против `slices.md:51`: срез «ждёт ручной проверки» без зависимых.
- **Новая сессия.** `approval.md:47` и `sbrain/references/handoff.md:25` против `splan/references/recon.md:21` и `entry.md:9`: итог лежит только в чате.
- **«Исполнитель».** `plan-format.md:130`, `:188` и `:56` против `swork/SKILL.md:72` и `executor.md:42–44`.
- Источник: аудит подагентом 2026-10-11; цитаты сверены с файлами в той же сессии
