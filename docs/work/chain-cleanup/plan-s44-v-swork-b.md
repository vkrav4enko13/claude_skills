# S44. Читатель: `swork`: снимок, отчёт, упрощение, ревью

> Перевод порции 9 сверен с оригиналом правило за правилом тем, кто перевода не делал.

- **Status:** done
- **Covers:** R83
- **Depends on:** S35
- **Files:**
  - change: `swork/references/snapshot.md`, `swork/references/snapshot-powershell.md`, `swork/references/report.md`, `swork/references/simplify.md`, `swork/references/review.md` — только исправления
  - change: `docs/work/chain-cleanup/phrases.sh`, `docs/work/quality-tokens/phrases.sh`, `~/Documents/my/chain-stand/translate/ambiguous.tsv`
  - create: `~/Documents/my/chain-stand/translate/review-9.tsv` — вне корня
- **Interfaces:**
  - takes: оригиналы `$B/ru-state/<тот же путь>`; правила `tests/translate/pass1.md`; таблицу `tests/translate/map.tsv`; словарь `tests/translate/glossary.tsv`
  - gives: `review-9.tsv` — на каждый файл строка `<путь>⇥checked⇥<сверено правил>⇥<исправлено>`, на каждое исправление строка `<путь>⇥fixed⇥<что было не так>`; ⇥ — табуляция
- **Reuse:** `tests/translate/compare.sh --portion 9 --reviewed` и `tests/translate/lines.sh`; своих проверок не пиши
- **What to do:**
  1. По каждому файлу порции прочитай оригинал и перевод рядом и сверь правило за правилом: ни одно не потеряно, не добавлено, не стало мягче или жёстче («никогда», «только», «всегда», «не больше»), порядок шагов тот же, термины — по словарю.
  2. Найденное исправь в переводе по `tests/translate/pass1.md`; закреплённые строки оставь русскими, устройство файла не меняй.
  3. Запиши отчёт `review-9.tsv`. Исправил фразу, на которую смотрит строка проверки, — поправь значение её переменной в файлах фраз.
  4. Двоякое место, которого ещё нет в `ambiguous.tsv`, допиши строкой.
- **Checks:** строка 106
