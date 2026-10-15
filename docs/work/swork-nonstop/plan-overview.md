# Plan overview of topic swork-nonstop

> The plan as one file for reading; the source is the slice cards: where they differ, the card is right.

- **Goal:** `swork` без остановок, решения в отчёте; лимиты вики, читаемые по ссылке, удвоены

## S1. Стенд для безостановочного swork — done

Стенд умеет сказать, дошёл ли `swork` до отчёта без вопроса и перечислил ли свои решения; старый `swork` проверку проваливает.

- **Files:** create `tests/chain/nonstop-check.sh`, `nonstop-run.sh`, `nonstop-scenarios.md`, `nonstop-expected.tsv`;
  change `tests/chain/seed-away.sh`
- **Depends on:** none
- **Steps:**
  1. `nonstop-check.sh <project> <stage folder>` судит по ответу 1-го хода (`.result` из `turns/01.json`):
     отчёт с выбором и раздел «Решил сам», в нём S4 и S5; S4, S5, S6 — `done`; `notes-old.txt` удалён
     → `nonstop run: pass`, иначе `fail` с кодом 1.
  2. `nonstop-run.sh <skills>`: стенд из этих скилов → `seed-away` → этап `seed` → `nonstop-check.sh`.
  3. `seed-away.sh`: проверка S5 `test ! -e notes-old.txt && echo gone` (старая `ls` никогда не зелёная);
     шапка больше не называет S5 «не делается без пользователя».
  4. Сценарии N1–N9 для чтения вслепую: окружение, ручная проверка, чужой файл, прерванный необратимый срез,
     регресс сделанного среза, малое изменение, поправка посреди работы, неодобренный план, зелёная до правок.
- **Checks:** line 4 — `swork` коммита 6f6e3f4 проваливает проверку; expected: `nonstop run: fail`

  ```
  S=$(mktemp -d) && git archive 6f6e3f4 sbrain splan swork saway | tar -x -C $S
    && { bash tests/chain/nonstop-run.sh $S; test $? -eq 1; }
  ```

## S2. Лимиты вики, читаемые по ссылке, ×2 — done

Карточки и индексы тем дробятся вдвое реже; старт сессии не дорожает.

- **Files:** change `sbrain/references/wiki-rules.md`, `sbrain/scripts/check.sh`, `splan/references/plan-format.md`,
  `tests/make-wiki.sh`, `tests/expected-broken.txt`
- **Depends on:** none
- **Steps:**
  1. Карточка 60 строк и 6000 знаков; индекс папки 100 строк; строка индекса папки, архива и обзора 400 знаков.
  2. Без изменений: корневой индекс 40, `rules.md` 30, чтение при старте 80, строка корня, правил и журнала 200.
  3. `check.sh`: предел строки зависит от файла — 400 или 200; `plan-format.md:178` — 400.
  4. Тестовая вики: карточки 65 строк и 6200 знаков, индекс 105 строк, строки индекса тем и обзора 450 знаков —
     нарушения; строка индекса 300 знаков — нет; `expected-broken.txt` по новому выводу.
- **Checks:** line 1 — тестовая вики даёт ожидаемые нарушения; expected: `script is fine`

  ```
  T=$(mktemp -d)/wiki-trial && bash tests/make-wiki.sh $T >/dev/null
    && bash tests/run-check.sh sbrain/scripts/check.sh $T
  ```

  line 2 — вики проекта по новым пределам; expected: `wiki is fine` — `bash sbrain/scripts/check.sh docs`

  line 3 — корень 40, чтение 80, карточка 60/6000; expected: `3`

  ```
  grep -cF -e '| The root index | 40 lines |' -e 'at most 80 lines together'
    -e '| A card | 60 lines and 6000 characters |' sbrain/references/wiki-rules.md
  ```

## S3. swork решает вместо остановок — done

Запущенный `swork` в бывшей точке остановки решает сам, пишет `⚠` в чат и идёт к отчёту.

- **Files:** change `swork/SKILL.md`, `swork/references/slices.md`, `entry.md`, `snapshot.md`, `finish.md`, `small.md`
- **Depends on:** S1
- **Steps:**
  1. Раздел 4 → «Own decisions»: ждёт только меню после отчёта и вход по фазе.
  2. Меню остановки → «Decisions and bypass»: расхождение, красная после 2 попыток, зелёная до правок,
     `need a file` — правка карточки среза не больше 2 раз, никогда «Ожидаемое»; потом `bypassed`.
  3. Обход: несделанный срез возвращает из `base/` файлы, которых не называет ни один сделанный срез,
     и удаляет свои новые файлы; сделанный раньше срез и срез с «Откатом» ничего не восстанавливают;
     зависимые не делаются, остальное делается.
  4. «Откат» — сохранение, затем срез; сохранение не удалось — `bypassed`.
  5. Окружение — одна попытка поднять, иначе `not checked`; ручная проверка — зависимые «на непроверенной основе».
  6. Продолжение: чужое в `known.txt`; прерванный необратимый срез — выяснить по коду, неясно — `bypassed`,
     не повторять; сделанный срез покраснел — правка, потом `bypassed`, его сделанные зависимые
     называются в отчёте; `bypassed` не повторяется; старый `stopped` — как красный после двух попыток.
  7. Стадии 5–7 не требуют обойдённого; малое изменение держит решения в чате;
     поправка пользователя — со следующего шага, без меню.
- **Checks:** line 8 — в `swork` нет раздела остановок и меню; expected: `swork/SKILL.md:0` и `swork/references/slices.md:0`

  ```
  { grep -c -e '^## 4. Stops' -e '^## Stop menu' swork/SKILL.md swork/references/slices.md || true; }
  ```

## S4. Отчёт «Решил сам» и splan в лад — done

В отчёте каждое решение с причиной; `splan` знает новые статусы и называет необратимые срезы.

- **Files:** change `swork/references/report.md`, `splan/references/plan-format.md`, `approval.md`, `review.md`, `splan/SKILL.md`
- **Depends on:** S2, S3
- **Steps:**
  1. Раздел «Decided myself»: проблема — выбор — почему — иначе; затем обойдённое, не проверенное,
     на непроверенной основе, `known.txt`, необратимые срезы без согласия.
  2. Статусы `not checked`, `bypassed` вместо `stopped`; «Откат» исполним как написан.
  3. Остановка перед записью и показ плана называют срезы с «Откатом» и ручные проверки с зависимыми.
- **Checks:** line 6 — девять сценариев вслепую; expected: `9 of 9 ok`

  ```
  bash tests/chain/away-blind.sh . $(mktemp -d)/n tests/chain/nonstop-scenarios.md
    tests/chain/nonstop-expected.tsv | tail -1
  ```

  line 9 — `bypassed` в `plan-format.md` и «Decided myself» в `report.md`; expected: два числа, каждое ≥ 1

  ```
  grep -c '`bypassed`' splan/references/plan-format.md; grep -c 'Decided myself' swork/references/report.md
  ```

## S5. saway без дублей и приёмка — done

`saway` ссылается на `swork`; стенд доказывает непрерывность и что качество не хуже.

- **Files:** change `saway/SKILL.md`, `tests/chain/rules.md`, `away-check.sh`, `away-scenarios.md`, `away-expected.tsv`,
  `fields-scenarios.md`, `fields-expected.tsv`
- **Depends on:** S2, S3, S4
- **Steps:**
  1. `saway`: убрать пункт «A `swork` stop» и переехавшие правила обхода; срез с «Откатом» освобождён от запрета
     на необратимое, но запрет вне папки проекта остаётся; запрещённый срез получает `bypassed`;
     выполненный без вас срез с «Откатом» пишется в «Ждёт пользователя» с командой отката.
  2. `away-check.sh`: необратимый S5 и зависимый S6 — `done`; «ждёт пользователя» называет S5.
  3. Сценарии: B1, B4, B6, B12, B13, B14, F2 — под новое поведение; ответы B6 → `a`, F2 → `b`, остальные прежние.
  4. Правила судьи `swork-*`: только ссылки `file:line` на новые строки.
- **Checks:** line 5 — текущие скилы на `seed-away`; expected: `nonstop run: pass` — `bash tests/chain/nonstop-run.sh .`

  line 7 — по три прогона `seed` на скилах 6f6e3f4 и на текущих, один судья; expected: `— not more`

  ```
  S=$(mktemp -d) && git archive 6f6e3f4 sbrain splan swork saway | tar -x -C $S
    && bash tests/chain/series.sh nonstop-before $S --stages seed
    && bash tests/chain/series.sh nonstop-after . --stages seed
    && bash tests/chain/judge.sh nonstop-before nonstop-after
    && bash tests/chain/verdict.sh quality nonstop-before nonstop-after
  ```

  line 10 — 15 сценариев `saway` вслепую; expected: `15 of 15 ok` — `bash tests/chain/away-blind.sh . $(mktemp -d)/a | tail -1`

  line 11 — 8 сценариев полей вслепую; expected: `8 of 8 ok`

  ```
  bash tests/chain/away-blind.sh . $(mktemp -d)/f tests/chain/fields-scenarios.md
    tests/chain/fields-expected.tsv | tail -1
  ```

  line 12 — `saway` на `seed-away`; expected: `away run: pass`

  ```
  T=$(mktemp -d) && bash tests/chain/stand.sh $T . >/dev/null && P=$T/wiki-trial/clean
    && bash tests/chain/seed-away.sh $P >/dev/null && bash tests/chain/drive.sh $P away $T/stage medium >/dev/null;
    bash tests/chain/away-check.sh $P $T/stage
  ```

  line 13 — в `saway` нет пункта об остановке; expected: `0` — ``{ grep -c 'A `swork` stop' saway/SKILL.md || true; }``

  line 14 — правило в `rules.md`; expected: `2`

  ```
  grep -c -e 'отдельный скил `saway` — 2026-10-11' -e 'works continuously' docs/rules.md
  ```

## Technical decisions

- Своя правка не трогает «Ожидаемое» и значения сценария — иначе `swork` подгонит проверку.
- Прерванный срез с «Откатом» выясняется по коду, неясный обходится, никогда не повторяется.
- Обойдённый срез возвращает только файлы, которых не называет ни один сделанный срез; срезы с «Откатом» — нет.
- Статусы `bypassed` и `not checked` вместо `stopped`; старый `stopped` — как красный после двух попыток.
- Малое изменение держит решения в чате.
- `splan` при показе плана называет необратимые срезы и ручные проверки с зависимыми.
- Приёмка: живая проверка на `seed-away`, девять сценариев вслепую и две серии `seed` — до (6f6e3f4) и после;
  `b2` не годится: в нём четыре этапа, а вердикт не различает этапы.
- Правила судьи не требуют остановок — меняются только ссылки на строки.

## Not doing

- То, что в [scope.md](scope.md); `install.sh --mac`, коммит и пуш — выбор пользователя после отчёта.
- Проверки закрытых тем (`saway-nonstop`, `chain-tokens`) не правятся.

## Not agreed

- R17 уже записан `sbrain` 2026-10-15: строка 14 зелёная до правок, у S5 остальные строки красные.
- Под `saway` необратимый срез вне папки проекта по-прежнему обходится.
- Второй круг проверки: учтено всё; остаточный риск — если отчёт и меню придут разными сообщениями,
  `.result` 1-го хода держит только последнее, и строка 5 может покраснеть ложно.
