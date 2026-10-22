# S47. Заготовки стенда — английские

> Стенд вики и посев строят карточки в английском формате и с английским текстом; задачи и посеянные дефекты те же.

- **Status:** done
- **Covers:** R65, R71, R93
- **Depends on:** S46
- **Files:**
  - change: `tests/make-wiki.sh`, `tests/chain/seed.sh`, `tests/chain/seeds.md`, `tests/run-check.sh`, `tests/plan-lines.sh`, `docs/work/chain-cleanup/phrases.sh`, `docs/work/quality-tokens/phrases.sh`
- **Interfaces:**
  - takes: `tests/translate/apply.sh`, `tests/translate/map.tsv`, `tests/translate/pass1.md`, `tests/translate/glossary.tsv`
  - gives: заготовки вики в английском формате — теми же строками таблицы, что пишут скилы
- **Reuse:** `tests/translate/apply.sh` — замена строк формата; `tests/run-check.sh` — проверка стенда вики
- **What to do:**
  1. `make-wiki.sh`, `seed.sh`, `seeds.md`: сначала переведи текст карточек, сообщения и комментарии по `pass1.md` и словарю, оставив закреплённые строки русскими; затем запусти `apply.sh --scope skills --scope old` — на русском тексте короткие строки таблицы режут слова. Строки «Путь» и «Проверено» в заготовках `state.md` заменит область `old`.
  2. Данные задач не переводи: слова `app.txt` и ожидаемые `карточка`, `карточка 1`, литерал «слов», функцию `letters` с её алфавитом, карточку на 2000 букв и строку в 150 знаков. На них держатся посеянный дефект о длине в байтах и проверка счёта в знаках.
  3. `seed.sh` ищет в корневом индексе заголовок раздела «В работе» (строка 113): после замены это тот же английский заголовок, который пишет `make-wiki.sh`.
  4. `run-check.sh` и `plan-lines.sh`: сообщения и комментарии переведи руками, слова бери из таблицы, область `stand`; ручную строку `plan-lines.sh` узнаёт по `checked manually`.
  5. В файлах фраз меняй значения только тех переменных, над которыми назван файл этого среза.
- **Checks:** строки 111, 112
