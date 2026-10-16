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

## S6. Приёмка двух агентов сразу — awaiting manual check

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
