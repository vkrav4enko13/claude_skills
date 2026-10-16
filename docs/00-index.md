# claude_skills

> Личные скилы для Claude Code и Codex.

## In progress

## Deferred

- manual check of topic quality-zero: lines 17, 18 — until the user says so
- `multi-agent`: an early finish between a neighbour's `done` and claim, `.agents/` clashing with a repo folder — outside `quality-zero` · [log](work/multi-agent/progress-3.md)
- публикация скилов другим — когда-нибудь; потребует чистки личных путей
- пробные задачи из настоящих сбоев цепочки в стенд `tests/` — идея из плейбука Anthropic, вне темы `quality-tokens`
- хук, запрещающий править тесты во время починки, вместо одного правила в тексте `swork` — идея из плейбука Anthropic, вне темы `quality-tokens`
- `saway`: no run under `/goal` — needs the user live; outside `quality-zero`
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
