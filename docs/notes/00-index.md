# Заметки

> Факты о проекте, которых не восстановить из кода.

## Cards

- [Срезы swork с общими файлами исполнены одним проходом](swork-one-pass.md) — S1–S6 правили одни файлы: текст написан за проход, проверки срезов прогнаны после
- [После сверки на посеве упрощению и ревью нечего искать](swork-seed-after-conformance.md) — их задания проверены только на нетронутом посеве
- [Сценарии swork после правок повторно не читались](swork-scenarios-not-reread.md) — 17 мест с двояким ответом закрыты правками, повторного чтения не было
- [Ручные проверки swork закрыты настоящими прогонами](swork-manual-checks.md) — малая задача 2026-10-11 и исполнение плана wiki 2026-10-10
- [Команды снимка swork запускай через bash](swork-zsh-loops.md) — zsh не делит `$VAR` на слова, цикл по списку файлов ломается
- [Приёмы качества исполнения из источников](execution-quality-sources.md) — три взяты в `swork` и `splan` 2026-10-11, остальные отвергнуты, с причинами
- [Где цепочка тратит время и токены](efficiency-measurements.md) — замеры двух прогонов и что по ним облегчено 2026-10-11
- [Как мерить объём скила в токенах](skill-size-measure.md) — счётчик безголового `claude`, цена токена в байтах и грабли с `awk`
- [saway: откуда приёмы и что решено без пользователя](saway-sources.md) — диспетчер над тремя скилами, `/goal`, что не испытано
- [Источники о лишнем коде и расходе токенов](reuse-token-sources.md) — чтение 2026-10-11 для темы `quality-tokens`: взятое, спорное и ненайденное
- [Проба языка скилов](language-probe.md) — русский и английский равны по точности, английский быстрее на 18 % по двум прогонам
- [Время прогонов цепочки по этапам](run-timing.md) — модель, подагенты и обдумывание в теме `quality-tokens`; способ замера по записям сессий
- [Аудит: где скилы мешают друг другу](audit-conflicts-handoff.md) — места в текстах для R8–R24 темы `chain-cleanup`
- [Аудит: противоречия внутри скила](audit-conflicts-inner.md) — места в текстах для R25–R34 темы `chain-cleanup`
- [Аудит: дубли, мёртвое и лишние токены](audit-lean.md) — места в текстах для R44–R54 и семь невзятых защит
- [Аудит `splan`: девять мест с двумя чтениями](audit-splan-readings.md) — места в текстах для R35–R43 темы `chain-cleanup`
- [Как проверять скил до и после правки](skill-eval-facts.md) — факты документации Claude Code: три прогона, слепая сверка, вопросы без человека
- [Проба сессии без человека](headless-stand-probe.md) — `claude -p` со скилами уровня проекта: вопросы списком, `--resume`, подагенты, усилие
- [Имя переменной перед не-ASCII знаком в bash 3.2](bash32-var-before-nonascii.md) — `"$имя»"` под `/bin/bash` читается одним именем: пиши `${имя}»`
- [Русские слова в awk при `en_US.UTF-8`](awk-cyrillic-equality.md) — `"правило" == "посев"` даёт 1: ставь `LC_ALL=C` или сравнивай через `index`
- [Отказы разрешений на стенде](stand-permission-denials.md) — проверку опасных удалений не снимают ни `auto`, ни `--add-dir`, ни песочница
- [Замер chain-cleanup: где ушло время](chain-cleanup-speed-recon.md) — дольше идут проверяющие `swork`; прогон `before/3` принял недоделанную работу
- [Скорость серии на английских текстах](chain-speed-en-series.md) — отличий от «до» сверх разброса нет; прибавляют обзор плана и чтение задания из файла
- [Where the chain spends tokens at `xhigh`](chain-token-map-xhigh.md) — thinking 59–66 % of output, checkers 46 %, ordered writing about 11 %; scripts kept next to the stand data
- [Effort on Opus 5.5](opus55-effort.md) — the default and the advice are `medium`; the stand and the measured sessions ran at `xhigh`
- [A reviewer wiped the shared temp folder](stand-nonstop-parallel.md) — a review subagent of a tested `swork` ran `rm -rf` on `$TMPDIR/tmp.*`; not a parallel collision
