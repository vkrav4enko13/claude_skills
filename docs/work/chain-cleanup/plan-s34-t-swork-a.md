# S34. Первый проход: `swork`: срезы, завершение, исполнитель, сверка

> Файлы порции 8 написаны по-английски; закреплённые строки в них пока русские, устройство то же.

- **Status:** done
- **Covers:** R70, R79, R85
- **Depends on:** S26
- **Files:**
  - change: `swork/references/slices.md`, `swork/references/finish.md`, `swork/references/executor.md`, `swork/references/conformance.md`
  - change: `docs/work/chain-cleanup/phrases.sh`, `docs/work/quality-tokens/phrases.sh` — значения переменных своих файлов
  - change: `tests/translate/map.tsv`, `~/Documents/my/chain-stand/translate/ambiguous.tsv` — только дописать строку
- **Interfaces:**
  - takes: правила `tests/translate/pass1.md`, таблицу `tests/translate/map.tsv`, словарь `tests/translate/glossary.tsv`; оригиналы `$B/ru-state/<тот же путь>`
  - gives: перевод порции 8 — читателю, срезу S43
- **Reuse:** `tests/translate/compare.sh --portion 8` и `tests/translate/lines.sh` проверяют перевод сами; своих проверок не пиши
- **What to do:**
  1. Переведи каждый файл порции целиком по правилам `tests/translate/pass1.md`.
  2. Оригинал читай из `$B/ru-state/`, а не из рабочего файла, и его не правь.
  3. В обоих файлах фраз замени значения переменных, над которыми назван твой файл, на тот же текст из перевода. Значение — регулярное выражение `grep` или программа `awk`: меняй в нём только русский текст, одинарных кавычек не ставь. Фразу строки «чего в тексте быть не должно» переведи так, как она звучала бы в твоём переводе. Файлы фраз — данные строк проверки, а не карточки: править их можно.
  4. Двоякое место допиши строкой в `ambiguous.tsv`; строку формата, которой нет в `map.tsv`, допиши в таблицу и назови в поле ЗАМЕЧЕНО.
- **Checks:** строка 96
