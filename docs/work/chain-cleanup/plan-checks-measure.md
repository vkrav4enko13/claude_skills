# Check lines of topic chain-cleanup: замер и вердикт

> Строки 5–8: поля замера, вердикт на ухудшении и без данных, списки правил.

| No. | Requirement | Scenario | Command | Expected | Slice | Result |
|---|---|---|---|---|---|---|
| 5 | R61 | прогон стенда закончен → в `metrics.json` минуты по часам, минуты модели, токены и число запусков подагентов | `jq -r '"\(.wall_min > 0) \(.model_min > 0) \(.tokens_in > 0) \(.tokens_out > 0) \(.agents >= 0)"' "$HOME/Documents/my/chain-stand/smoke/1/metrics.json"` | `true true true true true` | S3 | green 2026-10-13 |
| 6 | R60 | у прогона «после» нарушений больше, а посев найден реже, чем у «до» → оба вердикта говорят «хуже» и кончаются кодом 1 | `cd "$HOME/Documents/my/claude_skills" && . docs/work/chain-cleanup/phrases.sh && T=$(mktemp -d) && mkdir -p "$T/blind/a" "$T/blind/b" && printf 'a\tx\t1\nb\ty\t1\n' > "$T/blind/key.tsv" && printf "$p6_1" > "$T/blind/a/verdict.tsv" && printf "$p6_2" > "$T/blind/b/verdict.tsv" && { CHAIN_BASE="$T" bash tests/chain/verdict.sh quality x y; q=$?; CHAIN_BASE="$T" bash tests/chain/verdict.sh seeds x y; s=$?; echo "коды: $q $s"; [ "$q $s" = "1 1" ]; }` | `коды: 1 1` | S3 | green 2026-10-13 |
| 7 | R55 | нет ни ключа, ни вердиктов судьи → вердикт говорит «замера нет», а не «не больше» | `cd "$HOME/Documents/my/claude_skills" && T=$(mktemp -d) && { CHAIN_BASE="$T" bash tests/chain/verdict.sh quality x y; c=$?; echo "код: $c"; [ $c -eq 1 ]; }` | `код: 1` | S3 | green 2026-10-13 |
| 8 | R57 | списки правил записаны → 12 правил `sbrain`, 25 — `splan`, 25 — `swork`, у каждого файл и строка | `cd "$HOME/Documents/my/claude_skills" && c=$(awk '/^## /{s=$2} /^- (sbrain-13|splan-26|swork-26)\./{next} /^- [a-z]+-[0-9]+\. .* — [a-z].*:[0-9]+$/{n[s]++} END{print n["sbrain"]+0, n["splan"]+0, n["swork"]+0}' tests/chain/rules.md) && echo "$c" && [ "$c" = "12 25 25" ]` | `12 25 25` | S4 | green 2026-10-13 |
