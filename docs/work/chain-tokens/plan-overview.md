# Plan overview of topic chain-tokens

> The plan as one file for reading; the source is the slice cards: where they differ, the card is right.

- **Goal:** цепочка на усилии `medium` с качеством не хуже, затем меньше токенов на прогон

## S1. Инструмент карты расходов `trace.sh` — done

Одна команда печатает, куда серия тратит токены: по этапам, ролям и видам, вход по кэшу, уровни усилия и чтения.

- **Files:** create: `tests/chain/trace.sh`
- **Depends on:** нет
- **Steps:**
  1. читает папки прогонов серии и этапы `brain plan work seed away`, какие есть; записи сессий и подагентов, включая вложенных
  2. запрос — записи одного `requestId`: расход из последней, блоки без повторов
  3. обдумывание берётся точно из записи; остаток выхода делится на текст и аргументы инструментов по байтам
  4. роль — по описанию подагента: `stage`, `plan-review`, `plan-review-2`, `executor`, `fixer`, `conformance`, `review`, `review-2`, иначе `other`
  5. секции: `total stages roles kinds input efforts reads overview depth requests`; формы строк — в части 2 карточки
- **Checks:** line 1 — серия `en` → итоги равны замеру стенда;
  expected: `total output 1188907`, `total thinking 697705`, `total output_per_run 396302`

  ```
  bash tests/chain/trace.sh en total
  ```
- **Checks:** line 2 — серия `en` → выход по этапам, ролям и видам, вход по записи и чтению кэша;
  expected: строки `stages …` четырёх этапов, `roles main`, `kinds main thinking|text|tool`, `input cache_write 2598878`, `input cache_read 32851436`

  ```
  bash tests/chain/trace.sh en stages roles kinds input
  ```
- **Checks:** line 3 — серия `effort`, где есть только этап `seed` → печатает что есть, без сбоя;
  expected: одна строка `stages seed …`, затем `code 0`

  ```
  bash tests/chain/trace.sh effort stages; echo "code $?"
  ```

## S2. Уровень усилия серии — done

Стенд ведёт сессии серии на названном для неё уровне; судья остаётся на `xhigh`.

- **Files:** change: `tests/chain/series.sh`, `tests/chain/drive.sh`
- **Depends on:** S1
- **Steps:**
  1. `series.sh` получает `--effort <уровень>`, `drive.sh` — четвёртый аргумент; без них уровень `medium`
  2. неизвестный уровень — строка usage и код 2 до любых изменений
  3. уровень серии пишется в файл `effort` её папки; серия без файла, но с `skills/` считается шедшей на `xhigh`
  4. серию просят на другом уровне — отказ `series <имя> was run at <уровень>`, код 2
  5. прогон `smoke-m`: один прогон этапа `brain` на `medium`
- **Checks:** line 4 — серия запущена с `--effort medium` → все запросы её сессий шли на `medium`;
  expected: во всех строках `efforts` уровень `medium`; последняя строка `medium`

  ```
  bash tests/chain/trace.sh smoke-m efforts; cat "$HOME/Documents/my/chain-stand/smoke-m/effort"
  ```
- **Checks:** line 5 — судья → по-прежнему на `xhigh`;
  expected: `1`

  ```
  grep -c -- '--effort xhigh' tests/chain/judge.sh
  ```
- **Checks:** line 6 — неизвестный уровень `ultra` → отказ с кодом 2, папка серии не создаётся;
  expected: `code 2`, после него пусто

  ```
  T=$(mktemp -d); CHAIN_BASE=$T bash tests/chain/series.sh x . --effort ultra 2> /dev/null; echo "code $?"; ls "$T"
  ```
- **Checks:** line 7 — серию `smoke-m`, шедшую на `medium`, просят на `high` → отказ с её уровнем;
  expected: `series smoke-m was run at medium`, затем `code 2`

  ```
  bash tests/chain/series.sh smoke-m . --runs 1 --stages brain --effort high 2>&1; echo "code $?"
  ```

## S3. Инструмент ворот качества `gate.sh` — done

Одна команда говорит, прошла ли серия ворота качества, и если нет — почему.

- **Files:** create: `tests/chain/gate.sh`
- **Depends on:** нет
- **Steps:**
  1. `gate.sh <эталон> <серия> [--group <группа>]` печатает `stages: …`, `seeds: …`, строку `verdict.sh quality` и итог
  2. пройдено, когда все этапы всех прогонов завершены, найдено 5 дефектов в каждом прогоне и нарушений не больше, чем в эталоне
  3. нет вердиктов или ключа — причина `no measurement`, ворота не пройдены
  4. с `--group`: в `levers.tsv` у группы нет взятых рычагов — `gate: skipped …`, код 0, серия не читается
- **Checks:** line 8 — серия `en` против самой себя → ворота пройдены;
  expected: `stages: 12/12`, `seeds: 15/15`, `gate: passed`, `code 0`

  ```
  bash tests/chain/gate.sh en en; echo "code $?"
  ```
- **Checks:** line 9 — в одном прогоне не найден один посеянный дефект → ворота не пройдены;
  expected: `seeds: 14/15`, `gate: failed — seeds 14/15`, `code 1`

  ```
  T=$(mktemp -d); cp -R "$HOME/Documents/my/chain-stand/en" "$HOME/Documents/my/chain-stand/blind" "$T";
  perl -pi -e 's/^seed\tseed-1\tfound/seed\tseed-1\tmissed/' "$T/blind/02a2165d/verdict.tsv"; CHAIN_BASE=$T bash tests/chain/gate.sh en en;
  echo "code $?"
  ```
- **Checks:** line 10 — один этап одного прогона не завершён → ворота не пройдены;
  expected: `stages: 11/12`, `gate: failed — stages 11/12`, `code 1`

  ```
  T=$(mktemp -d); cp -R "$HOME/Documents/my/chain-stand/en" "$HOME/Documents/my/chain-stand/blind" "$T";
  jq '.done = false' "$T/en/1/seed/stage.json" > "$T/s.json"; mv "$T/s.json" "$T/en/1/seed/stage.json"; CHAIN_BASE=$T bash tests/chain/gate.sh en en;
  echo "code $?"
  ```
- **Checks:** line 11 — серию не читал судья → отказ, а не молчаливый проход;
  expected: `gate: failed — no measurement`, `code 1`

  ```
  T=$(mktemp -d); cp -R "$HOME/Documents/my/chain-stand/en" "$T"; CHAIN_BASE=$T bash tests/chain/gate.sh en en; echo "code $?"
  ```

## S4. Базовая серия `medium` — done

Стенд показывает, что цепочка на `medium` на нынешних текстах проходит ворота; появляется база для всех следующих чисел.

- **Files:** create: `tests/chain/raised.tsv`; change: файл скила и `tests/chain/rules.md` — только при подъёме роли
- **Depends on:** S1, S2, S3
- **Steps:**
  1. сначала `git status --short sbrain splan swork saway` должен быть пуст: база снимается на текстах коммита `1c4f384`
  2. серия `medium`: `series.sh`, затем `judge.sh`, затем `gate.sh en medium`
  3. ворота не пройдены — подъём роли по процедуре ворот: `high`, потом `xhigh`, перезапуск только её дорожки; запись в `raised.tsv`
  4. один прогон этапа `away` на `medium` в `away-m/1` и его проверка `away-check.sh`
- **Checks:** line 12 — базовая серия → три прогона на `medium` на текстах без закрепления и один пройденный прогон этапа `away`;
  expected: `medium`; `1 2 3 done effort rules.md skills`; четыре строки с `:0` (или `:1` у поднятого скила); последняя — `away run: pass`

  ```
  S="$HOME/Documents/my/chain-stand"; cat "$S/medium/effort"; ls "$S/medium"; grep -c '^effort:' "$S"/medium/skills/*/SKILL.md;
  bash tests/chain/away-check.sh "$S/away-m/1/box/wiki-trial/clean" "$S/away-m/1/away"
  ```
- **Checks:** line 13 — базовая серия против серии `en` → ворота пройдены;
  expected: `stages: 12/12`, `seeds: 15/15`, `gate: passed`, `code 0`

  ```
  bash tests/chain/gate.sh en medium; echo "code $?"
  ```
- **Checks:** line 14 — роль, чей этап не прошёл ворота → идёт на `high`, после второго провала на `xhigh`;
  expected: у каждого уровня выше `medium` есть строка в `raised.tsv`, кроме одного `efforts agents high` — исполнителя готового текста; подъёмов нет — только заголовок

  ```
  bash tests/chain/trace.sh medium efforts; echo ---; cat tests/chain/raised.tsv
  ```

## S5. Ранжирование рычагов — done

Рычаги R12–R22 отсортированы по тому, что цепочка тратит на `medium`; мелкие отложены с числом.

- **Files:** create: `tests/chain/levers.tsv`
- **Depends on:** S4
- **Steps:**
  1. столбцы: `lever group kind tokens percent verdict basis`; одиннадцать строк по убыванию `tokens`
  2. `tokens` — верхняя граница экономии на прогон: весь сток, на который рычаг действует; правила по каждому рычагу — в части 2 карточки
  3. `taken`, если рычаг — удаление, рычаг входа (R21, R22) или его процент не ниже 3,0; иначе `deferred`
  4. после среза главная сессия пишет отложенные рычаги строками в «Отложено» корневого индекса
- **Checks:** line 15 — карта базовой серии → одиннадцать рычагов R12–R22 по убыванию экономии; «отложен» только рычаг поведения ниже 3 %;
  expected: `11 0 0`

  ```
  awk -F'\t' 'NR>1{n++; bad+=(($6=="deferred")!=($3=="behaviour"&&$5<3)); if(NR>2&&$4>p)u++; p=$4} END{print n, bad+0, u+0}' tests/chain/levers.tsv
  ```

## S6. Скилы закрепляют `medium` — done

Скил, запущенный в сессии на любом уровне, ведёт первый ход и всех подагентов на `medium`; исполнитель готового текста — не исключение.

- **Files:** change: четыре `SKILL.md`, `swork/references/slices.md`, `tests/chain/rules.md`
- **Depends on:** S4
- **Steps:**
  1. в шапку четырёх `SKILL.md` — строка `effort: medium`
  2. в `sbrain`, `splan`, `swork` — абзац «Subagents run at `medium`»: каждому подагенту уровень задаётся параметром запуска
  3. в `slices.md` убираются два предложения про `high` для исполнителя готового текста
  4. прогон `pin`: один прогон этапа `seed` в сессии на `high`
- **Checks:** line 17 — сессия на `high` запускает скил с закреплённым `medium` → запросы первого хода шли на `medium`;
  expected: строка `efforts first medium <n>`; строки `efforts first high` нет

  ```
  bash tests/chain/trace.sh pin efforts
  ```
- **Checks:** line 18 — тот же прогон → все запросы всех подагентов шли на `medium`, и в следующих ходах тоже;
  expected: три строки с `:1`; строка `efforts agents medium <n>` и других `efforts agents` нет

  ```
  grep -c 'Subagents run at' sbrain/SKILL.md splan/SKILL.md swork/SKILL.md; bash tests/chain/trace.sh pin efforts
  ```
- **Checks:** line 19 — исполнитель среза с готовым текстом на этапе `seed` → на `medium`, как любой другой;
  expected: `medium`

  ```
  jq -r .seed_first_agent_effort "$HOME/Documents/my/chain-stand/pin/1/metrics.json"
  ```

## S7. Поля ответа без читателя — done

Подагенты перестают писать то, что никто не читает; слепое чтение показывает, что главная сессия действует по их ответам как раньше.

- **Files:** change: `tests/chain/away-blind.sh`, `swork/references/executor.md`, `tests/chain/rules.md`; create: `tests/chain/fields-scenarios.md`, `tests/chain/fields-expected.tsv`
- **Depends on:** S4, S6
- **Steps:**
  1. `away-blind.sh` получает два необязательных аргумента: файл сценариев и файл ожидаемых ответов
  2. восемь сценариев F1–F8 о том, что главная сессия делает с ответом подагента
  3. чтение на старых текстах должно дать `8 of 8 ok`; расходится — правится сценарий, а не скил
  4. из формы ответа исполнителя убирается `CHECK:`, из правила 6 задания — слова про код и хвост вывода; запуск проверок остаётся
  5. чтение на новых текстах
- **Checks:** line 20 — слепой читатель проходит восемь сценариев на текстах до и после удаления → те же действия;
  expected: `8 of 8 ok` дважды

  ```
  tail -qn 1 "$HOME/Documents/my/chain-stand/fields/old/result.txt" "$HOME/Documents/my/chain-stand/fields/new/result.txt"
  ```
- **Checks:** line 21 — форма ответа исполнителя → поля `CHECK`, которое никто не читает, нет;
  expected: `0`

  ```
  grep -c '^CHECK:' swork/references/executor.md; true
  ```

## S8. Передача в новую сессию; этапы `saway` из чистого контекста — done

Меню передачи первым предлагает запустить следующий скил в новой сессии, с командой; `saway` ведёт каждый этап в своём подагенте.

- **Files:** change: `sbrain/references/handoff.md`, `splan/references/approval.md`, `saway/SKILL.md`, `sbrain/references/wiki-rules.md`, `sbrain/references/wiki-block.md`,
  `tests/chain/rules.md`;
  при красной строке — `tests/chain/away-check.sh`, `away-scenarios.md`, `away-expected.tsv`
- **Depends on:** S6, S7
- **Steps:**
  1. `sbrain`: «Да, дальше план» становится двумя вариантами — «в новой сессии» (`/clear`, затем `/splan <тема>`) и «в этой сессии»
  2. `splan`: то же для «Да, исполнять» с `/swork <тема>`; в меню остаётся четыре варианта, редкие называются в вопросе
  3. два новых правила для судьи: `sbrain-14` и `splan-27`
  4. `saway`: пока есть папка темы, этап идёт в свежем подагенте «Stage <скил> of <тема>» на `medium`; он действует как главная сессия этапа
  5. главная сессия `saway` пишет строку прогресса до запуска этапа и после ответа, затем перечитывает `state.md`
  6. в правила вики и блок `CLAUDE.md` — исключение: подагент-этап `saway` пишет как главная сессия
  7. прогоны: серия `ctx` (один прогон `brain plan work`), этап `away` в `away-ctx/1`, слепое чтение `saway`
- **Checks:** line 22 — `sbrain` и `splan` передают работу с итогом в папке темы → меню даёт команду запуска следующего скила в новой сессии;
  expected: строка `/splan …count`; два счёта не меньше 1; `2`

  ```
  S="$HOME/Documents/my/chain-stand/ctx/1"; grep -m1 -oE '/splan [^ ]*count' "$S/brain/chat.md"; grep -c '/clear' "$S/brain/chat.md" "$S/plan/chat.md";
  grep -c -e '^- sbrain-14\.' -e '^- splan-27\.' tests/chain/rules.md
  ```
- **Checks:** line 23 — каждый следующий скил стартует в своей сессии → идёт только от карточек темы и завершает этап;
  expected: `true` три раза

  ```
  jq -r .done "$HOME/Documents/my/chain-stand/ctx/1"/{brain,plan,work}/stage.json
  ```
- **Checks:** line 24 — `saway` ведёт этап `away` → этап идёт в своём подагенте, тот запускает исполнителей и проверяющих; прогон пройден;
  expected: `away run: pass`; строки `depth 1 <n>` и `depth 2 <n>` с n не меньше 1; строка `roles stage …`

  ```
  S="$HOME/Documents/my/chain-stand/away-ctx/1"; bash tests/chain/away-check.sh "$S/box/wiki-trial/clean" "$S/away";
  bash tests/chain/trace.sh away-ctx depth roles
  ```
- **Checks:** line 25 — слепое чтение работы без пользователя на новом `saway` → требуемые ответы;
  expected: `15 of 15 ok`

  ```
  tail -n 1 "$HOME/Documents/my/chain-stand/away-ctx/blind/result.txt"
  ```

## S9. Пакет «лишнее чтение» — done

Проверяющие читают только названное в задании, главная сессия не читает файлы заданий целиком, правила вики — раз на сессию; серия `b1` подтверждает качество.

- **Files:** change: `splan/references/review.md`, `swork/references/conformance.md`, `review.md`, `simplify.md`, `slices.md`, `finish.md`, три `SKILL.md`,
  `splan/references/approval.md`, `sbrain/references/wiki-rules.md`, `tests/chain/rules.md`
- **Depends on:** S5, S6, S7, S8
- **Steps:**
  1. правятся только рычаги со словом `taken` в `levers.tsv`; ни одного — ни правок, ни серии; файлы сначала сохраняются в `b1/before/`
  2. R12: в каждое задание проверяющего — запрет открывать файлы скилов, если их не называет план или список изменений; проверяющему плана названы карточки
  3. R13: ссылка на другой файл читается, когда дошёл до действия; файлы заданий главная сессия читает командой без блоков кода
  4. R14: в правила вики — «если этот текст уже в контексте сессии, не читай его снова»
  5. серия `b1` по процедуре ворот; не прошла после подъёмов — пакет откатывается, серия повторяется без него
- **Checks:** line 26 — проверяющие серии `b1` → ни одного чтения файла скила;
  expected: для ролей `plan-review`, `plan-review-2`, `conformance`, `review`, `review-2` нет строк `reads <роль> skill …` и `reads <роль> task …`

  ```
  bash tests/chain/trace.sh b1 reads
  ```
- **Checks:** line 27 — главные сессии серии `b1` → файлы заданий целиком не читаются, файлы скилов читаются не больше, чем в базовой серии;
  expected: над `---`: `reads main task 0 0`, байты `reads main skill` не больше, чем под `---`

  ```
  bash tests/chain/trace.sh b1 reads; echo ---; bash tests/chain/trace.sh medium reads
  ```
- **Checks:** line 28 — сессия серии `b1` → правила вики читаются не больше одного раза;
  expected: `1`; строка `reads session-max wiki-rules 1` или `… 0`

  ```
  grep -c 'already in the context' sbrain/references/wiki-rules.md; bash tests/chain/trace.sh b1 reads
  ```
- **Checks:** line 29 — серия пакета против серии `en` → ворота пройдены; рычагов группы не взято → серии нет;
  expected: `gate: passed` или `gate: skipped — no lever taken in reading`; `code 0`

  ```
  bash tests/chain/gate.sh en b1 --group reading; echo "code $?"
  ```

## S10. Пакет «повторный вывод» — done

Обзор плана пишется один раз и остаётся единственным подробным текстом, пакет исполнителя собирает скрипт, `saway` ничего не показывает по пути; серия `b2` подтверждает качество.

- **Files:** change: `splan/references/plan-format.md`, `approval.md`, `splan/SKILL.md`, `swork/references/executor.md`, `slices.md`, `finish.md`, `saway/SKILL.md`,
  `tests/chain/rules.md`; create: `swork/scripts/packet.sh`
- **Depends on:** S9
- **Steps:**
  1. R15: обзор пишется один раз — после проверки плана и её правок; позже переписываются только разделы изменённых срезов
  2. R16: в чате — строка на срез, решения, несогласованное и путь к обзору; подробный текст в чате не повторяется
  3. R17: `packet.sh <папка темы> <номер среза> <корень проекта> [<created.txt>]` печатает пакет в порядке восьми пунктов `executor.md`
  4. R17: главная сессия пишет пакет в файл временной папки и не перепечатывает карточки; скрипт не запускается — собирает вручную
  5. R18: подагент-этап `saway` не сочиняет для чата показы по пути; полное описание остаётся и строится из карточек и журнала хода
  6. серия `b2` по процедуре ворот и прогон этапа `away` в `away-out/1`; взят только R18 — серии нет
- **Checks:** line 30 — `splan` в серии `b2` → обзор написан один раз, после проверки плана;
  expected: три строки `overview <прогон> 1 <токены> <первая запись> after`

  ```
  bash tests/chain/trace.sh b2 overview
  ```
- **Checks:** line 31 — чат этапа `plan` в серии `b2` → называет файл обзора и не несёт подробного плана: поля «Шаги» нет;
  expected: три счёта не меньше 1, затем три строки с `:0`

  ```
  S="$HOME/Documents/my/chain-stand/b2"; grep -c 'plan-overview.md' "$S"/[123]/plan/chat.md;
  grep -c -e '[*][*]Steps:[*][*]' -e '[*][*]Шаги:[*][*]' "$S"/[123]/plan/chat.md; true
  ```
- **Checks:** line 32 — пакет среза 1 стендовой темы → собран скриптом из карточек; в сообщении запуска исполнителя в серии `b2` текста карточки нет;
  expected: над `---`: строки `# S1.`…, заголовок таблицы проверок, `## Shared constraints`, `## Not doing`, `## If the code differs from the plan`, `Project root: `…, строки `# S2.` нет;
  под: `0`

  ```
  P="$HOME/Documents/my/chain-stand/en/1/wiki-trial/clean"; bash swork/scripts/packet.sh "$P/docs/work/count" 1 "$P"; echo ---;
  grep -c '^# S[0-9]' "$HOME/Documents/my/chain-stand/b2/1/work/agents/01.md"; true
  ```
- **Checks:** line 33 — `saway` ведёт этап `away` на новых текстах → прогон пройден, а текста в чат написано меньше, чем до правки;
  expected: `away run: pass`; сумма `kinds main text` и `kinds stage text` над `---` меньше, чем под

  ```
  S="$HOME/Documents/my/chain-stand/away-out/1"; bash tests/chain/away-check.sh "$S/box/wiki-trial/clean" "$S/away";
  bash tests/chain/trace.sh away-out kinds; echo ---; bash tests/chain/trace.sh away-ctx kinds
  ```
- **Checks:** line 34 — серия пакета против серии `en` → ворота пройдены; рычагов группы не взято → серии нет;
  expected: `gate: passed` или `gate: skipped — no lever taken in output`; `code 0`

  ```
  bash tests/chain/gate.sh en b2 --group output; echo "code $?"
  ```

## S11. Пакет «второй круг» — done

Второй круг проверяющего получает своё короткое задание о том, что исправлено; серия `b3` подтверждает качество.

- **Files:** create: `swork/references/review-round2.md`, `splan/references/review-round2.md`; change: `swork/references/review.md`, `splan/references/review.md`,
  `swork/SKILL.md`, `tests/chain/rules.md`
- **Depends on:** S10
- **Steps:**
  1. R20 отложен в `levers.tsv` — ни правок, ни серии
  2. в каждом новом файле один блок: список исправленного, пути, вопрос «верна ли правка и не сломала ли соседнее», форма ответа первого круга
  3. второй круг вырезает блок в `review-round2.txt` (в `splan` — `plan-review-round2.txt`) и читается новым подагентом
  4. серия `b3` по процедуре ворот
- **Checks:** line 35 — второй круг ревью в серии `b3` → проверяющему уходит свой файл задания;
  expected: два счёта не меньше 1; путь для каждого прогона, где был второй круг; второго круга не было — путей нет

  ```
  grep -c 'round2.txt' swork/references/review.md splan/references/review.md;
  grep -l 'round2.txt' "$HOME/Documents/my/chain-stand/b3"/[123]/seed/agents/*.md; true
  ```
- **Checks:** line 36 — серия пакета против серии `en` → ворота пройдены; рычаг не взят → серии нет;
  expected: `gate: passed` или `gate: skipped — no lever taken in round`; `code 0`

  ```
  bash tests/chain/gate.sh en b3 --group round; echo "code $?"
  ```

## S12. Итог: экономия и раскладка — done

Итоговые числа печатает одна команда, а профили Мака получают тексты, чья серия прошла ворота.

- **Files:** create: `tests/chain/saving.sh`; change: `tests/chain/raised.tsv` и файл поднятой роли — только при подъёме
- **Depends on:** S11
- **Steps:**
  1. финальная серия — последняя принятая из `b3`, `b2`, `b1`, если её копия скилов равна текстам; иначе запускается серия `final`
  2. `saving.sh <база> <финал> <эталон>`: выход на прогон, экономия против базы с отметкой порога 10 %, экономия против `en`, кэш по трём сериям
  3. ворота финальной серии пройдены — `./install.sh --mac`; нет — ничего не раскладывается
  4. откат: перед раскладкой папки скилов и файлы инструкций трёх профилей копируются в `installed-before/`
  5. порог не взят — тема закрывается с достигнутым числом и отметкой «threshold not met»
- **Checks:** line 16 — отложенный рычаг → строка в «Отложено» корневого индекса с его номером;
  expected: одинаковые имена над и под `---`; отложенных нет — обе части пусты

  ```
  awk -F'\t' '$6=="deferred"{print "chain-tokens " $1}' tests/chain/levers.tsv; echo ---; grep -o 'chain-tokens R[0-9]*' docs/00-index.md; true
  ```
- **Checks:** line 37 — финальная серия против базовой → экономия выходных токенов на прогон и отметка порога 10 %;
  expected: строка `saving against medium: <p> % — threshold met` или `… — threshold not met`; `code 0`

  ```
  bash tests/chain/saving.sh medium "$(cat "$HOME/Documents/my/chain-stand/final.current")" en; echo "code $?"
  ```
- **Checks:** line 38 — тот же отчёт → экономия против серии `en` и запись и чтение кэша на прогон по трём сериям;
  expected: строка `saving against en: <p> %` и три строки `cache <серия>: write <n> read <n> per run`

  ```
  bash tests/chain/saving.sh medium "$(cat "$HOME/Documents/my/chain-stand/final.current")" en
  ```
- **Checks:** line 39 — правленые скилы → каждая защита из «Оставлено на месте» в своём файле, модель ни в одном скиле не названа;
  expected: четырнадцать счётов не меньше 1, затем четыре строки с `:0`

  ```
  for p in 'swork/references/slices.md:this line changes together with' 'swork/references/slices.md:Records in the wiki' 'swork/references/small.md:## Small change' \
      'swork/references/snapshot.md:created.txt' 'swork/references/entry.md:A plan of the earlier form' 'splan/SKILL.md:Approval covers only what was shown' \
      'sbrain/references/context.md:the confidence percentage' 'sbrain/references/survey.md:Tree counter' 'sbrain/SKILL.md:## Traps' 'splan/SKILL.md:## Traps' \
      'swork/SKILL.md:## Traps' 'saway/SKILL.md:## Traps' 'swork/references/finish.md:read by one reviewer that has not seen the conversation' \
      'splan/references/review.md:read by an agent that has not seen the conversation';
  do grep -cF -- "${p#*:}" "${p%%:*}"; done; grep -c '^model:' sbrain/SKILL.md splan/SKILL.md swork/SKILL.md saway/SKILL.md; true
  ```
- **Checks:** line 40 — профиль Мака → в нём финальные тексты, и их серия прошла ворота;
  expected: `gate: passed`; только строки `Only in` про `wiki-rules.md`, `check.sh` или `scripts`; `compared`

  ```
  bash tests/chain/gate.sh en "$(cat "$HOME/Documents/my/chain-stand/final.current")"; for s in sbrain splan swork saway;
  do diff -rq "$s" "$HOME/claude/personal/skills/$s"; done; echo compared
  ```
- **Checks:** line 41 — цепочка на `medium` на финальных текстах → качество не хуже серии `en`, выходных токенов на прогон меньше, чем в базовой;
  expected: `gate: passed`; второе `total output_per_run` меньше первого

  ```
  bash tests/chain/gate.sh en "$(cat "$HOME/Documents/my/chain-stand/final.current")"; bash tests/chain/trace.sh medium total;
  bash tests/chain/trace.sh "$(cat "$HOME/Documents/my/chain-stand/final.current")" total
  ```

## Technical decisions

- `trace.sh` пишется на bash и `jq`, а не переносом Python-скриптов: в `tests/` нет Python.
- Стенд передаёт `--effort`, а не переменную окружения: переменная перебила бы и закрепление в скилах, и подъём отдельной роли.
- Закрепление — шапка скила плюс одно предложение о запуске подагентов: шапка действует один ход, параметр запуска — в любом.
- Рычаги ранжируются по верхней границе — всему стоку, на который рычаг действует.
- R19 идёт как удаление: уходит только `CHECK`; `CHANGED` и `CREATED` читает `saway`, они остаются.
- Слепое чтение переиспользует `away-blind.sh` с двумя необязательными аргументами.
- Закрепление, удаления и рычаги контекста едут в первой серии пакета; непрошедший пакет откатывается, серия повторяется без него.
- Отдельной финальной серии нет, если последняя принятая шла на итоговых текстах.
- Задания второго круга лежат в своих файлах: команды вырезания берут все блоки файла.
- Пакет уходит исполнителю файлом во временной папке, а не текстом сообщения.
- Правки `saway` дополнительно принимаются этапом `away` стенда и слепым чтением.
- Серии пакетов судятся с двумя новыми правилами сверх `en`: ворота от этого только строже.

## Not doing

- Всё из «Out of scope» карточки `scope.md`: меньшая модель, быстрый режим, число проверяющих, параллельные подагенты, ПК.
- `trigger.sh`, `judge.sh`, `judge-prompt.md`, `seed.sh`, `seeds.md` не меняются.
- Режим `effort` в `verdict.sh` и скрипты анализа от 2026-10-13 остаются как есть.
- Места из «Kept in place» карточки `plan-2.md` не правятся: ловушки, слои согласия, счётчик дерева, `created.txt` и остальное из R29.

## Not agreed

- R14 на стенде выйдет «отложен»: там в сессии один скил, повторного чтения правил вики не бывает. Правка — одно предложение;
  если хотите взять её без порога, как R21–R22, скажите.
- Проверка строки 14 стала командой, а не ручной: ручная проверка в S4 остановила бы всё, что от него зависит.
- Второй круг проверки плана оставил допущения: ответ стенда «на этом остановиться» должен пройти и без такого варианта в меню;
  модель будет читать файлы заданий командой без блоков кода, а не целиком.
- Сколько стоит серия на `medium`, неизвестно до первой; серий будет от двух (база и финал) до пяти.
