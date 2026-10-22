# Check lines of topic chain-cleanup: судья

> Строки 115–117: судья.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 115 | R93, R95 | списки судьи переведены → номера 62 прежних правил те же, добавлены три правила о языке | `cd "$HOME/Documents/my/claude_skills" && O="$HOME/Documents/my/chain-stand/ru-state/tests/chain/rules.md" && [ "$(grep -oE '^- (sbrain|splan|swork)-[0-9]+\.' "$O" |sort |tr -d '\n')" = "$(grep -oE '^- (sbrain|splan|swork)-[0-9]+\.' tests/chain/rules.md |grep -vE 'sbrain-13|splan-26|swork-26' |sort |tr -d '\n')" ] && grep -cE '^- (sbrain-13|splan-26|swork-26)\. ' tests/chain/rules.md` | `3` | S49 | green 2026-10-13 |
| 116 | R94 | задание судье → о переводе и о русском языке в нём ни слова | `cd "$HOME/Documents/my/claude_skills" && ! grep -qiE 'translat|russian' tests/chain/judge-prompt.md && echo "о переводе ни слова"` | `о переводе ни слова` | S49 | green 2026-10-13 |
| 117 | R93 | вердикты прежних серий записаны русскими словами → `verdict.sh` считает их так же: нарушений 9 и 6, посев 15 и 15 | `cd "$HOME/Documents/my/claude_skills" && bash tests/chain/verdict.sh quality before after |grep -q 'before 9, after 6' && bash tests/chain/verdict.sh seeds before after |grep -q 'before 15, after 15' && bash tests/translate/lines.sh > /dev/null && echo "счёт прежний"` | `счёт прежний` | S49 | green 2026-10-13 |
