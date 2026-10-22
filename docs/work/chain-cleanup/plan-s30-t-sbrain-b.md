# S30. Первый проход: `sbrain`: сводка и карточки темы

> Файлы порции 4 написаны по-английски; закреплённые строки в них пока русские, устройство то же.

- **Status:** done
- **Covers:** R70, R79, R85
- **Depends on:** S26
- **Files:**
  - change: `sbrain/references/synthesis.md`, `sbrain/references/topic-cards.md`, `sbrain/references/handoff.md`, `sbrain/references/non-software.md`
  - change: `docs/work/chain-cleanup/phrases.sh`, `docs/work/quality-tokens/phrases.sh` — значения переменных своих файлов
  - change: `tests/translate/map.tsv`, `~/Documents/my/chain-stand/translate/ambiguous.tsv` — только дописать строку
- **Interfaces:**
  - takes: правила `tests/translate/pass1.md`, таблицу `tests/translate/map.tsv`, словарь `tests/translate/glossary.tsv`; оригиналы `$B/ru-state/<тот же путь>`
  - gives: перевод порции 4 — читателю, срезу S39
- **Reuse:** `tests/translate/compare.sh --portion 4` и `tests/translate/lines.sh` проверяют перевод сами; своих проверок не пиши
- **What to do:**
  1. Переведи каждый файл порции целиком по правилам `tests/translate/pass1.md`.
  2. Оригинал читай из `$B/ru-state/`, а не из рабочего файла, и его не правь.
  3. В обоих файлах фраз замени значения переменных, над которыми назван твой файл, на тот же текст из перевода. Значение — регулярное выражение `grep` или программа `awk`: меняй в нём только русский текст, одинарных кавычек не ставь. Фразу строки «чего в тексте быть не должно» переведи так, как она звучала бы в твоём переводе. Файлы фраз — данные строк проверки, а не карточки: править их можно.
  4. Двоякое место допиши строкой в `ambiguous.tsv`; строку формата, которой нет в `map.tsv`, допиши в таблицу и назови в поле ЗАМЕЧЕНО.
- **Checks:** строка 92
