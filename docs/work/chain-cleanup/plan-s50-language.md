# S50. Правила о языке стоят в текстах скилов

> Скил отвечает пользователю на его языке, а в файлы и подагентам пишет по-английски; каждый `SKILL.md` — не больше 5 000 токенов.

- **Status:** done
- **Covers:** R64, R65, R66, R67, R68, R69, R82, R87
- **Depends on:** S46
- **Files:**
  - change: `saway/SKILL.md`, `sbrain/SKILL.md`, `splan/SKILL.md`, `swork/SKILL.md` (строка 11)
  - change: `sbrain/references/wiki-rules.md`, `sbrain/references/topic-cards.md`, `splan/references/plan-format.md`, `splan/references/review.md`, `swork/references/executor.md`, `swork/references/conformance.md`, `swork/references/review.md`, `swork/references/simplify.md`
- **Interfaces:**
  - takes: английские тексты скилов после S46
  - gives: правило о языке — одной и той же фразой в четырёх `SKILL.md`
- **Reuse:** готового нет — искал: правило о языке стоит одной фразой в строке 11 каждого `SKILL.md`, в `references/` его нет
- **What to do:**
  1. В каждом `SKILL.md` предложение о языке пользователя замени на ⟦Talk to the user in their language: chat messages, menus, reports and the plan shown for approval. Option labels and section names that this skill gives in English are shown to the user in their language. Everything written to files and to subagents is in English, and subagents are asked to reply in English.⟧
  2. `wiki-rules.md`, раздел о записи, пункт о том, что пишет только основная сессия, — допиши в конец ⟦ Write wiki cards in English, both the format and the content. Words of the user are recorded in English translation. Cards written earlier in another language are read as they are and are not translated.⟧
  3. `plan-format.md`, абзац о том, как пишется обзор плана, — допиши в конец ⟦ Write the prose of the overview in the language of the user; slice numbers, statuses, field names, paths and commands stay exactly as in the slice cards.⟧
  4. В пяти заданиях подагентам — `splan/references/review.md`, `swork/references/executor.md`, `conformance.md`, `review.md` и общая шапка двух заданий в `simplify.md` — вставь после первого предложения задания ⟦ Reply in English.⟧
  5. `topic-cards.md`, шаблон карточки решения: подстановка слов пользователя — ⟦<the words of the user in English translation>⟧; предложение под шаблоном о том, что слова пользователя пишутся дословно, замени на ⟦Words of the user are given in English translation, close to the original, without retelling.⟧
  6. Новых пунктов списка, строк таблиц и заголовков не заводи: счёт `compare.sh` должен остаться прежним.
- **Checks:** строки 118, 119, 120
