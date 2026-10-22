# Check lines of topic quality-tokens: S4

> Строки 16–20: готовый код в плане и узкое задание проверяющему плана.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 16 | R1 | план карточками → разведка ищет готовый код, нарезка разносит его по срезам | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p16_1" splan/references/recon.md && grep -q "$p16_2" splan/references/slicing.md && echo "готовое ищется и разносится"` | `готовое ищется и разносится` | S4 | not run |
| 17 | R2 | готовый код найден → карточка среза несёт проверенное поле «Готовое» с именем, сигнатурой и файлом | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q -F -e "$p17_1" splan/references/plan-format.md && grep -q "$p17_2" splan/references/plan-format.md && grep -q "$p17_3" splan/references/plan-format.md && echo "поле среза есть"` | `поле среза есть` | S4 | not run |
| 18 | R3 | готового для среза нет → в поле стоит «готового нет — искал: …» | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && grep -q "$p18_1" splan/references/plan-format.md && echo "случай без готового описан"` | `случай без готового описан` | S4 | not run |
| 19 | R16 | задание проверяющему плана → два пункта: утверждения о коде и места для догадок; второй круг на месте | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && awk '/^\140\140\140/{f=!f; next} f && /^[0-9]+\. /{n++} END{exit n!=2}' splan/references/review.md && grep -q "$p19_1" splan/references/review.md && grep -q "$p19_2" splan/references/review.md && grep -q "$p19_3" splan/references/review.md && echo "задание из двух пунктов"` | `задание из двух пунктов` | S4 | not run |
| 20 | R17 | пункты, снятые с проверяющего, и пункт о готовом → стоят в самопроверке, вне блока задания | `cd "$HOME/Documents/my/claude_skills" && . docs/work/quality-tokens/phrases.sh && awk "$p20_1" splan/references/review.md && echo "самопроверка дополнена"` | `самопроверка дополнена` | S4 | not run |
