# Plan overview of topic multi-agent

> The plan as one file for reading; the source is the slice cards: where they differ, the card is right.

- **Goal:** несколько агентов в одной папке, ожидание вместо вопроса

## S1. Стенд для двух агентов — done

Стенд гоняет две сессии `swork` одновременно в одном проекте, каждый ход — в своей временной папке, и говорит, закончили ли обе без потерь.

- **Files:** change `tests/chain/drive.sh`, `collect.sh`, `nonstop-run.sh`, `judge.sh`, `judge-prompt.md`; create `seed-pair.sh`, `pair-run.sh`, `pair-check.sh`, `pair-scenarios.md`, `pair-expected.tsv`
- **Depends on:** none
- **Steps:**
  1. `drive.sh`: `TMPDIR="$dir/tmp"` каждому ходу; этап `pair` с темой пятым аргументом, один ход. `collect.sh`: этап `pair` готов, если ответ хода содержит отчёт.
  2. `nonstop-run.sh`: стенд в `$CHAIN_BASE`, не в общей временной папке.
  3. `seed-pair.sh`: (а) темы `usage` и `version`, обе дописывают строку в `README.md`; (б) тема `pair` с четырьмя независимыми срезами; проверки не зависят от порядка;
     проект под git (`git init` и коммит посева), чтобы старый `swork` откатывал чужое, как в настоящем проекте.
  4. `pair-run.sh`: стенд, посев, два `drive.sh … pair` параллельно, затем `pair-check.sh`.
  5. `pair-check.sh`: обе сессии дали отчёт (меню «принять» или метка `⏸` короткого), хотя бы один — итоговый, все срезы `done`,
     обе строки в `README.md` (а), кто какой срез сделал — печатается, не судится (б), захватов не осталось.
  6. `judge.sh` и `judge-prompt.md` не копируют `.agents/` и `.swork-*/`.
  7. Сценарии M1–M9 для чтения вслепую, ответы перемешаны.
- **Checks:** line 1 — скилы 55bbe31 на случае (а) проваливают проверку; expected: `pair run: fail`

  ```
  mkdir -p "$HOME/Documents/my/chain-stand" && S=$(mktemp -d "$HOME/Documents/my/chain-stand/old.XXXXXX") && git archive 55bbe31 sbrain splan swork saway | tar -x -C $S
    && { bash tests/chain/pair-run.sh a $S; test $? -eq 1; }
  ```

  line 2 — у каждого хода своя временная папка; expected: `1` — `grep -c 'TMPDIR="$dir/tmp"' tests/chain/drive.sh`

## S2. agents.sh и правило захватов — done

Один скрипт занимает, ждёт, пишет правки с диффами и отпускает; один файл правил говорит, когда его звать.

- **Files:** create `sbrain/scripts/agents.sh`, `sbrain/references/agents-rules.md`, `tests/agents-test.sh`; change `install.sh`, `tests/chain/stand.sh` (копирует пару, только если она есть)
- **Depends on:** none
- **Steps:**
  1. Корень — `$AGENTS_ROOT`, папка с `.agents/` выше по дереву, git, папка с `docs/00-index.md`, текущая; id агента — `<pid>:<время запуска>`
     из `$CLAUDE_PID` или подъёмом до процесса `claude`/`codex`; время запуска разбирается при `LC_ALL=C`; у каждой записи поле темы.
  2. Все изменения `.agents/` — под мьютексом `mkdir .agents/lock` с `pid`; брошенный мьютекс снимается.
  3. Хозяин жив — `kill -0` и то же время запуска.
  4. `claim` — всё или ничего, повторный захват своим — успех, копии в `held/`, печать чужих диффов с начала агента, «no changes» или «reread».
  5. `wait` — до 540 с, проверка раз в 2 с, снимает брошенные захваты, сам не занимает.
  6. `done` — дифф с копией (новый файл — против `/dev/null`, удалённый — `deleted`), строка журнала, отпуск;
     `release [--all]`, `busy [--topic]`, `others [--since <файл>]`, `id`; `AGENTS_ID` подменяет id для тестов.
  7. `agents-rules.md`: когда занимать, как ждать (`⏳`, без вопроса, без удержания, таймаут команды 600000 мс), `--topic` в теме, что делать после записи.
  8. `tests/agents-test.sh` — живой, мёртвый и переиспользованный pid, брошенный мьютекс, пути.
- **Checks:** line 3 — `agents.sh` сам по себе; expected: `agents: all ok` — `bash tests/agents-test.sh`

  line 4 — стенд и `install.sh` раскладывают пару файлов; expected: `4`, затем число ≥ 2

  ```
  mkdir -p "$HOME/Documents/my/chain-stand" && T=$(mktemp -d "$HOME/Documents/my/chain-stand/st.XXXXXX") && bash tests/chain/stand.sh $T . >/dev/null
    && ls $T/wiki-trial/clean/.claude/skills/{splan,swork}/scripts/agents.sh
       $T/wiki-trial/clean/.claude/skills/{splan,swork}/references/agents-rules.md | wc -l | tr -d ' ';
    grep -c 'agents-rules.md' install.sh
  ```

## S3. Запись в вики под захватом — все скилы — done

`sbrain`, `splan`, `swork` и `saway` занимают файл вики или карточку темы перед записью и отмечают правку после.

- **Files:** change `sbrain/references/wiki-rules.md`, `sbrain/references/topic-cards.md`, `splan/references/plan-format.md`, `swork/SKILL.md`, `saway/SKILL.md`
- **Depends on:** S2
- **Steps:**
  1. «Writing» в `wiki-rules.md`: первый пункт «занять перед записью, `done` после»; «Check» — после `done`.
  2. Правила карточек `topic-cards.md:23`, `plan-format.md:23`: «карточка пишется под захватом».
  3. `swork/SKILL.md`: «только главная сессия агента, под захватом»; скрипт проверки чинит только свои карточки.
  4. `saway/SKILL.md`: занятый файл ждём, не обходим и не спрашиваем.
- **Checks:** line 5 — правила вики и карточек указывают на правило захватов; expected: четыре строки, в каждой число ≥ 1

  ```
  grep -c 'agents-rules.md' sbrain/references/wiki-rules.md sbrain/references/topic-cards.md
    splan/references/plan-format.md swork/SKILL.md
  ```

## S4. swork: свои срезы рядом с чужими — done

Каждый агент `swork` берёт свободный срез под захватом, держит свою метку и не принимает работу соседа за чужие правки.

- **Files:** change `swork/SKILL.md`, `swork/references/slices.md`, `snapshot.md`, `snapshot-powershell.md`, `entry.md`, `small.md`
- **Depends on:** S2, S3
- **Steps:**
  1. Метка — `<снимок>/agents/<id>/marker`; продолжающий копирует самую новую, старая `.swork-marker` в корне тоже считается меткой;
     снимок удаляется, только когда в теме нет живых захватов.
  2. Выбор среза: свободный срез — один `claim` на «Файлы» и карточку; занят — следующий; свободных нет — ждать срез с меньшим номером;
     зависимые от обойдённого считаются выбывшими.
  3. На срез: захват до шага 1, `done` после шага 7; статусы и журнал хода — под коротким захватом; строки журнала с `[<имя>]`.
  4. Поиск правок «вне плана» всегда вычитает `.agents/` и `.swork-*/`, а также `agents.sh others --since <своя метка>`;
     незаписанный файл при живом соседе — в `known.txt`, не откатывается.
  5. Красная проверка при живом соседе — не попытка: дождаться и перепроверить.
  6. Вход: живой захват — пропустить срез; присоединение к живой теме — не продолжение прерванной работы.
  7. Ловушка «одновременно никогда» → «Два агента не правят один срез: решает захват».
- **Checks:** line 6 — `swork` больше не создаёт метку в корне, старой ловушки нет; expected: `0`

  ```
  grep -cF -e 'touch "$ROOT/.swork-marker"' -e 'One at a time: without git' swork/SKILL.md swork/references/*.md
    | awk -F: '{s+=$2} END {print s}'
  ```

## S5. swork: стадии, отчёты и откат рядом с соседями — done

Стадии 5–7 делает один агент, раньше закончивший даёт короткий отчёт, откат снимает только свои диффы, исполнитель видит чужие функции.

- **Files:** change `swork/references/finish.md`, `conformance.md`, `review.md`, `report.md`, `executor.md`, `swork/scripts/packet.sh`
- **Depends on:** S4
- **Steps:**
  1. После последнего своего среза — `claim <тема>/.stage`: занято — ждать и занять снова; занял, а итоговый отчёт уже показан — стоп;
     занял, но в теме есть живой чужой захват — отпустить всё, короткий отчёт с меткой `⏸` и именем того, кто сделает итоговый;
     занял и чужих захватов нет — стадии 5–7 и итоговый отчёт.
  2. Красные перепроверки стадий 5 и 6 — по правилу 5 из S4.
  3. «Откатить всё»: файл, который после этой темы правила другая, — `patch -R` своих диффов; не легло — файл не трогаем и называем;
     принятие и откат пишут под захватом.
  4. Список файлов для коммита не берёт `.agents/`, `.swork-*/` и файлы, где последняя правка чужой темы.
  5. `packet.sh` принимает несколько файлов «создано ранее»: свой `created.txt` первым с пометкой «(this topic)» и `created.txt` других тем.
  6. `executor.md`: «своя» строка — в блоке своей темы с номером своего среза; формат `created.txt` прежний.
- **Checks:** line 7 — отчёт знает короткий отчёт и ожидания; expected: число ≥ 2 — `grep -c -e 'short report' -e 'Waited' swork/references/report.md`

## S6. Приёмка двух агентов сразу — done

Живые прогоны пары, сценарии вслепую и прежние проверки стенда доказывают работу; раскладка — после вашего «принять».

- **Files:** change `docs/notes/stand-nonstop-parallel.md` — только при новом факте
- **Depends on:** S1, S2, S3, S4, S5
- **Steps:**
  1. Строки 8–11 по одной: каждый случай пары — уже две сессии.
  2. Красная строка пары — причина в тексте скила считается красной проверкой среза S2–S5.
  3. Строка 12 ручная, ждёт вашего «принять» и коммита.
- **Checks:** line 8 — девять сценариев вслепую; expected: `9 of 9 ok`

  ```
  bash tests/chain/away-blind.sh . "$HOME/Documents/my/chain-stand/blind-pair"
    tests/chain/pair-scenarios.md tests/chain/pair-expected.tsv | tail -1
  ```

  line 9 — случай (а); expected: `pair run: pass` — `bash tests/chain/pair-run.sh a .`

  line 10 — случай (б): все четыре сделаны, оба дали отчёт, хотя бы один итоговый; expected: `pair run: pass` — `bash tests/chain/pair-run.sh b .`

  line 11 — прежние проверки стенда; expected: `nonstop run: pass`, `away run: pass`, `script is fine`

  ```
  bash tests/chain/nonstop-run.sh . | tail -1
    && mkdir -p "$HOME/Documents/my/chain-stand" && T=$(mktemp -d "$HOME/Documents/my/chain-stand/away.XXXXXX") && bash tests/chain/stand.sh $T . >/dev/null
    && P=$T/wiki-trial/clean && bash tests/chain/seed-away.sh $P >/dev/null
    && { bash tests/chain/drive.sh $P away $T/stage medium >/dev/null; bash tests/chain/away-check.sh $P $T/stage | tail -1; }
    && W=$(mktemp -d "$HOME/Documents/my/chain-stand/wiki.XXXXXX")/wiki-trial && bash tests/make-wiki.sh $W >/dev/null
    && bash tests/run-check.sh sbrain/scripts/check.sh $W
  ```

  line 12 — после принятия и коммита; checked manually: `./install.sh --mac`, затем `grep -l agents-rules` по трём профилям; expected: три пути

## Technical decisions

- Ожидание — в обычном режиме, порциями до 9 минут.
- Общий для двух тем файл откатывается обратным применением своих диффов.
- Красная проверка при живом чужом захвате — не попытка.
- Незаписанную правку «вне плана» при живом соседе не откатываем.
- Стадии 5–7 — у того, кто первым занял `<тема>/.stage`.
- id агента — `<pid>:<время запуска>`; захват принадлежит сессии, не исполнителю.
- Метка — своя у агента в снимке; малое изменение — `.swork-<id>/`.
- Стенд: свой `TMPDIR` у каждого хода, стенды — в `$CHAIN_BASE`.
- Одна строка захвата на файл, без поля «кто ждёт»; поле темы — в каждой записи.
- Продолжающий агент берёт самую новую метку снимка; старая `.swork-marker` в корне тоже метка.

## Not doing

- То, что в [scope.md](scope.md); `install.sh --mac` и коммит — ваш выбор после отчёта.
- `rm -rf` проверяющего — тема `quality-zero`.

## Not agreed

- Codex не проверялся: процесс `codex` ищется подъёмом по родителям — предположение.
- Ход `claude -p` на стенде — один процесс на весь ход; `$CLAUDE_PID` в `-p` проверен 2026-10-15.
- Второй круг проверки: всё найденное исправлено; остаток — не проверено вживую, что старые скилы проваливают строку 1,
  и что фоновый процесс `claude bg-spare` не бывает общим у двух сессий.

# Часть 2 — продолжение R16–R36

- **Goal:** многоагентный режим работает, только пока есть `.agents/mode`; в нём каждый агент `swork` либо правит свой worktree (git 2.40+) и сливает его после зелёного шага, либо работает в общей папке и захватывает файл только на одну запись; сосед ждёт слияние или запись, а не срез; после каждого слияния или шага скрипт называет кандидатов в дубли
- Карточки части 2: [plan-2.md](plan-2.md), [plan-decisions-2.md](plan-decisions-2.md), [plan-decisions-3.md](plan-decisions-3.md), строки проверки 13–41; S1–S6 выше — сделанная и принятая часть 1.
- Порядок исполнения: S12 → S7 → S8; S9 (независим) → S13 → S10 → S11 → S14.

## S12. agents.sh: выключатель многоагентного режима — done

Без `.agents/mode` любая команда `agents.sh` отвечает «выключено» и ничего не пишет; `on`, `off` и `mode` включают, выключают и показывают режим; последний агент выключает его сам.

- **Files:** change `sbrain/scripts/agents.sh`, `tests/agents-test.sh`; create `tests/switch-test.sh`
- **Depends on:** none
- **Steps:**
  1. Поиск корня не меняется; `on` берёт корень из git или `docs/00-index.md`.
  2. Безусловный `mkdir -p` (:132) заменяется проверкой `mode_now`: без файла `claim`, `wait`, `done`, `release` печатают `agents: off` (код 0), `busy` — код 1 без вывода, `others` — код 0 без вывода; `mode` и `off` отвечают и выходят до записей и замка; `id` выходит сразу после печати; ничего не создаётся.
  3. `on [auto|worktree|shared]`: пишет слово в `.agents/mode` (по умолчанию `auto`), под git добавляет `.agents/` в `info/exclude` один раз; повторный `on` перезаписывает слово.
  4. `off` удаляет файл; `off --if-last` под замком оставляет его, если у другого живого агента есть захват (`claim of <имя>`), worktree (`worktree of <id>`) или захват после включения за последние 300 с (`agent <id> active`), иначе удаляет — `mode: off`.
  5. Шапка описывает `on`, `off`, `mode` и ответы в выключенном режиме.
  6. `tests/agents-test.sh` включает режим в своих игрушечных проектах (после строки 67, где уже заданы `A` и `B`, и после `cd "$W/repo"`).
  7. Новый `tests/switch-test.sh` — случаи строки 33.
- **Checks:** line 33 — без `.agents/mode` ничего не пишется; `on`, `on shared`, `on bogus`; `off --if-last` при захвате, активном агенте, worktree и мёртвом соседе; старый тест зелёный; expected: `switch: ok`, затем `agents: all ok`

  ```
  bash tests/switch-test.sh && bash tests/agents-test.sh
  ```

## S7. agents.sh: worktree, синхронизация и слияние — done

В режиме worktree (git 2.40+, `.agents/mode` = `auto` или `worktree`) агент получает свой worktree из снимка общей папки, подмодули клонируются только для чтения, забирает чужие слияния и сливает свои правки; иначе код 5 отправляет его в общий режим.

- **Files:** change `sbrain/scripts/agents.sh`; create `tests/merge-test.sh`
- **Depends on:** S12
- **Steps:**
  1. Шапка: `wt`, `sync`, `merge`, `drop`, коды 4 (конфликт) и 5 («работай в общем режиме») с причиной `shared: …`; без режима `wt`, `sync`, `merge` — `agents: off` и код 5, `drop` — код 0.
  2. Проверка режима: `shared` в файле → код 5; для `auto`/`worktree` нужны git, корень — вершина git, git ≥ 2.40; подмодули и вики выше корня — не причина.
  3. `snap <dir>`: коммит папки через свой постоянный индекс (отдельный для общей папки и для worktree), без `.swork*` с содержимым и путей подмодулей (`.agents/` уже в `info/exclude`); без веток и ссылок.
  4. `wt`: `git worktree add --detach`, клон игнорируемых файлов `cp -cR`; каждый подмодуль — клоном `cp -cR` без его `.git`, только для чтения; ошибка `worktree add` → код 5.
  5. `.agents/attributes`: `merge=mergiraf` для JS/TS/JSON, только если `mergiraf` есть; всё через `-c`, без `.git/config`.
  6. `sync`: `merge-tree` над HEAD worktree, `read-tree -u --reset`, HEAD — на общий снимок; конфликт — маркеры diff3 только в worktree, код 4; затем клоны подмодулей обновляются `rsync -a --delete --exclude=.git`.
  7. `merge "<суть>" [--base <снимок>]`: под замком, пишет только пути из `diff-tree` (без gitlink и путей подмодулей); ждёт, если путь захвачен живым агентом; файл изменился после снимка — начинает заново (R20); каждый путь — в журнал правок с диффом; затем `sync`.
  8. `drop`: `git worktree remove --force`.
  9. `tests/merge-test.sh <случай>|all`: случаи строк 13–20, 34, 35; каждый сначала `agents.sh on`; заглушка `git` с версией 2.39.0; заглушка `mergiraf` записывает вызов и делает `git merge-file "$4" "$3" "$5"`.
  10. `tests/agents-test.sh` остаётся зелёным после выноса логирования в `log_diff`.
- **Checks:** line 13 — снимок с незакоммиченным, неотслеживаемым и игнорируемым; индекс и ссылки пользователя не тронуты; expected: `merge snapshot: ok` — `bash tests/merge-test.sh snapshot`
  line 14 — `sync` забирает чужое слияние, конфликт — код 4; expected: `merge sync: ok` — `bash tests/merge-test.sh sync`
  line 15 — разные строки одного файла, удалённый, новый и файл с пробелом; журнал; expected: `merge clean: ok` — `bash tests/merge-test.sh clean`
  line 16 — правка между снимком и записью → слияние заново; expected: `merge race: ok` — `bash tests/merge-test.sh race`
  line 17 — одни строки → код 4, после разрешения — 0; expected: `merge conflict: ok` — `bash tests/merge-test.sh conflict`
  line 18 — заглушка `mergiraf` вызвана, без неё — построчное слияние; expected: `merge driver: ok` — `bash tests/merge-test.sh driver`
  line 19 — без git, git 2.39.0, корень — подпапка → код 5 с причиной `shared: …`; expected: `merge fallback: ok` — `bash tests/merge-test.sh fallback`
  line 20 — путь захвачен живым агентом на запись → слияние ждёт; expected: `merge claimed: ok` — `bash tests/merge-test.sh claimed`
  line 34 — `shared` в файле → код 5; `worktree` и `auto` → worktree; без файла → `agents: off`, `.agents/` не создан; expected: `merge mode: ok` — `bash tests/merge-test.sh mode`
  line 35 — подмодуль `lib/`: клон без `.git`, `git status` worktree чист, правка внутри `lib/` не сливается, `sync` обновляет клон; expected: `merge submodule: ok` — `bash tests/merge-test.sh submodule`

## S8. agents.sh: worktree мёртвого агента и журнал ожиданий — done

Неслитая правка мёртвого агента сохраняется, его worktree удаляется, срез снова свободен; каждое ожидание оставляет строку с длительностью.

- **Files:** change `sbrain/scripts/agents.sh`, `tests/merge-test.sh` (создан в S7)
- **Depends on:** S7
- **Steps:**
  1. В обеих ветках `abandoned:` (`claim`, `wait`): дифф worktree мёртвого агента и его новых файлов — в `.agents/orphans/<id>.diff`, `git worktree remove --force`, строка `orphan saved: …`.
  2. `wait`: строка в `.agents/waits.tsv` — id, имя, тема, файлы, держатель, начало, секунды, исход (`free`, `abandoned`, `busy`).
  3. `merge`: ожидание замка или захваченного пути от 1 с — строка в `waits.tsv`.
  4. `wt` и `sync` подбирают папки `.agents/wt/*` мёртвых агентов так же.
  5. Шапка описывает `orphans/` и `waits.tsv`.
- **Checks:** line 21 — мёртвый агент с правкой в worktree → дифф сохранён, worktree удалён, захват у нового; expected: `merge orphan: ok` — `bash tests/merge-test.sh orphan`
  line 22 — ожидания `free`, `abandoned`, `busy` и ожидание слияния — строки по 8 полей; expected: `merge waits: ok` — `bash tests/merge-test.sh waits`

## S9. Скрипт поиска дублей — done

После слияния или шага одна команда называет кандидатов в дубли среди изменённых файлов по всему проекту: одинаковые имена, похожий код, ключи данных и ресурсы.

- **Files:** create `swork/scripts/dups.py`, `tests/dups-test.sh`
- **Depends on:** none
- **Steps:**
  1. Файлы проекта: `git ls-files -co --exclude-standard` или обход; без `.git`, точечных папок (кроме вики), `node_modules`, файлов больше 1 МБ.
  2. Имена: функции, классы, константы верхнего уровня JS/TS, Python, shell, определённые ещё где-то → `name`; `ast-grep`, если установлен.
  3. Похожий код: окна по 6 нормализованных строк → `similar`; `jscpd` дополнительно, если установлен.
  4. Данные: ключ JSON дважды в объекте → `key`; ключ `.str`/`.lconf`/`.properties` дважды или с другим значением → `key`/`value`; путь ресурса дважды → `resource`.
  5. Двоичный, не UTF-8, битый JSON → `skipped:`, работа продолжается.
  6. Каждая пара мест — одной строкой; с `ast-grep` определения берутся из него и по всему проекту.
  7. `tests/dups-test.sh <случай>|all` — случаи строк 23–25; в `base` изменённые пути названы, тело `formatReward` — не длиннее 3 строк.
- **Checks:** line 23 — пять подложенных дублей названы, чистый файл — `dups: none`; expected: `dups base: ok` — `bash tests/dups-test.sh base`
  line 24 — заглушки `ast-grep` и `jscpd` вызваны, без них — своя проверка и одна строка `not installed:`; expected: `dups tools: ok` — `bash tests/dups-test.sh tools`
  line 25 — PNG, Latin-1, битый JSON → `skipped:`, без падения; expected: `dups odd: ok` — `bash tests/dups-test.sh odd`

## S13. Скилы: выключатель и общий режим — done

Скил включает режим, когда пользователь просит работать несколькими агентами; `swork` выбирает режим перед каждым срезом, в общем режиме захватывает файл только на одну запись, после шага ищет дубли и называет режим в отчёте; последний агент выключает режим.

- **Files:** create `swork/references/modes.md`, `tests/chain/modes-scenarios.md`, `tests/chain/modes-expected.tsv`; change `sbrain/references/agents-rules.md`, `sbrain/SKILL.md`, `splan/SKILL.md`, `swork/SKILL.md`, `saway/SKILL.md`, `swork/references/slices.md`, `executor.md`, `small.md`, `report.md`, `tests/chain/pair-scenarios.md`
- **Depends on:** S9, S12
- **Steps:**
  1. `agents-rules.md`, раздел «Switch»: правила действуют, только пока есть `.agents/mode`; без него — один агент, вызовы остаются (вызов и есть проверка); просьба о нескольких агентах → `agents.sh on` (слово `worktree`/`shared`, если названо; «без worktree» — `shared`); `off`; `off --if-last` у `swork` перед отчётом и у `saway` перед полным описанием.
  2. Четыре `SKILL.md`: по строке «Several agents» со ссылкой на «Switch»; `saway` цитирует слова пользователя в задачах стадий и выключает режим перед описанием.
  3. `modes.md` «Mode»: `agents.sh mode` на шаге 2 и перед каждым срезом; `off` — один агент; `shared` — общий режим; `auto`/`worktree` — `worktree.md` (S10), код 5 → общий режим с причиной; включённый посреди работы режим — общий со следующего среза.
  4. `modes.md` «Shared mode»: захват только карточки среза; метка шага; исполнителю — строка `AGENTS=… TOPIC=… SLICE=S<N>`; после шага — `dups.py` по своим строкам журнала за шаг; красная проверка при чужой правке (`others --since` метки) — дождаться `done` соседа и перепроверить один раз;
    обход среза — обратными своими диффами (суть `done` исполнителя начинается с `S<N>:`), созданный и опустевший файл удаляется, никогда не из `base/`; указатель в «Decisions and bypass» `slices.md`.
  5. `modes.md` «Switch»: ссылка и порядок `off --if-last` перед полным и коротким отчётом.
  6. `slices.md`: режим на шаге 2; «Picking a slice» — только карточка; ожидание — на карточке; `done` — с карточкой; строка `AGENTS=…` в сообщении исполнителю.
  7. `executor.md`, правило 11: при `AGENTS=… TOPIC=… SLICE=S<N>` — `claim` прямо перед записью файла, `done` сразу после; код 3 — `wait` в цикле, без вопроса; после `abandoned:` — перечитать файл.
  8. `small.md`: строка про несколько агентов.
  9. `report.md`: пункт «Mode» — режим, причина и итог `off --if-last`; та же строка в коротком отчёте.
  10. `pair-scenarios.md`: посылка «`.agents/mode` содержит `shared`».
  11. Одиннадцать сценариев Q1–Q11 для чтения вслепую.
- **Checks:** line 36 — одиннадцать случаев режимов прочитаны вслепую; expected: `11 of 11 ok`

  ```
  bash tests/chain/away-blind.sh . "$HOME/Documents/my/chain-stand/blind-modes" tests/chain/modes-scenarios.md tests/chain/modes-expected.tsv | tail -1
  ```

  line 37 — тексты ссылаются на `modes.md`, `agents.sh on`, «Switch», `off --if-last`, `AGENTS=`; expected: все числа ≥ 1 — команда `grep -c …` из `plan-checks-modes.md`
  line 38 — девять сценариев пары части 1 с новой посылкой; expected: `9 of 9 ok`

  ```
  bash tests/chain/away-blind.sh . "$HOME/Documents/my/chain-stand/blind-pair" tests/chain/pair-scenarios.md tests/chain/pair-expected.tsv | tail -1
  ```

## S10. swork: режим worktree — done

В режиме worktree `swork` работает в своём worktree, захватывает только карточку среза, синхронизируется перед шагом, сливает после зелёного шага, перепроверяет слитое, разбирает дубли, срез внутри подмодуля ведёт в общем режиме; вики пишется поверх текущей версии.

- **Files:** create `swork/references/worktree.md`, `tests/chain/worktree-scenarios.md`, `tests/chain/worktree-expected.tsv`; change `swork/SKILL.md`, `swork/references/slices.md`, `entry.md`, `small.md`, `executor.md`, `finish.md`, `report.md`, `sbrain/references/agents-rules.md`, `saway/SKILL.md`
- **Depends on:** S7, S8, S9, S13
- **Steps:**
  1. «Mode»: начинается там, где `modes.md` сказал `auto`/`worktree`: `agents.sh wt`; код 0 — worktree, запись `mode: worktree <путь>`; код 5 — общий режим с причиной; поздний код 5 от `sync`/`merge` — общий режим до конца.
  2. «Before a step»: `agents.sh sync` перед срезом, исправлением и стадиями 5–7, не в середине шага; захват только карточки среза.
  3. «Executor and checks»: корень исполнителя — worktree; проверки — `cd "$WT" && …`; правки вне плана — через `git status` worktree, откат внутри worktree.
  4. «After a green step»: `agents.sh merge … --base <снимок>`; перепроверка на слитом; красная — правка в worktree и новое слияние; затем `dups.py` по слитым путям.
  5. Конфликт: оставить оба намерения, перепроверить, слить снова, без вопроса, строка в отчёте. Дубль: настоящий — оставить версию из общей папки; ложный — строка в отчёте. Два неудачных захода — «Decisions and bypass».
  6. «Submodule slice»: срез с файлами внутри подмодуля — в общем режиме по `modes.md`, корень и проверки — общая папка, без слияния; запись `S<N>: shared mode — inside submodule <путь>`; следующий `sync` обновляет клон.
  7. Обход слитого среза: обратное применение своих диффов слияния `patch -R`, не восстановление из `base/`.
  8. Стадии 5–7 и финальные проверки — в worktree после синхронизации; «принять» и «откатить всё» — `agents.sh drop`; продолжающая сессия находит свой мёртвый worktree через `abandoned:`.
  9. Указатели на `worktree.md` в `SKILL.md`, `slices.md`, `entry.md`, `small.md`; `executor.md` — все команды из данного корня; «Waited» в `report.md` — из `waits.tsv`.
  10. `agents-rules.md`: правка поверх текущей версии, строка в журнал и списки — к текущему файлу с чужими строками (R26); раздел «Worktree» (код 5 — общий режим).
  11. `saway/SKILL.md`: откат внутри своего worktree разрешён.
  12. Тринадцать сценариев W1–W13 для чтения вслепую.
- **Checks:** line 26 — тринадцать случаев режима worktree прочитаны вслепую; expected: `13 of 13 ok`

  ```
  bash tests/chain/away-blind.sh . "$HOME/Documents/my/chain-stand/blind-wt" tests/chain/worktree-scenarios.md tests/chain/worktree-expected.tsv | tail -1
  ```

  line 27 — тексты ссылаются на `worktree.md`, `waits.tsv`, «current version»; expected: четыре строки с числом ≥ 1, число ≥ 5, два числа ≥ 1 — команда `grep -c …` из `plan-checks-swork.md`

## S11. Живой стенд: два агента в одном git-проекте — done

Две живые сессии `swork` одновременно: в git разные строки сливаются за секунды, одни и те же — без потери правки, дубли названы; без git — общий режим с захватом файла только на запись.

- **Files:** change `tests/chain/seed-pair.sh`, `pair-run.sh`, `pair-check.sh`
- **Depends on:** S7, S8, S9, S10, S13
- **Steps:**
  0. Действие среза `replace`; затравка создаёт `app.js`, `src/shop.js`, `src/hud.js`, `resources.json`; проверки начинаются с `sleep 20`; в случаях a–f затравка вызывает `agents.sh on` — `.agents/mode` = `auto`.
  1. Случай c: `app.js` с `left()` вверху и `right()` около 40-й строки, темы `left` и `right` без зависимостей.
  2. Случай d: обе темы правят одну строку `label` — одна текст, другая цвет; итог должен держать оба.
  3. Случай e: темы `shop` и `hud` добавляют одну и ту же `formatReward()` и ключ `bonus_win` с разными значениями.
  4. Случай f: случай c без git — общий режим.
  5. `pair-check.sh`: прежние строки плюс по случаю — `edits: both`, `max wait: ok` (≤ 30 с), `label: both`, `conflict named: yes`, `dups named: yes`, `dups left: none`, `worktrees: none`, `mode named: shared`.
  6. `pair-run.sh` и `pair-check.sh`: списки случаев a–f; `dups.py` берётся из копии стенда; `max wait` без `waits.tsv` — ok.
- **Checks:** line 28 — случай c; expected: `pair run: pass` — `bash tests/chain/pair-run.sh c .`
  line 29 — случай d; expected: `pair run: pass` — `bash tests/chain/pair-run.sh d .`
  line 30 — случай e; expected: `pair run: pass` — `bash tests/chain/pair-run.sh e .`
  line 31 — случай f без git: обе сессии в общем режиме и называют его, обе правки на месте, `.agents/wt/` нет, ожидания ≤ 30 с; expected: `pair run: pass` — `bash tests/chain/pair-run.sh f .`

## S14. Живой стенд: подмодуль и выключатель — awaiting manual check

Две живые сессии: в репозитории с подмодулем одна работает в worktree, а срез внутри подмодуля идёт в общем режиме; сессия, начатая без режима, присоединяется, когда вторая его включает, и последняя его выключает; прежние проверки зелёные.

- **Files:** change `tests/chain/seed-pair.sh`, `pair-run.sh`, `pair-check.sh`, `drive.sh`
- **Depends on:** S11
- **Steps:**
  1. `drive.sh`: стадия `pair-multi` — как `pair` во всех четырёх местах (:11, :42, :88–92, :209), первое сообщение `/swork $topic — исполни план; работаем несколькими агентами`.
  2. Случай g: локальный подмодуль `lib/` с `util.js`; тема `left` как в c, тема `right` меняет `"old"` на `"new"` в `lib/util.js`; `agents.sh on`.
  3. Случай h: случай c без `.agents/`; у `left` два среза, у `right` три, проверки с `sleep 40` — сессия 2 кончает позже и выключает режим.
  4. `pair-run.sh`: g — обе сессии сразу; h — сессия 1 (`left`), ожидание `execution in progress` в её `state.md` (до 600 с), запись `before switch: none|present`, затем сессия 2 (`pair-multi`, `right`).
  5. `pair-check.sh`: g — `edits: both`, `worktree used: yes`, `submodule slice: shared`; h — `before switch: none`, `joined: yes` (два id в журнале правок), `mode at end: off`, `switch-off named: yes`, `edits: both`.
  6. Строка 32 — последней; строка 41 ждёт пользователя.
- **Checks:** line 39 — случай g; expected: `pair run: pass` — `bash tests/chain/pair-run.sh g .`
  line 40 — случай h; expected: `pair run: pass` — `bash tests/chain/pair-run.sh h .`
  line 32 — прежние проверки: `agents-test.sh`, пары a и b (под git, режим `auto`, worktree), nonstop, away (до трёх попыток), скрипт вики; expected: `agents: all ok`, `pair run: pass` дважды, `nonstop run: pass`, `away run: pass`, `script is fine` — команда из `plan-checks-stand.md`
  line 41 — вручную после вашего принятия и коммита: `./install.sh --mac`, затем `grep -l` `worktree.md`/`modes.md` по трём профилям и `ls` `dups.py`, `modes.md`; expected: три пути, затем пути `dups.py` и `modes.md`

## Technical decisions (part 2)

- Четыре новые команды `agents.sh` (`wt`, `sync`, `merge`, `drop`) и журнал ожиданий в `wait` — вместо второго скрипта.
- Код 5 «работай в общем режиме» с одной строкой причины `shared: …` — вместо текстового сообщения; подмодули — не причина.
- Слияние пишет только пути из `diff-tree`, каждый сверяет со снимком; удаляет удалённые, создаёт новые, gitlink пропускает.
- Слияние ждёт, пока живой агент держит путь захватом на запись (общий режим, срез в подмодуле).
- Ожидания замка и `wait` — в `.agents/waits.tsv`.
- `AGENTS_BEFORE_WRITE` — крючок только для теста R20.
- Игнорируемые файлы — клоном `cp -cR`: 0,62 с на 43 МБ.
- Скрипт дублей — `swork/scripts/dups.py` на `python3 -I`.
- Правила режима worktree — в новом `swork/references/worktree.md`; выбор режима, общий режим и выключатель — в новом `swork/references/modes.md`.
- Обход слитого среза — обратными диффами, не из `base/`.
- Малое изменение тоже работает в worktree.
- Выключатель — сам `agents.sh`: без `.agents/mode` команды отвечают `agents: off` и ничего не пишут; скилы продолжают вызывать его перед записью, вызов и есть проверка — вместо проверки файла в четырёх скилах (дизайн §12: «пропускать вызовы»).
- `on`, `off [--if-last]`, `mode`; `off --if-last` держит режим, пока у другого живого агента есть захват, worktree или захват после включения; вызывают его только отчёт `swork` и полное описание `saway`.
- `swork` смотрит режим перед каждым срезом; включённый посреди работы режим — общий со следующего среза, без worktree.
- В общем режиме захватывает на запись исполнитель (правило 11 по строке `AGENTS=… TOPIC=… SLICE=S<N>`), основная сессия — только карточку среза.
- «Файл, который правил сосед за шаг» — по `others --since <метка шага>`.
- `merge-tree --merge-base` есть с git 2.40 (подтверждено RelNotes 2.40.0).
- Подмодули: клон `cp -cR` без `.git`, снимки без путей подмодулей, обновление клона `rsync` при `sync`; замер: 851 МБ — клон 2,8 с, обновление 1,2 с.

## Not doing (part 2)

- Что в [scope.md](scope.md); `install.sh --mac` и коммит — ваш выбор после отчёта (строка 41).
- Нестабильная строка прогресса в проверке away и прочие хвосты части 1.
- Раннее предупреждение `merge-tree` до шага.
- Установка `mergiraf`, `ast-grep`, `jscpd`.
- Worktree для сессии, присоединившейся посреди работы; слияние правок внутри подмодуля.

## Not agreed (part 2)

- План одобрен без вас (`saway`), решения — в [away-2.md](away-2.md) и [away-3.md](away-3.md).
- Исполнитель сам выполняет команды из переданного корня — ничто не задаёт ему рабочую папку.
- Сессия `claude -p` на стенде — один процесс на весь ход, id worktree не меняется; подагенты сессии делят её id.
- Независимая проверка: 4 блокирующих замечания (pathspec снимка, порядок `on` в `agents-test.sh`, выход `id`/`mode`/`off` без режима, обход среза в общем режиме)
  и 7 существенных исправлены в карточках; второй круг подтвердил 14 исправлений и нашёл 4 недочёта в них (аргументы заглушки `mergiraf`,
  своё в журнале правок при обходе в общем режиме, имя файла сироты, выход `mode`) — исправлены, третьего круга нет.
- Не исправлено: в строке 32 `| tail -1 &&` берёт код `tail`, падение прогона не рвёт цепочку — вывод всё равно печатается и сверяется.
- Риск строки 40: если обе сессии кончат почти одновременно, каждая увидит другую живой и `.agents/mode` останется; случай h разводит их по времени третьим срезом.
- Дизайн §12 говорит «скилы пропускают вызовы `agents.sh`»; план оставляет вызовы, а скрипт отвечает `agents: off` — то же поведение R35 другим способом.
- Worktree в `.agents/wt/` с клонированными `node_modules` и подмодулями видны инструментам проекта, которые не читают `.git/info/exclude`; место задано R16.
- `dups.py` лежит в `swork/scripts/`, а не рядом с `agents.sh` в `sbrain/scripts/`, как в дизайне §8.
