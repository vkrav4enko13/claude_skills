# S51. Проба описаний

> На русскую просьбу срабатывает тот же скил, что и до перевода описаний.

- **Status:** done
- **Covers:** R88, R89
- **Depends on:** S50
- **Files:**
  - create: `tests/chain/trigger.sh`, `tests/chain/requests.tsv`; `~/Documents/my/chain-stand/trigger/` — вне корня
  - change: поле `description` в `saway/SKILL.md`, `sbrain/SKILL.md`, `splan/SKILL.md`, `swork/SKILL.md` — только если проба разошлась
- **Interfaces:**
  - takes: вызов сессии стенда из `tests/chain/drive.sh` (функция `turn`); русские скилы в `$B/ru-state/`; `docs/work/chain-cleanup/.splan/requests.tsv` — 24 строки: просьба и ожидаемый скил
  - gives: `bash tests/chain/trigger.sh <папка скилов> <файл просьб> <файл итога>` — в файле итога строка `<просьба>⇥<скил или none>` на каждую просьбу
- **Reuse:** `tests/chain/stand.sh` кладёт скилы в `.claude/skills` проекта; `drive.sh` зовёт сессию без человека; где лежат записи сессии — заметка `docs/notes/headless-stand-probe.md`
- **What to do:**
  1. `requests.tsv` скопируй из `.splan/` побайтно.
  2. `trigger.sh` на каждую просьбу заводит пустой временный проект со скилами из названной папки, подаёт просьбу одной сессией с единственным разрешённым инструментом `Skill` и пределом в 120 секунд и берёт имя скила из первого вызова этого инструмента в записях сессии; вызова нет — `none`.
  3. Запусти фоновой командой `bash tests/chain/trigger.sh "$B/ru-state" tests/chain/requests.tsv "$B/trigger/ru.tsv"`, затем `bash tests/chain/trigger.sh . tests/chain/requests.tsv "$B/trigger/en.tsv"`.
  4. Итоги разошлись — поправь английское описание скила, на который просьба перестала попадать, и повтори второй запуск. Русских слов в описание не добавляй.
  5. Сообщения и комментарии — английские.
- **Checks:** строка 121
