# Check lines of topic chain-cleanup: усилие и цель

> Строки 76–77: проба усилия и сквозная проверка цели.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 76 | R62 | проба усилия закончена → правило об усилии `high` стоит в тексте тогда и только тогда, когда проба принята | `cd "$HOME/Documents/my/claude_skills" && v=$(cat "$HOME/Documents/my/chain-stand/effort/verdict.txt") && if [ "$v" = accepted ]; then grep -q 'with effort .high.' swork/references/slices.md; else ! grep -q 'with effort .high.' swork/references/slices.md; fi && echo "текст согласован с пробой: $v"` | `текст согласован с пробой` | S21 | green 2026-10-13 |
| 77 | цель | все правки сделаны → качество и посев не хуже серии «после», прежние строки зелёные, кириллица только в разрешённых местах, стенд вики и вики проекта в порядке | `cd "$HOME/Documents/my/claude_skills" && E=$(cat "$HOME/Documents/my/chain-stand/en.current") && bash tests/chain/verdict.sh quality after "$E" && bash tests/chain/verdict.sh seeds after "$E" && bash tests/translate/lines.sh && bash tests/translate/cyr.sh && T=$(mktemp -d) && bash tests/make-wiki.sh "$T/wiki-trial" > /dev/null && bash tests/run-check.sh sbrain/scripts/check.sh "$T/wiki-trial" > /dev/null && bash sbrain/scripts/check.sh docs && echo "цель достигнута"` | `цель достигнута` | S54 | green 2026-10-13 |
