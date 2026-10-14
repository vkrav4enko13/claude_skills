# Plan overview of topic sbrain-quality

> The plan as one file for reading; the source is the slice cards: where they differ, the card is right.

- **Goal:** опрос и «грилль» `sbrain` измеряются на стенде, тексты `sbrain` правятся по числам

## S1. Подменный пользователь и этап `survey` — done

`sbrain` проходит опрос с сырой идеи, на вопросы отвечает подменный пользователь по персоне.

- **Files:** create `tests/chain/persona.md`, `persona-prompt.md`, `answer.sh`; change `drive.sh`, `collect.sh`, `series.sh`, `trace.sh`
- **Depends on:** нет
- **Steps:** персона на идею `long.sh` (сколько слов длиннее N букв) с решениями D1–D5; `answer.sh` — отдельная сессия на `xhigh`
  без инструментов; этап кончается подтверждёнными требованиями новой темы, `END`, ошибкой или после 12 ответов — причина в `ended.txt`
- **Checks:** lines 1, 2, 3

## S2. Этап `grill` с пятью заложенными изъянами — done

- **Files:** create `tests/chain/grill-plan.md`, `grill-longest.sh`, `seeds-survey.md`; change `persona.md`, `drive.sh`, `collect.sh`, `series.sh`, `trace.sh`
- **Depends on:** S1
- **Steps:** план флага `-s` для `longest.sh` с изъянами flaw-1…5; чистый проект с `longest.sh` без посеянных дефектов; не больше 8 ответов
- **Checks:** lines 4, 5

## S3. Судья опроса — done

- **Files:** create `tests/chain/judge-survey-prompt.md`, `rules-survey.md`; change `judge.sh`
- **Depends on:** S2
- **Steps:** правила sv-1…sv-7; строки «решение перенесено» и «изъян назван»; посев судья читает только после строк правил
- **Checks:** lines 6, 7, 8

## S4. Ворота опроса `survey-gate.sh` — done

- **Depends on:** S3 · **Checks:** lines 9, 10 — три числа двух серий: нарушения, перенесённые решения, названные изъяны

## S5. Базовая серия `sv-base` — done

- **Depends on:** S4 · **Checks:** line 11 — три прогона `survey` и `grill` на нынешних текстах, судья, числа и цена

## S6. Правки текстов `sbrain` по числам — done

- **Depends on:** S5 · **Checks:** line 12 — правится только то, что промахнулось в двух прогонах и больше; не больше двух кругов;
  принимается, если не хуже по всем трём числам и лучше хотя бы по одному

## S7. Полная цепочка и отчёт — done

- **Depends on:** S6 · **Checks:** lines 13, 14 — если тексты `sbrain` менялись, серия цепочки проходит ворота против `en`; раскладка — с вашего согласия

## Not agreed

- Решения приняты без опроса — по вашему «делай все»; они в `decisions.md`, оспорить можно любое.
