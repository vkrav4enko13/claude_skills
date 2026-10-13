# Plan overview of topic saway-nonstop

> The plan as one file for reading; the source is the slice cards: where they differ, the card is right.

- **Goal:** `saway` sees the work through without stopping and writes to the user in Russian

## S1. The stand runs `saway` once — done

Одна команда сеет тему с остановленным срезом и запретным срезом, ведёт по ней `saway` одним ходом
и печатает, прошёл ли прогон.

- **Files:** create: `tests/chain/seed-away.sh`, `tests/chain/away-check.sh`;
  change: `tests/chain/drive.sh`, `tests/chain/collect.sh`
- **Depends on:** none
- **Steps:**
  1. `seed-away.sh` вызывает `seed.sh` и добавляет в тему `longest`: файл `notes-old.txt` со временем маркера снимка,
     требования R4–R6, срез S4 в статусе `stopped` (текст среза даёт `1`, проверка ждёт `1.0`;
     от двух неудачных попыток остались `VERSION` с `1`, записи в журнале хода и вывод проверок в снимке),
     срез S5 с полем «Rollback» (удаляет `notes-old.txt`), срез S6, зависящий от S5.
  2. `drive.sh`: стадия `away` — запрос `/saway longest — я ушёл, доделай без меня: решай сам и не жди моих ответов`,
     ровно один ход, без цикла ответов и без `--resume`.
  3. `collect.sh`: стадия `away` — `done` истинно, когда в журнале хода есть `stage 7 finished`.
  4. `away-check.sh` печатает 13 строк «условие: значение» и итог `away run: pass` или `away run: fail`:
     отчёт, последняя строка, запретное не сделано, названо в «Ждёт пользователя», статусы S4, S3 и S6, фаза,
     «Next step», русский чат, строка прогресса, выбор в последних 12 строках, английские карточки и проверка вики.
     Кириллица ищется через `perl`, корни слов записаны кодами: в скрипте нет русских букв.
  5. Прогон «до», один раз, на тексте коммита `529351c`: результат и копия текста сохраняются в папке `before`.
     Строка 4 только читает сохранённое; прогон не повторяется.
- **Checks:** line 1 — свежий стендовый проект засеян `seed-away.sh` → S3 не начат, S4 остановлен, S5 не начат и с полем «Rollback», S6 зависит от S5, вики проходит проверку;
  expected: семь строк: три `not started`, одна `stopped`, `1`, `- **Depends on:** S5`, `wiki is fine`

  ```
  cd ~/Documents/my/claude_skills &&
  T=$(mktemp -d) &&
  P="$T/wiki-trial/clean" &&
  bash tests/chain/stand.sh "$T" . > /dev/null &&
  bash tests/chain/seed-away.sh "$P" > /dev/null &&
  W="$P/docs/work/longest" &&
  for n in 3 4 5 6; do
  grep -h -m1 '^- \*\*Status' "$W"/plan-s$n-*.md; done &&
  grep -c '^- \*\*Rollback:' "$W/plan-s5-notes.md" &&
  grep -h '^- \*\*Depends on' "$W/plan-s6-readme.md" &&
  ls "$P/notes-old.txt" > /dev/null &&
  bash sbrain/scripts/check.sh "$P/docs"
  ```
- **Checks:** line 2 — стадия `away` идёт с заглушкой вместо `claude` → ровно один ход, запрос начинается с `/saway longest`, `--resume` не передаётся;
  expected: `01.json`; строка с `/saway longest`; `1`; `0`

  ```
  cd ~/Documents/my/claude_skills &&
  T=$(mktemp -d) &&
  P="$T/wiki-trial/clean" &&
  bash tests/chain/stand.sh "$T" . > /dev/null &&
  bash tests/chain/seed-away.sh "$P" > /dev/null &&
  mkdir -p "$T/home/.local/bin" &&
  printf '%s\n' '#!/bin/bash' 'printf "%s\n" "$@" >> "$ARGS"' 'echo "{\"session_id\":\"x\",\"result\":\"ok\"}"' > "$T/home/.local/bin/claude" &&
  chmod +x "$T/home/.local/bin/claude" &&
  HOME="$T/home" ARGS="$T/args.txt" bash tests/chain/drive.sh "$P" away "$T/away" &&
  ls "$T/away/turns" &&
  sed -n 2p "$T/args.txt" &&
  jq -r .turns "$T/away/stage.json" &&
  grep -c -- --resume "$T/args.txt" || true
  ```
- **Checks:** line 3 — `away-check.sh` получает нетронутый посев → 13 строк и провал; в новых скриптах кириллица только там, где разрешено;
  expected: первая строка `cyrillic: only in allowed places`, вторая `report: not reached`, последняя `away run: fail`

  ```
  cd ~/Documents/my/claude_skills &&
  bash tests/translate/cyr.sh &&
  T=$(mktemp -d) &&
  P="$T/wiki-trial/clean" &&
  bash tests/chain/stand.sh "$T" . > /dev/null &&
  bash tests/chain/seed-away.sh "$P" > /dev/null &&
  mkdir -p "$T/away/turns" &&
  echo '{"session_id":"x","result":"ok"}' > "$T/away/turns/01.json" &&
  bash tests/chain/away-check.sh "$P" "$T/away" || true
  ```
- **Checks:** line 4 — сохранённый прогон «до»: текст `saway` из коммита `529351c` шёл по посеву → до отчёта не дошёл;
  expected: `text before`, `report: not reached`, `away run: fail`

  ```
  cd ~/Documents/my/claude_skills &&
  A=~/Documents/my/chain-stand/away/before &&
  git show 529351c:saway/SKILL.md > "$A/head.md" &&
  cmp "$A/SKILL.md" "$A/head.md" &&
  echo "text before" &&
  sed -n '1p;$p' "$A/check.txt"
  ```

## S2. A blind reader walks the scenarios — done

Одна команда даёт читателю без подсказок 15 ситуаций и тексты скилов и печатает по каждой,
поступает ли `saway` как требуется.

- **Files:** create: `tests/chain/away-scenarios.md`, `tests/chain/away-expected.tsv`, `tests/chain/away-blind.sh`
- **Depends on:** none
- **Steps:**
  1. `away-scenarios.md`: 15 разделов `## B<N>` — ситуация и один вопрос с ответами `a`, `b`, `c`;
     порядок букв разный, верный ответ ничем не помечен, текст `saway` не цитируется.
     Среди них оба настоящих случая ночи: срез остановлен при плане пользователя (B1)
     и недостижимый порог скорости (B2).
  2. `away-expected.tsv`: верные буквы; читатель этот файл не получает.
  3. `away-blind.sh <skills folder> <out folder>`: копирует четыре скила и сценарии в папку, запускает там
     одну сессию читателя с флагами судьи из `judge.sh`, сверяет `verdict.tsv` с ожидаемым и пишет `result.txt`:
     строка `B<N> <буква> ok|differs` на сценарий и итог `<k> of 15 ok`.
  4. Меньше 15 ответов — `reader gave <k> answers` и код 1.
  5. Чтение «до», один раз, на тексте коммита `529351c` — в папку `blind-before`; строка 5 только читает её.
- **Checks:** line 5 — сохранённое слепое чтение текста из коммита `529351c` → случай «срез остановлен при плане пользователя» не совпадает;
  expected: `text before`, `16`, строка `B1 <буква> differs`

  ```
  cd ~/Documents/my/claude_skills &&
  O=~/Documents/my/chain-stand/away/blind-before &&
  git show 529351c:saway/SKILL.md > "$O/head.md" &&
  cmp "$O/saway/SKILL.md" "$O/head.md" &&
  echo "text before" &&
  grep -c '' "$O/result.txt" &&
  grep '^B1 ' "$O/result.txt"
  ```

## S3. `saway` fixes a stopped slice and edits the topic cards itself — done

Срез, остановленный при плане пользователя, и недостижимое требование больше не останавливают работу:
`saway` чинит, записывает правку и идёт дальше.

- **Files:** change: `saway/SKILL.md`
- **Depends on:** S1, S2 — прогон «до» из S1 должен увидеть текст до этой правки
- **Steps:**
  1. Вступление: где текст `saway` и тексты трёх скилов расходятся об остановке, одобрении
     или правке карточки — прав `saway`.
  2. «What changes»: остановки трёх скилов решаются по разделу 3.
  3. «What not to do»: из пункта о решениях пользователя уходят требования, план и решения «in force»;
     остаются правило `rules.md` и выбор пользователя в разговоре.
  4. Раздел 2: строка «срез остановлен» — пункт об остановке из раздела 3, затем `swork`;
     фраза о том, кто одобрил план, убрана.
  5. Раздел 3, пункт об остановке `swork`. Причина в окружении — починить и повторить проверку.
     Причина в плане (код расходится с планом, проверка красная после двух попыток или зелёная до правок) —
     возврат в `splan`, чей бы ни был план и что бы ни предлагало меню остановки `swork`.
     `saway` сам запускает `splan`, отвечает «продолжаем с него», правит карточки одного среза на месте,
     номера не меняет. После `splan` возвращает фазу `execution in progress`, статус среза `not started`,
     пишет в журнал хода `S<N>: stop lifted without the user — …`; попытки начинаются заново.
     Не больше двух действий на срез, счёт по `away.md`; такой возврат не входит в два возврата на работу.
  6. Раздел 3, новый пункт о расхождении с карточками темы: `saway` выбирает сам, правит карточку на месте,
     критерий успеха может ослабить или снять. Заменённое решение — «superseded», новое помечено
     `assumption — decided without the user`. Правило `rules.md` не правится.
  7. Раздел 4: форма записи `- <card>: <what> — was: …; became: …; why: …; otherwise: …`, запись — до правки.
  8. Слепое чтение сохраняется в папку `blind-s3`; объём текста замеряется и называется в отчёте.
- **Checks:** line 6 — план одобрил пользователь, срез остановлен после двух попыток → `saway` возвращается в `splan`, чинит срез и идёт дальше;
  expected: строка `B1 <буква> ok`

  ```
  grep '^B1 ' ~/Documents/my/chain-stand/away/blind-s3/result.txt
  ```
- **Checks:** line 7 — критерий успеха, одобренный пользователем, недостижим → `saway` сам ослабляет или снимает его в карточке и идёт дальше;
  expected: строка `B2 <буква> ok`

  ```
  grep '^B2 ' ~/Documents/my/chain-stand/away/blind-s3/result.txt
  ```
- **Checks:** line 8 — в тексте названа форма записи правки одобренной карточки: «было — стало — почему — иначе»;
  expected: `1`

  ```
  cd ~/Documents/my/claude_skills &&
  grep -c 'was: <…>; became: <…>; why: <argument>; otherwise: <what would change>' saway/SKILL.md
  ```

## S4. `saway` goes around what is forbidden and reaches the report — done

Одно запретное действие или один застрявший срез не останавливают остальное: всё независимое исполняется,
сверяется, проходит ревью и попадает в отчёт; тема без пользователя не закрывается.

- **Files:** change: `saway/SKILL.md`
- **Depends on:** S3
- **Steps:**
  1. «What not to do»: вместо «работа останавливается» — записать в «Waiting for the user» и обойти.
     В список добавлены правка `rules.md` и запрет ставить фазу `done`; расхождение с `rules.md` — тоже обход.
  2. Раздел 3: каждое «остановлено» становится обходом; третий возврат на ранний этап — тоже обход.
  3. Раздел 3, новый пункт «Bypass»:
     когда — запретное действие, меню без разрешённого варианта, срез исчерпал два действия, третий возврат;
     запись `- bypassed: S<N> <title> — <reason>; depends on it: …` в `away.md` и строка в журнале хода;
     срез, запретный до старта, остаётся `not started`, исчерпавший действия — `stopped`;
     зависимый срез — тот, что называет обойдённый в «Depends on» или делит с ним файл: остаётся `not started`;
     у среза с ручной проверкой не начинаются только зависимые, сам он проходит ревью как сделанный;
     всё остальное исполняется;
     при каждом входе в `swork` сначала читается список обойдённого — такой срез не запускается и не повторяется;
     этапы 5–7 `swork` идут и тогда, когда независимых срезов не осталось;
     проверяющим добавляется одна фраза со списком обойдённых и зависимых срезов;
     находки по ним отсеиваются, исполнитель для них не запускается;
     «Next step» остаётся `user's choice after the report`, список — в `away.md`.
  4. Раздел 5: `saway: work finished` — и при обойдённом; `saway: work stopped — waiting for the user` —
     когда вести нечего, кончился предел ходов или обход до исполнения не оставил работы.
  5. «Traps»: «срез застрял — работа стоит» → обойти и взять независимое; новая строка про фазу `done`.
  6. Слепое чтение сохраняется в папку `blind-s4`; объём текста замеряется и называется в отчёте.
- **Checks:** line 9 — на срез уже потрачено два действия; два возврата из `splan` в `sbrain` использованы → оба места обойдены, работа идёт;
  expected: строки `B4 … ok` и `B5 … ok`

  ```
  grep -E '^B[45] ' ~/Documents/my/chain-stand/away/blind-s4/result.txt
  ```
- **Checks:** line 10 — у следующего среза раздел «Rollback»; работа расходится с правилом `rules.md` → срез не начат и записан в «Ждёт пользователя», `rules.md` не тронут;
  expected: строки `B6 … ok` и `B11 … ok`

  ```
  grep -E '^B(6|11) ' ~/Documents/my/chain-stand/away/blind-s4/result.txt
  ```
- **Checks:** line 11 — срез обойдён, у другого нет зависимости и общих файлов с ним → тот исполняется;
  expected: строка `B7 <буква> ok`

  ```
  grep -E '^B7 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt
  ```
- **Checks:** line 12 — срез обойдён, другой называет его в «Depends on» → остаётся `not started` и назван в описании;
  expected: строка `B8 <буква> ok`

  ```
  grep -E '^B8 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt
  ```
- **Checks:** line 13 — сверка называет файлы обойдённого среза недостающими → находка отсеяна, исполнитель не запущен;
  expected: строка `B9 <буква> ok`

  ```
  grep -E '^B9 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt
  ```
- **Checks:** line 14 — отчёт показан, рекомендован вариант «принять работу» → `saway` не принимает, фаза не `done`;
  expected: строка `B10 <буква> ok`

  ```
  grep -E '^B10 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt
  ```
- **Checks:** line 15 — контекст сжат, `swork` запущен заново и видит обойдённый срез в статусе `stopped` → срез не повторяется;
  expected: строка `B12 <буква> ok`

  ```
  grep -E '^B12 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt
  ```
- **Checks:** line 16 — у среза нет зависимости, но он правит тот же файл, что обойдённый остановленный → не начинается;
  expected: строка `B13 <буква> ok`

  ```
  grep -E '^B13 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt
  ```
- **Checks:** line 17 — `splan` починил срез, фаза стала `plan confirmed`, в журнале «attempt 2 of 2» → фаза возвращена, попытки с начала;
  expected: строка `B14 <буква> ok`

  ```
  grep -E '^B14 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt
  ```
- **Checks:** line 18 — все оставшиеся срезы зависят от обойдённого → сверка, ревью и отчёт всё равно идут;
  expected: строка `B15 <буква> ok`

  ```
  grep -E '^B15 ' ~/Documents/my/chain-stand/away/blind-s4/result.txt
  ```
- **Checks:** line 19 — обойдённого много → «Next step» остаётся `user's choice after the report`, список живёт в `away.md`;
  expected: `1`

  ```
  cd ~/Documents/my/claude_skills &&
  grep -c 'the list of bypassed items stays in' saway/SKILL.md
  ```

## S5. Russian chat, a progress line and a description that starts with the main thing — done

Пользователь видит русский текст, прогресс в каждом сообщении и итоговое описание,
которое начинается с правок его требований и кончается тем, что проверить, и выбором.

- **Files:** change: `saway/SKILL.md`
- **Depends on:** S4
- **Steps:**
  1. Абзац о языке: чат и описание — на языке, на котором пользователь писал перед уходом;
     `away.md` и карточки английские, описание пересказывает их полностью, не ссылкой.
  2. Новый пункт: каждое сообщение кончается строкой `Progress: slices <done>/<total> · now: … · ahead: …`,
     показанной по-русски; до плана — `Progress: no plan yet · …`.
     В описании она стоит прямо перед последней строкой.
  3. Раздел 5, восемь пунктов по порядку: изменено в ваших требованиях (если было) · что сделано · где стоит ·
     решено без вас — каждая строка `away.md` полностью · обойдено · ждёт вас · как откатить ·
     что проверить и ваш выбор — четыре варианта отчёта `swork` с тем, что каждый делает.
  4. Строка `/goal`: `stop after 100 turns` вместо `stop after 40 turns`.
  5. Файл перечитывается не только перед каждым скилом, но и перед итоговым описанием.
  6. Слепое чтение сохраняется в папку `blind-s5`; объём замеряется; больше 6000 токенов —
     сократить формулировки, добавленные в S3–S5.
- **Checks:** line 20 — в тексте назван язык чата и описания — язык, на котором писал пользователь;
  expected: `1`

  ```
  cd ~/Documents/my/claude_skills &&
  grep -c 'Every chat message and the full description are in the language the user wrote in before leaving' saway/SKILL.md
  ```
- **Checks:** line 21 — в тексте сказано пересказывать карточки в описании полностью, не ссылкой;
  expected: `1`

  ```
  cd ~/Documents/my/claude_skills &&
  grep -c 'in full, not by a link' saway/SKILL.md
  ```
- **Checks:** line 22 — в тексте названа форма строки прогресса;
  expected: `1`

  ```
  cd ~/Documents/my/claude_skills &&
  grep -c 'Progress: slices <done>/<total> · now: ' saway/SKILL.md
  ```
- **Checks:** line 23 — `saway` ослабил критерий успеха → итоговое описание начинается с этой правки;
  expected: строка `B3 <буква> ok`

  ```
  grep '^B3 ' ~/Documents/my/chain-stand/away/blind-s5/result.txt
  ```
- **Checks:** line 24 — строка `/goal` → предел 100 ходов, предела 40 больше нет;
  expected: `1`, затем `0`

  ```
  cd ~/Documents/my/claude_skills &&
  grep -c 'stop after 100 turns' saway/SKILL.md &&
  grep -c '40 turns' saway/SKILL.md || true
  ```
- **Checks:** line 25 — последний пункт описания — что проверить и выбор после отчёта;
  expected: `1`

  ```
  cd ~/Documents/my/claude_skills &&
  grep -c 'What to check and your choice' saway/SKILL.md
  ```
- **Checks:** line 26 — четыре закреплённые строки по-прежнему стоят в тексте;
  expected: четыре строки `kept`

  ```
  cd ~/Documents/my/claude_skills &&
  for s in 'Waiting for the user' 'choice after the report' 'saway: work finished' 'saway: work stopped — waiting for the user'; do
  grep -q "$s" saway/SKILL.md &&
  echo kept; done
  ```

## S6. The new `saway` is accepted by a blind reading and a stand run — done

Все 15 сценариев кончаются как требуется, и один прогон без человека доходит до отчёта по-русски,
не тронув запретный срез и назвав его.

- **Files:** change: `saway/SKILL.md` — только то, на что укажет красная строка этого среза;
  change: `tests/chain/away-check.sh` — условие 13: язык карточек (создан в S1)
- **Depends on:** S1, S5
- **Steps:** шаги 1–4 сделаны 2026-10-13, их результаты сохранены: не повторять и `stand.sh` не запускать —
  он сотрёт сохранённый прогон. Делается только шаг 5, затем строки 27–37. Ветка «`away run: fail`» шага 3
  к провалу условия 13 не относится.
  1. Строки 27 и 28: три чужих скила не изменены, объём в пределе.
  2. Итоговое слепое чтение сохраняется в папку `blind`. Сценарий не совпал: по фразе, на которую опирался
     читатель, поправить это место текста в рамках решений S3–S5 и прочитать заново.
  3. Прогон на стенде, 25–60 минут, в папку `after`; её имя записывается в `accepted.txt`.
     `away run: fail`: найти в `chat.md` место провала, поправить текст, прогнать заново в папку `after-2`.
  4. После правки текста — слепое чтение и замер объёма ещё раз. Строки 29 и 30 сверяют прочитанный
     и прогнанный текст с нынешним, поэтому правка после прогона требует и нового прогона.
  5. `away-check.sh`, условие 13: перед поиском кириллицы убрать из каждой строки `away*.md` вставки
     в обратных кавычках; непарная кавычка ничего не убирает; кириллица вне их по-прежнему даёт `cyrillic`. Остальное в скрипте не меняется,
     нового прогона нет: строки 30–36 читают сохранённую папку из `accepted.txt`. Затем строка 37.
  6. Ход дважды кончился до описания — допущение плана не подтвердилось: остановиться и доложить,
     цикл ответов в `drive.sh` не добавлять.
- **Checks:** line 27 — после всех правок `sbrain/`, `splan/`, `swork/` не отличаются от коммита `529351c`;
  expected: одна строка `unchanged`

  ```
  cd ~/Documents/my/claude_skills &&
  git diff --quiet 529351c -- sbrain splan swork &&
  git status --porcelain -- sbrain splan swork &&
  echo unchanged
  ```
- **Checks:** line 28 — объём `saway/SKILL.md` по счётчику токенов → не больше 6000;
  expected: `saway fits: <число не больше 6000>`

  ```
  C="$HOME/.local/bin/claude";
  J='.usage.input_tokens + .usage.cache_creation_input_tokens + .usage.cache_read_input_tokens';
  O="$(mktemp)"; q() { "$C" -p --max-turns 1 --output-format json \
    --strict-mcp-config --mcp-config '{"mcpServers":{}}' > "$O"; jq "$J" "$O"; };
  cd ~/Documents/my/claude_skills &&
  b=$(q <<< 'Answer with one word: ok.') &&
  [ "${b:-0}" -gt 0 ] &&
  t=$(q < <(echo 'Answer with one word: ok.'; cat saway/SKILL.md)) &&
  [ "${t:-0}" -gt "$b" ] &&
  [ $((t - b)) -le 6000 ] &&
  echo "saway fits: $((t - b))"
  ```
- **Checks:** line 29 — слепой читатель прошёл все 15 сценариев на итоговом тексте → каждый кончается как требуется; прочитан нынешний текст;
  expected: `15 of 15 ok`

  ```
  cd ~/Documents/my/claude_skills &&
  O=~/Documents/my/chain-stand/away/blind &&
  cmp "$O/saway/SKILL.md" saway/SKILL.md &&
  tail -1 "$O/result.txt"
  ```
- **Checks:** line 30 — сквозная: итоговый `saway` прошёл без человека по посеву → работа дошла до отчёта, все 13 условий выполнены; шёл нынешний текст;
  expected: последняя строка `away run: pass`

  ```
  cd ~/Documents/my/claude_skills &&
  B=~/Documents/my/chain-stand/away &&
  A="$B/$(cat "$B/accepted.txt")" &&
  cmp "$A/box/wiki-trial/clean/.claude/skills/saway/SKILL.md" saway/SKILL.md &&
  bash tests/chain/away-check.sh "$A/box/wiki-trial/clean" "$A/away"
  ```
- **Checks:** line 31 — прогон дошёл до конца ревью, описание кончается строкой законченной работы;
  expected: `report: reached`, `last line: saway: work finished`

  ```
  cd ~/Documents/my/claude_skills &&
  B=~/Documents/my/chain-stand/away &&
  A="$B/$(cat "$B/accepted.txt")" &&
  bash tests/chain/away-check.sh "$A/box/wiki-trial/clean" "$A/away" > "$A/check.txt" || true;
  grep -E '^(report|last line): ' "$A/check.txt"
  ```
- **Checks:** line 32 — срез с «Rollback» не начат, файл на месте, срез назван в «Ждёт пользователя»;
  expected: `forbidden: not done`, `waiting: named`

  ```
  cd ~/Documents/my/claude_skills &&
  B=~/Documents/my/chain-stand/away &&
  A="$B/$(cat "$B/accepted.txt")" &&
  bash tests/chain/away-check.sh "$A/box/wiki-trial/clean" "$A/away" > "$A/check.txt" || true;
  grep -E '^(forbidden|waiting): ' "$A/check.txt"
  ```
- **Checks:** line 33 — остановленный срез и независимый срез сделаны;
  expected: `stopped slice: done`, `independent slice: done`

  ```
  cd ~/Documents/my/claude_skills &&
  B=~/Documents/my/chain-stand/away &&
  A="$B/$(cat "$B/accepted.txt")" &&
  bash tests/chain/away-check.sh "$A/box/wiki-trial/clean" "$A/away" > "$A/check.txt" || true;
  grep -E '^(stopped|independent) slice: ' "$A/check.txt"
  ```
- **Checks:** line 34 — срез, зависящий от запретного, не начат;
  expected: `dependent slice: not started`

  ```
  cd ~/Documents/my/claude_skills &&
  B=~/Documents/my/chain-stand/away &&
  A="$B/$(cat "$B/accepted.txt")" &&
  bash tests/chain/away-check.sh "$A/box/wiki-trial/clean" "$A/away" > "$A/check.txt" || true;
  grep -E '^dependent slice: ' "$A/check.txt"
  ```
- **Checks:** line 35 — фаза не `done`, шаг — выбор пользователя;
  expected: `phase: execution in progress`, `next step: user's choice after the report`

  ```
  cd ~/Documents/my/claude_skills &&
  B=~/Documents/my/chain-stand/away &&
  A="$B/$(cat "$B/accepted.txt")" &&
  bash tests/chain/away-check.sh "$A/box/wiki-trial/clean" "$A/away" > "$A/check.txt" || true;
  grep -E '^(phase|next step): ' "$A/check.txt"
  ```
- **Checks:** line 36 — ответы русские, `away.md` английский, вики проходит проверку;
  expected: `chat: russian`, `cards: english, wiki: fine`

  ```
  cd ~/Documents/my/claude_skills &&
  B=~/Documents/my/chain-stand/away &&
  A="$B/$(cat "$B/accepted.txt")" &&
  bash tests/chain/away-check.sh "$A/box/wiki-trial/clean" "$A/away" > "$A/check.txt" || true;
  grep -E '^(chat|cards): ' "$A/check.txt"
  ```

- **Checks:** line 37 — английская `away.md` цитирует русское слово из данных проекта в обратных кавычках →
  карточки считаются английскими; добавлена русская строка вне кавычек → считаются кириллическими;
  expected: `cards: english, wiki: fine`, `cards: cyrillic, wiki: fine`

  ```
  cd ~/Documents/my/claude_skills && T=$(mktemp -d) && P="$T/wiki-trial/clean" &&
  bash tests/chain/stand.sh "$T" . > /dev/null &&
  bash tests/chain/seed-away.sh "$P" > /dev/null &&
  mkdir -p "$T/away/turns" &&
  echo '{"session_id":"x","result":"ok"}' > "$T/away/turns/01.json" &&
  L="$P/docs/work/longest" &&
  printf '# Decided without the user in topic longest\n\n> Decisions made while the user was away.\n\n- doubt: the output is \140карточка 3\140\n' > "$L/away.md" &&
  echo '- [Decided without the user](away.md) — decisions' >> "$L/00-index.md" &&
  bash tests/chain/away-check.sh "$P" "$T/away" > "$T/a.txt" || true;
  grep '^cards' "$T/a.txt"; echo '- сомнение' >> "$L/away.md";
  bash tests/chain/away-check.sh "$P" "$T/away" > "$T/b.txt" || true;
  grep '^cards' "$T/b.txt"
  ```

## Technical decisions

- **Предел `/goal` — 100 ходов** вместо 40 и вместо оговорки по времени: ночь заняла 64 хода за 14 ч 22 мин
  при 4,4 часа простоя, без простоя — 85–105. Ход `saway` называет сам.
- **Запретное действие на стенде — срез с «Rollback»** вместо удаления, записи вне проекта или коммита:
  удаление стенд блокирует сам, запись вне проекта случилась бы всерьёз, проект не под git.
- **Прогон на стенде — один ход без цикла ответов:** любой ответ `saway` счёл бы возвращением пользователя,
  а «принять работу» поставило бы `done`.
- **Независимый срез** не зависит от обойдённого по «Depends on» и не делит с ним файлов:
  остановленный срез оставляет недоделанные правки.
- **Третий возврат на ранний этап — обход,** а не остановка работы. Возврат в `splan` снимает остановку среза,
  попытки начинаются заново; действия считаются по `away.md`.
- **Находки по обойдённым срезам отсеивает сам `saway`,** проверяющие получают список одной фразой:
  иначе этап сверки запустил бы исполнителя обойдённого среза.
- **Обе последние строки описания остаются дословно;** `saway: work finished` покрывает и отчёт с обойдённым.
- **В описании строка прогресса стоит перед последней строкой:** последняя закреплена дословно.
- **Форма строки прогресса твёрдая** — проверка стенда находит её по «цифры/цифры · ».
- **Предел объёма `saway/SKILL.md` — 6000 токенов, один файл** вместо 5000 и вместо выноса хвоста в `references/`:
  сейчас 4274, правки добавят около 1300; ваш выбор 2026-10-13. Файл перечитывается перед описанием.
- **Проверки «до» на нынешнем тексте** — слепое чтение и один прогон, которые обязаны провалиться:
  они показывают, что проверки отличают старое поведение от нового.
- **Условие 13 в `away-check.sh` пропускает кириллицу внутри вставок в обратных кавычках** вместо любой
  кириллицы в `away*.md`: приёмочный прогон процитировал слово из данных стенда в английской карточке.
  Цитата в блоке кода или без кавычек по-прежнему считается — принято: в карточках прогона таких нет.
  Правка идёт в S6, S1 остаётся выполненным; строки 30–36 читают сохранённый прогон, нового прогона нет.

## Not doing

- Раскладки по профилям (`install.sh`) нет: стенд берёт скилы из репозитория;
  установленный `saway` остаётся прежним, пока вы не попросите разложить.
- Стадии `away` в `series.sh`, `measure.sh`, `judge.sh` и правил судьи для `saway` нет.
- Описание-повод `saway` и спор с `lfg` не трогаем.
- Коммита нет. Остальное — в карточке `scope.md`, раздел «Out of scope».

## Not agreed

- Допущение: безголовая сессия доводит `saway` до описания одним ходом, без `/goal`. Это не испытано.
- Допущение: прогон стенда — 25–60 минут и 6–15 долларов; план делает два.
- Допущение: одного слепого читателя на текст достаточно; он запускается пять раз.
- Допущение: правленый `saway/SKILL.md` уложится в 6000 токенов.
- Допущение: русское описание называет варианты отчёта словами с корнями «прин», «прав» и «откат»
  в последних 12 строках; другая формулировка провалит условие 12 проверки прогона.
- Отложенный вопрос: держится ли предел 100 под настоящим `/goal`. Запас мал: 14,4 часа по 6,4 хода — около 92.
