# Check lines of topic chain-cleanup: лишнее

> Строки 65–69: мёртвые поля, чтение этапов, PowerShell, пачки.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 65 | R49 | карточки темы и плана → скилы не пишут строк «Путь», «Проверено» и «Требования подтверждены» | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && ! grep -rq -e "$p65_1" -e "$p65_2" -e "$p65_3" -e "$p65_4" -e "$p65_5" sbrain splan swork saway && echo "мёртвых строк нет"` | `мёртвых строк нет` | S19 | green 2026-10-13 |
| 66 | R51 | файл этапа `swork` → читается один раз за прогон, перечитывается только без текста в контексте | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p66_1" swork/references/snapshot.md && grep -q "$p66_2" swork/references/slices.md && echo есть` | `есть` | S19 | green 2026-10-13 |
| 67 | R52 | команды PowerShell → лежат отдельным файлом, перенесены дословно | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && T=$(mktemp -d) && git show 8655b4b:swork/references/snapshot.md > "$T/old" && ! grep -q 'Get-ChildItem' swork/references/snapshot.md && diff <(sed -n '/Set-Content/,/^Remove-Item -Recurse/p' "$T/old" |grep -v '^#' |sed 's/"[^"]*: \$LASTEXITCODE"/X/') <(sed -n '/Set-Content/,/^Remove-Item -Recurse/p' swork/references/snapshot-powershell.md |grep -v '^#' |sed 's/"[^"]*: \$LASTEXITCODE"/X/') && grep -q "$p67_1" swork/references/snapshot.md && echo "перенос дословный"` | `перенос дословный` | S19 | green 2026-10-13 |
| 68 | R53 | разведка подагентами → запускаются одним сообщением | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p68_1" splan/references/recon.md && echo есть` | `есть` | S19 | green 2026-10-13 |
| 69 | R54 | вопросы на пробелы и согласие по разделам дизайна → пачкой и одним запросом | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && grep -q "$p69_1" sbrain/references/survey.md && grep -q "$p69_2" sbrain/references/approaches.md && echo есть` | `есть` | S19 | green 2026-10-13 |
