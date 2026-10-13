# chain-cleanup — чистка цепочки, показ плана, скорость и перевод

> Четыре скила без конфликтов и дублей, с подробным показом плана и целиком на английском — при условии, что качество и точность не стали хуже.

**Требования подтверждены:** 2026-10-13 — цель: «четыре скила без конфликтов и дублей, с подробным показом плана и целиком на английском, при качестве не хуже»

## Карточки

- [Состояние](state.md) — фаза темы и следующий шаг
- [Задача](task.md) — что строим, для кого и как поймём, что получилось
- Требования R1–R63: [показ плана](requirements-plan-view.md) · [передача плана](requirements-handoff-plan.md) · [остановки](requirements-handoff-run.md) · [внутри скила](requirements-inner.md)
- Требования R1–R63: [чтения `splan`](requirements-readings.md) · [дубли и порядок работ](requirements-lean.md) · [замер и скорость](requirements-quality.md)
- Дизайн, разделы 1–3: [план для человека](design-plan-view.md) · [конфликты, дубли, лишнее](design-conflicts.md) · [скорость и замер](design-speed.md)
- Решения и границы: [объём и язык](decisions-scope.md) · [план, скорость и замер](decisions-design.md) · [не входит](scope-out.md) · [допущения](scope-assumptions.md)
- Перевод, язык и текст: [R64–R73](requirements-en.md) · [R74–R83](requirements-en-text.md) · [R84–R90](requirements-en-pass2.md) · [раздел 4](design-language.md) · [раздел 5](design-translation.md)
- Перевод, замер и переключение: [R91–R99](requirements-en-measure.md) · [R100–R104](requirements-en-cutover.md) · [раздел 6](design-translation-measure.md) · [раздел 7](design-cutover.md)
- Перевод, решения и границы: [решения](decisions-translation.md) · [о замере](decisions-translation-measure.md) · [английская вики](decision-english-wiki.md) · [границы](scope-translation.md)
- [План](plan.md) — цель, общие ограничения, что не делаем и правило расхождений
- Решения плана: [технические](plan-decisions.md) · [перевод](plan-decisions-en.md) · [фокус проверки](plan-decisions-focus.md) · [порядок переключения](cutover.md)
- Строки проверки 1–20: [стенд](plan-checks-stand.md) · [замер](plan-checks-measure.md) · [серия «до»](plan-checks-before.md) · [показ плана](plan-checks-view.md)
- Строки проверки 21–38: [передача](plan-checks-handoff.md) · [части](plan-checks-parts.md) · [остановки](plan-checks-run.md) · [стыки](plan-checks-joints.md)
- Строки проверки 39–58: [swork](plan-checks-inner.md) · [sbrain](plan-checks-sbrain.md) · [чтения](plan-checks-readings.md) · [формат](plan-checks-format.md)
- Строки проверки 59–77: [дубли](plan-checks-dups.md) · [лишнее](plan-checks-lean.md) · [серия «после»](plan-checks-after.md) · [усилие и цель](plan-checks-goal.md)
- Строки проверки 78–81: [время модели и токены](plan-checks-time.md) · [слепота судьи](plan-checks-blind.md)
- Строки проверки 82–131: [82–84](plan-checks-en-prep-a.md) · [85–86](plan-checks-en-prep-b.md) · [87–88, 131](plan-checks-en-tools.md) · [89–93](plan-checks-en-pass1-a.md)
- Строки проверки 82–131: [94–97](plan-checks-en-pass1-b.md) · [98–102](plan-checks-en-read-a.md) · [103–106](plan-checks-en-read-b.md) · [107–110](plan-checks-en-pass2.md)
- Строки проверки 82–131: [111–114](plan-checks-en-stand.md) · [115–117](plan-checks-en-judge.md) · [118–120](plan-checks-en-rules.md) · [121–122](plan-checks-en-probe.md)
- Строки проверки 82–131: [123–126](plan-checks-en-series.md) · [127](plan-checks-en-format-a.md) · [128–130](plan-checks-en-format-b.md)
- Срезы замера: [S20 серия «после»](plan-s20-after.md) · [S21 усилие](plan-s21-effort.md) · [S53 серия `en`](plan-s53-series-en.md) · [S54 скорость и цель](plan-s54-speed.md)
- Срезы подготовки: [S23 строки](plan-s23-lines.md) · [S24 стенд](plan-s24-stand-done.md) · [S25 состояние](plan-s25-ru-state.md) · [S26 таблица](plan-s26-tools.md)
- Первый проход: [S27](plan-s27-t-saway.md) · [S28](plan-s28-t-skills.md) · [S29](plan-s29-t-sbrain-a.md) · [S30](plan-s30-t-sbrain-b.md) · [S31](plan-s31-t-sbrain-c.md) · [S32](plan-s32-t-splan-a.md)
- Первый проход: [S33](plan-s33-t-mixed.md) · [S34](plan-s34-t-swork-a.md) · [S35](plan-s35-t-swork-b.md)
- Читатели: [S36](plan-s36-v-saway.md) · [S37](plan-s37-v-skills.md) · [S38](plan-s38-v-sbrain-a.md) · [S39](plan-s39-v-sbrain-b.md) · [S40](plan-s40-v-sbrain-c.md) · [S41](plan-s41-v-splan-a.md)
- Читатели: [S42](plan-s42-v-mixed.md) · [S43](plan-s43-v-swork-a.md) · [S44](plan-s44-v-swork-b.md)
- Второй проход: [S45 двоякие места](plan-s45-ambiguous.md) · [S46 тексты](plan-s46-pass2.md) · [S47 заготовки](plan-s47-fixtures.md) · [S48 стенд](plan-s48-stand-en.md)
- Второй проход: [S49 судья](plan-s49-judge-en.md)
- Приёмка перевода: [S50 язык](plan-s50-language.md) · [S51 проба](plan-s51-trigger.md) · [S52 кириллица](plan-s52-cyrillic.md) · [S55 формат](plan-s55-format.md)
- [Ход исполнения, часть 30](progress-30.md) — продолжение записей `swork`
- [Решено без пользователя](away.md) — решения `saway` за пользователя и что ждёт его самого
- [Решено без пользователя, часть 2](away-2.md) — продолжение: решения `saway` с вечера 2026-10-12
- [Решено без пользователя, часть 3](away-3.md) — продолжение: решения `saway` с ночи 2026-10-13
- [Готовое](00-archive.md) — срезы S1–S19 и S22 и ход исполнения до правки плана
