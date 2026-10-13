# Строки проверки темы chain-cleanup: серия на английских текстах

> Строки 123–126: серия на английских текстах.

| № | Требование | Сценарий | Команда | Ожидаемое | Срез | Результат |
|---|---|---|---|---|---|---|
| 123 | R93 | серия на английских текстах → три прогона, в каждом засчитаны четыре этапа и были подагенты | `R="$HOME/Documents/my/chain-stand"; E="$R/$(cat "$R/en.current")"; cat "$E/done" > /dev/null && grep -c true <(jq -r .done "$E"/[123]/{brain,plan,work,seed}/stage.json) && awk '$1>0{n++} END{print n+0}' <(jq -r .agents "$E"/[123]/metrics.json)` | `12` и `3` | S53 | зелёная 2026-10-13 |
| 124 | R95 | судья сверил три прогона серии → у каждого ответ по 65 правилам, включая три о языке, и по пяти дефектам | `R="$HOME/Documents/my/chain-stand"; S=$(cat "$R/en.current"); LC_ALL=C awk -F'\t' '$1=="rule"{n++} $1=="seed"{m++} END{print n+0, m+0}' $(for L in $(LC_ALL=C awk -F'\t' -v s="$S" '$2==s{print $1}' "$R/blind/key.tsv"); do echo "$R/blind/$L/verdict.tsv"; done)` | `195 15` | S53 | зелёная 2026-10-13 |
| 125 | R91, R96, R97 | нарушения правил в серии на английских текстах → их не больше, чем в серии «после» | `cd "$HOME/Documents/my/claude_skills" && bash tests/chain/verdict.sh quality after "$(cat "$HOME/Documents/my/chain-stand/en.current")" > /dev/null && echo "не больше"` | `не больше` | S53 | зелёная 2026-10-13 |
| 126 | R96 | посеянные дефекты в серии на английских текстах → найдено не меньше, чем в серии «после» | `cd "$HOME/Documents/my/claude_skills" && bash tests/chain/verdict.sh seeds after "$(cat "$HOME/Documents/my/chain-stand/en.current")" > /dev/null && echo "не меньше"` | `не меньше` | S53 | зелёная 2026-10-13 |
