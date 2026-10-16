# Plan overview of topic quality-zero

> The plan as one file for reading; the source is the slice cards: where they differ, the card is right.

- **Goal:** the four skills pass one whole stand series with zero judge violations

Все команды — из корня проекта; `CB` — это `"$HOME/Documents/my/chain-stand"`. `<all stages>` — `brain plan work seed survey grill away nonstop pair`.

## S1. Stand guards — done

Стенд держит временные файлы у себя, `restore` не стирает новые тесты, испорченный вердикт — «no measurement».

- **Files:** change: `tests/chain/trigger.sh`, `tests/chain/answer.sh`, `tests/chain/drive.sh`, `tests/agents-test.sh`, `tests/translate/state.sh`, `tests/chain/verdict.sh`, `tests/chain/survey-gate.sh`; create: `tests/chain/tally.sh`, `tests/chain/verdict-test.sh`
- **Depends on:** none
- **Steps:**
  1. `trigger.sh`, `answer.sh`, `agents-test.sh` — временные папки под `CHAIN_BASE` (`trigger.XXXXXX`, `answer.XXXXXX`, `agents-test.XXXXXX`).
  2. `drive.sh` — файлы вопроса и персоны в `"$dir/tmp/question"` и `"$dir/tmp/persona"`.
  3. `state.sh restore` — для `tests` цикл удаления пропускается.
  4. `tally.sh` — подсчёт `verdict.sh` переезжает сюда как `tally_label`: одна строка на метку — нарушения всего и по каждому скилу и `sv`, решения, изъяны, найденные ошибки, ответы yes/no по правилам `saway`; вердикт испорчен, если строка не из четырёх полей или строк `rule` меньше, чем правил в файле метки: `rules.md` у основной, `rules-survey.md` у опросной.
  5. `verdict.sh` и `survey-gate.sh` подключают `tally.sh` и убирают свои копии: `no measurement: verdict <label>` и `survey gate: failed — no measurement`.
  6. `verdict-test.sh` — четыре случая на временном `CHAIN_BASE`, итог `verdict test: all ok`.
- **Checks:**
  - line 1 — `agents-test.sh` с пустым `TMPDIR` ничего в нём не оставляет; expected: `agents: all ok`, затем `0`

    ```
    T=$(mktemp -d "$CB/tw.XXXXXX")
      && TMPDIR=$T bash tests/agents-test.sh | tail -1
      && ls -A $T | wc -l | tr -d ' '
    ```
  - line 2 — голого `mktemp` не осталось; expected: только `rc 1`

    ```
    grep -nE 'mktemp( -d)?\)' tests/chain/trigger.sh tests/chain/answer.sh tests/chain/drive.sh tests/agents-test.sh; echo "rc $?"
    ```
  - line 3 — копия репозитория: `save`, новый файл, `restore` → файл на месте; expected: `restored`, затем `r/tests/zz-new.txt`

    ```
    C=$(mktemp -d "$CB/rs.XXXXXX") && rsync -a --exclude .git ./ $C/r/
      && CHAIN_BASE=$C STATE_ROOT=$C/r bash $C/r/tests/translate/state.sh save >/dev/null
      && touch $C/r/tests/zz-new.txt
      && CHAIN_BASE=$C STATE_ROOT=$C/r bash $C/r/tests/translate/state.sh restore
      && ls $C/r/tests/zz-new.txt | sed "s#$C/##"
    ```
  - line 4 — испорченные вердикты и один хороший; expected: `verdict malformed: no measurement`, `verdict short: no measurement`, `survey malformed: no measurement`, `verdict good: counted`, `verdict test: all ok`

    ```
    bash tests/chain/verdict-test.sh
    ```

## S2. The series judges every stage — done

Одна серия гонит лейны, этап `saway`, `nonstop` и `pair`, судит и `saway` и сводит всё в одну строку `zero:`.

- **Files:** change: `tests/chain/rules.md`, `tests/chain/judge.sh`, `tests/chain/judge-prompt.md`, `tests/chain/series.sh`; create: `tests/chain/zero.sh`
- **Depends on:** S1, S4, S5, S6
- **Steps:**
  1. `rules.md` — раздел `## saway`, не меньше 8 правил `saway-<N>` со ссылкой на строку `saway/SKILL.md`; после S4 и S5 все ссылки `rules.md` переносятся на нынешние строки, `rules.md:66` — на строку записей этапов в `finish.md`.
  2. `judge.sh` — у прогона две метки: `<run>` (brain, plan, work, seed, away) и `<run>-survey` (survey, grill), каждая — только если такие этапы есть; `away` в цикле этапов, `project-away/`.
  3. `judge-prompt.md` — четыре раздела правил, строка `away` → `saway`, `project-away/`.
  4. `series.sh` — этапы `away`, `nonstop`, `pair`, лейны `awaybox`, `nonstopbox`, `pairbox` (случай `a` в прогоне 1, `b` в остальных, темы как в `pair-run.sh:22-23`; pair пройден, когда готовы `pair1` и `pair2`); проверки пишутся в `away-check.txt`, `nonstop-check.txt`, `pair-check.txt`; `run()` проходит все лейны, даже если один не пройден; этапы по умолчанию не меняются.
  5. `zero.sh <series>` — сначала `judge.sh`, потом проверка ключей и вердиктов; печатает десять строк: `stages: <d>/<10 × runs>`, `seeds:` (по основным меткам), `violations:` по скилам и `sv`, `decisions:` и `flaws:` (по опросным меткам), `away:`, `nonstop:`, `pair:`, `judged: saway <n> rules` (только ответы yes и no), `zero: pass | zero: fail — <причины>`.
  6. Пробная серия из одного прогона — проверяет устройство, а не пороги.
- **Checks:**
  - line 5 — в разделе `saway` не меньше 8 правил, все ссылки `rules.md` указывают на существующие строки; expected: число от 8, затем одна строка `<N> ok` и ни одной `bad`

    ```
    grep -c '^- saway-[0-9]' tests/chain/rules.md;
    grep -oE '(sbrain|splan|swork|saway)/[A-Za-z0-9/._-]+:[0-9]+' tests/chain/rules.md
      | while IFS=: read f n; do [ -f "$f" ] && [ "$(wc -l < "$f")" -ge "$n" ] && echo ok || echo "bad $f:$n"; done
      | sort | uniq -c
    ```
  - line 6 — пробная серия со всеми этапами; expected: все десять строк, `stages: <d>/10`, `saway <n>` и `sv <n>` в `violations:`, `decisions: <n>/5`, `flaws: <n>/5`, `judged: saway <n> rules` с n от 1, последняя начинается с `zero:`

    ```
    bash tests/chain/series.sh qz-smoke . --runs 1 --stages "brain plan work seed survey grill away nonstop pair";
    bash tests/chain/zero.sh qz-smoke
    ```
  - line 7 — несуществующая серия; expected: `zero: fail — no measurement`, затем `rc 1`

    ```
    bash tests/chain/zero.sh qz-none; echo "rc $?"
    ```

## S3. saway, not lfg, on "I am leaving" — done

Проба срабатывания идёт с плагинами профиля и показывает, какой скил берёт «я ухожу, доделай без меня».

- **Files:** change: `tests/chain/trigger.sh`; create: `tests/chain/requests-away.tsv`
- **Depends on:** S1
- **Steps:**
  1. В каждом пробном проекте — `.claude/settings.json` только с `enabledPlugins` из `settings.json` профиля; `--setting-sources project,local` остаётся; усилие пробы — `medium`.
  2. `requests-away.tsv` — русская строка из `requests.tsv:19`, английская `I am leaving, finish the work without me`, контрольная `lfg: add one line to README and open a pull request`.
  3. Контрольная дала `none` — плагин не загрузился, строка красная, причина в отчёт.
- **Checks:**
  - line 8 — expected: `saway`, `saway`, `compound-engineering:lfg`

    ```
    bash tests/chain/trigger.sh . tests/chain/requests-away.tsv "$CB/trigger-away.tsv"
      && cut -f2 "$CB/trigger-away.tsv"
    ```

## S4. swork: stage-7 record, no deletion, full rollback — done

`swork` пишет этап 7 явной записью, читающие субагенты `swork` и ревьюер `splan` ничего не удаляют вне проекта, «откатить всё» возвращает и «Next step».

- **Files:** change: `swork/references/finish.md`, `swork/references/slices.md`, `tests/chain/pair-check.sh`, `swork/references/review.md`, `swork/references/conformance.md`, `swork/references/simplify.md`, `splan/references/review.md`, `swork/references/report.md`
- **Depends on:** none
- **Steps:**
  1. `finish.md:14` — запись «stage 7 finished», с меткой — «stage 7 finished [<name>]», не свободным текстом.
  2. `slices.md:32` — у записей этапов метка в конце.
  3. `pair-check.sh:51` — принимает и `stage 7 finished [<id>]`; сопоставление в одном месте и опция `--record "<line>"`: `record: <id>`, `record: plain` или `record: none`.
  4. Четыре задачи — «Delete no file and no folder outside the project folder, temporary folders included.»
  5. `report.md`, «roll back everything» — ещё и «Next step» «execute the plan through `swork`» в `state.md` и в строке «In progress».
- **Checks:**
  - line 9 — `finish.md` называет запись и её вид с меткой; что `pair-check.sh` принимает метку, видно по строке `pair:` в строке 6; expected: `1`

    ```
    grep -cF 'stage 7 finished [<name>]' swork/references/finish.md
    ```
  - line 10 — expected: четыре строки, каждая кончается `:1`

    ```
    grep -c 'outside the project folder' swork/references/review.md swork/references/conformance.md swork/references/simplify.md splan/references/review.md
    ```
  - line 11 — expected: строка внутри ветки «roll back everything», с `state.md` и строкой «In progress»

    ```
    grep -n 'execute the plan through' swork/references/report.md
    ```
  - line 20 — три вида записи этапа 7; expected: `record: s1`, `record: s2`, `record: plain`

    ```
    for l in '- 2026-10-16 · stage 7 finished [s1]' '- 2026-10-16 [s2]: stage 7 [s2]: finished' '- 2026-10-16 · stage 7 finished';
      do bash tests/chain/pair-check.sh --record "$l"; done
    ```

## S5. saway: the first progress line and the review findings — done

`saway` показывает строку хода с первого сообщения, а его текст больше не оставляет открытыми случаи из ревью.

- **Files:** change: `saway/SKILL.md`, `tests/chain/away-blind.sh`, `tests/chain/away-scenarios.md`, `tests/chain/away-expected.tsv`
- **Depends on:** none
- **Steps:**
  1. `SKILL.md:37` — `state.md` читается до первого сообщения; правило строки целиком только в `:21`.
  2. `away-blind.sh` — в подсказке: `⇥` означает настоящую табуляцию; в шапке `<k> of 17 ok`.
  3. Возврат пользователя посреди работы — в условия строки `saway: work stopped — waiting for the user` на `:113`; `:18` ссылается на неё.
  4. `SKILL.md:82` — решения «user chose» в карточке не правятся, идут в обход по `:31`.
  5. Два новых сценария: `B16` под шаг 3, `B17` под шаг 4.
- **Checks:**
  - line 12 — expected: одна строка с `state.md`

    ```
    grep -n 'before the first message' saway/SKILL.md
    ```
  - line 13 — слепое чтение 17 сценариев; expected: `17 of 17 ok`

    ```
    bash tests/chain/away-blind.sh . "$CB/qz-blind" | tail -1
    ```

## S6. splan: the goal without a journal — done

Там, где вики не ведётся, `splan` всё равно находит цель для сквозной проверки.

- **Files:** change: `splan/references/slicing.md`
- **Depends on:** none
- **Steps:**
  1. `slicing.md:13` — без вики цель берётся из «In brief» карточки `task.md`, а без темы — из просьбы пользователя.
- **Checks:**
  - line 14 — expected: строка о вики, которая не ведётся, с `task.md` и просьбой пользователя

    ```
    grep -n 'task.md' splan/references/slicing.md
    ```

## S7. agents.sh: dead claims and a wiki above the git root — done

Мёртвый захват снимается, даже если другой файл занят; файлы вики выше корня git можно захватить, хранилище одно.

- **Files:** change: `sbrain/scripts/agents.sh`, `sbrain/references/agents-rules.md`, `tests/agents-test.sh`
- **Depends on:** none
- **Steps:**
  1. `claim` — в мёртвой ветке `drop_claims` до `exit 3`; шапка `:18` и `agents-rules.md:15` это говорят.
  2. `find_up` получает необязательную начальную папку; корень выбирается как раньше; проверка пути принимает путь под папкой с `docs/00-index.md`, найденной вверх от корня git, и хранит его с `../`; копия в `held/<id>/` — с `_up/` вместо `../`.
  3. Два новых случая в `agents-test.sh`: «a busy and a dead owner's file together», «a wiki above the git root».
- **Checks:**
  - line 15 — expected: `agents: all ok`, затем число от 2

    ```
    bash tests/agents-test.sh | tail -1; grep -cE 'busy and a dead|wiki above the git root' tests/agents-test.sh
    ```

## S8. Rounds to zero and acceptance — awaiting manual check

Целые серии после последней правки до `zero: pass`, не больше трёх кругов; каждое «нет» читается вручную; раскладка — после приёмки.

- **Files:** change: `tests/chain/rules.md` (только для неверного вердикта, с доказательством); тексты скилов, на которые указало верное «нет»
- **Depends on:** S1, S2, S3, S4, S5, S6, S7
- **Steps:**
  1. Круг 1 — строка 16 с `qz-r1`.
  2. Каждое «нет» — строка 17: неверное → правка правила и цитата в журнал; верное → правка текста скила.
  3. Сбой стенда — починка, удаление строк ключа и папок меток этого прогона в `blind/`, перезапуск на той же серии; это не круг.
  4. Невыполненный этап, ненайденная ошибка, решений или изъянов меньше 15, проваленная проверка away/nonstop/pair — разбор как у «нет».
  5. После правки — новая серия `qz-r2`, `qz-r3`; после третьего круга без `zero: pass` — отчёт с каждым оставшимся нарушением и причиной.
  6. Строка 19 ждёт приёмки пользователя.
- **Checks:**
  - line 16 — expected: `zero: pass`

    ```
    bash tests/chain/series.sh qz-r<N> . --stages "brain plan work seed survey grill away nonstop pair";
    bash tests/chain/zero.sh qz-r<N>
    ```
  - line 17 — checked manually: каждое «нет» по следу; expected: строка журнала на каждое «нет» — метка, правило, верно или нет, цитата или правленая строка
  - line 18 — checked manually: круги и сбои стенда; expected: не больше трёх кругов, сбой не считается кругом, без `zero: pass` после третьего — отчёт с причинами
  - line 19 — checked manually после приёмки: `./install.sh --mac`, затем grep по трём профилям; expected: `3`

## Technical decisions

- Запись этапа 7 — `stage 7 finished [<name>]`: текст «stage 7 finished» цел, три скрипта не меняются.
- `saway` читает `state.md` до первого сообщения: числа строки хода известны, а `away-check.sh` и так требует вид `N/N · `.
- «Откатить всё» пишет «Next step» как «execute the plan through `swork`» — значение `splan` для `plan confirmed`.
- `.agents/` остаётся в корне git; файлы вики выше корня хранятся с `../`, копии в `held/` — с `_up/`; корень `swork` не меняется.
- Плагины в `trigger.sh` — через `.claude/settings.json` пробного проекта; хуки профиля в пробы не попадают.
- У прогона две метки судьи: иначе с survey/grill судья не видит brain, plan, work, seed и away; прогоны считаются по папкам, а не по ключам.
- Прогон проходит все лейны, даже если один не пройден: круг должен измерить всё.
- Один подсчёт в `tally.sh` для `verdict.sh`, `survey-gate.sh` и `zero.sh`: `verdict.sh` нельзя подключить, у него свой верхний уровень.
- `trigger.sh` на `medium`: какой скил запустить, решает сессия самой цепочки.
- Pair: случай a в прогоне 1, b в прогонах 2–3.
- Новые лейны в `series.sh` и сводка `zero.sh` вместо обёртки над `nonstop-run.sh` и `pair-run.sh`.
- Новая серия на каждый круг: правила копируются в серию один раз.

## Not doing

- Всё из [scope.md](scope.md).
- Ошибка порядка аргументов `agents.sh done --topic`.
- `verdict.sh quality` против серий прошлых тем здесь не используется.
- Правки текста скилов, которых срез не называет; `requests.tsv`, `gate.sh` и этапы `series.sh` по умолчанию не меняются.
- Коммит — только по просьбе.

## Not agreed

- Не согласовано: из четырёх находок R13 исправляются три — находка `saway/SKILL.md:73` (1c4f384) про строки обхода при входе устарела: этого правила в `saway` больше нет, а `:85` уже называет последнюю часть `away.md`. Нужно ваше подтверждение — S5.
- Допущение: прогоны `nonstop` и `pair` судятся только своими проверками, не судьёй — S2, S8.
- Допущение: три прогона одновременно со своими стендами и `.agents/` не мешают pair-лейнам друг друга — S2, S8.
- Допущение: сессия `claude -p` читает кэш плагинов профиля при `enabledPlugins` в `.claude/settings.json` проекта — S3.
- Допущение: серия со всеми этапами — несколько часов, в прогоне семь лейнов подряд; до четырёх серий (пробная и три круга) приемлемы — S2, S8.
