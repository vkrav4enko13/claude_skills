# claude_skills

> Личные скилы для Claude Code и Codex.

## In progress



## Deferred

- manual check of topic multi-agent: line 12 — until the user says so (install to the Mac profiles)
- topic `quality-zero`: zero judge violations over the four skills — after `multi-agent`; answers given — [scope](work/multi-agent/scope.md)
- `quality-zero`: a `swork` reviewer ran `rm -rf` on `$TMPDIR/tmp.*` — [note](notes/stand-nonstop-parallel.md)
- `quality-zero`: stand sessions skip plain rules — a free-text stage-7 record, a `saway` reply without progress line — [log](work/multi-agent/progress-2.md)
- публикация скилов другим — когда-нибудь; потребует чистки личных путей
- пробные задачи из настоящих сбоев цепочки в стенд `tests/` — идея из плейбука Anthropic, вне темы `quality-tokens`
- хук, запрещающий править тесты во время починки, вместо одного правила в тексте `swork` — идея из плейбука Anthropic, вне темы `quality-tokens`
- `saway`: исправления последнего чтения не перечитаны, прогона под `/goal` не было, повод спорит с `lfg` из плагина — [заметка](notes/saway-sources.md)
- `state.sh restore` сотрёт 11 файлов `tests/` вне git, `verdict.sh` не проверяет форму вердикта судьи — нужна правка плана — [находки ревью](work/chain-cleanup/progress-29.md)
- «откатить всё» в `report.md` не возвращает «Следующий шаг»; без журнала `splan` неоткуда взять цель — нужна правка плана — [отсев ревью](work/chain-cleanup/progress-30.md)
- `saway`: four review findings left untouched — each needs a plan fix and a new stand run — [findings](work/saway-nonstop/progress-5.md)
- chain-tokens R12: reviewers read skill files — 2.9 % of a run's output, below 3 %
- chain-tokens R16: the plan shown twice, file and chat — 1.7 % of a run's output, below 3 %
- chain-tokens R20: the full task for a second review round — 1.6 % of a run's output, below 3 %
- chain-tokens R13: the main session reads whole task files — 1.5 % of a run's output, below 3 %
- chain-tokens R15: the plan overview rewritten after the review — 0.7 % of a run's output, below 3 %
- chain-tokens R18: saway shows to an absent user — 0.0 % of a run's output, below 3 %
- chain-tokens R14: the wiki rules read once per session — 0.0 % of a run's output, below 3 %

## Sections

- [Правила проекта](rules.md) — decisions and answers that hold for the whole project
- [Журнал](journal/) — a line per task, a file per month
- [Темы](work/00-index.md) — topic folders
- [Заметки](notes/00-index.md) — facts that cannot be recovered from the code
