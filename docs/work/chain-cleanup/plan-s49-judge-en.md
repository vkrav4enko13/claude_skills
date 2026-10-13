# S49. Судья — английский: те же номера правил, правило о языке, прежние вердикты читаются

> Судья сверяет серию по тем же 62 правилам и трём новым о языке; вердикты прежних серий считаются так же, как раньше.

- **Статус:** готов
- **Закрывает:** R93, R94, R95
- **Зависит от:** S48
- **Файлы:**
  - изменить: `tests/chain/rules.md`, `tests/chain/judge-prompt.md`, `tests/chain/judge.sh`, `tests/chain/verdict.sh`, `docs/work/chain-cleanup/phrases.sh`, `docs/work/quality-tokens/phrases.sh`
- **Интерфейсы:**
  - берёт: `tests/translate/map.tsv`, область `stand`, вид `judge`; словарь `tests/translate/glossary.tsv` и правила `tests/translate/pass1.md` — слова начала требования «Когда», «Пока», «Если», «Где» переводятся по словарю; оригинал списков `$B/ru-state/tests/chain/rules.md`
  - отдаёт: `verdict.tsv` новой серии — словами `rule`, `seed`, `yes`, `no`, `unsure`, `not applicable`, `found`, `not found`; вызов `verdict.sh quality|seeds|speed <до> <после>` прежний, строка вердикта — `violations: before <a>, after <b> — not more` и так же для остальных
- **Готовое:** `verdict.sh` уже считает строки вердикта функцией `tally`; `tests/translate/apply.sh`
- **Что сделать:**
  1. `rules.md`: переведи 62 правила один к одному, номера те же; закреплённые строки — английские по таблице; названия разделов отчёта и подписей меню пиши по-английски с пометкой `(in the user's language)`; после тире оставь путь и номер строки как в оригинале.
  2. Допиши три правила с одним текстом — `sbrain-13`, `splan-26`, `swork-26`: ⟦Replies to the user in the chat are in the language the user writes in; wiki cards, their format strings, and tasks to and replies from subagents are in English; the prose of the plan overview is in the language of the user.⟧ После текста — тире и место, как у остальных правил: `sbrain/SKILL.md:11`, `splan/SKILL.md:11`, `swork/SKILL.md:11`.
  3. `judge-prompt.md`: переведи руками; слова ответа — из таблицы, область `stand`; о переводе и о том, какая серия новая, в задании ни слова.
  4. `verdict.sh` считает английские слова; слово прежнего вердикта сначала переводит по строкам таблицы области `stand` вида `judge`. Архив `$B/blind/` не правь.
  5. `judge.sh` и `verdict.sh`: сообщения и комментарии — английские по таблице; в файлах фраз — значения переменных, над которыми названы эти файлы.
- **Проверки:** строки 115, 116, 117
