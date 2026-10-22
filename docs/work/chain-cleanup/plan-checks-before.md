# Check lines of topic chain-cleanup: судья и серия «до»

> Строки 9–11: вердикт судьи на пробном прогоне, серия «до» и её тексты.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 9 | R57 | следы пробного прогона отданы судье под случайной меткой → в `verdict.tsv` по строке на каждое из 12 правил `sbrain`, с одним из четырёх ответов | `B="$HOME/Documents/my/chain-stand/blind"; L=$(awk -F'\t' '$2=="smoke"{print $1}' "$B/key.tsv") && awk -F'\t' '$1=="правило" && index($2,"sbrain-")==1 && index(" да нет сомнение неприменимо "," "$3" ")>0{n++} END{print n+0}' "$B/$L/verdict.tsv"` | `12` | S4 | green 2026-10-13 |
| 10 | R56 | серия «до» → три прогона, в каждом пройдены четыре этапа и были подагенты | `B="$HOME/Documents/my/chain-stand/before"; cat "$B/done" > /dev/null && grep -c true <(jq -r .done "$B"/[123]/{brain,plan,work,seed}/stage.json) && awk '$1>0{n++} END{print n+0}' <(jq -r .agents "$B"/[123]/metrics.json)` | `12` и `3` | S5 | green 2026-10-13 |
| 11 | R63 | серия «до» шла раньше правок → её тексты равны коммиту `8655b4b`, списки правил лежат рядом с ней | `cd "$HOME/Documents/my/claude_skills" && B="$HOME/Documents/my/chain-stand/before" && T=$(mktemp -d) && git archive -o "$T/a.tar" 8655b4b sbrain splan swork saway && tar -xf "$T/a.tar" -C "$T" && for s in sbrain splan swork saway; do if ! diff -r -x .DS_Store "$T/$s" "$B/skills/$s" > /dev/null; then exit 1; fi; done; grep -c '^- ' "$B/rules.md"` | `62` | S5 | green 2026-10-13 |
