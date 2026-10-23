# Plan overview of topic chain-speed

> The plan as one file for reading; the source is the slice cards: where they differ, the card is right.

- **Goal:** the LGS speed levers in the chain, quality not worse

## S1. Reduced stand — done

Серия темы гоняет только дорожки, которые задевают рычаги, и новую малую дорожку `small`.

- **Files:** create `tests/chain/cs-stages.txt`, `tests/chain/seed-small.sh`; change `tests/chain/series.sh`, `tests/chain/drive.sh`, `tests/chain/collect.sh`
- **Depends on:** none
- **Steps:**
  сначала строки 10 и 18: `multi-agent` не закрыта или на стенде нет нужного файла → стоп; затем перепроверить номера строк;
  `cs-stages.txt` — одна строка набора дорожек;
  `seed-small.sh` — чистый проект, `count.sh` и тема `docs/work/count-q/` на `requirements confirmed` с одним требованием про `-q`; `saway` ведёт её через `splan` и `swork`;
  дорожка пройдена, если в последнем ответе `saway: work finished`, а `count.sh -q` на копии даёт 0 на пустом и 1 на непустом `app.txt`.
- **Checks:** line 1 — набор дорожек в одном файле; expected: `brain plan work seed survey grill away trap-reuse trap-native small`
  line 2 — один прогон малой дорожки; expected: `"done": true`
  line 10 — `multi-agent` закрыта; expected: `done`
  line 18 — стенд цел после закрытия `multi-agent`; expected: ловушки в `series.sh`, все нужные файлы на месте

  ```
  bash tests/chain/series.sh cs-small "$PWD" --runs 1 --stages "small"
  ```

## S2. Stand tools — done

Стенд проверяет результат `count.sh`, сравнивает две серии парным судьёй и считает субагентов по ролям.

- **Files:** create `tests/chain/count-check.sh`, `tests/chain/fixtures/count-good/count.sh`, `tests/chain/fixtures/count-words/count.sh`, `tests/chain/pair-judge.sh`, `tests/chain/pair-judge-prompt.md`, `tests/chain/levers-check.sh`; change `tests/chain/compare.sh`, `tests/chain/compare-test.sh`
- **Depends on:** S1
- **Steps:**
  `count-check.sh` — копия во временную папку; 3 строки по 6 слов → `3`, пустой → `0`, `-v` → `3 слов`;
  `levers-check.sh` — `role_of` из `trace.sh`, все стадии каждого прогона, роли: исполнитель, проход, второй раунд, ревьюер плана, субагент этапа;
  `pair-judge.sh` — слепое A/B по дорожкам, которые есть в обеих сериях, только качество; карта «дорожка → что читать»;
  `compare.sh` печатает строки ловушек и для отдельных `trap-<name>`.
- **Checks:** lines 3, 4 — верный и неверный `count.sh`; line 5 — судья на `qz-r2`/`qz-r3`; line 6 — счёт ролей на `qz-r2`

## S3. Skills check — done

Скрипт без модели проверяет ссылки, цитируемые заголовки, цитаты правил судьи и строки, которые ищет стенд.

- **Files:** create `tests/skills-check.sh`; change `tests/chain/rules.md`, `tests/chain/rules-survey.md`
- **Depends on:** S1
- **Steps:** три формы цитаты заголовка; цитата правила — ≥ 2 общих слова с правилом в строке ±1; скрипт сам печатает устаревшие цитаты, номер правится, текст правила — нет.
- **Checks:** line 7 — `skills ok`; lines 8, 9 — сломанный заголовок и пропавший литерал → названы, exit 1

## S4. The "before" series — done

Текущие скилы меряются один раз на облегчённом стенде.

- **Files:** create `docs/work/chain-speed/numbers.md`
- **Depends on:** S1, S2, S3
- **Steps:** копия скилов в `cs-snap/before` (база откатов); размеры скилов без трёх файлов вики; серия `cs-before` из 2 прогонов; `zero.sh` (провал на `nonstop`/`pair` ожидаем); в `## Before` — время, выходные токены и стоимость на прогон, нарушения, `count`, роли.
- **Checks:** line 11 — серия прошла, цифры записаны

## S5. swork levers — done

Один проход 5–7 только при коде, малые срезы делает сама сессия, записи пачкой, при продолжении перепроверяется только изменённое.

- **Files:** change `swork/SKILL.md`, `swork/references/{finish,review,simplify,conformance,report,slices,executor,entry,small}.md`, `tests/chain/rules.md` (swork-1, 2, 3, 4, 6, 8, 11, 12, 14, 17, 19)
- **Depends on:** S4
- **Steps:** R7–R11 по образцу игровой цепочки; `stage 7 finished` пишется и при пропуске; полный перепрогон перед стадией 5 остаётся; фразы рычагов и описания субагента прохода — слово в слово.
- **Checks:** line 12 — четыре фразы найдены, `skills ok`

## S6. splan and saway levers — done

Ревьюер плана только на большом плане, строка проверки может покрывать несколько требований, малая работа `saway` идёт в своей сессии.

- **Files:** change `splan/SKILL.md`, `splan/references/{approval,review,slicing,plan-format}.md`, `saway/SKILL.md`, `tests/chain/rules.md` (splan-8, 22, 23; saway-9)
- **Depends on:** S4
- **Steps:** большой план — больше трёх срезов или срез большого кода; малая работа — путь «Small», план из чата, нет папки темы или тема до пяти требований с не большим планом.
- **Checks:** line 13 — три фразы найдены, `skills ok`

## S7. Slim the four skills — done

Каждый скил говорит то же на 30–40 % меньше байт.

- **Files:** change все `.md` четырёх скилов, кроме `wiki-rules.md`, `wiki-block.md`, `wiki-migrate.md`; цитаты в правилах судьи
- **Depends on:** S5, S6
- **Steps:** итерация 1 — повторы, «почему», лишние ловушки; итерация 2 — противоречия и устаревшие ссылки; итерация 3 — только если размер выше 70 %; слово в слово остаются литералы стенда и фразы рычагов; после каждой — `skills-check` и тесты без модели.
- **Checks:** line 14 — размеры 60–70 % от S4, `skills ok`

## S8. Ponytail ideas — bypassed

Лестница кода у исполнителя, читаемость в упрощении, порог доказательства в ревью.

- **Files:** change `swork/references/{executor,simplify,review}.md`
- **Depends on:** S7
- **Steps:** только из `docs/work/ponytail-lean/ideas.md`; валидация, обработка ошибок и просьбы плана не урезаются; фразы строки 15 слово в слово.
- **Checks:** line 15 — три фразы найдены, `skills ok`

## S9. The final series — done

Серия «после» доказывает экономию и что качество не просело, или называет, что откатить.

- **Files:** change `docs/work/chain-speed/numbers.md`
- **Depends on:** S8
- **Steps:** серия `cs-after` из 2 прогонов; всё по R15 → `accepted`; качество хуже → откат R13 → R8 → R9 → остальное правкой к поведению `cs-snap/before`, не больше двух доп. серий, потом `stopped`; экономия < 20 % → `threshold not met`.
- **Checks:** line 16 — время и выходные токены ≤ 80 %, нарушений ≤, парный судья не хуже, `count ok` дважды, рычаги видны в ролях; line 17 — итог записан

## Technical decisions

- Набор дорожек в одном файле; `stage 7 finished` пишется и при пропуске прохода; роли — по следам прогона.
- Парный судья на схеме `judge.sh`; токены R15 — выходные, на прогон; откат рычага — правкой к поведению копии `cs-snap/before`.
- Сначала рычаги поведения, потом сжатие; цитаты правил проверяются по словам правила.

## Not doing

- Не трогаем `docs/rules.md`, карточки `multi-agent`, выброшенные дорожки, три файла вики `sbrain`; не переименовываем файлы заданий `swork`; `install.sh` не запускаем; не коммитим.

## Not agreed

- `judge.sh` не судит дорожки `small` и ловушки: их качество покрывают только парный судья и проверки результата.
