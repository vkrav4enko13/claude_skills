# Plan overview of topic ponytail-lean

> The plan as one file for reading; the source is the slice cards: where they differ, the card is right.

- **Goal:** the chain writes less superfluous code from the start, with ponytail ideas taken through a clean room, at quality not worse on the stand

Все команды — из корня проекта; `CB` — это `"$HOME/Documents/my/chain-stand"`. Строк проверки — 53, из них вручную — 3 (51, 52, 53).

## S1. Code map in the executor packet — done

Пакет исполнителя содержит короткую карту определений верхнего уровня; если карта сломалась, пакет всё равно собирается.

- **Files:** create: `swork/scripts/codemap.sh`, `tests/codemap-test.sh`; change: `swork/scripts/packet.sh`, `swork/references/executor.md` (раздел «Packet»), `install.sh` (копия в `splan/scripts/`, Mac `:193-199` и PC `:223-229`), `tests/chain/stand.sh` (та же копия, только если `codemap.sh` есть)
- **Depends on:** none
- **Steps:**
  1. `codemap.sh <root>`: пропускает `.git`, `.claude`, `.agents`, `docs`, `node_modules`, `vendor`, `dist`, `build`, `__pycache__`, папки `tests`/`test`/`__tests__`/`spec` и файлы `*_test.*`, `*.test.*`, `*.spec.*`, `*.min.*`, `*.lock`.
  2. Берёт только верхний уровень: bash `name() {`/`function name`, Python `def`/`class`, JS/TS `export`/`function`/`class`, Go `func`, Ruby `def`/`class` — имя со списком параметров.
  3. Вывод — блок на папку; папки `lib`, `shared`, `common`, `core`, `util`, `utils`, `helpers` идут первыми.
  4. Предел — 2000 знаков; если обрезано, последняя строка `… (truncated)`.
  5. Имена с пробелами и кириллицей читаются безопасно (`-print0`).
  6. `packet.sh` запускает `codemap.sh`, лежащий рядом с ним, с пределом 10 с через фоновое задание и `kill` (`timeout` на этом Mac нет) и печатает блок `=== code map ===` только при коде 0 и непустом выводе.
  7. В `executor.md` — новый пункт 8 «The code map» после корня проекта, «What was created earlier» становится 9-м: карта не получилась — искать в проекте всё равно обязательно.
  8. `codemap-test.sh` — случаи `order`, `tests`, `nested`, `size`, `empty`, `names`, итог `codemap: all ok`.
- **Checks:**
  - line 1 — `app/` и `lib/`, функция в `tests/`, вложенный `def` → `lib/` первым, без тестов, только внешний; expected: `order: ok`, `tests: ok`, `nested: ok`

    ```
    bash tests/codemap-test.sh | grep -E '^(order|tests|nested):'
    ```
  - line 2 — 300 функций → не больше 2000 знаков, хвост `… (truncated)`; expected: `size: ok`

    ```
    bash tests/codemap-test.sh | grep '^size:'
    ```
  - line 3 — пустая папка → пусто, код 0; expected: `empty: ok`

    ```
    bash tests/codemap-test.sh | grep '^empty:'
    ```
  - line 4 — `my file.sh` и `данные/` → оба в карте; expected: `names: ok`, затем `codemap: all ok`

    ```
    bash tests/codemap-test.sh | grep '^names:'; bash tests/codemap-test.sh | tail -1
    ```
  - line 5 — карта этого репозитория; expected: число ≤ 2000, затем `0`

    ```
    bash swork/scripts/codemap.sh . | LC_ALL=C.UTF-8 wc -m | tr -d ' '; bash swork/scripts/codemap.sh . | grep -c '^tests/'
    ```
  - line 6 — пакет темы содержит блок карты; expected: `1`

    ```
    bash swork/scripts/packet.sh docs/work/quality-zero 1 . | grep -c '^=== code map ===$'
    ```
  - line 7 — карта падает → пакет без блока; expected: `rc 0`, `0`, `1`

    ```
    T=$(mktemp -d "$CB/pk.XXXXXX") && cp -R swork $T/ && printf 'exit 1\n' > $T/swork/scripts/codemap.sh
      && bash $T/swork/scripts/packet.sh docs/work/quality-zero 1 . > $T/p.txt; echo "rc $?";
      grep -c '=== code map ===' $T/p.txt; grep -c '^# S1\.' $T/p.txt
    ```
  - line 8 — карта зависла → пакет за ≤ 12 с без блока; expected: `0`, затем `s <n>`, n ≤ 12

    ```
    T=$(mktemp -d "$CB/ph.XXXXXX") && cp -R swork $T/ && printf 'sleep 60\n' > $T/swork/scripts/codemap.sh
      && SECONDS=0 && bash $T/swork/scripts/packet.sh docs/work/quality-zero 1 . | grep -c '=== code map ==='; echo "s $SECONDS"
    ```
  - line 9 — стенд и `install.sh` кладут `codemap.sh` в `splan` и `swork`; expected: `2`, затем число ≥ 2

    ```
    T=$(mktemp -d "$CB/cm.XXXXXX") && bash tests/chain/stand.sh $T . >/dev/null
      && ls $T/wiki-trial/clean/.claude/skills/{splan,swork}/scripts/codemap.sh | wc -l | tr -d ' '; grep -c 'codemap.sh' install.sh
    ```

## S2. Executor rules of writing code — done

Исполнитель `swork` сначала перечисляет, куда дойдёт правка, берёт самую дешёвую ступень, которая работает, чинит общий код один раз, не режет защиты и отчитывается полями `LADDER:` и `GAPS:`. Текст правил дан в карточке дословно.

- **Files:** change: `swork/references/executor.md` (правила 4 и 8, новые 11–16, форма ответа)
- **Depends on:** none
- **Steps:**
  1. Правило 4 — перечислить места правки: вызывающие, тесты, фикстуры, настройки, экспорты. Место вне «Files» — статус «need a file». Перечислить тест ≠ написать его.
  2. Правило 8 — лестница из шести ступеней: не нужно → уже в проекте (Reuse, созданное ранее, карта, поиск) → стандартная библиотека или платформа → установленная зависимость → одна строка → минимальный код. Зависимость ради пары строк не добавлять.
  3. Новые правила 11–16:
     - 11 — найти всех вызывающих и чинить общую функцию;
     - 12 — переносить проверки вместе с кодом;
     - 13 — список «не резать никогда», он выше лестницы;
     - 14 — самый малый дифф после области правки; при равенстве — вариант, верный на краях;
     - 15 — комментарий в одну строку и только «почему»;
     - 16 — `shortcut: <ceiling>; upgrade when <trigger>`.
  4. Поля ответа `LADDER:` (ступень и почему не ниже, где искал, вызывающие) и `GAPS:` (что не строил, что не проверил, риск).
  5. Полный текст этих правил живёт только здесь.
- **Checks:**
  - line 10 — область, вызывающие, перенос проверок; expected: `1` трижды

    ```
    for p in 'list every place the change must reach' 'find every caller of it' 'carry its validation and its error handling';
      do grep -cF "$p" swork/references/executor.md; done
    ```
  - line 11 — лестница, без лишних зависимостей, список выше лестницы; expected: `1` трижды

    ```
    for p in 'go down the ladder' 'Never add a dependency to save a few lines' 'This list overrides rule 8';
      do grep -cF "$p" swork/references/executor.md; done
    ```
  - line 12 — `shortcut:`, малый дифф, комментарии, края; expected: `1` четыре раза

    ```
    for p in 'shortcut: <ceiling>; upgrade when <trigger>' 'take the smallest diff' 'says only why' 'correct on edge cases';
      do grep -cF "$p" swork/references/executor.md; done
    ```
  - line 13 — поля ответа; expected: `2`

    ```
    grep -cE '^(LADDER|GAPS): ' swork/references/executor.md
    ```

## S3. Simplification, conformance and report follow the executor rules — done

Упрощение бережёт список «не резать» исполнителя, сверка держит исполнителя за его поле `LADDER:`, в отчёте появляется раздел «Долг».

- **Files:** change: `swork/SKILL.md` (`:116`), `swork/references/simplify.md`, `swork/references/slices.md`, `swork/references/conformance.md`, `swork/references/report.md`
- **Depends on:** S2
- **Steps:**
  1. `simplify.md`: первая фраза задания остаётся, а «go down the ladder» и свои четыре ступени (`:48-55`) заменены ссылкой на ступени правила 8 (1 — удалить, 2–4 — заменить, 5–6 — упростить на месте); свой список границ — ссылкой на правило 13; в «What not to touch» — «does not cut anything on the never-cut list».
     `<skill folder>` — подстановка главной сессии. В `swork/SKILL.md:116` ответ ловушки — «The never-cut list of the executor rules is not touched».
  2. `slices.md`: главная сессия пишет поле `LADDER:` в `.swork/ladder.txt` строками `S<N>: …`, а поле `GAPS:` — в журнал хода строкой `S<N>: gaps — …`.
  3. `conformance.md`: сверке передаётся путь к `ladder.txt` — единственное исключение из «отчёты исполнителей не передаются»; новый подпункт LADDER внутри WRONG: нет строки или код ей противоречит — находка WRONG; `ladder.txt` нет (малый путь без исполнителя) — подпункт пропускается. Комментарий `shortcut:` не оправдывает отступления от плана.
  4. `report.md`: раздел «**Debt**» после «Noticed by the executors» — все `shortcut:` в тронутых файлах, без триггера — «rot risk»; в «Noticed by the executors» — ещё и строки «gaps» исполнителей.
- **Checks:**
  - line 14 — текст лестницы в одном файле; expected: только `swork/references/executor.md`

    ```
    grep -rlF 'go down the ladder' sbrain splan swork saway hooks 2>/dev/null
    ```
  - line 15 — упрощение ссылается на правила исполнителя, своего списка границ нет; expected: число ≥ 2, затем `0`

    ```
    grep -c 'references/executor.md' swork/references/simplify.md;
      grep -c 'checks at the boundaries of the system: user input' swork/references/simplify.md
    ```
  - line 16 — `ladder.txt` у главной сессии и у сверки; expected: `slices.md:` ≥ 1 и `conformance.md:` ≥ 1, затем число ≥ 1

    ```
    grep -c 'ladder.txt' swork/references/slices.md swork/references/conformance.md; grep -c 'LADDER' swork/references/conformance.md
    ```
  - line 17 — «Долг» и «rot risk»; expected: `1`, `1`

    ```
    grep -cF '**Debt**' swork/references/report.md; grep -c 'rot risk' swork/references/report.md
    ```

## S4. Review of swork rebuilt — done

Ревью `swork` ранжирует находки по видам, ищет всех вызывающих изменённого контракта, называет предполагаемую нагрузку и возвращает три уровня с вердиктом.

- **Files:** change: `swork/references/review.md`
- **Depends on:** S2
- **Steps:**
  1. `:5` — ревью ищет ошибки и лишний код, оставшийся после упрощения.
  2. Ревьюер читает правила 8, 13, 16 исполнителя (`<skill folder>` подставляет главная сессия). В «Look for» добавлено: при смене сигнатуры, результата или поведения искать всех вызывающих; рискованная логика без теста.
  3. Строка `ASSUMED LOAD` берётся из README или плана; если там пусто — «not stated, assumed small».
  4. `shortcut:` с триггером в пределах потолка — это решение, а не находка; без триггера — находка вида risk.
  5. Форма ответа:
     - виды по порядку: bug, risk, load, missing test, speed, superfluous;
     - `TIER 1`/`2`/`3`, сквозная нумерация;
     - у каждой находки: для чего код, что ломается, правка, цена отказа;
     - «Found no errors — say so» остаётся;
     - итог: `VERDICT:`, `REMOVABLE LINES:`, `NOT CHECKED:`, затем `READ:`;
     - каждая цитируемая фраза — в одной строке.
  6. Отбор и второй круг: «serious» = TIER 1, «minor» = TIER 2–3; лишний код TIER 3 применяется, только если проверки среза остаются зелёными.
- **Checks:**
  - line 18 — `shortcut:` без триггера — находка, в пределах потолка — нет; expected: `1`, `1`

    ```
    for p in 'without a trigger is a finding' 'while the code stays within its ceiling, is a decision, not a finding';
      do grep -cF "$p" swork/references/review.md; done
    ```
  - line 19 — порядок видов и поиск вызывающих; expected: `1`, `1`

    ```
    for p in 'bug, risk (security, data loss), load,' 'search the whole project for every caller';
      do grep -cF "$p" swork/references/review.md; done
    ```
  - line 20 — нагрузка, уровни, вердикт, удаляемые строки, непроверенное, цена; expected: `yes` шесть раз

    ```
    for p in 'ASSUMED LOAD' 'TIER 1' 'VERDICT:' 'REMOVABLE LINES:' 'NOT CHECKED:' 'the cost of not fixing';
      do grep -cF "$p" swork/references/review.md | sed 's/^[1-9][0-9]*$/yes/'; done
    ```
  - line 21 — ссылка на правила исполнителя, старой фразы «лишнее — дело упрощения» нет; expected: число ≥ 1, затем `0`

    ```
    grep -c 'references/executor.md' swork/references/review.md;
      grep -c 'what is superfluous — of the simplification; not of the review' swork/references/review.md
    ```

## S5. splan: tests for risky logic, map and audit in the recon — done

`splan` даёт рискованному срезу один малый тест, тривиальному — никакого, разведку начинает с карты, рискованные пути читает как аудит и у каждой готовой части называет ступень. Текст дан в карточке дословно.

- **Files:** change: `splan/references/slicing.md`, `splan/references/recon.md`, `splan/references/plan-format.md`
- **Depends on:** S1, S2
- **Steps:**
  1. `slicing.md`:
     - пункт «Risky logic gets one small test»: ветвление, цикл, разбор, деньги, безопасность, новый скрипт → одна строка проверки с одним малым тестом;
     - тривиальный срез (переименование, текст, настройка) — без теста;
     - в «no tests — do not invent them» — исключение для этого теста.
  2. `recon.md`: «Map first» — запустить `codemap.sh`; упал — искать как обычно.
  3. `recon.md`: «Audit the touched part» — рискованные пути (вход извне, деньги, доступ, запись, фоновые задачи, общее состояние) читать целиком; непрочитанное — в «Assumptions» как `not read: <paths>`.
  4. `recon.md`: у готового кода — ступень правила 8 исполнителя (2 — проект, 3 — библиотека, 4 — установленная зависимость).
  5. `plan-format.md`: в поле «Reuse» — ступень.
- **Checks:**
  - line 22 — малый тест рискованной логике, тривиальному — нет; expected: `1`, `1`

    ```
    for p in 'Risky logic gets one small test' 'A trivial slice — a rename, a text, a setting — gets no test';
      do grep -cF "$p" splan/references/slicing.md; done
    ```
  - line 23 — карта в разведке и ступень в «Reuse»; expected: число ≥ 1, затем число ≥ 1

    ```
    grep -c 'codemap.sh' splan/references/recon.md; grep -c 'rung' splan/references/plan-format.md
    ```
  - line 24 — аудит и список непрочитанного; expected: `1`, `1`

    ```
    for p in 'Audit the touched part' 'not read: <paths>'; do grep -cF "$p" splan/references/recon.md; done
    ```
  - line 25 — ссылка на правила исполнителя; expected: число ≥ 1

    ```
    grep -c 'references/executor.md' splan/references/recon.md
    ```

## S6. Every chain skill closes with gaps and explains in full — done

В последнем сообщении `sbrain`, `splan`, `swork` и `saway` перед меню или дословной последней строкой стоят строки «не сделано / не проверено / риск»; подробное объяснение по просьбе не урезается.

- **Files:** change: `sbrain/references/handoff.md`, `splan/references/approval.md`, `swork/references/report.md`, `saway/SKILL.md`
- **Depends on:** none
- **Steps:**
  1. В `handoff.md` перед меню передачи и в шаг 9 `approval.md` перед запросом одобрения — две фразы дословно: `Before the menu or the fixed last line, write one or two lines: what was not done, what was not verified, and any risk.` и `A detailed explanation the user asks for is given in full, without trimming it for brevity.`
  2. В `report.md` — обе фразы перед пунктом «What next».
  3. В `saway/SKILL.md` — обе фразы перед абзацем о дословной последней строке.
- **Checks:**
  - line 26 — строки о пробелах в четырёх скилах; expected: четыре строки, каждая кончается `:1`

    ```
    grep -cF 'Before the menu or the fixed last line, write one or two lines: what was not done, what was not verified, and any risk.'
      sbrain/references/handoff.md splan/references/approval.md swork/references/report.md saway/SKILL.md
    ```
  - line 27 — полное объяснение в четырёх скилах; expected: четыре строки, каждая кончается `:1`

    ```
    grep -cF 'A detailed explanation the user asks for is given in full, without trimming it for brevity.'
      sbrain/references/handoff.md splan/references/approval.md swork/references/report.md saway/SKILL.md
    ```

## S7. Hooks of the chain — done

Ключевые правила цепочки приходят в каждую сессию Claude Code (`startup`, `resume`, `clear`, `compact`) и в каждый подагент при старте. С каждым сообщением пользователя приходит строка о языке. Сломанный хук сессию не останавливает.

- **Files:** create: `hooks/chain-rules.md`, `hooks/inject.sh`, `hooks/lang.sh`, `tests/hooks-test.sh`, `tests/hooks-live.sh`; change: `install.sh`
- **Depends on:** S2
- **Steps:**
  1. `chain-rules.md` — дословно в карточке: первая строка `# Chain rules`, оговорка «действуют, пока в работе скил цепочки», семь правил; путь к правилам исполнителя — `{{SKILLS}}/swork/references/executor.md`.
  2. `inject.sh` по `hook_event_name`: `SessionStart` → текст правил, где `{{SKILLS}}` заменён абсолютным путём `$(dirname "$0")/../skills`; `SubagentStart` → JSON `hookSpecificOutput.additionalContext`; на всё прочее, на мусор, без `jq` или без файла молчит. Всегда код 0.
  3. `lang.sh` печатает `Reply to the user in the language of their own words.`
  4. `install.sh`, только Mac и только `~/claude/personal` и `~/claude/work`:
     - копирует `hooks/` в `<profile>/chain-hooks/`;
     - в `settings.json` (нет файла — `{}`) убирает записи с `/chain-hooks/` и добавляет три новые: `SessionStart` (matcher `startup|resume|clear|compact`), `SubagentStart`, `UserPromptSubmit`, у всех `timeout: 5`;
     - пишет через временный файл и `mv`, прочие ключи и хуки сохраняются;
     - `--uninstall` убирает только наши записи.
  5. `hooks-test.sh` — подменённый дом, два прогона установки и снятие; случаи `install`, `rerun`, `kept`, `missing`, `codex`, `uninstall`.
  6. `hooks-live.sh` — два настоящих `claude -p` на `medium`: видит ли правила сессия и видит ли подагент.
- **Checks:**
  - line 28 — старт, возобновление, очистка, сжатие → правила; expected: `# Chain rules` четыре раза

    ```
    for s in startup resume clear compact; do printf '{"hook_event_name":"SessionStart","source":"%s"}' $s
      | bash hooks/inject.sh | head -1; done
    ```
  - line 29 — старт подагента → правила как контекст; expected: `SubagentStart`, `# Chain rules`

    ```
    printf '{"hook_event_name":"SubagentStart","agent_type":"Explore"}' | bash hooks/inject.sh
      | jq -r '.hookSpecificOutput.hookEventName, (.hookSpecificOutput.additionalContext | split("\n")[0])'
    ```
  - line 30 — сообщение пользователя → строка о языке; expected: `Reply to the user in the language of their own words.`

    ```
    printf '{"hook_event_name":"UserPromptSubmit","prompt":"x"}' | bash hooks/lang.sh
    ```
  - line 31 — не JSON и нет файла правил → тишина, код 0; expected: только `rc 0`, `rc 0`

    ```
    printf 'not json' | bash hooks/inject.sh; echo "rc $?"; H=$(mktemp -d "$CB/hk.XXXXXX") && cp hooks/inject.sh $H/
      && printf '{"hook_event_name":"SessionStart","source":"startup"}' | bash $H/inject.sh; echo "rc $?"
    ```
  - line 32 — установка дважды и снятие в подменённом доме; expected: `install: ok`, `rerun: ok`, `kept: ok`, `codex: ok`, `uninstall: ok`, `hooks: all ok`

    ```
    bash tests/hooks-test.sh | grep -vE '^missing:'
    ```
  - line 33 — профиль без `settings.json`; expected: `missing: ok`

    ```
    bash tests/hooks-test.sh | grep '^missing:'
    ```
  - line 34 — живая сессия и её подагент видят правила; expected: `session: yes`, `subagent: yes`

    ```
    bash tests/hooks-live.sh
    ```

## S8. Five trap tasks with hidden checks — done

На стенде пять маленьких bash-проектов-ловушек на лишний или неполный код. У каждой есть скрытая проверка, которую до прогонов испытывают на хорошем и плохом эталонах.

- **Files:** create: `tests/chain/traps/{reuse,shared-bug,rename,traversal,native}/` (у каждой `project/`, `task.md`, `requirements.md`, `check.sh`, `good/`, `bad/`; `over/` — у `reuse` и `native`), `tests/chain/seed-trap.sh`, `tests/chain/trap-test.sh`
- **Depends on:** none
- **Steps:**
  1. Пять ловушек:
     - `reuse` — `slug.sh` должен взять готовые `trim` и `lower`;
     - `shared-bug` — `cents_to_str` печатает `0.5`, задача называет только чек, а чинить надо общую функцию для чека и возврата;
     - `rename` — `user_name` → `display_name` в коде, тестах и фикстурах;
     - `traversal` — `show.sh` не должен выдавать `../secret.txt` и `/etc/hosts`; хороший эталон отказывает через `if` со сравнением, его `tests/test_show.sh` проверяет и заметку, и оба отказа;
     - `native` — счёт слов, решаемый `sort | uniq -c`.
  2. `over/` — переусложнённые, но рабочие варианты для калибровки судьи; без ассоциативных массивов, потому что ловушки идут под `/bin/bash` 3.2.
  3. `task.md` и `requirements.md` — словами пользователя, без намёка на ловушку.
  4. `seed-trap.sh` по образцу `seed-pair.sh` (с `git init` и коммитом `seed`), фаза `requirements confirmed`.
  5. `trap-test.sh`: хороший эталон проходит, плохой падает.
- **Checks:**
  - line 35 — скрытые проверки на эталонах; expected: `trap reuse: ok`, `trap shared-bug: ok`, `trap rename: ok`, `trap traversal: ok`, `trap native: ok`, `traps: all ok`

    ```
    bash tests/chain/trap-test.sh
    ```

## S9. Traps run on the stand and are measured — done

Серия прогоняет каждую ловушку через `splan` и `swork` в своём ящике и пишет за прогон: строки кода, скрытую проверку, есть ли тест на риск, токены, время, цену и сжатый размер. Кандидат получает хуки в ящике.

- **Files:** change: `tests/chain/drive.sh`, `tests/chain/collect.sh`, `tests/chain/series.sh`, `tests/chain/stand.sh`; create: `tests/chain/trap-measure.sh`
- **Depends on:** S7, S8
- **Steps:**
  1. `drive.sh` (и проверка числа аргументов `:37`): этапы `trap-plan` (фаза `plan confirmed`) и `trap-work` (фаза `done`) с темой пятым аргументом.
  2. `collect.sh` (и проверка числа аргументов `:23`): тема — четвёртым аргументом; `trap-work` засчитывается как `work`.
  3. `series.sh`:
     - этап `traps` = пять `trap-<name>`;
     - у каждой ловушки свой ящик: `stand.sh`, `seed-trap.sh`, копия `seeded/`, затем план и исполнение;
     - мерить и после неудачного прогона;
     - лейн пройден, когда у обоих этапов `done` в `stage.json`;
     - имена этапов ловушек не пишутся в файл `stages`: `zero.sh` и `judge.sh` остаются на основных этапах.
  4. `series.sh` копирует `hooks/`, если он есть в источнике, а `rules.md` берёт из `<источник>/tests/chain/rules.md` — так база судится правилами `cda6856`.
  5. `stand.sh`: если в источнике есть `hooks/`, хуки идут в `.claude/settings.json` проекта ящика; у базы хуков нет.
  6. `trap-measure.sh` → `trap-<name>.json`:
     - `lines` — добавленные строки вне `tests/`, `docs/`, `.claude/`, `.git/`, `.agents/`, `.swork*`;
     - `hidden` — результат скрытой проверки;
     - `risky_test` — тест в `tests/` новый или изменён;
     - `tokens_out`, `wall_s`;
     - `cost_usd` — `total_cost_usd` последнего хода каждого этапа (поле накопительное);
     - `gz_bytes` — размер в `gzip`.
- **Checks:**
  - line 36 — одна ловушка в серии из одного прогона; expected: `run 1: done`, затем строка с `lines hidden risky_test tokens_out wall_s cost_usd gz_bytes`

    ```
    bash tests/chain/series.sh pl-smoke . --runs 1 --stages trap-reuse;
      jq -r 'keys_unsorted | join(" ")' "$CB/pl-smoke/1/trap-reuse.json"
    ```
  - line 37 — ящик из скилов с `hooks/` получает три события; серия берёт `rules.md` из источника; expected: `SessionStart SubagentStart UserPromptSubmit`, затем число ≥ 1

    ```
    T=$(mktemp -d "$CB/hb.XXXXXX") && bash tests/chain/stand.sh $T . >/dev/null
      && jq -r '.hooks | keys | join(" ")' $T/wiki-trial/clean/.claude/settings.json; grep -c 'src/tests/chain/rules.md' tests/chain/series.sh
    ```

## S10. Over-engineering judge and injected bugs — done

Каждый прогон ловушки получает оценку переусложнения 0–3 с названной лишней конструкцией и долю пойманных внесённых ошибок. Судье доверяют только после проверки на эталонах.

- **Files:** create: `tests/chain/overeng.sh`, `tests/chain/overeng-prompt.md`, `tests/chain/overeng-test.sh`, `tests/chain/mutate.sh`, `tests/chain/mutate-test.sh`; change: `tests/chain/trap-measure.sh` (created in S9)
- **Depends on:** S8, S9
- **Steps:**
  1. Промпт судьи своими словами: задача и добавленный код → `<0–3><TAB><конструкция>`.
  2. `overeng.sh` — `claude -p` без инструментов на `medium`.
  3. `overeng-test.sh`: `over` выше `good` на `reuse` и `native`; на `medium` не прошло — один раз `xhigh`, и если там прошло, `xhigh` становится уровнем по умолчанию.
  4. `mutate.sh` — три мутанта на каждый поставленный файл:
     - перевёрнутое сравнение;
     - `if true`;
     - литерал +1.
     Мутант пойман, если упал хоть один поставленный тест.
  5. `mutate-test.sh`: хороший эталон `traversal` с тестом ловит ≥ 1, плохой — `0/<n> — no tests`.
  6. `trap-measure.sh` дописывает ключи `overeng`, `construct`, `caught`, `mutants`.
- **Checks:**
  - line 38 — калибровка судьи; expected: `overeng reuse: over <a> > good <b>`, `overeng native: over <a> > good <b>`, `overeng calibration: ok`

    ```
    bash tests/chain/overeng-test.sh
    ```
  - line 39 — внесённые ошибки; expected: `mutate good: caught <k>/<n>` с k ≥ 1, `mutate bad: caught 0/<n> — no tests`, `mutate test: all ok`

    ```
    bash tests/chain/mutate-test.sh
    ```
  - line 40 — замер прогона из строки 36 заново; expected: `lines hidden risky_test tokens_out wall_s cost_usd gz_bytes overeng construct caught mutants`

    ```
    bash tests/chain/trap-measure.sh "$CB/pl-smoke/1" reuse && jq -r 'keys_unsorted | join(" ")' "$CB/pl-smoke/1/trap-reuse.json"
    ```

## S11. Judge rules for the new skill rules — done

Судья проверяет каждое новое правило написания кода, планирования и отчёта по следам прогона; каждое правило ссылается на свою строку скила.

- **Files:** change: `tests/chain/rules.md`
- **Depends on:** S1, S2, S3, S4, S5, S6
- **Steps:**
  1. Правила `swork-27`…`swork-37` (R1–R7, R12, R15, R16, R17) и `splan-28` (R9) — формулировки в карточке; каждое ссылается на нынешнюю строку скила.
  2. Все прежние ссылки на файлы, правленные в S1–S6, переносятся на нынешние строки.
- **Checks:**
  - line 41 — новые правила на месте; expected: `11`, затем `1`

    ```
    grep -cE '^- swork-(2[7-9]|3[0-7])\. ' tests/chain/rules.md; grep -c '^- splan-28\. ' tests/chain/rules.md
    ```
  - line 42 — все ссылки живые; expected: одна строка `<N> ok`, строк `bad` нет

    ```
    grep -oE '(sbrain|splan|swork|saway)/[A-Za-z0-9/._-]+:[0-9]+' tests/chain/rules.md
      | while IFS=: read f n; do [ -f "$f" ] && [ "$(wc -l < "$f")" -ge "$n" ] && echo ok || echo "bad $f:$n"; done | sort | uniq -c
    ```

## S12. Comparison of a baseline and a candidate series — done

Одна команда сравнивает две серии по всем мерам качества, медианам и отношениям ловушек, токенам, времени и цене и говорит, принят ли кандидат.

- **Files:** create: `tests/chain/compare.sh`, `tests/chain/compare-test.sh`
- **Depends on:** S9, S10
- **Steps:**
  1. Вывод по порядку:
     - `violations: … (shared rules)`, `new rules: cand <n>`;
     - `stages`…`pair`;
     - `trap runs: base <k>/15, cand <k>/15`;
     - по мерам ловушек — медиана по прогонам задачи и отношение (среднее геометрическое по задачам);
     - `tokens:`, `cost:`, `wall:` — по всем папкам этапов всех прогонов; `speed: x<число>`;
     - последней — `accept: pass|fail — <меры>`.
  2. Нарушения считаются только по правилам, которые есть у обеих серий; новые правила показываются отдельно. Медиана базы 0 → отношение `n/a`; приёмка сравнивает суммы медиан по задачам.
  3. Кандидат принят, если:
     - нарушений не больше;
     - stages, seeds, decisions, flaws, away, nonstop, pair не ниже;
     - скрытые проверки не ниже;
     - строк кода меньше;
     - переусложнение не выше;
     - пойманных ошибок не меньше;
     - время серии и ловушек не выше.
     Если провалено только время — `accept: fail — wall (time only)`.
  4. `--only "<этапы>"` — для абляции. Сравниваются только названные этапы:
     - нарушения и посевы — если назван судимый этап;
     - решения и изъяны — если назван `survey` или `grill`;
     - ловушки — если назван `traps`;
     - токены, цена и время — только по их папкам;
     - остальное печатает `skipped`.
  5. `--map`: `map: keep`, если качество ловушек не хуже, а `tokens_out` с картой ниже; иначе `map: drop`.
  6. `compare-test.sh` на поддельных сериях проверяет 13 случаев, включая `only` и `zero-ratio`.
- **Checks:**
  - line 43 — равные, больше нарушений, меньше скрытых, строк не меньше, медленнее; expected: `case pass: ok`, `case violations: ok`, `case hidden: ok`, `case lines: ok`, `case time: ok`, `case only: ok`

    ```
    bash tests/chain/compare-test.sh | grep -E '^case (pass|violations|hidden|lines|time|only):'
    ```
  - line 44 — медианы, переусложнение, пойманные; expected: `case medians: ok`, `case overeng: ok`, `case caught: ok`, `case zero-ratio: ok`

    ```
    bash tests/chain/compare-test.sh | grep -E '^case (medians|overeng|caught|zero-ratio):'
    ```
  - line 45 — токены, цена, ускорение, решение о карте; expected: `case report: ok`, `case map: ok`, затем `compare test: all ok`

    ```
    bash tests/chain/compare-test.sh | grep -E '^case (report|map):'; bash tests/chain/compare-test.sh | tail -1
    ```
  - line 46 — нарушения кандидата только по новым правилам → всё равно pass; expected: `case new-rules: ok`

    ```
    bash tests/chain/compare-test.sh | grep '^case new-rules:'
    ```

## S13. Series, acceptance and install — not started

База на `cda6856` и кандидат проходят одни и те же этапы и ловушки. Правки принимаются по сравнению, карта остаётся или уходит по своей серии ловушек, чистота комнаты проверена, хуки попадают в профили Mac.

- **Files:** change: файлы S1–S7 — только если карту убирают (шаг 5) или абляция откатывает группу (шаг 6)
- **Depends on:** S1–S12
- **Steps:**
  1. `git worktree add --detach "$CB/base-src" cda6856`.
  2. Серии `pl-base` (из `$CB/base-src`) и `pl-cand` (из `.`):
     - этапы `brain plan work seed survey grill away nonstop pair traps`;
     - три прогона на `medium`;
     - затем `zero.sh` для обеих — это судейство.
  3. `compare.sh pl-base pl-cand`; вывод — в журнал хода.
  4. Серия `pl-nomap` — только ловушки, из копии без `codemap.sh`; затем `compare.sh --map pl-nomap pl-cand`.
  5. `map: drop` → карта удаляется из проекта (в правиле 8 «the code map and a search» → «and a search»), строки 1–9 и 23 — `not checked: map dropped by line 50`.
  6. `accept: fail` не по времени → абляция по группам G1–G7 (исполнитель, проверяющие, ревью, splan, закрывающие строки, хуки, карта):
     - начать с группы, ближайшей к проваленной мере;
     - одна серия на группу;
     - `zero.sh pl-abl-<group>`, если среди этапов есть судимый, затем `compare.sh --only "<эти этапы>" pl-base pl-abl-<group>`;
     - первая группа, без которой серия проходит, откатывается в проекте к `cda6856`.
  7. После шага 5 или отката: повторить шаг 2 S11, прогнать строку 42, убрать из `chain-rules.md` и `rules.md` ссылки на выброшенное.
  8. `accept: fail — wall (time only)` → без абляции, записать и идти дальше.
  9. Чистая комната:
     - свежий подагент на `medium` читает https://github.com/dietrichgebert/ponytail и `git diff cda6856`;
     - ищет совпадения от 8 слов;
     - нашёл — переформулировать и проверить ещё раз.
  10. После приёмки пользователем — сохранение, затем установка.
- **Checks:**
  - line 47 — база шла на скилах и правилах `cda6856`; expected: `same`

    ```
    diff -r "$CB/base-src/swork" "$CB/pl-base/skills/swork" && cmp "$CB/base-src/tests/chain/rules.md" "$CB/pl-base/rules.md" && echo same
    ```
  - line 48 — цель: кандидат против базы на всех этапах и ловушках; expected: `accept: pass`

    ```
    bash tests/chain/compare.sh pl-base pl-cand | tail -1
    ```
  - line 49 — по 3 прогона ловушек, токены, цена, ускорение; expected: `trap runs: base 15/15, cand 15/15`, строки `tokens:`, `cost:`, `speed: x<число>`

    ```
    bash tests/chain/compare.sh pl-base pl-cand | grep -E '^(trap runs|tokens|cost|speed):'
    ```
  - line 50 — карта остаётся, только если токены ниже при равном качестве; expected: `map: keep`, или `map: drop` и карта убрана

    ```
    bash tests/chain/compare.sh --map pl-nomap pl-cand | tail -1
    ```
  - line 51 — checked manually: строка 48 сразу `accept: pass` — делать нечего; иначе в журнале хода все серии `pl-abl-<group>` с последней строкой сравнения, файлы выброшенной группы — как в `cda6856`; expected: «not needed» или одна выброшенная группа и `accept: pass`
  - line 52 — checked manually: проверка чистой комнаты из шага 9; expected: `no copied wording`
  - line 53 — checked manually после приёмки; expected: `3`, `3`, `0`

    ```
    ./install.sh --mac
    for p in personal work; do jq '[.hooks[]?[]?.hooks[]? | select(.command | contains("/chain-hooks/"))] | length'
      "$HOME/claude/$p/settings.json"; done; grep -c chain-hooks "$HOME/.codex/config.toml"
    ```
- **Rollback:**
  - перед `./install.sh --mac` копии `settings.json` обоих профилей кладутся в `$CB/pl-rollback/`;
  - возврат: копии на место, `rm -rf` обеих `chain-hooks`, `bash "$CB/base-src/install.sh" --mac`.

## Technical decisions

- **Где живёт карта.** `codemap.sh` — в `swork/scripts/`, в `splan` его копируют `install.sh` и `stand.sh`. Так же сейчас расходятся `check.sh` и `agents.sh`.
- **Предел карты.** 10 с через фоновое задание и `kill`, потому что `timeout` на этом Mac нет.
- **`LADDER:` для сверки.** Главная сессия хранит его в `.swork/ladder.txt`; это единственная часть отчётов исполнителей, которую получает сверка.
- **Вызывающий вне «Files».** Идёт через статус «need a file»: правило 2 исполнителя не трогаем.
- **Ссылки на правила.** Упрощение и ревью читают правила из `executor.md`, а не держат копию (R8).
- **Хуки.** Папка `hooks/` в репо ставится в `<profile>/chain-hooks/` двух профилей Claude Code. Три записи сливаются в `settings.json` через `jq`, свои узнаются по `/chain-hooks/`. Codex хуков не получает — ваш выбор.
- **Хуки на стенде.** Кандидат получает хуки через `.claude/settings.json` ящика: стенд не читает профиль, а база должна идти без хуков.
- **Правила судьи для базы.** База судится `rules.md` из `cda6856`.
- **Счёт нарушений.** «Нарушений не больше» считается по общим правилам; нарушения новых — отдельной строкой.
- **Меры ловушек.** Строки — из `git diff --no-index --numstat`; сжатый размер — `gzip -c`; тест на риск — новый или изменённый файл в `tests/`; цена — `total_cost_usd` последнего хода каждого этапа, сумма по этапам.
- **Судья переусложнения.** Работает на `medium`; `xhigh` — только если на `medium` не прошёл калибровку.
- **Внесённые ошибки.** Делаются через `sed`, три мутанта на файл.
- **R31 — перед меню.** Строки о пробелах стоят перед меню или дословной последней строкой, а не после: последние сообщения `sbrain`, `splan`, `swork` кончаются меню, `saway` — дословной строкой.
- **Ловушки не судит основной судья.** Их меряют скрипты и судья переусложнения; новые правила судятся на темах `count` и `longest`.
- **Токены, время и цена серии** — по всем папкам этапов, а не из `metrics.json` (там четыре этапа и нет цены).
- **Абляция.** `compare.sh --only` сравнивает только этапы, из которых пришла проваленная мера.
- **Нулевая медиана базы.** Отношение `n/a`; приёмка — по суммам медиан.
- **Правила хука.** Действуют только при работе скила цепочки; путь к правилам исполнителя `inject.sh` подставляет абсолютный.
- **Время.** Сумма `wall_s` по этапам. Если провалено только время — «не принято по времени», ничего не откатывается само.

## Not doing

- Русских копий скилов и строк в `tests/translate/map.tsv` не делаем.
- Хуков для Codex и для PC не ставим; копирование скилов на PC остаётся как есть.
- Этапы, разделы и уровень основного судьи не меняем, кроме новых правил S11.
- Тексты ради токенов не сокращаем.
- Остальное вне темы — в `scope.md`.

## Not agreed

- **Допущение о стенде.** Стенд запускается с `--setting-sources project,local`, поэтому хуки профиля в его прогоны не попадают.
- **Допущение о цене.** `total_cost_usd` хода включает его подагентов и накапливается по возобновлённой сессии, как `duration_api_ms`: цена этапа — значение последнего хода.
- **Допущение о событиях хуков.** События Claude Code 2.1.302 такие, как описано в S7: `SubagentStart` берёт JSON `additionalContext`, блокирует только код 2.
- **Ограничение R39.** `UserPromptSubmit` срабатывает только на сообщения пользователя: ходы `/goal` и фоновые уведомления строку о языке не получат.
- **Отклонено из обзора:** шумность `risky_test` (переименование в ловушке `rename` всегда трогает `tests/`) — оставлено: мера одна на все серии, сравнение относительное.
