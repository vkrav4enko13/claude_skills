# S48. Скрипты стенда — английские; первые запросы называют язык

> Водитель узнаёт английские фазы и статусы, а первый запрос каждого этапа содержит русские слова, по которым скил выбирает язык ответа.

- **Status:** done
- **Covers:** R71, R72, R93
- **Depends on:** S47
- **Files:**
  - change: `tests/chain/drive.sh`, `tests/chain/collect.sh`, `tests/chain/series.sh`, `tests/chain/measure.sh`, `tests/chain/stand.sh`, `install.sh`, `docs/work/chain-cleanup/phrases.sh`, `docs/work/quality-tokens/phrases.sh`
- **Interfaces:**
  - takes: `tests/translate/apply.sh`, `tests/translate/map.tsv` — области `skills` и `stand`
  - gives: вызовы скриптов прежние; `collect.sh` пишет в следы заголовки `## Request`, `## Reply`, `## Task`, `## Last reply`
- **Reuse:** `tests/translate/apply.sh`
- **What to do:**
  1. `collect.sh`: сначала переведи сообщения и комментарии, затем запусти `apply.sh --scope skills --scope stand` — фазы, статусы и запись «этап 7 закончен» станут английскими строками таблицы. `drive.sh` правь руками, `apply.sh` на нём не запускай: в нём ответы пользователя, и слово «да» в них остаётся русским.
  2. Первые запросы этапов `plan`, `work` и `seed` замени на ⟦/splan count — спланируй тему⟧, ⟦/swork count — исполни план⟧, ⟦/swork longest — продолжи работу⟧. Запрос этапа `brain`, ответы этапов и `tests/trial-summary.md` не трогай: это сторона пользователя.
  3. `series.sh`, `measure.sh`, `stand.sh`, `install.sh`: сообщения и комментарии — английские; у `install.sh` — и примечание для ПК в подстановке `{{NOTE}}`.
  4. В файлах фраз меняй значения только тех переменных, над которыми назван файл этого среза.
- **Checks:** строки 113, 114
