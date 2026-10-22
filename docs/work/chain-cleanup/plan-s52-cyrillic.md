# S52. Кириллица — только в разрешённых местах

> Одна команда показывает, что в скилах, скриптах и заготовках стенда русский текст остался только там, где он нужен.

- **Status:** done
- **Covers:** R73
- **Depends on:** S49, S51
- **Files:**
  - create: `tests/translate/cyr.sh`, `tests/translate/cyr-allow.txt`
  - change: файлы в `saway`, `sbrain`, `splan`, `swork`, `tests` и `install.sh`, в которых нашлась кириллица вне списка
- **Interfaces:**
  - takes: `tests/translate/map.tsv`, `tests/translate/pass1.md`
  - gives: `bash tests/translate/cyr.sh [<папка>]` — печатает `cyrillic: only in allowed places`, код 0; иначе `<файл>:<номер строки>` и код 1
- **Reuse:** готового нет — искал: `tests/translate/` (`apply.sh` называет кириллицу в файле, но не знает разрешённых мест)
- **What to do:**
  1. `cyr.sh` обходит `saway`, `sbrain`, `splan`, `swork`, `tests` и `install.sh` и называет строки с кириллицей, которых нет в списке разрешённых. Кириллицу он ищет как `\p{Cyrillic}` через `perl -CSD` (без `-CSD` perl её не видит): русских букв в его тексте нет. С аргументом-папкой скрипт обходит её вместо проекта — так строка проверки убеждается, что он не слеп.
  2. `cyr-allow.txt` — по строке на место: путь либо путь и регулярное выражение строки через двоеточие. Разрешены: `tests/translate/map.tsv`, `tests/translate/glossary.tsv`, `tests/trial-summary.md`, `tests/chain/requests.tsv`; в `tests/chain/drive.sh` — первые запросы и ответы этапов; сам `tests/translate/cyr-allow.txt`; в `tests/make-wiki.sh`, `tests/chain/seed.sh` и `tests/chain/seeds.md` — данные задач: слова `app.txt`, `карточка`, литерал «слов», алфавит `letters`, карточка на 2000 букв и строка в 150 знаков.
  3. Нашлась кириллица вне списка — это недоделка прежнего среза: переведи её по таблице и `pass1.md`; список разрешённого не расширяй.
  4. Сообщения и комментарии — английские.
- **Checks:** строка 122
