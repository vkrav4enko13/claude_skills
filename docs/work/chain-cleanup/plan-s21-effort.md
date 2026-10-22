# S21. Проба усилия для срезов с готовым текстом

> Исполнитель среза с готовым текстом идёт на усилии `high`, если проба показала те же проверки и меньше минут; иначе правило в текст не попадает.

- **Status:** done
- **Covers:** R62
- **Depends on:** S53
- **Files:**
  - change: `tests/chain/verdict.sh`, `swork/references/slices.md` (раздел 3, шаг 3), `splan/references/plan-format.md` (шаблон среза и правила среза), `docs/work/chain-cleanup/phrases.sh`, `docs/work/quality-tokens/phrases.sh`
  - create: `~/Documents/my/chain-stand/effort/` — вне корня проекта
- **Interfaces:**
  - takes: строку шаблона среза о пометках и пункт о пометках — от S9; `series.sh … --stages seed` и поля `seed_first_agent_min`, `seed_first_agent_effort` в `metrics.json` — от S3; срез S3 темы `longest` с пометкой `ready text` — от S47; `$B/en.current` — от S53
  - gives: `verdict.sh effort <серия> <серия пробы>`; `$B/effort/verdict.txt` — слово `accepted` либо `rejected`
- **Reuse:** параметр усилия у инструмента запуска подагентов — в Claude Code 2.1.292 и новее; `tests/chain/series.sh` проводит пробу; разбор серий — уже в `tests/chain/verdict.sh`
- **What to do:**
  1. `verdict.sh` — новый режим `effort <серия> <серия пробы>`: пишет в `$B/<серия пробы>/verdict.txt` слово `accepted` либо `rejected` и печатает ⟦effort high: <слово>⟧, код 0 в обоих случаях. `accepted` — когда в каждом прогоне пробы этап `seed` пройден, `seed_first_agent_effort` — `high`, в `progress.md` темы `longest` нет записи `S3: attempt`, а сумма `seed_first_agent_min` меньше, чем в названной серии. Нет серии — ⟦no measurement: <чего не хватает>⟧, код 1. Прежние режимы `quality`, `seeds` и `speed` не трогай.
  2. `slices.md`, раздел 3, шаг 3 — допиши в конец ⟦ For a slice marked `ready text`, launch the executor with effort `high`, using the effort parameter of the subagent launch tool; if there is no such parameter, at the session level. Conformance and review reviewers and all other subagents run at the session level.⟧
  3. `plan-format.md`: строку шаблона среза о пометках замени на ⟦- **Marks:** no behavior change; ready text⟧; к пункту о пометках допиши ⟦ `ready text` — for a slice whose "What to do" gives the text of every edit verbatim.⟧
  4. Запусти `bash tests/chain/series.sh effort . --stages seed` фоновой командой и дождись её конца; затем `bash tests/chain/verdict.sh effort "$(cat "$B/en.current")" effort`.
  5. Вердикт `rejected` — убери тексты шагов 2 и 3 и верни прежние строки. В ответе приведи строку вердикта и суммы минут первого подагента этапа `seed` в обеих сериях.
  6. Серию на английских текстах не повторяй; остальные скрипты стенда не правь. Новых строк и пунктов в текстах скилов не заводи: только дописывай в названные.
- **Checks:** строка 76
